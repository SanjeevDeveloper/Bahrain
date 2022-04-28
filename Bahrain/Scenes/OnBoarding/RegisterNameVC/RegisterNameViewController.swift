
import UIKit

protocol RegisterNameDisplayLogic: class
{
    func dataStoreUpdated()
}

class RegisterNameViewController: UIViewController, RegisterNameDisplayLogic
{
    var interactor: RegisterNameBusinessLogic?
    var router: (NSObjectProtocol & RegisterNameRoutingLogic & RegisterNameDataPassing)?
    
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
        let interactor = RegisterNameInteractor()
        let presenter = RegisterNamePresenter()
        let router = RegisterNameRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if let scene = segue.identifier {
            let selector = NSSelectorFromString("routeTo\(scene)WithSegue:")
            if let router = router, router.responds(to: selector) {
                router.perform(selector, with: segue)
            }
        }
    }
    
    /////////////////////////////////////////////////////
    
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        applyFontAndColor()
        applyLocalizedText()
        initialFunction()
    }
    
    override func viewWillAppear(_ animated: Bool) {
    }
    
    // MARK: Apply Font And Color
    func applyFontAndColor() {
        nameTextField.backgroundColor = apptxtfBackGroundColor
        nextButton.backgroundColor = appBarThemeColor
        nextButton.setTitleColor(appBtnWhiteColor, for:.normal)
    }
    
    // MARK: Apply LocalizedText
    func applyLocalizedText() {
         CommonFunctions.sharedInstance.setNavigationTitleView(titleStr: localizedTextFor(key: RegisterNameSceneText.registerNameSceneTitle.rawValue), onVC: self)
        subtitleLabel.text = localizedTextFor(key: RegisterNameSceneText.registerNameSceneSubtitle.rawValue)
        let nameTextFieldPlaceholder = NSMutableAttributedString(string: localizedTextFor(key: RegisterNameSceneText.registerNameSceneNameTextFieldPlaceholder.rawValue))
        nameTextFieldPlaceholder.append(asterik)
        nameTextField.attributedPlaceholder = nameTextFieldPlaceholder
        
        nextButton.setTitle(localizedTextFor(key:GeneralText.nextButton.rawValue), for: .normal)
    }
    
    // MARK: UIButton Actions
    
    @IBAction func nextButtonAction(_ sender: Any) {
        let registerRequest = RegistrationRequest()
        registerRequest.name = nameTextField.text_Trimmed()
        interactor?.updateDataStoreWithName(request: registerRequest)
    }
    
    // MARK: Other Functions
    
    func initialFunction() {
        scrollView.manageKeyboard()
    }
    
    func dataStoreUpdated() {
        performSegue(withIdentifier: RegisterNamePaths.Identifiers.RegisterMobile, sender: nil)
    }
}

// MARK: UITextFieldDelegate
extension RegisterNameViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
