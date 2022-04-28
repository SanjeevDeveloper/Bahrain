
import UIKit

protocol FavoriteListDisplayLogic: class
{
    func displayResponse(isFilter:Bool, viewModel: FavoriteList.ApiViewModel,isClear: Bool)
    func updateUI(viewObj:FavoriteList.ViewModel.UIModel, isFilterApplied:Bool)
  func presentSelectedArea(_ area: String)
}

class FavoriteListViewController: BaseViewControllerUser, FavoriteListDisplayLogic
{
    
    var interactor: FavoriteListBusinessLogic?
    var router: (NSObjectProtocol & FavoriteListRoutingLogic & FavoriteListDataPassing)?
    
    
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
        let interactor = FavoriteListInteractor()
        let presenter = FavoriteListPresenter()
        let router = FavoriteListRouter()
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
            if scene == FavoriteListPaths.Identifiers.MapList {
                if let router = router {
                    router.routeToMap(segue: segue, saloonArray: favoriteListArray)
                }
            }
           else if (scene == "SelectArea") {
                router?.routeToSelectArea(segue: segue, isFavorite: isFavorite)
            }
            else if scene == "FilterScreen" {
                if let router = router {
                    if MinimumValue == maximumValue {
                        let minusValue =  MinimumValue.intValue - 20
                        MinimumValue = minusValue as NSNumber
                    }
                    router.routeToFilterScreen(segue: segue,minimumValue: MinimumValue,MaximumValue:maximumValue,isFavorite:isFavorite)
                }
            }
            else {
                let selector = NSSelectorFromString("routeTo\(scene)WithSegue:")
                if let router = router, router.responds(to: selector) {
                    router.perform(selector, with: segue)
                }
            }
        }
    }
    
    //////////////////////////////////////////////////////////////////////////
    
    
    @IBOutlet weak var locationTextField: UITextFieldCustomClass!
    @IBOutlet weak var searchTextField: UITextFieldFontSize!
    @IBOutlet weak var favoriteListTableView: UITableView!
    @IBOutlet weak var noSalonLabel: UILabelFontSize!
    @IBOutlet weak var backButton: UIButton!
    
    var favoriteListArray = [FavoriteList.ApiViewModel.tableCellData]()
    var offset = 0
    var lastSearchText = ""
    var isFavorite = ""
    var maximumValue = NSNumber()
    var MinimumValue = NSNumber()
    
    var isNavigationHidden = false
    // MARK: View lifecycle
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        favoriteListTableView.manageKeyboard()
        favoriteListTableView.tableFooterView = UIView()
        initialFunction()
        applyLocalizedText()
        applyFontAndColor()
    }
    
    override func viewWillAppear(_ animated: Bool) {
      getSelectedArea()
        if  self.navigationController?.isNavigationBarHidden == true {
            self.navigationController?.isNavigationBarHidden = false
            isNavigationHidden = true
        }
        interactor?.hitAdvanceFilterBusinessApi(offset: offset, filterText: searchTextField.text_Trimmed())
    }
  
  func getSelectedArea() {
    interactor?.getSelectedArea()
  }
  
  func presentSelectedArea(_ area: String) {
      locationTextField.text = area
  }
    
    override func viewWillDisappear(_ animated: Bool) {
        if  isNavigationHidden {
            self.navigationController?.isNavigationBarHidden = true
        }
    }
    
    // MARK: Apply Font And Color
    func applyFontAndColor() {
        noSalonLabel.textColor = appBarThemeColor
        searchTextField.textColor = appTxtfDarkColor
    }
    
    // MARK: Apply LocalizedText
    func applyLocalizedText() {
        noSalonLabel.text = localizedTextFor(key: GeneralText.noSalonAvailableMessage.rawValue)
        searchTextField.placeholder = localizedTextFor(key: FavoriteListSceneText.FavoriteListSceneSearchTextField.rawValue)
        locationTextField.placeholder = localizedTextFor(key: FavoriteListSceneText.FavoriteListSceneLocationTextFieldPlaceholder.rawValue)
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
        
        if !searchTextField.text_Trimmed().isEmptyString() {
            favoriteListArray.removeAll()
            favoriteListTableView.reloadData()
            interactor?.clearFilterData()
        }
        self.view.endEditing(true)
        interactor?.updateUI()
        lastSearchText = searchTextField.text_Trimmed()
    }
    
    
    @IBAction func selectAreaBtn(_ sender: Any) {

    }
    
    @IBAction func backBarButtonItem(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    // MARK: DisplayResponse
    
    func displayResponse(isFilter:Bool, viewModel: FavoriteList.ApiViewModel,isClear: Bool)
    {
        
        if let errorString = viewModel.errorString {
            CustomAlertController.sharedInstance.showErrorAlert(error: errorString)
        }
        else {
            if isFilter {
                favoriteListArray.removeAll()
                offset = 0
            }else{
                maximumValue = viewModel.maximumPrice
                MinimumValue = viewModel.minimumPrice
            }
            if isClear {
                favoriteListArray.removeAll()
            }
            favoriteListArray.append(contentsOf: viewModel.tableArray)
            favoriteListTableView.reloadData()
            printToConsole(item: favoriteListArray)
            
            if offset == 0 {
                if favoriteListArray.count == 0 {
                    noSalonLabel.isHidden = false
                    if !isFilter {
                        self.navigationItem.rightBarButtonItems![1].isEnabled = false
                    }
                    
                }
                else if favoriteListArray.count == 1 {
                  noSalonLabel.isHidden = true
                  if !isFilter {
                    self.navigationItem.rightBarButtonItems![1].isEnabled = false
                  }
                }
                else {
                    noSalonLabel.isHidden = true
                    self.navigationItem.rightBarButtonItems![1].isEnabled = true
                }
            }
            else {
                noSalonLabel.isHidden = true
                self.navigationItem.rightBarButtonItems![1].isEnabled = true
            }
        }
    }
    
    // MARK: UpdateUI
    func updateUI(viewObj:FavoriteList.ViewModel.UIModel, isFilterApplied:Bool) {
        let type = viewObj.type
        if type == .service {
            CommonFunctions.sharedInstance.setNavigationTitleView(titleStr: viewObj.title!.uppercased(), onVC: self)
            isFavorite = "categoryFilter"
            if isFilterApplied {
                interactor?.hitAdvanceFilterBusinessApi(offset: offset, filterText: searchTextField.text_Trimmed())
            }
            else {
                interactor?.hitListBusinessByServiceNameApi(offset: offset, filterText: searchTextField.text_Trimmed())
            }
        }
        else if type == .category {
            CommonFunctions.sharedInstance.setNavigationTitleView(titleStr: viewObj.title!.uppercased(), onVC: self)
            isFavorite = "subCategoryFilter"
         
            if isFilterApplied {
                interactor?.hitAdvanceFilterBusinessApi(offset: offset, filterText: searchTextField.text_Trimmed())
            }
            else {
                interactor?.hitListBusinessByCategoryIdApi(offset: offset, filterText: searchTextField.text_Trimmed())
            }
        }
        else {
            isFavorite = "favFilter"
            if isFilterApplied {
                interactor?.hitAdvanceFilterBusinessApi(offset: offset, filterText: searchTextField.text_Trimmed())
            }
            else {
                CommonFunctions.sharedInstance.setNavigationTitleView(titleStr: localizedTextFor(key: FavoriteListSceneText.FavoriteListSceneTitle.rawValue).uppercased(), onVC: self)
                interactor?.hitListFavouriteApi(offset:offset, filterText: searchTextField.text_Trimmed())
            }
        }
    }
}

// MARK: UITableViewDelegate
extension FavoriteListViewController : UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return favoriteListArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        let footerView = view as! UITableViewHeaderFooterView
        footerView.tintColor = UIColor.clear
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReUseIdentifier, for: indexPath) as! FavoriteListTableViewCell
        let currentObj = favoriteListArray[indexPath.section]
        if isFavorite == "favFilter"{
            cell.paymentTypeImageView.isHidden = false
        }
        cell.setData(currentObj: currentObj)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentObj = favoriteListArray[indexPath.section]
        router?.routeToSaloonDetail(businessId: currentObj.saloonId)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.section == (((self.offset + 1)*10) - 1) {
            self.offset += 1
//            initialFunction()
        }
    }
}

// MARK: UITableViewDelegate
extension FavoriteListViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        
        let updatedStr = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        
        if updatedStr == " " {
            return false
        } else {
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
        initialFunction()
    }
}
