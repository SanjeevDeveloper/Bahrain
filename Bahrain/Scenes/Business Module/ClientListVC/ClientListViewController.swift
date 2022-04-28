
import UIKit

protocol ClientListDisplayLogic: class
{
    //func displayUpdatedClient(clientsArray: [client])
    func displayResponse(viewModel: ClientList.ViewModel,isSearching : Bool)
    func displayHitApiResponse()
    func displayScreenName(screenName: String?)
    
}

class ClientListViewController: UIViewController, ClientListDisplayLogic
{
    
    var interactor: ClientListBusinessLogic?
    var router: (NSObjectProtocol & ClientListRoutingLogic & ClientListDataPassing)?
    
    
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
        let interactor = ClientListInteractor()
        let presenter = ClientListPresenter()
        let router = ClientListRouter()
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
    
    
    ////////////////////////////////////////////////////////
    
    @IBOutlet weak var addLabel:UILabel!
    @IBOutlet weak var clientsTableView:UITableView!
    @IBOutlet weak var addView:UIView!
    @IBOutlet weak var searchTextField:UITextField!
    @IBOutlet weak var addClientLabel: UILabelFontSize!
    var clientsArray = [ClientList.ViewModel.tableCellData]()
    var offset = 0
    var lastSearchText = ""
    var fromBusinessBookingscreen = ""
    
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideBackButtonTitle()
        clientsTableView.tableFooterView = UIView()
        initialFunction()
        applyFontAndColor()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        applyLocalizedText()
        if self.clientsArray.count == 0 {
            addView.isHidden = false
        }
        else {
            addView.isHidden = true
        }
        interactor?.hitApiAgain()
    }
    
    // MARK: Apply Font And Color
    func applyFontAndColor() {
        addLabel.textColor = appTxtfDarkColor
        searchTextField.textColor = appTxtfDarkColor
        addClientLabel.textColor = appTxtfDarkColor
    }
    
    // MARK: Apply LocalizedText
    func applyLocalizedText() {
        CommonFunctions.sharedInstance.setNavigationTitleView(titleStr:   localizedTextFor(key: ClientListSceneText.clientListSceneTitle.rawValue), onVC: self)
        
        addLabel.text = localizedTextFor(key: ClientListSceneText.clientListSceneAddLabel.rawValue)
        addClientLabel.text = localizedTextFor(key: ClientListSceneText.clientListSceneAddLabel.rawValue)
        
        let colorAttribute = [NSAttributedStringKey.foregroundColor: UIColor.darkGray]
        let searchTextFieldPlaceholder = NSMutableAttributedString(string: localizedTextFor(key: ClientListSceneText.clientListSceneSearchTextFieldPlaceholder.rawValue), attributes: colorAttribute)
        searchTextField.attributedPlaceholder = searchTextFieldPlaceholder
    }
    
    // MARK: Other Functions
    
    func initialFunction() {
        if !searchTextField.text_Trimmed().isEmptyString() || lastSearchText == "" || lastSearchText != "" {
            clientsArray.removeAll()
            clientsTableView.reloadData()
        }
        self.view.endEditing(true)
        self.hideBackButtonTitle()
        interactor?.getListBusinessClient(offset: offset, filterText: searchTextField.text_Trimmed())
        lastSearchText = searchTextField.text_Trimmed()
        
        interactor?.getScreenName()
    }
    
    // MARK: Display Response
    
    func displayScreenName(screenName: String?) {
        
        if screenName != nil {
            fromBusinessBookingscreen = screenName!
        }
        
    }
    
    func displayResponse(viewModel: ClientList.ViewModel,isSearching : Bool) {
        clientsArray.append(contentsOf: viewModel.clientListArray)
        clientsTableView.reloadData()
        if isSearching != true {
            if self.clientsArray.count == 0 {
                addView.isHidden = false
            }
            else {
                addView.isHidden = true
            }
        }
    }
    
    func displayHitApiResponse() {
        offset = 0
        clientsArray.removeAll()
        interactor?.getListBusinessClient(offset: offset, filterText: "")
    }
}

// MARK: UITableViewDelegate

extension ClientListViewController : UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return clientsArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 15
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let headerView = view as! UITableViewHeaderFooterView
        headerView.tintColor = UIColor.clear
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReUseIdentifier, for: indexPath)
        let clientObj = clientsArray[indexPath.section]
        let clientNameLabel = cell.viewWithTag(1) as! UILabel
        clientNameLabel.text = clientObj.firstName
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if fromBusinessBookingscreen == screenType.BusinessBooking.rawValue {
            let currentObject = self.clientsArray[indexPath.section]
            printToConsole(item: currentObject)
            self.router?.routeToBusinessBooking(segue: nil, dict: currentObject)
        }
        else {
            let currentObject = self.clientsArray[indexPath.section]
            printToConsole(item: currentObject)
            self.router?.routeToEditClient(segue: nil, dict: currentObject)
            
        }
    }
}

// MARK: UITextFieldDelegate

extension ClientListViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
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
    
    @objc func getTextWhenPausedTyping(textField: UITextField) {
        initialFunction()
    }
}
