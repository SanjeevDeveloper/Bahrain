
import UIKit
import GoogleMaps
import MapKit

protocol PinLocationDisplayLogic: class
{
    func locationUpdated()
}

class PinLocationViewController: UIViewController, PinLocationDisplayLogic
{
    var interactor: PinLocationBusinessLogic?
    var router: (NSObjectProtocol & PinLocationRoutingLogic & PinLocationDataPassing)?
    
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
        let interactor = PinLocationInteractor()
        let presenter = PinLocationPresenter()
        let router = PinLocationRouter()
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
    
    ///////////////////////////////////////////////////
    
    @IBOutlet var mapView: GMSMapView!
    @IBOutlet var addressLabel: UILabel!
    @IBOutlet var doneButton: UIButton!
    
    var delegate:movePageController!
    
    // MARK: Life Cycle
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        applyLocalizedText()
        applyFontAndColor()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "whiteBackIcon"), style: .done, target: self, action: #selector(self.backButtonAction(sender:)))
        let languageIdentifier = UserDefaults.standard.value(forKey: userDefualtKeys.currentLanguage.rawValue) as! String
        if languageIdentifier == Languages.Arabic {
            self.navigationItem.leftBarButtonItem?.image = #imageLiteral(resourceName: "whiteRightArrow")
        }
        else {
            self.navigationItem.leftBarButtonItem?.image = #imageLiteral(resourceName: "whiteBackIcon")
        }
        
        DispatchQueue.main.async {
            if LocationWrapper.sharedInstance.latitude != 0.0 {
                self.setMapPosition()
            }
            else {
                LocationWrapper.sharedInstance.fetchLocation()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    // MARK: Apply Font And Color
    func applyFontAndColor() {
        doneButton.backgroundColor = appBarThemeColor
        addressLabel.backgroundColor = appBarThemeColor
        doneButton.setTitleColor(appBtnWhiteColor, for: .normal)
    }
    
    // MARK: Apply LocalizedText
    func applyLocalizedText() {
        CommonFunctions.sharedInstance.setNavigationTitleView(titleStr:   localizedTextFor(key: BusinessPinLocationSceneText.businessPinLocationSceneTitle.rawValue), onVC: self)
        if appDelegateObj.isPageControlActive {
            doneButton.setTitle(localizedTextFor(key:GeneralText.Continue.rawValue), for: .normal)
        }else {
            doneButton.setTitle(localizedTextFor(key: GeneralText.doneButton.rawValue), for: .normal)
        }
    }
    
    // MARK: Button Action
    
    @objc func backButtonAction(sender: AnyObject) {
        popTwoViewControllers()
    }
    
    func setMapPosition() {
        let camera: GMSCameraPosition = GMSCameraPosition.camera(withLatitude: LocationWrapper.sharedInstance.latitude, longitude: LocationWrapper.sharedInstance.longitude, zoom: 18.0)
        self.mapView.camera = camera
        self.mapView.mapType = .normal
        
        let coordinates = CLLocationCoordinate2D(latitude: LocationWrapper.sharedInstance.latitude, longitude: LocationWrapper.sharedInstance.longitude)
        updateAddressLabel(coordinates: coordinates)
    }
    
    @IBAction func doneButtonAction(_ sender: Any) {
        let centerPosition = mapView.center
        let coordinates = mapView.projection.coordinate(for: centerPosition)
        let request = PinLocation.Request(latitude: coordinates.latitude.description, longitude: coordinates.longitude.description)
        interactor?.updateLocation(request: request)
    }
    
    func locationUpdated() {
        CustomAlertController.sharedInstance.showAlert(subTitle: localizedTextFor(key: GeneralText.businessPinned.rawValue), type: .success)
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
    
    func updateAddressLabel(coordinates:CLLocationCoordinate2D) {
        let geocoder = GMSGeocoder()
        geocoder.reverseGeocodeCoordinate(coordinates) { (response, error) in
            
            if let location = response?.firstResult() {
                if let lines = location.lines {
                    self.addressLabel.text = lines.joined(separator: "\n")
                }
            }
        }
    }
}

// MARK: GMSMapViewDelegate
extension PinLocationViewController: GMSMapViewDelegate {
    
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        
    }
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        let centerPosition = mapView.center
        let coordinates = mapView.projection.coordinate(for: centerPosition)
        printToConsole(item: coordinates)
        updateAddressLabel(coordinates: coordinates)
    }
    
}
