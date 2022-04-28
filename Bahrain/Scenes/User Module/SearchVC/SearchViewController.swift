
import UIKit

protocol SearchDisplayLogic: class
{
    func displayResponse(viewModel: Search.ViewModel)
    func displayFilterResponse(viewModel: Search.ViewModel)
  func presentSelectedArea(_ area: String)
}

class SearchViewController: UIViewController, SearchDisplayLogic
{
    var interactor: SearchBusinessLogic?
    var router: (NSObjectProtocol & SearchRoutingLogic & SearchDataPassing)?
    
    @IBOutlet weak var locationButton: UIButton!
    @IBOutlet weak var locationCrossButton: UIButton!
    @IBOutlet weak var locationButtonWidthConst: NSLayoutConstraint!
    
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
        let interactor = SearchInteractor()
        let presenter = SearchPresenter()
        let router = SearchRouter()
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
            else if (scene == "SelectArea") {
              router?.routeToSelectArea(segue: segue)
            }
            else if scene == "FilterScreen" {
                if let router = router {
                    if MinimumValue == maximumValue {
                        let minusValue =  MinimumValue.intValue - 20
                        MinimumValue = minusValue as NSNumber
                    }
                    router.routeToFilterScreen(segue: segue,minimumValue: MinimumValue,MaximumValue:maximumValue)
                }
            }
            
        }
        
    }
    
    ////////////////////////////////////////////////////
    
    @IBOutlet weak var searchTableView: UITableView!
    @IBOutlet weak var searchTextField: UITextFieldCustomClass!
    @IBOutlet weak var noSalonLabel: UILabelFontSize!
  @IBOutlet weak var locationTextField: UITextFieldCustomClass!
    @IBOutlet weak var backButton: UIButton!
    
    var searchArray = [Search.ViewModel.tableCellData]()
    var offset = 0
    var lastSearchText = ""
    var maximumValue = NSNumber()
    var MinimumValue = NSNumber()
    
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        applyLocalizedText()
        applyFontAndColor()
        hideBackButtonTitle()
        searchTableView.tableFooterView = UIView()
        searchTableView.manageKeyboard()
        initialFunction()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
       getSelectedArea()
    }
  
  func getSelectedArea() {
    interactor?.getSelectedArea()
  }
  
  func presentSelectedArea(_ area: String) {
    locationTextField.text = area
    if area != "" {
      searchTextField.text = ""
      interactor?.clearFilterData()
    }
    interactor?.hitSearchSalonFilterApi(offset: offset, filterText: searchTextField.text_Trimmed())
  }
    
    // MARK: Apply Font And Color
    func applyFontAndColor() {
        noSalonLabel.textColor = appBarThemeColor
    }
    
    @IBAction func onClickedSelectArea(_ sender: Any) {
        router?.routeToSelectArea(segue: nil)
    }
    // MARK: Apply LocalizedText
    func applyLocalizedText() {
      locationTextField.placeholder = localizedTextFor(key: FavoriteListSceneText.FavoriteListSceneLocationTextFieldPlaceholder.rawValue)
        self.tabBarController?.tabBar.isHidden = true
        CommonFunctions.sharedInstance.setNavigationTitleView(titleStr:  localizedTextFor(key: SearchSceneText.SearchSceneTitle.rawValue), onVC: self)
        searchTextField.placeholder = localizedTextFor(key: SearchSceneText.SearchSceneSearchTextFiledPlaceholderText.rawValue)
        noSalonLabel.text = localizedTextFor(key: GeneralText.noSalonAvailableMessage.rawValue)
    }
    
    // MARK: Other Functions
    
    func initialFunction() {
        
         if isCurrentLanguageArabic() {
                   backButton.contentHorizontalAlignment = .right
                   backButton.setImage(UIImage(named: "whiteRightArrow"), for: .normal)
               } else {
                   backButton.contentHorizontalAlignment = .left
                   backButton.setImage(UIImage(named: "whiteBackIcon"), for: .normal)
               }
        
        if !searchTextField.text_Trimmed().isEmptyString()  {
            searchArray.removeAll()
            searchTableView.reloadData()
            interactor?.clearFilterData()
        }
        self.view.endEditing(true)
      let param = [
        "count":100,
        "page":0,
        "latitude":0,
        "longitude":0,
       // "area":"",
        "keyword": searchTextField.text_Trimmed(),
        "gender": "\(CommonFunctions.sharedInstance.genderValue())"
        ] as [String : Any]
      interactor?.hitListBusinessApi(offset: offset, filterText: searchTextField.text_Trimmed(), parameters: param)
        lastSearchText = searchTextField.text_Trimmed()
    }
    
    @IBAction func backBarButtonItem(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: Display Response
    
    func displayResponse(viewModel: Search.ViewModel)
    {
        if let errorString = viewModel.errorString {
            CustomAlertController.sharedInstance.showErrorAlert(error: errorString)
        }
        else {
            if offset == 0 {
                if viewModel.tableArray.count == 0 {
                    noSalonLabel.isHidden = false
                    self.navigationItem.rightBarButtonItems![0].isEnabled = false
                }
                else {
                    noSalonLabel.isHidden = true
                    self.navigationItem.rightBarButtonItems![0].isEnabled = true
                }
            }
            else {
                noSalonLabel.isHidden = true
                self.navigationItem.rightBarButtonItems![0].isEnabled = true
            }
            maximumValue = viewModel.maximumPrice
            MinimumValue = viewModel.minimumPrice
            searchArray.removeAll() // Offset case remaining
            searchArray.append(contentsOf: viewModel.tableArray)
            searchTableView.reloadData()
        }
    }
    
    func displayFilterResponse(viewModel: Search.ViewModel)
    {
        if let errorString = viewModel.errorString {
            CustomAlertController.sharedInstance.showErrorAlert(error: errorString)
        }
        else {
            if offset == 0 {
                
                if viewModel.tableArray.count == 0 {
                    noSalonLabel.isHidden = false
                }
                else {
                    noSalonLabel.isHidden = true
                }
            }
            else {
                noSalonLabel.isHidden = true
            }
            searchArray.removeAll() // Offset case remaining
            searchArray.append(contentsOf: viewModel.tableArray)
            searchTableView.reloadData()
        }
    }
    
    @IBAction func onClickedLocationCrossButton(_ sender: Any) {
        locationButtonWidthConst.constant = 0
        locationTextField.placeholder = localizedTextFor(key: FavoriteListSceneText.FavoriteListSceneLocationTextFieldPlaceholder.rawValue)
        initialFunction()
    }
    func showSalonsOnTheBasisOfCoordinates(lat: Double, long: Double) {
        locationButtonWidthConst.constant = 45
        locationTextField.placeholder = "Your current location selected"
        searchArray.removeAll()
        searchTableView.reloadData()
        interactor?.clearFilterData()
        searchTextField.text = ""
        let param = [
          "count":100,
          "page":0,
          "latitude":lat,
          "longitude":long,
         // "area":"",
          "keyword": searchTextField.text_Trimmed(),
          "gender": "\(CommonFunctions.sharedInstance.genderValue())"
          ] as [String : Any]
        interactor?.hitListBusinessApi(offset: offset, filterText: searchTextField.text_Trimmed(), parameters: param)
          lastSearchText = searchTextField.text_Trimmed()
    }
    
}

// MARK: UITableViewDelegate

extension SearchViewController : UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return searchArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 3
    }
    
    func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        let footerView = view as! UITableViewHeaderFooterView
        footerView.tintColor = UIColor.clear
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReUseIdentifier, for: indexPath) as! SearchTableViewCell
        let currentObj = searchArray[indexPath.section]
        cell.setData(currentObj: currentObj)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentObj = searchArray[indexPath.section]
        router?.routeToSaloonDetail(businessId: currentObj.saloonId)
    }
    
}

// MARK: UITextFieldDelegate

extension SearchViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        
        let updatedStr = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        
        if updatedStr == " " {
            return false
        }else {
            NSObject.cancelPreviousPerformRequests(
                withTarget: self,
                selector: #selector(self.getTextWhenPausedTyping),
                object: textField)
            self.perform(
                #selector(self.getTextWhenPausedTyping),
                with: textField,
                afterDelay: 1.2)
            return true
        }
        
    }
    
    @objc func getTextWhenPausedTyping(textField: UITextField) {
      locationTextField.text = ""
        initialFunction()
    }
}
