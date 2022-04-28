

import UIKit
import GoogleMaps
import MapKit
import GooglePlaces

struct LocationData {
    var addressText, latitude, longitude, road: String
}

protocol UserPinLocationDisplayLogic: class {
    
    func displayLocation(_ location: AddressList.ViewModel?)
}

class UserPinLocationViewController: UIViewController, UserPinLocationDisplayLogic
{
  var interactor: UserPinLocationBusinessLogic?
  var router: (NSObjectProtocol & UserPinLocationRoutingLogic & UserPinLocationDataPassing)?

  // MARK: Object lifecycle
  
  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?)
  {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    setup()
  }
  
  required init?(coder aDecoder: NSCoder)
  {
    super.init(coder: aDecoder)
    setup()
  }
  
  // MARK: Setup
  
  private func setup()
  {
    let viewController = self
    let interactor = UserPinLocationInteractor()
    let presenter = UserPinLocationPresenter()
    let router = UserPinLocationRouter()
    viewController.interactor = interactor
    viewController.router = router
    interactor.presenter = presenter
    presenter.viewController = viewController
    router.viewController = viewController
    router.dataStore = interactor
  }
  
  // MARK: Routing
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?)
  {
    if let scene = segue.identifier {
      let selector = NSSelectorFromString("routeTo\(scene)WithSegue:")
      if let router = router, router.responds(to: selector) {
        router.perform(selector, with: segue)
      }
    }
  }
  
  // MARK: View lifecycle
    @IBOutlet var mapView: GMSMapView!
    @IBOutlet var addressLabel: UILabel!
    @IBOutlet var doneButton: UIButton!
    
    @IBOutlet weak var tableViewSearchedResults: UITableView!
    @IBOutlet weak var textFieldSearch: UITextField!
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    
    var delegate:movePageController!
    
    var latitude = 0.0
    var longitude = 0.0
    var road = ""
    
    var searchedResults = [GMSAutocompletePrediction]()
    var isComingForBooking = false
    
    // MARK: Life Cycle
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        addObserverOnTableViewReload()
        applyLocalizedText()
        applyFontAndColor()
        let languageIdentifier = UserDefaults.standard.value(forKey: userDefualtKeys.currentLanguage.rawValue) as! String
        if languageIdentifier == Languages.Arabic {
            self.navigationItem.leftBarButtonItem?.image = #imageLiteral(resourceName: "whiteRightArrow")
        }
        else {
            self.navigationItem.leftBarButtonItem?.image = #imageLiteral(resourceName: "whiteBackIcon")
        }
        
        textFieldSearch.tintColor = appBarThemeColor
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "whiteBackIcon"), style: .done, target: self, action: #selector(self.backToInitial(sender:)))
        interactor?.getEditObject()
    }
    
    func displayLocation(_ location: AddressList.ViewModel?) {
        if let unwrapLocation = location {
            self.setMapPosition(lat: unwrapLocation.latitude.doubleValue(), lon: unwrapLocation.longitude.doubleValue())
        } else {
            DispatchQueue.main.async {
                if LocationWrapper.sharedInstance.latitude != 0.0 {
                    self.setMapPosition(lat: self.latitude, lon: self.longitude)
                }
                else {
                    LocationWrapper.sharedInstance.fetchLocation()
                }
            }
        }
    }
    
    @objc func backToInitial(sender: AnyObject) {
        router?.goBack()
    }
    
    func addObserverOnTableViewReload() {
        tableViewSearchedResults.addObserver(self, forKeyPath: tableContentSize, options: .new, context: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let obj = object as? UITableView {
            if obj == tableViewSearchedResults && keyPath == tableContentSize {
                if (change?[NSKeyValueChangeKey.newKey] as? CGSize) != nil {
                    tableViewHeightConstraint.constant = tableViewSearchedResults.contentSize.height
                }
            }
        }
    }
    
    // MARK: Apply Font And Color
    func applyFontAndColor() {
        doneButton.backgroundColor = appBarThemeColor
        addressLabel.backgroundColor = appBarThemeColor
        doneButton.setTitleColor(appBtnWhiteColor, for: .normal)
    }
    
    // MARK: Apply LocalizedText
    func applyLocalizedText() {
        CommonFunctions.sharedInstance.setNavigationTitleView(titleStr:   localizedTextFor(key: UserPinLocationSceneText.UserPinLocationSceneTitle.rawValue), onVC: self)
        if appDelegateObj.isPageControlActive {
            doneButton.setTitle(localizedTextFor(key:GeneralText.Continue.rawValue), for: .normal)
        }else {
            doneButton.setTitle(localizedTextFor(key: GeneralText.doneButton.rawValue), for: .normal)
        }
        textFieldSearch.placeholder = localizedTextFor(key: GeneralText.searchPlace.rawValue)
    }
    
    // MARK: Button Action
    
    func setMapPosition(lat: Double, lon: Double) {
        
        if lat != 0.0 {
            self.latitude = lat
            self.longitude = lon
        } else {
            if LocationWrapper.sharedInstance.latitude != 0.0 {
                self.latitude = LocationWrapper.sharedInstance.latitude
                self.longitude = LocationWrapper.sharedInstance.longitude
            } else {
                LocationWrapper.sharedInstance.fetchLocation()
                self.latitude = LocationWrapper.sharedInstance.latitude
                self.longitude = LocationWrapper.sharedInstance.longitude
            }
        }
        
        let camera: GMSCameraPosition = GMSCameraPosition.camera(withLatitude: self.latitude, longitude: self.longitude, zoom: 15.0)
        self.mapView.camera = camera
        self.mapView.mapType = .normal
        
        let coordinates = CLLocationCoordinate2D(latitude: self.latitude, longitude: self.longitude)
        updateAddressLabel(coordinates: coordinates)
    }
    
    @IBAction func doneButtonAction(_ sender: Any) {
        let location = LocationData(addressText: addressLabel.text ?? "", latitude: "\(self.latitude)", longitude: "\(self.longitude)", road: self.road)
        if isComingForBooking {
            router?.routeToAddAddress(location: location)
        } else {
            router?.routeToProfileOrRegister(location: location)
        }
    }
    
    func locationUpdated() {
        if appDelegateObj.isPageControlActive {
            delegate.moveToNextPage()
        }
        else {
            popTwoViewControllers()
        }
    }
    
    func popTwoViewControllers() {
        let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController]
        self.navigationController!.popToViewController(viewControllers[viewControllers.count - 3], animated: true)
    }
    
    func updateAddressLabel(coordinates: CLLocationCoordinate2D) {
        let geocoder = GMSGeocoder()
        self.latitude = coordinates.latitude
        self.longitude = coordinates.longitude
        geocoder.reverseGeocodeCoordinate(coordinates) { (response, error) in
            
            if let location = response?.firstResult() {
                if let lines = location.lines {
                    self.addressLabel.text = lines.joined(separator: "\n")
                }
                if let road = location.thoroughfare {
                    self.road = road
                }
            }
        }
    }
    
    func clearResults() {
        searchedResults.removeAll()
        tableViewSearchedResults.reloadData()
    }
    
    func getPlacesPredictionsOf(text: String) {
        ManageHudder.sharedInstance.startActivityIndicator()
        GooglePlacesIntegration.googlePlacesAutoComplete(searchText: text) { (predictions, error)  in
            ManageHudder.sharedInstance.stopActivityIndicator()
            if let error = error {
                CustomAlertController.sharedInstance.showErrorAlert(error: error)
            } else {
                if let predictions = predictions {
                    printToConsole(item: predictions)
                    self.searchedResults = predictions
                    self.tableViewSearchedResults.reloadData()
                } else {
                    printToConsole(item: "no predictions found")
                }
            }
        }
    }
    
    func getDetailsOfPrediction(_ prediction: GMSAutocompletePrediction) {
        let placeId = prediction.placeID
        GooglePlacesIntegration.getPlaceDetail(placeID: placeId) { (placeDetail, status)  in
            DispatchQueue.main.async {
                self.searchedResults.removeAll()
                self.tableViewSearchedResults.reloadData()
                self.textFieldSearch.text = ""
                self.textFieldSearch.resignFirstResponder()
                
                if let placeDetail = placeDetail {
                    let cordinate = placeDetail.coordinate
                    self.setMapPosition(lat: cordinate.latitude, lon: cordinate.longitude)
                } else if status == "OVER_QUERY_LIMIT" {
                    CustomAlertController.sharedInstance.showErrorAlert(error: localizedTextFor(key: GeneralText.tooManyGooglePlacesRequests.rawValue))
                } else {
                    CustomAlertController.sharedInstance.showErrorAlert(error: localizedTextFor(key: GeneralText.googleServerError.rawValue))
                }
            }
        }
    }
}

// MARK: GMSMapViewDelegate
extension UserPinLocationViewController: GMSMapViewDelegate {
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        let centerPosition = mapView.center
        let coordinates = mapView.projection.coordinate(for: centerPosition)
        printToConsole(item: coordinates)
        updateAddressLabel(coordinates: coordinates)
    }
    
}

extension UserPinLocationViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        NSObject.cancelPreviousPerformRequests(
            withTarget: self,
            selector: #selector(self.getTextWhenPausedTyping),
            object: textField)
        self.perform(
            #selector(self.getTextWhenPausedTyping),
            with: textField,
            afterDelay: 0.8)
        return true
    }
    
    @objc func getTextWhenPausedTyping(textField: UITextField) {
        let text = textField.text
        if text?.count == 0 {
            clearResults()
        } else {
            getPlacesPredictionsOf(text: textField.text ?? "")
        }
    }
}

extension UserPinLocationViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchedResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReUseIdentifier, for: indexPath)
        let prediction = searchedResults[indexPath.row]
        cell.textLabel?.attributedText = prediction.attributedFullText
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let prediction = searchedResults[indexPath.row]
        getDetailsOfPrediction(prediction)
    }
}
