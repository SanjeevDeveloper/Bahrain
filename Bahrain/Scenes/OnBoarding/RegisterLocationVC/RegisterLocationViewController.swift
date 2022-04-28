
import UIKit

protocol RegisterLocationDisplayLogic: class
{
    func displayRegistrationResponse(viewModel: RegisterLocation.ViewModel)
    func displayUpdateImageResponse(viewModel: RegisterLocation.ViewModel.ResponseError)
}

class RegisterLocationViewController: UIViewController, RegisterLocationDisplayLogic
{
    var interactor: RegisterLocationBusinessLogic?
    var router: (NSObjectProtocol & RegisterLocationRoutingLogic & RegisterLocationDataPassing)?
    
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
        let interactor = RegisterLocationInteractor()
        let presenter = RegisterLocationPresenter()
        let router = RegisterLocationRouter()
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
    
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var birthdayTextField: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var currentImage: UIImage?
    var lat = String()
    var lng = String()
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        applyLocalizedText()
        applyFontAndColor()
        initialFunction()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let coordinates = router?.dataStore?.coordinate {
            lat = "\(coordinates.latitude)"
            lng = "\(coordinates.longitude)"
        }
    }
    
    
    // MARK: Apply Font And Color
    func applyFontAndColor() {
        addressTextField.backgroundColor = apptxtfBackGroundColor
        birthdayTextField.backgroundColor = apptxtfBackGroundColor
        registerButton.backgroundColor = appBarThemeColor
        addressTextField.textColor = appTxtfDarkColor
        birthdayTextField.textColor = appTxtfDarkColor
        registerButton.setTitleColor(appBtnWhiteColor, for:.normal)
    }
    
    // MARK: Apply LocalizedText
    func applyLocalizedText() {
        CommonFunctions.sharedInstance.setNavigationTitleView(titleStr: localizedTextFor(key: RegisterLocationSceneText.registerLocationSceneTitle.rawValue), onVC: self)
        let colorAttribute = [NSAttributedStringKey.foregroundColor: UIColor.gray]
        
        let  addressTextFieldPlaceholder = NSMutableAttributedString(string: localizedTextFor(key: RegisterLocationSceneText.registerEmailTextFieldPlaceholder.rawValue), attributes: colorAttribute)
        addressTextFieldPlaceholder.append(asterik)
        addressTextField.attributedPlaceholder = addressTextFieldPlaceholder
        
        
        let  birthdayTextFieldPlaceholder = NSMutableAttributedString(string: localizedTextFor(key: RegisterLocationSceneText.registerLocationSceneBirthdayTextFieldPlaceholder.rawValue), attributes: colorAttribute)
        birthdayTextField.attributedPlaceholder = birthdayTextFieldPlaceholder
        
        registerButton.setTitle(localizedTextFor(key:RegisterLocationSceneText.registerLocationSceneRegisterButton.rawValue), for: .normal)
    }
    
    // MARK: UIButton Actions
    
    @IBAction func nextButtonAction(_ sender: Any) {
        let registerRequest = RegistrationRequest()
        registerRequest.address = addressTextField.text_Trimmed()
        registerRequest.address2 = ""
        registerRequest.birthday = birthdayTextField.text_Trimmed()
        registerRequest.area = ""
        registerRequest.block = ""
        registerRequest.road = ""
        registerRequest.houseNo = ""
        registerRequest.flatno = ""
        registerRequest.pinAddress = ""
        registerRequest.latitude = lat
        registerRequest.longitude = lng
        interactor?.registerUser(request:registerRequest)
    }
    
    @IBAction func btnPinLocation(_ sender: Any) {
        performSegue(withIdentifier: RegisterLocationPaths.Identifiers.pinLocation, sender: nil)
    }
    // MARK: Other Functions
    
    func initialFunction() {
        hideBackButtonTitle()
        scrollView.manageKeyboard()
        self.navigationItem.setHidesBackButton(true, animated:true)
        LocationWrapper.sharedInstance.fetchLocation()
    }
    
    // MARK: Display Update Image Response
    func displayUpdateImageResponse(viewModel: RegisterLocation.ViewModel.ResponseError) {
        if viewModel.errorString != nil {
            userRegistered()
        } else {
            let resultObj = viewModel.dict as! NSDictionary
            CommonFunctions.sharedInstance.updateUserData(.profileImage, value: resultObj[PhotoType.profileImage] as! String)
            userRegistered()
        }
    }
    
    func userRegistered()
    {
        performSegue(withIdentifier: RegisterLocationPaths.Identifiers.Home, sender: nil)
    }
    
    // MARK: Display Registration Response
    func displayRegistrationResponse(viewModel: RegisterLocation.ViewModel) {
        if let error = viewModel.error {
            CustomAlertController.sharedInstance.showErrorAlert(error: error)
        }
        else {
            interactor?.hitUpdateProfileImageApi()
        }
    }
    
    @objc func handleDatePicker(sender: UIDatePicker){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormats.format1
        dateFormatter.timeZone = UaeTimeZone
        birthdayTextField.text = dateFormatter.string(from: sender.date)
    }
    
}

// MARK: UITextFieldDelegate
extension RegisterLocationViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == birthdayTextField {
            let datePickerView = UIDatePicker()
            datePickerView.datePickerMode = .date
            datePickerView.maximumDate = Date()
            datePickerView.timeZone = UaeTimeZone
            textField.inputView = datePickerView
            datePickerView.addTarget(self, action: #selector(handleDatePicker(sender:)), for: .valueChanged)
            return true
        } else {
            return true
        }
    }
}

