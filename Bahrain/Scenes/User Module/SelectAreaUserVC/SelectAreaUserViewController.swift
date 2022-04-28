
import UIKit

protocol SelectAreaUserDisplayLogic: class
{
    func displayResponse(viewModel: SelectAreaUser.ViewModel)
    func displayScreenName(ResponseMsg:String?, area: String)
}

class SelectAreaUserViewController: UIViewController, SelectAreaUserDisplayLogic
{
    
    
    var interactor: SelectAreaUserBusinessLogic?
    var router: (NSObjectProtocol & SelectAreaUserRoutingLogic & SelectAreaUserDataPassing)?
    
    var screenName: String?
    
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
        let interactor = SelectAreaUserInteractor()
        let presenter = SelectAreaUserPresenter()
        let router = SelectAreaUserRouter()
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
    
    /////////////////////////////////////////////////////////////////////////
    
    @IBOutlet weak var searchTextField: UITextFieldFontSize!
    @IBOutlet weak var selectAreaTableView: UITableView!
    @IBOutlet weak var noRecordDatalbl: UILabelFontSize!
    @IBOutlet weak var locationButton: UIButton!

    var selectAreaArray = [SelectAreaUser.ViewModel.tableCellData]()
    var filteredArray = [SelectAreaUser.ViewModel.tableCellData]()
    var searchActive = false
    
    // MARK: View lifecycle
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        locationButton.isHidden = true
        initialFunction()
        
         CommonFunctions.sharedInstance.setNavigationTitleView(titleStr:  localizedTextFor(key: SelectAreaSceneText.SelectAreaSceneTitle.rawValue), onVC: self)
        
        let colorAttribute = [NSAttributedStringKey.foregroundColor: UIColor.lightGray]
        let  searchTextFieldPlaceholder = NSMutableAttributedString(string: localizedTextFor(key: SelectAreaSceneText.SelectAreaSceneSelectAreaTextField.rawValue), attributes: colorAttribute)
        searchTextField.attributedPlaceholder = searchTextFieldPlaceholder
        
        locationButton.setTitle("  " + localizedTextFor(key: GeneralText.useMyCurrentLocation.rawValue), for: .normal)
        
      locationButton.setTitle("  " + localizedTextFor(key: GeneralText.useMyCurrentLocation.rawValue), for: .selected)
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "whiteBackIcon"), style: .done, target: self, action: #selector(self.backButtonAction(sender:)))
        let languageIdentifier = UserDefaults.standard.value(forKey: userDefualtKeys.currentLanguage.rawValue) as! String
        if languageIdentifier == Languages.Arabic {
            self.navigationItem.leftBarButtonItem?.image = #imageLiteral(resourceName: "whiteRightArrow")
        }
        else {
            self.navigationItem.leftBarButtonItem?.image = #imageLiteral(resourceName: "whiteBackIcon")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        interactor?.showScreenName()
        if selectAreaArray.count == 0 {
            // noRecordDatalbl.isHidden = false
        } else{
            // noRecordDatalbl.isHidden = true
        }
    }
    
    // MARK: Other Functions
    
    func initialFunction() {
        
        if isCurrentLanguageArabic() {
            locationButton.imageEdgeInsets = UIEdgeInsetsMake(0, 150, 0, 0)
            locationButton.titleEdgeInsets = UIEdgeInsetsMake(0, 100, 0, 0)
         } else {
            locationButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 150)
            locationButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 100)
        }
        
        self.navigationItem.setHidesBackButton(true, animated: false)
        selectAreaTableView.tableFooterView = UIView()
        selectAreaTableView.manageKeyboard()
        interactor?.hitAreasListApi()
    }
    
    func displayScreenName(ResponseMsg: String?, area: String) {
        screenName = ResponseMsg
        if screenName == "Favorite"{
           locationButton.isHidden = false
        }
      if screenName == "Search"{
        locationButton.isHidden = false
      }
      
      if area == "currentLocation" {
         locationButton.isSelected = true
      } else {
         locationButton.isSelected = false
      }
    }
    
    
    @IBAction func locationBtn(_ sender: Any) {
      if locationButton.isSelected {
        locationButton.isSelected = false
        if screenName == "Search" {
          router?.routeToSearchScreen(selectAreaText: "")
        } else {
          router?.routeToFavoriteScreen(selectAreaText: "")
        }
      } else {
        locationButton.isSelected = true
        if screenName == "Search" {
          router?.routeToSearchScreen(selectAreaText: "currentLocation")
        } else {
          router?.routeToFavoriteScreen(selectAreaText: "currentLocation")
        }
      }
    }
    
    // MARK: Display Response
    
    func displayResponse(viewModel: SelectAreaUser.ViewModel)
    {
        if let errorString = viewModel.errorString {
            CustomAlertController.sharedInstance.showErrorAlert(error: errorString)
        }
        else {
            selectAreaArray = viewModel.tableArray
            selectAreaTableView.reloadData()
            if selectAreaArray.count == 0 {
                // noRecordDatalbl.isHidden = false
            } else {
                //noRecordDatalbl.isHidden = true
            }
        }
    }
    
    @objc func backButtonAction(sender: UIBarButtonItem) {
         self.navigationController?.popViewController(animated: true)
    }
}

// MARK: UITextFieldDelegate

extension SelectAreaUserViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let string1 = string
        let string2 = textField.text
        var finalString = ""
        if string.count > 0 { // if it was not delete character
            finalString = string2! + string1
        }
        else if (string2?.count)! > 0{ // if it was a delete character
            
            finalString = String(string2!.dropLast())
        }
        if finalString == "" {
            searchActive = false
            selectAreaTableView.reloadData()
        }
        else{
            searchActive = true
            filterArray(searchString: finalString)
        }
        return true
    }
    
    func filterArray(searchString:String){
        filteredArray.removeAll()
        for obj in selectAreaArray {
            var rowObject = [SelectAreaUser.ViewModel.tableRowData]()
            for innerObj in obj.row {
                if innerObj.areaListTitle.lowercased().contains(searchString) {
                    rowObject.append(innerObj)
                }
            }
            if rowObject.count != 0 {
                let filteredObj = SelectAreaUser.ViewModel.tableCellData(header: obj.header, row: rowObject)
                filteredArray.append(filteredObj)
            }
        }
        if filteredArray.count == 0 {
            //noRecordDatalbl.isHidden = false
        }else{
            // noRecordDatalbl.isHidden = true
        }
        selectAreaTableView.reloadData()
    }
}

// MARK: UITableViewDelegate

extension SelectAreaUserViewController : UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if searchActive {
            return filteredArray.count
        }
        else {
            return selectAreaArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerCell = tableView.dequeueReusableCell(withIdentifier: "HeaderCell")
        headerCell?.backgroundColor = appBarThemeColor
        headerCell?.contentView.backgroundColor = appBarThemeColor
        headerCell?.textLabel?.text = localizedTextFor(key: LocationSceneText.capital.rawValue)
//        if searchActive {
//            let sectionObject = filteredArray[section]
//            headerCell?.textLabel?.text = sectionObject.header.areaHeaderTitle
//        }
//        else {
//            let sectionObject = selectAreaArray[section]
//            headerCell?.textLabel?.text = sectionObject.header.areaHeaderTitle
//        }
        return headerCell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchActive {
            let sectionObject = filteredArray[section]
            let rowsObject = sectionObject.row
            return rowsObject.count
        }
        else {
            let sectionObject = selectAreaArray[section]
            let rowsObject = sectionObject.row
            return rowsObject.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReUseIdentifier, for: indexPath)
        
        if searchActive {
            let sectionObject = filteredArray[indexPath.section]
            let rowsObject = sectionObject.row
            
            cell.textLabel?.text = rowsObject[indexPath.row].areaListTitle
        }
        else {
            let sectionObject = selectAreaArray[indexPath.section]
            let rowsObject = sectionObject.row
            
            cell.textLabel?.text = rowsObject[indexPath.row].areaListTitle
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var sectionObject:SelectAreaUser.ViewModel.tableCellData!
        if searchActive {
            sectionObject = filteredArray[indexPath.section]
        }
        else {
            sectionObject = selectAreaArray[indexPath.section]
        }
        let rowsobj = sectionObject.row
      let capitalName = sectionObject.header.areaHeaderTitle
        
        let selectedString = rowsobj[indexPath.row].areaListTitle
        
        if screenName == "filter"{
            router?.routeToFilterScreen(selectAreaText: selectedString)
        }
        else if screenName == "profileSetting" {
            router?.routeToProfileSetting(selectAreaText: selectedString)
        }
        else if screenName == "RegisterLocation" {
          router?.routeToRegisterLocationScreen(selectAreaText: selectedString, capitalName: capitalName)
        }
        else if screenName == "BusinessLocation" {
            router?.routeToBusinessLocation(selectAreaText: selectedString)
        }
        else if screenName == "Favorite" {
            router?.routeToFavoriteScreen(selectAreaText: selectedString)
        }
        else if screenName == "Search" {
          router?.routeToSearchScreen(selectAreaText: selectedString)
      }
    }
}
