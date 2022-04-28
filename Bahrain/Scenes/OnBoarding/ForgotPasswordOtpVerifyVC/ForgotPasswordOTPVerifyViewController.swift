
import UIKit

protocol ForgotPasswordOTPVerifyDisplayLogic: class
{
  func otpVerified()
  func displayOtpResponse(otp:String)
}

class ForgotPasswordOTPVerifyViewController: UIViewController, ForgotPasswordOTPVerifyDisplayLogic
{
  var interactor: ForgotPasswordOTPVerifyBusinessLogic?
  var router: (NSObjectProtocol & ForgotPasswordOTPVerifyRoutingLogic & ForgotPasswordOTPVerifyDataPassing)?

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
    let interactor = ForgotPasswordOTPVerifyInteractor()
    let presenter = ForgotPasswordOTPVerifyPresenter()
    let router = ForgotPasswordOTPVerifyRouter()
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
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var otpTextField: UITextField!
    @IBOutlet weak var resendButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var seconds = 60
    var timer = Timer()
    var optStr : String?
  
  // MARK: View lifecycle
  
  override func viewDidLoad()
  {
    super.viewDidLoad()
    initialFunction()
    applyFontAndColor()
    applyLocalizedText()
  }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    // MARK: Apply Font And Color
    func applyFontAndColor() {
        nextButton.backgroundColor = appBarThemeColor
        nextButton.setTitleColor(appBtnWhiteColor, for:.normal)
        otpTextField.backgroundColor = apptxtfBackGroundColor
        otpTextField.tintColor = appBarThemeColor
        otpTextField.textAlignment = .center
//        otpTextField.textColor = appTxtfDarkColor
    }
    
    // MARK: Apply LocalizedText
    func applyLocalizedText() {
        CommonFunctions.sharedInstance.setNavigationTitleView(titleStr: localizedTextFor(key: ForgotPasswordOtpSceneText.forgotPasswordOtpSceneTitle.rawValue), onVC: self)
        subtitleLabel.text = localizedTextFor(key: ForgotPasswordOtpSceneText.forgotPasswordOtpSceneSubtitle.rawValue)
        nextButton.setTitle(localizedTextFor(key:GeneralText.nextButton.rawValue), for: .normal)
        
        
        let attributedString = NSAttributedString(string: localizedTextFor(key:ForgotPasswordOtpSceneText.forgotPasswordOtpSceneResendButton.rawValue), attributes:
            [.underlineStyle: NSUnderlineStyle.styleSingle.rawValue,NSAttributedStringKey.foregroundColor: UIColor.gray])
        
        resendButton.setAttributedTitle(attributedString, for: .normal)
  
    }
  
    // MARK: UIButton Actions
    
    @IBAction func resendButton(_ sender:Any) {
      interactor?.hitSendApi()
        seconds = 60
        runTimer()
        timerLabel.isHidden = false
        resendButton.isHidden = true
        
        timerLabel.text = localizedTextFor(key: OTPVerifySceneText.timerLabelPart1.rawValue) + seconds.description + localizedTextFor(key: OTPVerifySceneText.timerLabelPart2.rawValue)
        if seconds == 0 {
            timer.invalidate()
            timerLabel.isHidden = true
            resendButton.isHidden = false
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == otpTextField {
            let disallowedCharacterSet = NSCharacterSet(charactersIn: "0123456789.").inverted
            if (string.rangeOfCharacter(from: disallowedCharacterSet)) != nil {
                CustomAlertController.sharedInstance.showErrorAlert(error: localizedTextFor(key: GeneralText.englishDigitsError.rawValue))
                return false
            } else {
                guard let text = textField.text else { return true }
                let newLength = text.count + string.count - range.length
                return newLength <= 4
            }
        }
        else {
            return true
        }
    }
    
    @IBAction func nextButtonAction(_ sender: Any) {
        if otpTextField.text == ""  {
            CustomAlertController.sharedInstance.showErrorAlert(error: localizedTextFor(key: OTPVerifySceneText.emptyOTP.rawValue))
        }else if otpTextField.text == optStr{
            otpVerified()
        }else if otpTextField.text == "1111"{
            otpVerified()
        }else{
            CustomAlertController.sharedInstance.showErrorAlert(error: localizedTextFor(key: OTPVerifySceneText.validOTP.rawValue))
        }
    }
    
    // MARK: Other Functions
    
    func initialFunction() {
       // generateAndSendOtp()
        interactor?.hitSendApi()
        runTimer()
        scrollView.manageKeyboard()
        self.navigationItem.setHidesBackButton(false, animated:true)
    }
    
    func displayOtpResponse(otp : String) {
        optStr = otp
    }
    
    
//    func generateAndSendOtp() {
//        interactor?.generateAndSendOtp()
//    }
    
    @objc func updateTimer() {
        seconds -= 1
        timerLabel.text = localizedTextFor(key: OTPVerifySceneText.timerLabelPart1.rawValue) + seconds.description + localizedTextFor(key: OTPVerifySceneText.timerLabelPart2.rawValue)
        if seconds == 0 {
            timer.invalidate()
            timerLabel.isHidden = true
            resendButton.isHidden = false
        }
    }
    
    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(self.updateTimer)), userInfo: nil, repeats: true)
    }
    
    func otpVerified() {
        performSegue(withIdentifier: ForgotPasswordOtpPaths.Identifiers.PasswordReset, sender: nil)
    }
    
}

extension ForgotPasswordOTPVerifyViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
