
import UIKit

protocol ForgotPasswordDisplayLogic: class
{
    func mobileNumberVerified()
}

class ForgotPasswordViewController: UIViewController, ForgotPasswordDisplayLogic
{
  var interactor: ForgotPasswordBusinessLogic?
  var router: (NSObjectProtocol & ForgotPasswordRoutingLogic & ForgotPasswordDataPassing)?

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
    let interactor = ForgotPasswordInteractor()
    let presenter = ForgotPasswordPresenter()
    let router = ForgotPasswordRouter()
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
    @IBOutlet weak var subtitleDescriptionLabel: UILabel!
    @IBOutlet weak var countryCodeTextField: UITextField!
    @IBOutlet weak var mobileNumberTextField: UITextField!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
  
  // MARK: View lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    applyLocalizedText()
    applyFontAndColor()
    initialFunction()
  }
    
    override func viewWillAppear(_ animated: Bool) {
    }
    
    // MARK: Apply Font And Color
    func applyFontAndColor() {
        mobileNumberTextField.backgroundColor = apptxtfBackGroundColor
        countryCodeTextField.backgroundColor = apptxtfBackGroundColor
        nextButton.backgroundColor = appBarThemeColor
        mobileNumberTextField.textColor = appTxtfDarkColor
        mobileNumberTextField.textColor = appTxtfDarkColor
        countryCodeTextField.textColor = appTxtfDarkColor
        nextButton.setTitleColor(appBtnWhiteColor, for:.normal)
    }
    
    // MARK: Apply LocalizedText
    func applyLocalizedText() {

         CommonFunctions.sharedInstance.setNavigationTitleView(titleStr: localizedTextFor(key: ForgotPasswordSceneText.forgotPasswordSceneTitle.rawValue), onVC: self)
        
        subtitleLabel.text = localizedTextFor(key: ForgotPasswordSceneText.forgotPasswordSceneSubtitle.rawValue)
        
        subtitleDescriptionLabel.text = localizedTextFor(key: ForgotPasswordSceneText.forgotPasswordSceneSubtitleDescription.rawValue)
         let colorAttribute = [NSAttributedStringKey.foregroundColor: UIColor.gray]
        
        let mobileNumberTextFieldPlaceholder = NSMutableAttributedString(string: localizedTextFor(key: ForgotPasswordSceneText.forgotPasswordSceneNumberTextFieldPlaceholder.rawValue), attributes: colorAttribute)
        mobileNumberTextFieldPlaceholder.append(asterik)
        
        mobileNumberTextField.attributedPlaceholder = mobileNumberTextFieldPlaceholder
        nextButton.setTitle(localizedTextFor(key:GeneralText.nextButton.rawValue), for: .normal)
    }
    
     // MARK: UIButton Actions
    
    @IBAction func nextButtonAction(_ sender: Any) {
        let mobileNumber = mobileNumberTextField.text_Trimmed()
        let countryCode = countryCodeTextField.text_Trimmed()
        let request = ForgotPassword.Request(mobileNumber: mobileNumber, countryCode: countryCode)
        interactor?.verifyMobileNumber(request: request)
    }
    
    // MARK: Other Functions
    
    func initialFunction() {
        scrollView.manageKeyboard()
    }

    func mobileNumberVerified() {
        performSegue(withIdentifier: ForgotPasswordPaths.Identifiers.OtpVerify, sender: nil)
    }
    
}

 // MARK: UITextFieldDelegate
extension ForgotPasswordViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == countryCodeTextField {
            let countryPicker =  MRCountryPicker()
            countryPicker.countryPickerDelegate = self
            countryPicker.showPhoneNumbers = true
            countryPicker.setLocale(userDefault.value(forKey: userDefualtKeys.currentLanguage.rawValue) as! String)
            textField.inputView = countryPicker
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == mobileNumberTextField {
            let disallowedCharacterSet = NSCharacterSet(charactersIn: "0123456789.").inverted
            if (string.rangeOfCharacter(from: disallowedCharacterSet)) != nil {
                CustomAlertController.sharedInstance.showErrorAlert(error: localizedTextFor(key: GeneralText.englishDigitsError.rawValue))
                return false
            } else {
                guard let text = textField.text else { return true }
                let newLength = text.count + string.count - range.length
                return newLength <= 10
            }
        }
        else {
            return true
        }
    }
}

// MARK: MRCountryPickerDelegate
extension ForgotPasswordViewController : MRCountryPickerDelegate {
    
    func countryPhoneCodePicker(_ picker: MRCountryPicker, didSelectCountryWithName name: String, countryCode: String, phoneCode: String, flag: UIImage) {
        countryCodeTextField.text = phoneCode
    }
}
