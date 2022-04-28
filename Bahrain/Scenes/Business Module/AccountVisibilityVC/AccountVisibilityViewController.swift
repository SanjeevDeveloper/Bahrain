

import UIKit

protocol AccountVisibilityDisplayLogic: class
{
    func displayVisibilityResponse(viewModel: AccountVisibility.ViewModel)
    func displayDeleteAccountResponse()
}

class AccountVisibilityViewController: UIViewController, AccountVisibilityDisplayLogic
{
    
    var interactor: AccountVisibilityBusinessLogic?
    var router: (NSObjectProtocol & AccountVisibilityRoutingLogic & AccountVisibilityDataPassing)?
    
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
        let interactor = AccountVisibilityInteractor()
        let presenter = AccountVisibilityPresenter()
        let router = AccountVisibilityRouter()
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
    
    ///////////////////////////////////////////////////////////////////////////
    
    @IBOutlet weak var visibilityClientLabel:UILabel!
    @IBOutlet weak var deleteButton:UIButton!
    @IBOutlet weak var visibilitySwitch:UISwitch!
    
    // MARK: View lifecycle
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        initialFunction()
        applyFontAndColor()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        applyLocalizedText()
    }
    
    // MARK: Apply Font And Color
    func applyFontAndColor() {
        visibilityClientLabel.textColor = appTxtfDarkColor
        deleteButton.setTitleColor(appBarThemeColor, for: .normal)
    }
    
    // MARK: Apply LocalizedText
    func applyLocalizedText() {
        CommonFunctions.sharedInstance.setNavigationTitleView(titleStr:   localizedTextFor(key: AccountVisibilitySceneText.accountVisibilitySceneTitle.rawValue), onVC: self)
        visibilityClientLabel.text = localizedTextFor(key: AccountVisibilitySceneText.accountVisibilitySceneSwitchButtonTitle.rawValue)
        deleteButton.setTitle(localizedTextFor(key: AccountVisibilitySceneText.accountVisibilitySceneDeleteButtonTitle.rawValue), for: .normal)
    }
    
    // MARK: Button Action
    
    @IBAction func SwitchButtonAction(_ sender: UISwitch) {
        self.interactor?.hitUpdateBusinessApi(visibility: sender.isOn)
    }
    
    
    @IBAction func deleteButtonAction(_ sender: Any) {
        
        interactor?.hitDeleteBusinessAccountApi()
    }
    
    func showAlert(isVisibilty:Bool) {
        
        let alertController = PMAlertController(textForegroundColor:UIColor.darkGray, viewBackgroundColor: UIColor.white, title:localizedTextFor(key: AccountVisibilitySceneText.accountVisibilityScenePopupTitle.rawValue) , description:localizedTextFor(key: AccountVisibilitySceneText.accountVisibilityScenePopupSubTitle.rawValue), image: nil , style: .alert)
        
        let yesButton = PMAlertAction(title: localizedTextFor(key: GeneralText.yes.rawValue), style: .default, action: {
            self.interactor?.hitUpdateBusinessApi(visibility: isVisibilty)
        })
        
        let noButton = PMAlertAction(title: localizedTextFor(key: GeneralText.no.rawValue), style: .default, action: {
            alertController.dismiss(animated: true, completion: nil)
        })
        
        alertController.addAction(yesButton)
        alertController.addAction(noButton)
        
        present(alertController, animated: true, completion: nil)
    }
    
    // MARK: Other Functions
    
    func initialFunction() {
        interactor?.hitGetBusinessByIdApi()
    }
    
    func logout() {
        // updating user log in status in user default
        userDefault.set(false, forKey: userDefualtKeys.userLoggedIn.rawValue)
        
        // updating user data in user default
        userDefault.removeObject(forKey: userDefualtKeys.UserObject.rawValue)
        
        // Clears app delegate user object dictioary
        appDelegateObj.userDataDictionary.removeAllObjects()
        
        
        // moving to login screen
        moveToLoginScreen()
    }
    
    func moveToLoginScreen() {
       let initialNavigationController = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: ViewControllersIds.LoginViewControllerID)
        let navCtrl = OnBoardingModuleNavigationController(rootViewController: initialNavigationController)
        appDelegateObj.window?.rootViewController = navCtrl
        appDelegateObj.window?.makeKeyAndVisible()
        
    }
    
    // MARK: Display Response
    
    func displayVisibilityResponse(viewModel: AccountVisibility.ViewModel)
    {
        visibilitySwitch.isOn = viewModel.visibility
    }
    
    func displayDeleteAccountResponse() {
        logout()
    }
}
