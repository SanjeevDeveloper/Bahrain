
import UIKit

protocol ForgotPasswordResetDisplayLogic: class
{
    func resetPasswordResponse(response:ForgotPasswordReset.ViewModel)
}

class ForgotPasswordResetViewController: UIViewController, ForgotPasswordResetDisplayLogic
{
    var interactor: ForgotPasswordResetBusinessLogic?
    var router: (NSObjectProtocol & ForgotPasswordResetRoutingLogic & ForgotPasswordResetDataPassing)?
    
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
        let interactor = ForgotPasswordResetInteractor()
        let presenter = ForgotPasswordResetPresenter()
        let router = ForgotPasswordResetRouter()
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
    
    /////////////////////////////////////////////////////
    
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var newPasswordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialFunction()
        applyLocalizedText()
        applyFontAndColor()
    }
    
    override func viewWillAppear(_ animated: Bool) {
    }
    
    // MARK: Apply Font And Color
    func applyFontAndColor() {
        submitButton.backgroundColor = appBarThemeColor
        newPasswordTextField.backgroundColor = apptxtfBackGroundColor
        confirmPasswordTextField.backgroundColor = apptxtfBackGroundColor
        newPasswordTextField.textColor = appTxtfDarkColor
        confirmPasswordTextField.textColor = appTxtfDarkColor
        submitButton.setTitleColor(appBtnWhiteColor, for: .normal)
    }
    
    // MARK: Apply LocalizedText
    func applyLocalizedText() {
         CommonFunctions.sharedInstance.setNavigationTitleView(titleStr: localizedTextFor(key: ForgotPasswordResetSceneText.forgotPasswordResetSceneTitle.rawValue), onVC: self)
        
        subtitleLabel.text = localizedTextFor(key: ForgotPasswordResetSceneText.forgotPasswordResetSceneSubtitle.rawValue)
        
        let colorAttribute = [NSAttributedStringKey.foregroundColor: UIColor.gray]
        
        let newPasswordTextFieldPlaceholder = NSMutableAttributedString(string: localizedTextFor(key: ForgotPasswordResetSceneText.forgotPasswordResetScenePasswordTextFieldPlaceholder.rawValue), attributes: colorAttribute)
        newPasswordTextFieldPlaceholder.append(asterik)
        
        newPasswordTextField.attributedPlaceholder = newPasswordTextFieldPlaceholder
        
        let confirmPasswordTextFieldPlaceholder = NSMutableAttributedString(string: localizedTextFor(key: ForgotPasswordResetSceneText.forgotPasswordResetSceneConfirmPasswordTextFieldPlaceholder.rawValue), attributes: colorAttribute)
        confirmPasswordTextFieldPlaceholder.append(asterik)
        
        confirmPasswordTextField.attributedPlaceholder = confirmPasswordTextFieldPlaceholder
        submitButton.setTitle(localizedTextFor(key:ForgotPasswordResetSceneText.forgotPasswordResetSceneSubmitButton.rawValue), for: .normal)
    }
    
    // MARK: UIButton Actions
    
    @IBAction func nextButtonAction(_ sender: Any) {
        let newPassword = newPasswordTextField.text_Trimmed()
        let confirmPassword = confirmPasswordTextField.text_Trimmed()
        let request = ForgotPasswordReset.Request(newPassword: newPassword, confirmPassword: confirmPassword)
        interactor?.hitResetPasswordApi(request: request)
        newPasswordTextField.text = ""
        confirmPasswordTextField.text = ""
    }
    
    // MARK: Other Functions
    
    func initialFunction() {
        scrollView.manageKeyboard()
    }
    
    // MARK: ResetPasswordResponse
    func resetPasswordResponse(response:ForgotPasswordReset.ViewModel) {
        if let error = response.error {
            CustomAlertController.sharedInstance.showErrorAlert(error: error)
        }
        else {
            router?.routeToLogin()
        }
    }
}

// MARK: UITextFieldDelegate
extension ForgotPasswordResetViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
