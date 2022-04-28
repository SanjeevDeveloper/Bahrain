

import UIKit

protocol LoginDisplayLogic: class
{
    func displayResponse(viewModel: ProfileSetting.ViewModel)
    func displayLoginResponse(viewModel: Login.ViewModel)
    func displayLoginSuccessResponse(isFirstTimeLogin:Bool)
    func displayChangePasswordResponse(viewModel: ProfileSetting.ChangePasswordModel)
}

class LoginViewController: UIViewController, LoginDisplayLogic
{
    
    var interactor: LoginBusinessLogic?
    var router: (NSObjectProtocol & LoginRoutingLogic & LoginDataPassing)?
    
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
        let interactor = LoginInteractor()
        let presenter = LoginPresenter()
        let router = LoginRouter()
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
    
    @IBOutlet weak var countryCodeTextField: UITextField!
    @IBOutlet weak var mobileNumberTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var forgotPwdButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var skipButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var showPasswordButton: UIButton!
    @IBOutlet weak var changePasswordView: UIView!
    @IBOutlet weak var changePasswordLabel: UILabelFontSize!
    @IBOutlet weak var currentPasswordTextField: UITextFieldFontSize!
    @IBOutlet weak var newPasswordTextField: UITextFieldFontSize!
    @IBOutlet weak var confirmPasswordTextField: UITextFieldFontSize!
    @IBOutlet weak var emailTextField: UITextFieldFontSize!
    @IBOutlet weak var doneButton: UIButtonFontSize!
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var genderVw: UIView!
    @IBOutlet weak var genderLbl: UILabelFontSize!
    @IBOutlet weak var maleLbl: UILabelFontSize!
    @IBOutlet weak var femaleLbl: UILabelFontSize!
    @IBOutlet weak var maleBtn: UIButton!
    @IBOutlet weak var femaleBtn: UIButton!
    
    var value = 1
    var isLoggedIn = false
    
    
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        genderVw.isHidden = true
        maleBtn.isSelected = false
        femaleBtn.isSelected = true
        initialFunction()
        showPasswordButton.isSelected = false
        applyFontAndColor()
        applyLocalizedText()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        addTapGesture()
    }
    
    // MARK: Apply Font And Color
    func applyFontAndColor() {
        mobileNumberTextField.keyboardType = .numberPad
        mobileNumberTextField.backgroundColor = apptxtfBackGroundColor
        passwordTextField.backgroundColor = apptxtfBackGroundColor
        signupButton.backgroundColor = appSignupBtnBackGroundColor
        skipButton.backgroundColor = appSkipBtnBackGroundColor
        signInButton.backgroundColor = appBarThemeColor
        mobileNumberTextField.textColor = appTxtfDarkColor
        passwordTextField.textColor = appTxtfDarkColor
        emailTextField.textColor = appTxtfDarkColor
        skipButton.setTitleColor(appBtnBlackColor, for: .normal)
        showPasswordButton.setTitleColor(UIColor.black, for: .normal)
        forgotPwdButton.setTitleColor(UIColor.darkGray, for: .normal)
    }
    
    // MARK: Apply LocalizedText
    func applyLocalizedText() {
        CommonFunctions.sharedInstance.setNavigationTitleView(titleStr: localizedTextFor(key: LoginSceneText.loginSceneTitle.rawValue), onVC: self)
        let colorAttribute = [NSAttributedStringKey.foregroundColor: UIColor.gray]
        
        let mobileNumberTextFieldPlaceholder = NSMutableAttributedString(string: localizedTextFor(key: LoginSceneText.loginSceneMobileTextFieldPlaceholder.rawValue), attributes: colorAttribute)
        mobileNumberTextFieldPlaceholder.append(asterik)
        
        maleLbl.text = localizedTextFor(key: LoginSceneText.gents.rawValue)
        femaleLbl.text = localizedTextFor(key: LoginSceneText.ladies.rawValue)
        genderLbl.text = localizedTextFor(key: LoginSceneText.selectGender.rawValue)
        
        mobileNumberTextField.attributedPlaceholder = mobileNumberTextFieldPlaceholder
        
        let passwordTextFieldPlaceholder = NSMutableAttributedString(string: localizedTextFor(key: LoginSceneText.loginScenePasswordTextFieldPlaceholder.rawValue), attributes: colorAttribute)
        passwordTextFieldPlaceholder.append(asterik)
        
        passwordTextField.attributedPlaceholder = passwordTextFieldPlaceholder
        signInButton.setTitle(localizedTextFor(key:LoginSceneText.loginSceneSignInButton.rawValue), for: .normal)
        
        let attributedString = NSAttributedString(string: localizedTextFor(key:LoginSceneText.loginSceneForgotButton.rawValue), attributes:
            [.underlineStyle: NSUnderlineStyle.styleSingle.rawValue])
        
        forgotPwdButton.setAttributedTitle(attributedString, for: .normal)
        forgotPwdButton.tintColor = UIColor.lightGray
        signupButton.setTitle(localizedTextFor(key:LoginSceneText.loginSceneSignupButton.rawValue), for: .normal)
        skipButton.setTitle(localizedTextFor(key:LoginSceneText.loginSceneSkipButton.rawValue), for: .normal)
        
        changePasswordLabel.text = localizedTextFor(key: ProfileSettingSceneText.ProfileSettingSceneChangePasswordLabel.rawValue)
        
        let oldPasswordTextFieldPlaceholder = NSMutableAttributedString(string: localizedTextFor(key: ProfileSettingSceneText.ProfileSettingSceneOldPasswordTextField.rawValue), attributes: colorAttribute)
        oldPasswordTextFieldPlaceholder.append(asterik)
        currentPasswordTextField.attributedPlaceholder = oldPasswordTextFieldPlaceholder
        
        let newPasswordTextFieldPlaceholder = NSMutableAttributedString(string: localizedTextFor(key: ProfileSettingSceneText.ProfileSettingSceneNewPasswordTextField.rawValue), attributes: colorAttribute)
        newPasswordTextFieldPlaceholder.append(asterik)
        newPasswordTextField.attributedPlaceholder = newPasswordTextFieldPlaceholder
        
        let confirmPasswordTextFieldPlaceholder = NSMutableAttributedString(string: localizedTextFor(key: ProfileSettingSceneText.ProfileSettingSceneConfirmPasswordTextField.rawValue), attributes: colorAttribute)
        confirmPasswordTextFieldPlaceholder.append(asterik)
        confirmPasswordTextField.attributedPlaceholder = confirmPasswordTextFieldPlaceholder
        
        let  emailTextFieldPlaceholder = NSMutableAttributedString(string: localizedTextFor(key: RegisterLocationSceneText.registerEmailTextFieldPlaceholder.rawValue), attributes: colorAttribute)
        emailTextFieldPlaceholder.append(asterik)
        emailTextField.attributedPlaceholder = emailTextFieldPlaceholder
        
        
        doneButton.setTitle(localizedTextFor(key: ProfileSettingSceneText.ProfileSettingSceneDoneButton.rawValue), for: .normal)
        
    }
    
    func addTapGesture() {
        self.view.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        tap.numberOfTapsRequired = 5
//        tap.numberOfTouchesRequired = 10
        self.view.addGestureRecognizer(tap)
    }
    
    func updatetextfieldsUserDefault(responseObj:NSDictionary) {
        if let userData:Data = userDefault.value(forKey: userDefualtKeys.UserObject.rawValue) as? Data {
            if let userDict:NSMutableDictionary = NSKeyedUnarchiver.unarchiveObject(with: userData) as? NSMutableDictionary {
                
                userDict["name"] = responseObj["name"]
                userDict["area"] = responseObj["area"]
                userDict["address"] = responseObj["address"]
                userDict["address2"] = responseObj["address2"]
                userDict["email"] = responseObj["email"]
                userDict["birthday"] = responseObj["birthday"]
                userDict["notification"] = responseObj["notification"]
                userDict["block"] = responseObj["block"]
                userDict["flatNumber"] = responseObj["flatNumber"]
                userDict["houseNumber"] = responseObj["houseNumber"]
                userDict["road"] = responseObj["road"]
                userDict["gender"] = responseObj["gender"]
                
                // saving again to userDefault
                let resultData = NSKeyedArchiver.archivedData(withRootObject: userDict)
                userDefault.set(true, forKey: userDefualtKeys.userLoggedIn.rawValue)
                userDefault.set(resultData, forKey: userDefualtKeys.UserObject.rawValue)
                
                // updating app instance unarchived user object
                appDelegateObj.unarchiveUserData()
                self.navigationController?.setNavigationBarHidden(false, animated: false)
                performSegue(withIdentifier: LoginPaths.Identifiers.Home, sender: nil)
            }
        }
    }
    
    func alertsheet() {
        let alert = UIAlertController(title: "Select Server", message: "Choose server to start testing.", preferredStyle: .actionSheet)
//        alert.addAction(UIAlertAction(title: "Local Server", style: .default, handler: { (_) in
//            UserDefaults.standard.set("Local", forKey: "Selected_Server")
//        }))
        
//        alert.addAction(UIAlertAction(title: "Staging Server", style: .default, handler: { (_) in
//            UserDefaults.standard.set("Staging", forKey: "Selected_Server")
//        }))
        
        alert.addAction(UIAlertAction(title: "Release Server", style: .default, handler: { (_) in
            UserDefaults.standard.set("Release", forKey: "Selected_Server")
        }))
        
        alert.addAction(UIAlertAction(title: "Live Server", style: .default, handler: { (_) in
            UserDefaults.standard.set("Live", forKey: "Selected_Server")
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        alertsheet()
    }
    
    // MARK: UIButton Actions
    
    @IBAction func skipButtonAction(_ sender: Any) {
        genderVw.isHidden = false
    }
    
    @IBAction func showPasswordButtonAction(_ sender: Any) {
        
        if showPasswordButton.isSelected{
            passwordTextField.isSecureTextEntry = true
            showPasswordButton.isSelected = false
        }
        else {
            passwordTextField.isSecureTextEntry = false
            showPasswordButton.isSelected = true
        }
    }
    
    @IBAction func loginButtonAction(_ sender: Any) {
        let loginRequest = Login.Request(
            countryCode: countryCodeTextField.text_Trimmed(),
            mobileNumber: mobileNumberTextField.text_Trimmed(),
            password: passwordTextField.text_Trimmed()
        )
        interactor?.hitLoginApi(request: loginRequest)
        passwordTextField.text = ""
    }
    
    @IBAction func maleBtnAction(_ sender: UIButton) {
        userDefault.set(0, forKey: "gender")
        if isLoggedIn {
            interactor?.hitEditUserProfileApi()
        } else {
            userDefault.set(false, forKey: userDefualtKeys.userLoggedIn.rawValue)
            performSegue(withIdentifier: LoginPaths.Identifiers.Home, sender: nil)
        }
    }
    
    @IBAction func femaleBtnAction(_ sender: UIButton) {
        userDefault.set(1, forKey: "gender")
        if isLoggedIn {
            interactor?.hitEditUserProfileApi()
        } else {
            userDefault.set(false, forKey: userDefualtKeys.userLoggedIn.rawValue)
            performSegue(withIdentifier: LoginPaths.Identifiers.Home, sender: nil)
        }
    }
    
    @IBAction func doneButtonAction(_ sender: Any) {
        let req = ProfileSetting.ChangePasswordRequest(
            currentPassword: currentPasswordTextField.text_Trimmed(),
            newPassword: newPasswordTextField.text_Trimmed(),
            verifyPassword: confirmPasswordTextField.text_Trimmed()
        )
        interactor?.hitChangePasswordApi(request: req, email: emailTextField.text_Trimmed())
    }
    
    
    // MARK: Other Functions
    
    func initialFunction() {
        self.navigationItem.setHidesBackButton(true, animated:true)
        scrollView.manageKeyboard()
    }
    
    // MARK: DisplayLoginResponse
    func displayLoginResponse(viewModel: Login.ViewModel) {
        if let error = viewModel.error {
            CustomAlertController.sharedInstance.showErrorAlert(error: error)
        }
    }
    
    func displayResponse(viewModel: ProfileSetting.ViewModel)
    {
        if viewModel.errorString != nil {
            CustomAlertController.sharedInstance.showErrorAlert(error: viewModel.errorString!)
        }
        else {
            updatetextfieldsUserDefault(responseObj:viewModel.dict!)
        }
    }
    
    func displayLoginSuccessResponse(isFirstTimeLogin: Bool) {
        
        if isFirstTimeLogin{
            changePasswordView.isHidden = false
        }
        else {
            // updating user log in status
            
            if getUserData(.gender) == "" {
                isLoggedIn = true
                self.view.endEditing(true)
                self.navigationController?.setNavigationBarHidden(true, animated: false)
                genderVw.isHidden = false
            } else {
                userDefault.set(true, forKey: userDefualtKeys.userLoggedIn.rawValue)
                performSegue(withIdentifier: LoginPaths.Identifiers.Home, sender: nil)
            }
        }
    }
    
    func displayChangePasswordResponse(viewModel: ProfileSetting.ChangePasswordModel)
    {
        if viewModel.errormessage != nil {
            CustomAlertController.sharedInstance.showErrorAlert(error: viewModel.errormessage!)
            
        }
        else {
            CustomAlertController.sharedInstance.showAlert(subTitle: viewModel.message, type: .success)
            // updating user log in status
            
            changePasswordView.isHidden = true
            if getUserData(.gender) == "" {
                isLoggedIn = true
                self.view.endEditing(true)
                self.navigationController?.setNavigationBarHidden(true, animated: false)
                genderVw.isHidden = false
            } else {
                userDefault.set(true, forKey: userDefualtKeys.userLoggedIn.rawValue)
                performSegue(withIdentifier: LoginPaths.Identifiers.Home, sender: nil)
            }
            
        }
    }
}

// MARK: UITextFieldDelegate
extension LoginViewController : UITextFieldDelegate {
    
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

extension LoginViewController : MRCountryPickerDelegate {
    
    func countryPhoneCodePicker(_ picker: MRCountryPicker, didSelectCountryWithName name: String, countryCode: String, phoneCode: String, flag: UIImage) {
        countryCodeTextField.text = phoneCode
    }
}
