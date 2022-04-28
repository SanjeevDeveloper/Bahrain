
import UIKit

protocol RegisterMobileNumberDisplayLogic: class
{
    func dataStoreUpdated()
}

class RegisterMobileNumberViewController: UIViewController, RegisterMobileNumberDisplayLogic
{
    var interactor: RegisterMobileNumberBusinessLogic?
    var router: (NSObjectProtocol & RegisterMobileNumberRoutingLogic & RegisterMobileNumberDataPassing)?
    
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
        let interactor = RegisterMobileNumberInteractor()
        let presenter = RegisterMobileNumberPresenter()
        let router = RegisterMobileNumberRouter()
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
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var countryCodeTextField: UITextField!
    @IBOutlet weak var mobileTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var cameraBtnTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var cameraBtnLeadingConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var genderLbl: UILabelFontSize!
    @IBOutlet weak var maleLbl: UILabelFontSize!
    @IBOutlet weak var femaleLbl: UILabelFontSize!
    @IBOutlet weak var maleBtn: UIButton!
    @IBOutlet weak var femaleBtn: UIButton!
    
    var currentImage: UIImage?
    var countryName = ""
    var value = 1
    
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        maleBtn.isSelected = false
        femaleBtn.isSelected = true
        
        applyFontAndColor()
        applyLocalizedText()
        initialFunction()
        let languageIdentifier = UserDefaults.standard.value(forKey: userDefualtKeys.currentLanguage.rawValue) as! String
        if languageIdentifier == Languages.Arabic {
            cameraBtnLeadingConstraint.isActive = true
            cameraBtnTrailingConstraint.isActive = false
        }
        else {
            cameraBtnLeadingConstraint.isActive = false
            cameraBtnTrailingConstraint.isActive = true
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
    }
    
    // MARK: Apply Font And Color
    func applyFontAndColor() {
        nameTextField.backgroundColor = apptxtfBackGroundColor
        mobileTextField.backgroundColor = apptxtfBackGroundColor
        passwordTextField.backgroundColor = apptxtfBackGroundColor
        nextButton.backgroundColor = appBarThemeColor
        nameTextField.textColor = appTxtfDarkColor
        mobileTextField.textColor = appTxtfDarkColor
        passwordTextField.textColor = appTxtfDarkColor
        subtitleLabel.textColor = appTxtfDarkColor
        nextButton.setTitleColor(appBtnWhiteColor, for:.normal)
    }
    
    // MARK: Apply LocalizedText
    func applyLocalizedText() {
        CommonFunctions.sharedInstance.setNavigationTitleView(titleStr: localizedTextFor(key: RegisterMobileSceneText.registerMobileSceneTitle.rawValue), onVC: self)
        
        maleLbl.text = localizedTextFor(key: LoginSceneText.male.rawValue)
        femaleLbl.text = localizedTextFor(key: LoginSceneText.female.rawValue)
        genderLbl.text = localizedTextFor(key: LoginSceneText.gender.rawValue)
        
        subtitleLabel.text = localizedTextFor(key: RegisterMobileSceneText.registerMobileSceneSubtitlePart2.rawValue)
        
        let mobileTextFieldPlaceholder = NSMutableAttributedString(string: localizedTextFor(key: RegisterMobileSceneText.registerMobileSceneNumberTextFieldPlaceholder.rawValue))
        mobileTextFieldPlaceholder.append(asterik)
        mobileTextField.attributedPlaceholder = mobileTextFieldPlaceholder
        
        
        let nameTextFieldPlaceholder = NSMutableAttributedString(string: localizedTextFor(key: RegisterMobileSceneText.registerMobileSceneNameTextFieldPlaceholder.rawValue))
        nameTextFieldPlaceholder.append(asterik)
        nameTextField.attributedPlaceholder = nameTextFieldPlaceholder
        
        
        let passwordTextFieldPlaceholder = NSMutableAttributedString(string: localizedTextFor(key: RegisterMobileSceneText.registerMobileScenePasswordTextFieldPlaceholder.rawValue))
        passwordTextFieldPlaceholder.append(asterik)
        passwordTextField.attributedPlaceholder = passwordTextFieldPlaceholder
        print(localizedTextFor(key:GeneralText.nextButton.rawValue))
        nextButton.setTitle(localizedTextFor(key:GeneralText.nextButton.rawValue), for: .normal)
    }
    
    // MARK: UIButton Actions
    
    @IBAction func cameraButtonAction(_ sender:AnyObject) {
        let customPicker = CustomImagePicker()
        customPicker.delegate = self
        customPicker.openImagePicker(controller: self, source: (sender as! UIButton))
    }
    
    @IBAction func maleBtnAction(_ sender: UIButton) {
        value = 0
        maleBtn.isSelected = true
        femaleBtn.isSelected = false
    }
    
    @IBAction func femaleBtnAction(_ sender: UIButton) {
        value = 1
        maleBtn.isSelected = false
        femaleBtn.isSelected = true
    }
    
    @IBAction func nextButtonAction(_ sender: Any) {
        let registerRequest = RegistrationRequest()
        registerRequest.countryCode = countryCodeTextField.text_Trimmed()
        registerRequest.phoneNumber = mobileTextField.text_Trimmed()
        registerRequest.name = nameTextField.text_Trimmed()
        registerRequest.password = passwordTextField.text_Trimmed()
        registerRequest.countryName = countryName
        registerRequest.gender = value
        if currentImage == nil {
            interactor?.updateDataStoreWithMobile(request: registerRequest, profileImage: #imageLiteral(resourceName: "userIcon"))
        } else {
            interactor?.updateDataStoreWithMobile(request: registerRequest, profileImage: currentImage!)
        }
        passwordTextField.text = ""
    }
    
    // MARK: Other Functions
    
    func initialFunction() {
        countryName = "Bahrain"
        scrollView.manageKeyboard()
    }
    
    func dataStoreUpdated() {
        performSegue(withIdentifier: RegisterMobilePaths.Identifiers.Verify, sender: nil)
    }
}

// MARK: UITextFieldDelegate

extension RegisterMobileNumberViewController : UITextFieldDelegate {
    
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
        if textField == mobileTextField {
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
        else if textField == passwordTextField {
            if (string as NSString).rangeOfCharacter(from: CharacterSet.whitespaces).location != NSNotFound {
                return false
            }
            else {
                return true
            }
        }
        else {
            return true
        }
    }
}

// MARK: MRCountryPickerDelegate

extension RegisterMobileNumberViewController : MRCountryPickerDelegate {
    
    func countryPhoneCodePicker(_ picker: MRCountryPicker, didSelectCountryWithName name: String, countryCode: String, phoneCode: String, flag: UIImage) {
        countryCodeTextField.text = phoneCode
        countryName = name
    }
}

// MARK: CustomImagePickerProtocol

extension RegisterMobileNumberViewController : CustomImagePickerProtocol {
    func didFinishPickingImage(image:UIImage) {
        printToConsole(item: image)
        userImageView.image = image
        currentImage = image
        userImageView.layer.borderWidth = 2
    }
    
    func didCancelPickingImage() {
        
    }
}

