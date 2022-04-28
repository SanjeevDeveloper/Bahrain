
import UIKit

protocol ProfileSettingDisplayLogic: class
{
    func displayResponse(viewModel: ProfileSetting.ViewModel)
    func displayUpdateImageResponse(viewModel: ProfileSetting.ViewModel)
    func displayChangePasswordResponse(viewModel: ProfileSetting.ChangePasswordModel)
    func displaySelectedAreaText(ResponseMsg:String?)
}

class ProfileSettingViewController: BaseViewControllerUser, ProfileSettingDisplayLogic
{
    
    var interactor: ProfileSettingBusinessLogic?
    var router: (NSObjectProtocol & ProfileSettingRoutingLogic & ProfileSettingDataPassing)?
    
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
        let interactor = ProfileSettingInteractor()
        let presenter = ProfileSettingPresenter()
        let router = ProfileSettingRouter()
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
    
    //////////////////////////////////////////////////////////////////////////
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabelFontSize!
    @IBOutlet weak var nameLabel: UILabelFontSize!
    @IBOutlet weak var nameTextField: UITextFieldCustomClass!
    @IBOutlet weak var numberLabel: UILabelFontSize!
    @IBOutlet weak var numberTextField: UITextFieldCustomClass!
    @IBOutlet weak var emailLabel: UILabelFontSize!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var changePasswordViewInStackView: UIView!
    @IBOutlet weak var passwordLabel: UILabelFontSize!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var birthdayLabel: UILabelFontSize!
    @IBOutlet weak var birthdayTextField: UITextField!
    @IBOutlet weak var switchLanguageLabel: UILabelFontSize!
    @IBOutlet weak var notificationLabel: UILabelFontSize!
    @IBOutlet weak var notificationSwitchButton: UISwitch!
    @IBOutlet weak var profileCameraButton: UIButton!
    @IBOutlet weak var backgroundCameraButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var changePasswordView: UIView!
    @IBOutlet weak var mobileNumberView: UIView!
    @IBOutlet weak var changePasswordLabel: UILabelFontSize!
    @IBOutlet weak var oldPasswordTextField: UITextFieldFontSize!
    @IBOutlet weak var newPasswordTextField: UITextFieldFontSize!
    @IBOutlet weak var confirmPasswordTextField: UITextFieldFontSize!
    @IBOutlet weak var cancelButton: UIButtonFontSize!
    @IBOutlet weak var doneButton: UIButtonFontSize!
    
    @IBOutlet weak var genderLbl: UILabelFontSize!
    @IBOutlet weak var maleLbl: UILabelFontSize!
    @IBOutlet weak var femaleLbl: UILabelFontSize!
    @IBOutlet weak var maleBtn: UIButton!
    @IBOutlet weak var femaleBtn: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var cameraBtnTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var cameraBtnLeadingConstraint: NSLayoutConstraint!
    
    var isCoverImageView = false
    var currentImage: UIImage?
    var isComingFromSelectArea:Bool!
    var lat = String()
    var lng = String()
    var value = Int()
    var genderValue = Int()
    
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        isComingFromSelectArea = false
        scrollView.manageKeyboard()
        profileCameraButton.isHidden = false
        backgroundCameraButton.isHidden = true
        applyLocalizedText()
        applyFontAndColor()
        updateBarButtonFont()
        let languageIdentifier = UserDefaults.standard.value(forKey: userDefualtKeys.currentLanguage.rawValue) as! String
        if languageIdentifier == Languages.Arabic {
            cameraBtnLeadingConstraint.isActive = true
            cameraBtnTrailingConstraint.isActive = false
        }
        else {
            cameraBtnLeadingConstraint.isActive = false
            cameraBtnTrailingConstraint.isActive = true
        }
        notificationSwitchButton.onTintColor = appBarThemeColor
    }
    
    override func viewWillAppear(_ animated: Bool) {
        interactor?.showSelectedArea()
        notificationSwitchButton.transform = CGAffineTransform(scaleX: 0.8, y: 0.8);
        notificationSwitchButton.isOn = getUserData(.notification).boolValue()
        if !isComingFromSelectArea {
            updateTouchEvents(bool:true)
            updateTextFieldsText()
            updateImageView()
        } else {
            if let coordinates = router?.dataStore?.coordinate {
                lat = "\(coordinates.latitude)"
                lng = "\(coordinates.longitude)"
            }
        }
    }
    
    // MARK: Apply Font And Color
    func applyFontAndColor() {
        
        if isCurrentLanguageArabic() {
            backButton.contentHorizontalAlignment = .right
            backButton.setImage(UIImage(named: "whiteRightArrow"), for: .normal)
        } else {
            backButton.contentHorizontalAlignment = .left
            backButton.setImage(UIImage(named: "whiteBackIcon"), for: .normal)
        }
        nameTextField.backgroundColor = apptxtfBackGroundColor
        numberTextField.backgroundColor = apptxtfBackGroundColor
        emailTextField.backgroundColor = apptxtfBackGroundColor
        oldPasswordTextField.backgroundColor = apptxtfBackGroundColor
        newPasswordTextField.backgroundColor = apptxtfBackGroundColor
        oldPasswordTextField.backgroundColor = apptxtfBackGroundColor
        cancelButton.backgroundColor = appBarThemeColor
        doneButton.backgroundColor = appBarThemeColor
        nameLabel.textColor = appTxtfDarkColor
        nameTextField.textColor = appTxtfDarkColor
        numberLabel.textColor = appTxtfDarkColor
        numberTextField.textColor = appTxtfDarkColor
        emailLabel.textColor = appTxtfDarkColor
        emailTextField.textColor = appTxtfDarkColor
        passwordLabel.textColor = appTxtfDarkColor
        changePasswordLabel.textColor = appTxtfDarkColor
        oldPasswordTextField.textColor = appTxtfDarkColor
        newPasswordTextField.textColor = appTxtfDarkColor
        changePasswordLabel.textColor = appTxtfDarkColor
        emailTextField.backgroundColor = apptxtfBackGroundColor
        confirmPasswordTextField.textColor = appTxtfDarkColor
        switchLanguageLabel.textColor = appBarThemeColor
        notificationLabel.textColor = appBarThemeColor
    }
    
    
    
    
    // MARK: Apply LocalizedText
    func applyLocalizedText() {
        
        let colorAttribute = [NSAttributedStringKey.foregroundColor: UIColor.gray]
        
        self.navigationItem.rightBarButtonItem?.title = localizedTextFor(key: ProfileSettingSceneText.ProfileSettingSceneSaveButton.rawValue)
        CommonFunctions.sharedInstance.setNavigationTitleView(titleStr:localizedTextFor(key: ProfileSettingSceneText.ProfileSettingSceneTitle.rawValue) , onVC: self)
        
        nameLabel.text = localizedTextFor(key: ProfileSettingSceneText.ProfileSettingSceneNameLabel.rawValue)
        
        maleLbl.text = localizedTextFor(key: LoginSceneText.male.rawValue)
        femaleLbl.text = localizedTextFor(key: LoginSceneText.female.rawValue)
        genderLbl.text = localizedTextFor(key: LoginSceneText.gender.rawValue)
        
        let nameTxtFPlaceholder = NSMutableAttributedString(string: localizedTextFor(key: ProfileSettingSceneText.namePlaceholder.rawValue), attributes: colorAttribute)
        nameTxtFPlaceholder.append(asterik)
        nameTextField.attributedPlaceholder = nameTxtFPlaceholder
        
        numberLabel.text = localizedTextFor(key: ProfileSettingSceneText.ProfileSettingSceneNumberLabel.rawValue)
        emailLabel.text = localizedTextFor(key: ProfileSettingSceneText.ProfileSettingSceneEmailLabel.rawValue)
        let emailTxtFPlaceholder = NSMutableAttributedString(string: localizedTextFor(key: ProfileSettingSceneText.emailAddressPlaceholder.rawValue), attributes: colorAttribute)
        emailTxtFPlaceholder.append(asterik)
        emailTextField.attributedPlaceholder = emailTxtFPlaceholder
        passwordLabel.text = localizedTextFor(key: ProfileSettingSceneText.ProfileSettingScenePasswordLabel.rawValue)
        
        let  passwordTextFieldPlaceholder = NSMutableAttributedString(string: localizedTextFor(key: ProfileSettingSceneText.ProfileSettingScenePasswordTextField.rawValue), attributes: colorAttribute)
        passwordTextField.attributedPlaceholder = passwordTextFieldPlaceholder
        birthdayLabel.text = localizedTextFor(key: ProfileSettingSceneText.ProfileSettingSceneBirthdayLabel.rawValue)
        switchLanguageLabel.text = localizedTextFor(key: ProfileSettingSceneText.ProfileSettingSceneSwitchLanguageLabel.rawValue)
        notificationLabel.text = localizedTextFor(key: ProfileSettingSceneText.ProfileSettingSceneNotificationLabel.rawValue)
        changePasswordLabel.text = localizedTextFor(key: ProfileSettingSceneText.ProfileSettingSceneChangePasswordLabel.rawValue)
        
        let oldPasswordTextFieldPlaceholder = NSMutableAttributedString(string: localizedTextFor(key: ProfileSettingSceneText.ProfileSettingSceneOldPasswordTextField.rawValue), attributes: colorAttribute)
        oldPasswordTextFieldPlaceholder.append(asterik)
        oldPasswordTextField.attributedPlaceholder = oldPasswordTextFieldPlaceholder
        
        let newPasswordTextFieldPlaceholder = NSMutableAttributedString(string: localizedTextFor(key: ProfileSettingSceneText.ProfileSettingSceneNewPasswordTextField.rawValue), attributes: colorAttribute)
        newPasswordTextFieldPlaceholder.append(asterik)
        
        newPasswordTextField.attributedPlaceholder = newPasswordTextFieldPlaceholder
        
        let confirmPasswordTextFieldPlaceholder = NSMutableAttributedString(string: localizedTextFor(key: ProfileSettingSceneText.ProfileSettingSceneConfirmPasswordTextField.rawValue), attributes: colorAttribute)
        confirmPasswordTextFieldPlaceholder.append(asterik)
        
        confirmPasswordTextField.attributedPlaceholder = confirmPasswordTextFieldPlaceholder
        
        cancelButton.setTitle(localizedTextFor(key: ProfileSettingSceneText.ProfileSettingSceneCancelButton.rawValue), for: .normal)
        doneButton.setTitle(localizedTextFor(key: ProfileSettingSceneText.ProfileSettingSceneDoneButton.rawValue), for: .normal)
    }
    
    // MARK: UpdateTextFieldsText
    func updateTextFieldsText() {
        userNameLabel.text = getUserData(.name)
        nameTextField.text = getUserData(.name)
        numberTextField.text = getUserData(.phoneNumber)
        emailTextField.text = getUserData(.email)
        printToConsole(item: getUserData(.birthday))
        
        value = getUserData(.gender).intValue()
        
        if value == 0 {
            maleBtn.isSelected = true
            femaleBtn.isSelected = false
        } else {
            femaleBtn.isSelected = true
            maleBtn.isSelected = false
        }
        
        if getUserData(.birthday).intValue() != 0 {
            let dateFormatter = DateFormatter()
            dateFormatter.timeZone = UaeTimeZone
            dateFormatter.dateFormat = dateFormats.format1
            let birthMilliseconds = Int(getUserData(.birthday))
            let birthdate = Date(largeMilliseconds: Int64(birthMilliseconds!))
            let dateString = dateFormatter.string(from: birthdate)
            birthdayTextField.text = dateString
        }
        
    }
    
    // MARK: UpdateImageView
    func updateImageView() {
        if let profileImageUrl = URL(string:Configurator().imageBaseUrl + getUserData(.profileImage)) {
            userImageView.sd_setImage(with: profileImageUrl, placeholderImage: #imageLiteral(resourceName: "userIcon"), options: .retryFailed, completed: nil)
        }
        if let coverImageUrl = URL(string:Configurator().imageBaseUrl + getUserData(.coverPhoto)) {
            //            coverImageView.sd_setImage(with: coverImageUrl, placeholderImage: #imageLiteral(resourceName: "businessBackground"), options: .retryFailed, completed: nil)
        }
    }
    
    // MARK: UIButton Actions
    @IBAction func notificationSwitch(_ sender: Any) {
        createAndHitRequest()  
    }
    
    @IBAction func profileCameraButtonAction(_ sender: Any) {
        self.isCoverImageView = false
        let customPicker = CustomImagePicker()
        customPicker.delegate = self
        customPicker.openImagePicker(controller: self, source: (sender as! UIButton))
    }
    
    @IBAction func backBarButtonItem(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func maleBtnAction(_ sender: UIButton) {
        value = 0
        genderValue = 1
        maleBtn.isSelected = true
        femaleBtn.isSelected = false
    }
    
    @IBAction func femaleBtnAction(_ sender: UIButton) {
        value = 1
        genderValue = 2
        maleBtn.isSelected = false
        femaleBtn.isSelected = true
    }
    
    @IBAction func backgroundCameraButtonAction(_ sender: Any) {
        self.isCoverImageView = true
        let customPicker = CustomImagePicker()
        customPicker.delegate = self
        customPicker.openImagePicker(controller: self, source: (sender as! UIButton))
    }
    
    @IBAction func cancelButtonAction(_ sender: Any) {
        self.view.endEditing(true)
        changePasswordView.isHidden = true
        navigationItem.rightBarButtonItem?.isEnabled = true
    }
    
    @IBAction func doneButtonAction(_ sender: Any) {
        let req = ProfileSetting.ChangePasswordRequest(
            currentPassword: oldPasswordTextField.text_Trimmed(),
            newPassword: newPasswordTextField.text_Trimmed(),
            verifyPassword: confirmPasswordTextField.text_Trimmed()
        )
        
        interactor?.hitChangePasswordApi(request: req)
    }
    
    @IBAction func changeLanguageButtonAction(_ sender: Any) {
        showChangeLanguageAlert()
    }
    
    
    // MARK: Change Language Alert
    func showChangeLanguageAlert() {
        
        let currentLanguage = userDefault.value(forKey: userDefualtKeys.currentLanguage.rawValue) as! String
        
        var alertText = ""
        if currentLanguage == Languages.english {
            
            alertText = localizedTextFor(key: ProfileSettingSceneText.ProfileSettingSceneChangeLanguageAlertText.rawValue) + " " + localizedTextFor(key:LanguageSceneText.languageSceneArabicButton.rawValue)
        }
        else {
            alertText = localizedTextFor(key: ProfileSettingSceneText.ProfileSettingSceneChangeLanguageAlertText.rawValue) + " " + localizedTextFor(key:LanguageSceneText.languageSceneEnglishButton.rawValue)
        }
        
        let alertController = PMAlertController(textForegroundColor:UIColor.darkGray, viewBackgroundColor: UIColor.white, title: alertText, description: "", image: nil, style: .alert)
        
        alertController.addAction(PMAlertAction(title: localizedTextFor(key: GeneralText.no.rawValue), style: .default, action: {
            alertController.dismiss(animated: true, completion: nil)
            self.tabBarController?.setTabBarVisible(visible: true)
            self.navigationController?.setNavigationBarHidden(false, animated: true)
        }))
        
        alertController.addAction(PMAlertAction(title: localizedTextFor(key: GeneralText.yes.rawValue), style: .default, action: {
            alertController.dismiss(animated: true, completion: nil)
            
            if currentLanguage == Languages.english {
                userDefault.set(Languages.Arabic, forKey: userDefualtKeys.currentLanguage.rawValue)
                userDefault.set([appleLanguages.Arabic], forKey: appleLanguagesKey)
                UIView.appearance().semanticContentAttribute = .forceRightToLeft
            }
            else {
                userDefault.set(Languages.english, forKey: userDefualtKeys.currentLanguage.rawValue)
                userDefault.set([appleLanguages.english], forKey: appleLanguagesKey)
                UIView.appearance().semanticContentAttribute = .forceLeftToRight
            }
            
            print("CURRENT SELECTED LANGUAGE >>>>>>>>>>>>", userDefault.value(forKey: userDefualtKeys.currentLanguage.rawValue) as! String)
            self.hitLogoutApi()
            
        }))
        
        present(alertController, animated: true, completion: nil)
    }
    
    func updateTouchEvents(bool:Bool) {
        for subview in self.view.subviews {
            if let scrollView = subview as? UIScrollView {
                let contentView = scrollView.subviews[0]
                for innerSubview in contentView.subviews {
                    if let stackView = innerSubview as? UIStackView {
                        for stackSubview in stackView.arrangedSubviews {
                            if stackSubview != changePasswordViewInStackView {
                                stackSubview.isUserInteractionEnabled = bool
                            }
                            
                        }
                    }
                }
                
            }
        }
    }
    
    func updateBarButtonFont() {
        let attributes = [
            NSAttributedStringKey.font: UIFont(name: appFont, size: 16)!,
            NSAttributedStringKey.foregroundColor: UIColor.white]
        self.navigationItem.rightBarButtonItem?.setTitleTextAttributes(attributes, for: .normal)
    }
    
    @IBAction func EditSaveButtonAction(_ sender: Any) {
        if self.navigationItem.rightBarButtonItem?.title == localizedTextFor(key: ProfileSettingSceneText.ProfileSettingSceneEditButton.rawValue) {
            
            self.navigationItem.rightBarButtonItem?.title = localizedTextFor(key: ProfileSettingSceneText.ProfileSettingSceneSaveButton.rawValue)
            
            profileCameraButton.isHidden = false
            backgroundCameraButton.isHidden = true
            
            updateTouchEvents(bool:true)
            
            self.tabBarController?.setTabBarVisible(visible:false)
            self.navigationItem.leftBarButtonItem?.isEnabled = false
        }
        else {
            
            print("genderValue:-",genderValue)
            
            if (genderValue == 1 || genderValue == 2) {
                
                let alertController = PMAlertController(textForegroundColor:UIColor.darkGray, viewBackgroundColor: UIColor.white, title: localizedTextFor(key: UserSideMenuText.logoutAlert.rawValue), description: "", image: nil, style: .alert)
                alertController.addAction(PMAlertAction(title: localizedTextFor(key: GeneralText.no.rawValue), style: .default, action: {
                    alertController.dismiss(animated: true, completion: nil)
                    self.navigationController?.setNavigationBarHidden(false, animated: true)
                }))
                
                alertController.addAction(PMAlertAction(title: localizedTextFor(key: GeneralText.yes.rawValue), style: .default, action: {
                    alertController.dismiss(animated: true, completion: nil)

                    self.createAndHitRequest()
                    
                }))
                
                present(alertController, animated: true, completion: nil)
    
            } else {
                self.createAndHitRequest()
            }
            
        }
    }
    
    // MARK: Api Hit
    func createAndHitRequest() {
        let currentLanguage = userDefault.value(forKey: userDefualtKeys.currentLanguage.rawValue) as! String
        
        //let dateFormatter = DateFormatter()
        //dateFormatter.dateFormat = dateFormats.format1
        
        //let birthdayDate = dateFormatter.date(from: birthdayTextField.text_Trimmed())
        //let birthMilliSeconds = birthdayDate?.millisecondsSince1970
        
        let request = ProfileSetting.Request (
            name: nameTextField.text_Trimmed(),
            area: "",
            birthday: birthdayTextField.text_Trimmed(),
            language: currentLanguage,
            latitude: lat,
            longitude: lng,
            notification: notificationSwitchButton.isOn.description,
            address: "",
            address2: "",
            email: emailTextField.text_Trimmed(),
            block: "",
            road: "",
            houseNo: "",
            flatno: "",
            gender: value)
        interactor?.hitEditUserProfileApi(request: request)
    }
    
    // MARK: Display Response
    
    func displaySelectedAreaText(ResponseMsg: String?) {
        isComingFromSelectArea = true
        self.navigationItem.rightBarButtonItem?.title = localizedTextFor(key: ProfileSettingSceneText.ProfileSettingSceneSaveButton.rawValue)
        
        profileCameraButton.isHidden = false
        backgroundCameraButton.isHidden = true
        
        updateTouchEvents(bool:true)
    }
    
    func displayResponse(viewModel: ProfileSetting.ViewModel)
    {
        if viewModel.errorString != nil {
            CustomAlertController.sharedInstance.showErrorAlert(error: viewModel.errorString!)
        }
        else {
            
            updatetextfieldsUserDefault(responseObj:viewModel.dict!)
            CustomAlertController.sharedInstance.showAlert(subTitle: localizedTextFor(key: ProfileSettingSceneText.ProfileSettingSceneProfileUpdateSuccessMessage.rawValue), type: .success)
            interactor?.clearArea()
            
            self.navigationItem.leftBarButtonItem?.isEnabled = true
            self.tabBarController?.setTabBarVisible(visible:true)
            self.navigationItem.rightBarButtonItem?.title = localizedTextFor(key: ProfileSettingSceneText.ProfileSettingSceneSaveButton.rawValue)
            profileCameraButton.isHidden = false
            backgroundCameraButton.isHidden = true
            
            updateTouchEvents(bool:true)
        }
    }
    
    func displayUpdateImageResponse(viewModel: ProfileSetting.ViewModel)
    {
        updateTouchEvents(bool:true)
        self.tabBarController?.setTabBarVisible(visible:true)
        
        if viewModel.errorString != nil {
            CustomAlertController.sharedInstance.showErrorAlert(error: viewModel.errorString!)
            
            self.navigationItem.rightBarButtonItem?.title = localizedTextFor(key: ProfileSettingSceneText.ProfileSettingSceneSaveButton.rawValue)
        }
        else {
            CommonFunctions.sharedInstance.updateUserData(.profileImage, value: viewModel.dict![PhotoType.profileImage] as! String)
            CommonFunctions.sharedInstance.updateUserData(.coverPhoto, value: viewModel.dict![PhotoType.coverPhoto] as! String)
            
            
            if self.isCoverImageView {
                //  coverImageView.image = currentImage
            }
            else {
                userImageView.image = currentImage
            }
            
            self.navigationItem.rightBarButtonItem?.title = localizedTextFor(key: ProfileSettingSceneText.ProfileSettingSceneSaveButton.rawValue)
            self.navigationItem.leftBarButtonItem?.isEnabled = true
            
            profileCameraButton.isHidden = false
            backgroundCameraButton.isHidden = true
            
            
            self.navigationItem.leftBarButtonItem?.isEnabled = true
            self.tabBarController?.setTabBarVisible(visible:true)
            self.navigationItem.rightBarButtonItem?.title = localizedTextFor(key: ProfileSettingSceneText.ProfileSettingSceneSaveButton.rawValue)
            updateTouchEvents(bool:true)
            
        }
    }
    
    func displayChangePasswordResponse(viewModel: ProfileSetting.ChangePasswordModel)
    {
        if viewModel.errormessage != nil {
            CustomAlertController.sharedInstance.showErrorAlert(error: viewModel.errormessage!)
            
        }
        else {
            CustomAlertController.sharedInstance.showAlert(subTitle: viewModel.message, type: .success)
            
            self.view.endEditing(true)
            changePasswordView.isHidden = true
            navigationItem.rightBarButtonItem?.isEnabled = true
        }
    }
    
    // MARK: UpdatetextfieldsUserDefault
    
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
                userDefault.set(resultData, forKey: userDefualtKeys.UserObject.rawValue)
                
                // updating app instance unarchived user object
                appDelegateObj.unarchiveUserData()
            }
        }
    }
    
    @objc func handleDatePicker(sender: UIDatePicker){
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = UaeTimeZone
        dateFormatter.dateFormat = dateFormats.format1
        birthdayTextField.text = dateFormatter.string(from: sender.date)
    }
}

// MARK: UITextFieldDelegate

extension ProfileSettingViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        if textField == birthdayTextField{
            
            let datePickerView = UIDatePicker()
            datePickerView.timeZone = UaeTimeZone
            datePickerView.datePickerMode = .date
            datePickerView.maximumDate = Date()
            
            if birthdayTextField.text != ""{
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = dateFormats.format1
                dateFormatter.timeZone = UaeTimeZone
                let birthMilliseconds = Int(getUserData(.birthday))
                let birthdate = Date(milliseconds: birthMilliseconds!)
                datePickerView.date = birthdate
            }
            textField.inputView = datePickerView
            datePickerView.addTarget(self, action: #selector(handleDatePicker(sender:)), for: .valueChanged)
        } else if textField == passwordTextField{
            oldPasswordTextField.text = ""
            newPasswordTextField.text = ""
            confirmPasswordTextField.text = ""
            changePasswordView.isHidden = false
            navigationItem.rightBarButtonItem?.isEnabled = false
            return false
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == newPasswordTextField {
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

// MARK: CustomImagePickerProtocol

extension ProfileSettingViewController: CustomImagePickerProtocol{
    func didFinishPickingImage(image:UIImage) {
        
        if self.isCoverImageView {
            let request = ProfileSetting.ImageRequest(imageView: image, imageTitle: PhotoType.coverPhoto)
            interactor?.hitUpdateProfileImageApi(request: request)
            currentImage = image
        }
        else {
            let request = ProfileSetting.ImageRequest(imageView: image, imageTitle: PhotoType.profileImage)
            interactor?.hitUpdateProfileImageApi(request: request)
            currentImage = image
        }
    }
    
    func didCancelPickingImage() {
        
    }
}

