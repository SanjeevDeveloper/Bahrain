
import UIKit

protocol BasicInformationDisplayLogic: class
{
    func imageUploaded(imageData:BasicInformation.imageRequest)
    func requestValidated()
    func infoUpdated()
    func gotBusinessInfo(viewModel:BasicInformation.ViewModel)
}

protocol movePageController {
    func moveToNextPage()
}

class BasicInformationViewController: UIViewController, BasicInformationDisplayLogic
{
    var interactor: BasicInformationBusinessLogic?
    var router: (NSObjectProtocol & BasicInformationRoutingLogic & BasicInformationDataPassing)?
    var isUserImageViewSelected = false
    var delegate:movePageController!
    
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
        let interactor = BasicInformationInteractor()
        let presenter = BasicInformationPresenter()
        let router = BasicInformationRouter()
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
    
    /////////////////////////////////////////////
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var backGroundImageView: UIImageView!
    @IBOutlet weak var btnBackgroundImage: UIButton!
    @IBOutlet weak var addProfileImgLbl: UILabelCustomClass!
    @IBOutlet weak var addCoverImgLbl: UILabelCustomClass!
    @IBOutlet weak var salonNameTextField:UITextField!
    @IBOutlet weak var arabicNameTextField: UITextFieldCustomClass!
    @IBOutlet weak var websiteTextField:UITextField!
    @IBOutlet weak var instagramTextField:UITextField!
    @IBOutlet weak var numberTextField:UITextField!
    @IBOutlet weak var aboutTextView:UITextView!
    @IBOutlet weak var arabicAboutTextView: UITextViewFontSize!
    @IBOutlet weak var doneButton:UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var profileBtnLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var profileBtnTrailingConstraint: NSLayoutConstraint!
    
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialFunction()
        applyLocalizedText()
        applyFontAndColor()
        aboutTextView.layer.cornerRadius = 4
        self.navigationItem.leftBarButtonItem?.isEnabled = false
        arabicNameTextField.textAlignment = .right
        let languageIdentifier = UserDefaults.standard.value(forKey: userDefualtKeys.currentLanguage.rawValue) as! String
        if languageIdentifier == Languages.Arabic {
            profileBtnLeadingConstraint.isActive = true
            profileBtnTrailingConstraint.isActive = false
        }
        else {
            profileBtnLeadingConstraint.isActive = false
            profileBtnTrailingConstraint.isActive = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        updateImages()
    }
    
    // MARK: Apply Font And Color
    func applyFontAndColor() {
        salonNameTextField.backgroundColor = apptxtfBackGroundColor
        arabicNameTextField.backgroundColor = apptxtfBackGroundColor
        websiteTextField.backgroundColor = apptxtfBackGroundColor
        instagramTextField.backgroundColor = apptxtfBackGroundColor
        numberTextField.backgroundColor = apptxtfBackGroundColor
        aboutTextView.backgroundColor = apptxtfBackGroundColor
        arabicAboutTextView.backgroundColor = apptxtfBackGroundColor
        doneButton.backgroundColor = appBarThemeColor
        salonNameTextField.textColor = appTxtfDarkColor
        arabicNameTextField.textColor = appTxtfDarkColor
        websiteTextField.textColor = appTxtfDarkColor
        instagramTextField.textColor = appTxtfDarkColor
        numberTextField.textColor = appTxtfDarkColor
        aboutTextView.textColor = appTxtfDarkColor
        arabicAboutTextView.textColor = appTxtfDarkColor
        doneButton.setTitleColor(appBtnWhiteColor, for: .normal)
    }
    
    // MARK: Apply LocalizedText
    func applyLocalizedText() {
        CommonFunctions.sharedInstance.setNavigationTitleView(titleStr:   localizedTextFor(key: BasicInformationSceneText.basicInformationSceneTitle.rawValue), onVC: self)
        addProfileImgLbl.text = localizedTextFor(key: BasicInformationSceneText.basicInformationAddProfileImgLblTitle.rawValue)
        addCoverImgLbl.text = localizedTextFor(key: BasicInformationSceneText.basicInformationAddCoverImgLblTitle.rawValue)
        let colorAttribute = [NSAttributedStringKey.foregroundColor: UIColor.darkGray]
        let salonNameTextFieldPlaceholder = NSMutableAttributedString(string: localizedTextFor(key: BasicInformationSceneText.basicInformationSceneSalonNameTextFieldPlaceholder.rawValue), attributes: colorAttribute)
        salonNameTextFieldPlaceholder.append(asterik)
        salonNameTextField.attributedPlaceholder = salonNameTextFieldPlaceholder
        
        let arabicNameTextFieldPlaceholder = NSAttributedString(string: localizedTextFor(key: BasicInformationSceneText.basicInformationSceneSalonArabicNameTextFieldPlaceholder.rawValue), attributes: colorAttribute)
        
        arabicNameTextField.attributedPlaceholder = arabicNameTextFieldPlaceholder
        
        let numberTextFieldPlaceholder = NSMutableAttributedString(string: localizedTextFor(key: BasicInformationSceneText.basicInformationScenePhoneTextFieldPlaceholder.rawValue), attributes: colorAttribute)
        numberTextFieldPlaceholder.append(asterik)
        numberTextField.attributedPlaceholder = numberTextFieldPlaceholder
        
        let websiteTextFieldPlaceholder = NSAttributedString(string: localizedTextFor(key: BasicInformationSceneText.basicInformationSceneWebsiteTextFieldPlaceholder.rawValue), attributes: colorAttribute)
        websiteTextField.attributedPlaceholder = websiteTextFieldPlaceholder
        
        let instagramTextFieldPlaceholder = NSAttributedString(string: localizedTextFor(key: BasicInformationSceneText.basicInformationSceneInstagramTextFieldPlaceholder.rawValue), attributes: colorAttribute)
        instagramTextField.attributedPlaceholder = instagramTextFieldPlaceholder
        
        aboutTextView.placeholder = localizedTextFor(key: BasicInformationSceneText.basicInformationSceneAboutTextViewPlaceholder.rawValue)
        aboutTextView.placeholderColor = UIColor.darkGray
        
        arabicAboutTextView.placeholder = localizedTextFor(key: BasicInformationSceneText.basicInformationSceneArabicAboutTextViewPlaceholder.rawValue)
        arabicAboutTextView.placeholderColor = UIColor.darkGray
        
        
        if appDelegateObj.isPageControlActive {
            doneButton.setTitle(localizedTextFor(key:GeneralText.Continue.rawValue), for: .normal)
        }else {
            doneButton.setTitle(localizedTextFor(key: BasicInformationSceneText.basicInformationSceneDoneButton.rawValue), for: .normal)
        }
    }
    
    // MARK: UIButton Actions
    
    @IBAction func userCameraButtonAction(_ sender:AnyObject) {
        let customPicker = CustomImagePicker()
        customPicker.delegate = self
        customPicker.openImagePicker(controller: self, source: (sender as! UIButton))
        isUserImageViewSelected = true
    }
    
    @IBAction func backgroundCameraButtonAction(_ sender:AnyObject) {
        let customPicker = CustomImagePicker()
        customPicker.delegate = self
        customPicker.openImagePicker(controller: self, source: (sender as! UIButton))
        isUserImageViewSelected = false
    }
    
    @IBAction func doneButtonAction(_ sender:AnyObject) {
        
        let saloonName = salonNameTextField.text_Trimmed()
        let arabicName = arabicNameTextField.text_Trimmed()
        let website = websiteTextField.text_Trimmed()
        let instagramAccount = instagramTextField.text_Trimmed()
        let phoneNumber = numberTextField.text_Trimmed()
        let about = aboutTextView.text_Trimmed()
        let arabicAbout = arabicAboutTextView.text_Trimmed()
        
        var profileImage:UIImage?
        var coverImage:UIImage?
        coverImage = backGroundImageView.image
      
        
        if userImageView.image != #imageLiteral(resourceName: "userIcon") {
            profileImage = userImageView.image
        }
        
        let request = BasicInformation.Request(saloonName: saloonName, arabicName: arabicName, website: website, instagramAccount: instagramAccount, phoneNumber: phoneNumber, about: about, arabicAbout: arabicAbout, profileImage: profileImage, coverImage: coverImage)
        
        interactor?.updateSaloonName(request: request)
        
    }
    
    // MARK: Other Functions
    
    func initialFunction() {
        scrollView.manageKeyboard()
//        if !appDelegateObj.isPageControlActive {
            interactor?.getBusinessInfo()
//        }
    }
    
    func requestValidated() {
        CustomAlertController.sharedInstance.showAlert(subTitle: localizedTextFor(key: GeneralText.basicInfoAdded.rawValue), type: .success)
        delegate.moveToNextPage()
    }
    
    func infoUpdated() {
        CustomAlertController.sharedInstance.showAlert(subTitle: localizedTextFor(key: BasicInformationSceneText.basicInformationSceneInfoUpdatedSuccessMessage.rawValue), type: .success)
        self.navigationController?.popViewController(animated: true)
    }
    
    func gotBusinessInfo(viewModel:BasicInformation.ViewModel)  {
        salonNameTextField.text = viewModel.saloonName
        arabicNameTextField.text = viewModel.arabicName
        websiteTextField.text = viewModel.website
        instagramTextField.text = viewModel.instagramAccount
        numberTextField.text = viewModel.phoneNumber
        aboutTextView.text = viewModel.about
        arabicAboutTextView.text = viewModel.arabicName
        printToConsole(item: Configurator().imageBaseUrl + viewModel.profileImageUrl)
        
        if let businessProfileImageUrl = URL(string:Configurator().imageBaseUrl + viewModel.profileImageUrl) {
            userImageView.sd_setImage(with: businessProfileImageUrl, placeholderImage: #imageLiteral(resourceName: "userIcon"), options: .retryFailed, completed: nil)
        }
        
        if let coverImageUrl = URL(string:Configurator().imageBaseUrl + viewModel.coverImageUrl) {
            backGroundImageView.sd_setImage(with: coverImageUrl, placeholderImage: nil, options: .retryFailed, completed: nil)
        }
        
    }
    
    func imageUploaded(imageData:BasicInformation.imageRequest) {
        
        if imageData.imageName == PhotoType.profileImage {
            userImageView.image = imageData.image
        }
        else {
            backGroundImageView.image = imageData.image
        }
        CustomAlertController.sharedInstance.showAlert(subTitle: localizedTextFor(key: GeneralText.imageUploadedSuccess.rawValue), type: .success)
    }
    
    // MARK: updateImages
    func updateImages() {
        let saloonProfileImageUrl = userDefault.value(forKey: userDefualtKeys.saloonProfileImage.rawValue) as? String ?? ""
        let saloonCoverImageUrl = userDefault.value(forKey: userDefualtKeys.saloonCoverImage.rawValue) as? String ?? ""
        if !saloonProfileImageUrl.isEmptyString() {
            
            if let businessProfileImageUrl = URL(string:Configurator().imageBaseUrl + saloonProfileImageUrl) {
                userImageView.sd_setImage(with: businessProfileImageUrl, placeholderImage: #imageLiteral(resourceName: "userIcon"), options: .retryFailed, completed: nil)
            }
            
            if let coverImageUrl = URL(string:Configurator().imageBaseUrl + saloonCoverImageUrl) {
                backGroundImageView.sd_setImage(with: coverImageUrl, placeholderImage: nil, options: .retryFailed, completed: nil)
            }
        }
    }
}

// MARK: UITextFieldDelegate
extension BasicInformationViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == numberTextField {
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

// MARK: CustomImagePickerProtocol

extension BasicInformationViewController : CustomImagePickerProtocol {
    func didFinishPickingImage(image:UIImage) {
        var imageRequest: BasicInformation.imageRequest
        if isUserImageViewSelected {
            imageRequest = BasicInformation.imageRequest(image: image, imageName: PhotoType.profileImage)
        }
        else {
            imageRequest = BasicInformation.imageRequest(image: image, imageName: PhotoType.coverPhoto)
        }
        interactor?.updateBusinessImage(request: imageRequest)
    }
    
    func didCancelPickingImage() {
        
    }
}
