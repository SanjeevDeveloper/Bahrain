
import UIKit

protocol ListYourServiceDisplayLogic: class
{
    func presentServicesResponse(viewModelArray: [ListYourService.ViewModel.service])
    func presentSelectedResponse(viewModelArray: [ListYourService.selectedService.service])
    func businessCreated()
    func displayServiceUpdatedResponse()
}

class ListYourServiceViewController: UIViewController, ListYourServiceDisplayLogic
{
    
    var interactor: ListYourServiceBusinessLogic?
    var router: (NSObjectProtocol & ListYourServiceRoutingLogic & ListYourServiceDataPassing)?
    
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
        let interactor = ListYourServiceInteractor()
        let presenter = ListYourServicePresenter()
        let router = ListYourServiceRouter()
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
    
    ///////////////////////////////////////////////////////
    
    @IBOutlet weak var servicesSelectedLabel:UILabel!
    @IBOutlet weak var continueButton:UIButton!
    @IBOutlet weak var ListTableView:UITableView!
    @IBOutlet weak var ListTableViewHeightConstraint:NSLayoutConstraint!
    
    var servicesListArray = [ListYourService.ViewModel.service]()
    
    // MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initialFunction()
        continueButton.backgroundColor = appBarThemeColor
        applyLocalizedText()

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
        applyFontAndColor()
        applyLocalizedText()
    }
    
    @objc func backButtonAction(sender: UIBarButtonItem) {
        
        if getUserData(.businessId) != "" {
            self.navigationController?.popViewController(animated: true)
        }
        else {
          dismiss(animated: true, completion: nil)
        }
        
        
    }
    
    // MARK: Apply Font And Color
    func applyFontAndColor() {
        continueButton.setTitleColor(appBtnWhiteColor, for: .normal)
        continueButton.tintColor = appBtnWhiteColor
        servicesSelectedLabel.textColor = UIColor.black
    }
    
    // MARK: Apply LocalizedText
    func applyLocalizedText() {
        CommonFunctions.sharedInstance.setNavigationTitleView(titleStr:   localizedTextFor(key: ListYourServiceSceneText.ListYourServiceSceneTitle.rawValue), onVC: self)
        
        if getUserData(.businessId) != "" {
            continueButton.setTitle(localizedTextFor(key: ListYourServiceSceneText.ListYourServiceSceneSaveChangesButton.rawValue), for: .normal)
        }
        else {
             continueButton.setTitle(localizedTextFor(key: ListYourServiceSceneText.ListYourServiceSceneContinueButton.rawValue), for: .normal)
        }
        
       
    }
    
    
    // MARK: UIButton Actions
    
    @IBAction func continueButtonAction(_ sender: Any) {
        if let selectedindexPaths = ListTableView.indexPathsForSelectedRows {
            if getUserData(.businessId) != "" {
                interactor?.hitUpdateBusinessApi(selectedIndexPaths: selectedindexPaths)
            }
            else {
                interactor?.registerBusiness(selectedIndexPaths: selectedindexPaths)
            }
            
        }
    }
    
    // MARK: Other Functions
    
    func initialFunction() {
        hideBackButtonTitle()
        interactor?.getServicesList()
        addObserverOnTableViewReload()
    }
    
    func addObserverOnTableViewReload() {
        ListTableView.addObserver(self, forKeyPath: tableContentSize, options: .new, context: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let obj = object as? UITableView {
            if obj == ListTableView && keyPath == tableContentSize {
                if (change?[NSKeyValueChangeKey.newKey] as? CGSize) != nil {
                    ListTableViewHeightConstraint.constant = ListTableView.contentSize.height
                }
            }
        }
    }
    
    deinit {
       // ListTableView.removeObserver(self, forKeyPath: tableContentSize)
    }
    
    func presentServicesResponse(viewModelArray: [ListYourService.ViewModel.service]) {
        self.servicesListArray = viewModelArray
        ListTableView.reloadData()
        
        if getUserData(.businessId) != "" {
            interactor?.getBusinessSelectedServices()
        }
       
    }
    
    func presentSelectedResponse(viewModelArray: [ListYourService.selectedService.service]) {
        
        for item in viewModelArray {
            let selectedId = item.id
            for (index, obj) in self.servicesListArray.enumerated() {
                let id = obj.id
                if selectedId == id {
                    let path = IndexPath(row: 0, section: index)
                    ListTableView.selectRow(at: path, animated: false, scrollPosition: .none)
                    tableView(ListTableView, didSelectRowAt: path)
                   
                    break
                }
            }
        }
    
          updateServiceSelectionLabel()
        
        
    }
    
    
    
    func businessCreated() {
        router?.routeToPageController()
    }
    
    func displayServiceUpdatedResponse() {
        CustomAlertController.sharedInstance.showAlert(subTitle:  localizedTextFor(key: ListYourServiceSceneText.ListYourServiceSceneCategoriesUpdated.rawValue), type: .success)
         self.navigationController?.popViewController(animated: true)
    }
    
    func updateServiceSelectionLabel() {
        if let selectedNumberOfRows = ListTableView.indexPathsForSelectedRows?.count {
            servicesSelectedLabel.text = (selectedNumberOfRows.description) + " " + localizedTextFor(key: ListYourServiceSceneText.ListYourServiceSceneSelectedServiceText.rawValue)
        }
        else {
            servicesSelectedLabel.text = ""
        }
    }
}

// MARK: UITableViewDelegate

extension ListYourServiceViewController : UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return servicesListArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReUseIdentifier, for: indexPath) as! ListYourServiceTableViewCell
        
        let currentObj = servicesListArray[indexPath.section]
        cell.setData(obj: currentObj)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 20
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! ListYourServiceTableViewCell
        cell.contentView.backgroundColor = appBarThemeColor
        cell.contentView.bringSubview(toFront: cell.separatorLabel)
        updateServiceSelectionLabel()
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)  as! ListYourServiceTableViewCell
        cell.contentView.backgroundColor = UIColor.lightGray
        updateServiceSelectionLabel()
    }
    
    func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        let footerView = view as! UITableViewHeaderFooterView
        footerView.tintColor = UIColor.clear
    }
}
