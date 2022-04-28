
import UIKit

protocol AddClientDisplayLogic: class
{
    func clientCreated()
    func displayClientData(response: ClientList.ViewModel.tableCellData?, editClient: String?)
    func displayClientCreationResponse(isedit: Bool)
    func displayDeleteResponse(msg: String)
    
    
}

class AddClientViewController: UIViewController, AddClientDisplayLogic
{
    var interactor: AddClientBusinessLogic?
    var router: (NSObjectProtocol & AddClientRoutingLogic & AddClientDataPassing)?
    
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
        let interactor = AddClientInteractor()
        let presenter = AddClientPresenter()
        let router = AddClientRouter()
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
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var nameTextField:UITextField!
    @IBOutlet weak var lastNameTextField:UITextField!
    @IBOutlet weak var countryCodeTextField:UITextField!
    @IBOutlet weak var phoneNumberTextField:UITextField!
    @IBOutlet weak var continueButton:UIButton!
    @IBOutlet weak var deleteButton: UIButtonCustomClass?
    @IBOutlet weak var scrollView: UIScrollView!
    
    var clientImage: UIImage?
    var ClientID = ""
    var id = ""
    
    // MARK: View lifecycle
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        initialFunction()
        applyFontAndColor()
        continueButton.setTitle(localizedTextFor(key: AddClientSceneText.addClientSceneContinueSaveChangesButton.rawValue), for: UIControlState.selected)
        continueButton.setTitle(localizedTextFor(key: AddClientSceneText.addClientSceneContinueButton.rawValue), for: .normal)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        applyLocalizedText()
        interactor?.getClientData()
    }
    
    // MARK: Apply Font And Color
    func applyFontAndColor() {
        nameTextField.textColor = appTxtfDarkColor
        lastNameTextField.textColor = appTxtfDarkColor
        countryCodeTextField.textColor = appTxtfDarkColor
        phoneNumberTextField.textColor = appTxtfDarkColor
        continueButton.setTitleColor(appBtnWhiteColor, for: .normal)
        nameTextField.backgroundColor = apptxtfBackGroundColor
        lastNameTextField.backgroundColor = apptxtfBackGroundColor
        countryCodeTextField.backgroundColor = apptxtfBackGroundColor
        phoneNumberTextField.backgroundColor = apptxtfBackGroundColor
        continueButton.backgroundColor = appBarThemeColor
    }
    
    // MARK: Apply LocalizedText
    func applyLocalizedText() {
        
        let colorAttribute = [NSAttributedStringKey.foregroundColor: UIColor.darkGray]
        let nameTextFieldPlaceholder = NSMutableAttributedString(string: localizedTextFor(key: AddClientSceneText.addClientSceneNameFieldPlaceholder.rawValue), attributes: colorAttribute)
        nameTextFieldPlaceholder.append(asterik)
        nameTextField.attributedPlaceholder = nameTextFieldPlaceholder
        
        let lastNameTextFieldPlaceholder = NSAttributedString(string: localizedTextFor(key: AddClientSceneText.addClientSceneLastNameFieldPlaceholder.rawValue), attributes: colorAttribute)
        lastNameTextField.attributedPlaceholder = lastNameTextFieldPlaceholder
        
        let phoneNumberTextFieldPlaceholder = NSMutableAttributedString(string: localizedTextFor(key: AddClientSceneText.addClientSceneNumberFieldPlaceholder.rawValue), attributes: colorAttribute)
        phoneNumberTextFieldPlaceholder.append(asterik)
        phoneNumberTextField.attributedPlaceholder = phoneNumberTextFieldPlaceholder
        
        if deleteButton != nil {
            deleteButton?.setTitle(localizedTextFor(key: AddClientSceneText.addClientSceneDeleteAccountButton.rawValue), for: .normal)
        }
    }
    
    // MARK: TextFiled ShouldChange Characters
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == phoneNumberTextField {
            guard let text = textField.text else { return true }
            let newLength = text.count + string.count - range.length
            return newLength <= 10
        }
        else {
            return true
        }
    }
    
    // MARK: UIButton Actions
    
    @IBAction func cameraButtonAction(_ sender:AnyObject) {
        let customPicker = CustomImagePicker()
        customPicker.delegate = self
        customPicker.openImagePicker(controller: self, source: (sender as! UIButton))
    }
    
    @IBAction func continueButtonAction(_ sender:AnyObject) {
        let firstName = nameTextField.text_Trimmed()
        let lastName = lastNameTextField.text_Trimmed()
        let phoneNumber = phoneNumberTextField.text_Trimmed()
        let countryCode = countryCodeTextField.text_Trimmed()
        
        let clientObj = client(firstName: firstName, lastName: lastName, phoneNumber: phoneNumber, countryCode: countryCode, profileImage: clientImage, profileImageUrlString: nil)
        
        if continueButton.isSelected {
            
            interactor?.hitSaveClientChangesApi(ClientId: id, client: clientObj)
        }
        else {
            interactor?.createClient(client: clientObj)
        }
        
        
    }
    
    @IBAction func deleteButtonAction(_ sender: Any) {
        showAlert()
    }
    
    
    // MARK: Other Functions
    
    func initialFunction() {
        scrollView.manageKeyboard()
    }
    
    func clientCreated() {
        router?.routeToClientList()
    }
    
    // MARK: display Response
    func displayClientData(response: ClientList.ViewModel.tableCellData?, editClient: String?) {
        if editClient == salonTypes.editClient.rawValue {
            if let clientImage = response?.profileImage {
                if !clientImage.isEmptyString() {
                    let imageUrl = Configurator().imageBaseUrl + clientImage
                    userImageView.sd_setImage(with: URL(string: imageUrl), completed: nil)
                }
            }
            nameTextField.text = response?.firstName
            lastNameTextField.text = response?.lastName
            countryCodeTextField.text = response?.countryCode
            phoneNumberTextField.text = response?.phoneNumber
            ClientID = (response?.ClientId)!
            id = (response?.id)!
            continueButton.isSelected = true
            CommonFunctions.sharedInstance.setNavigationTitleView(titleStr:   localizedTextFor(key: AddClientSceneText.editClientSceneTitle.rawValue), onVC: self)
            
        }
        else {
            continueButton.isSelected = false
            deleteButton?.removeFromSuperview()
            CommonFunctions.sharedInstance.setNavigationTitleView(titleStr:   localizedTextFor(key: AddClientSceneText.addClientSceneTitle.rawValue), onVC: self)
            
        }
    }
    
    func displayClientCreationResponse(isedit: Bool) {
        
        if isedit {
            CustomAlertController.sharedInstance.showAlert(subTitle: localizedTextFor(key: AddClientSceneText.addClientSceneClientUpdatedSuccessFullyText.rawValue), type: .success)
        }
        else {
            CustomAlertController.sharedInstance.showAlert(subTitle: localizedTextFor(key: AddClientSceneText.addClientSceneClientAddedSuccessFullyText.rawValue), type: .success)
        }
        
        router?.routeToClientList()
    }
    
    
    func displayDeleteResponse(msg: String) {
        CustomAlertController.sharedInstance.showAlert(subTitle: msg, type: .success)
        router?.routeToClientList()
    }
    
    func showAlert() {
        let alertController = PMAlertController(textForegroundColor:UIColor.darkGray, viewBackgroundColor: UIColor.white, title:"" , description: localizedTextFor(key: AddClientSceneText.addClientSceneDeleteAccountText.rawValue), image: nil , style: .alert)
        
        let yesButton = PMAlertAction(title: localizedTextFor(key: GeneralText.yes.rawValue), style: .default, action: {
            self.interactor?.hitDeleteBusinessClientApi(ClientId: self.ClientID)
        })
        
        let noButton = PMAlertAction(title: localizedTextFor(key: GeneralText.no.rawValue), style: .default, action: {
            alertController.dismiss(animated: true, completion: nil)
        })
        
        alertController.addAction(yesButton)
        alertController.addAction(noButton)
        
        present(alertController, animated: true, completion: nil)
    }
}

// MARK: UITextFieldDelegate

extension AddClientViewController : UITextFieldDelegate {
    
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
            return true
        }
        else {
            return true
        }
    }
}

// MARK: MRCountryPickerDelegate
extension AddClientViewController : MRCountryPickerDelegate {
    
    func countryPhoneCodePicker(_ picker: MRCountryPicker, didSelectCountryWithName name: String, countryCode: String, phoneCode: String, flag: UIImage) {
        countryCodeTextField.text = phoneCode
    }
}
// MARK: CustomImagePickerProtocol

extension AddClientViewController : CustomImagePickerProtocol {
    func didFinishPickingImage(image:UIImage) {
        self.clientImage = image
        userImageView.image = image
    }
    
    func didCancelPickingImage() {
        
    }
}
