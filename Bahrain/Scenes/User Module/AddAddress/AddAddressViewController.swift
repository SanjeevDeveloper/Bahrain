
import UIKit

protocol AddAddressDisplayLogic: class {
  func displayAddOrUpdateResponse(defaultAddress: AddressList.ViewModel, isEdit: Bool)
  func displayOldData(editObj: AddressList.ViewModel)
    func bookingConfirmed(bookingId:String)
    func displayLocationCordinate(location: LocationData)
}

class AddAddressViewController: UIViewController, AddAddressDisplayLogic {
  var interactor: AddAddressBusinessLogic?
  var router: (NSObjectProtocol & AddAddressRoutingLogic & AddAddressDataPassing)?
  
  // MARK: Object lifecycle
  
  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    setup()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setup()
  }
  
  // MARK: Setup
  
  private func setup() {
    let viewController = self
    let interactor = AddAddressInteractor()
    let presenter = AddAddressPresenter()
    let router = AddAddressRouter()
    viewController.interactor = interactor
    viewController.router = router
    interactor.presenter = presenter
    presenter.viewController = viewController
    router.viewController = viewController
    router.dataStore = interactor
  }
  
  // MARK: Routing
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let scene = segue.identifier {
      let selector = NSSelectorFromString("routeTo\(scene)WithSegue:")
      if let router = router, router.responds(to: selector) {
        router.perform(selector, with: segue)
      }
    }
  }
  
  @IBOutlet weak var scrollView: UIScrollView!
  
  @IBOutlet weak var pinLocationButton: UIButton!
  @IBOutlet weak var addressTextView: UITextView!
  @IBOutlet weak var addressTypeTextField: UITextField!
  @IBOutlet weak var mobileNumberTextField: UITextField!
  @IBOutlet weak var countryCodeTextField: UITextField!
  @IBOutlet weak var imgFlag: UIImageView!
  @IBOutlet weak var borderView: UIView!
  @IBOutlet weak var mapPinborderView: UIView!
  @IBOutlet weak var txtFieldBorderView: UIView!
  @IBOutlet weak var saveButton: UIButton!
  @IBOutlet weak var arrowImage: UIButton!
    @IBOutlet weak var textViewBorderView: UIView!
    @IBOutlet weak var otherTextField: UITextField!
    
    @IBOutlet weak var houseNumberTextField: UITextField!
    @IBOutlet weak var flatNumberTextField: UITextField!
    @IBOutlet weak var otherTextFieldBorderView: UIView!
    @IBOutlet weak var houseNumberTextFieldBorderView: UIView!
    @IBOutlet weak var flatNumberTextFieldBorderView: UIView!
    @IBOutlet weak var blockTextFieldBorderView: UIView!
    @IBOutlet weak var blockTextField: UITextField!
  
  var addressFromMap = ""
  var addressType = ""
  var countryArr = [Country]()
  var countryPicker = MRCountryPicker()
  var editObj: AddressList.ViewModel?
  var lat = ""
  var lon = ""
  // MARK: View lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    addKeyboardObserver()
    hideBackButtonTitle()
    applyLocalizedText()
    countryArr = countryPicker.countryNamesByCode()
    fontAndColor()
    interactor?.getOldData()
    interactor?.getLocationCoordinate()
    self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "whiteBackIcon"), style: .done, target: self, action: #selector(self.backToInitial(sender:)))
  }
    
    @objc func backToInitial(sender: AnyObject) {
        router?.goBack()
    }
    
    func displayLocationCordinate(location: LocationData) {
        addressTextView.text = location.addressText
        self.lat = location.latitude
        self.lon = location.longitude
        otherTextField.text = location.road
        addressTextView.isUserInteractionEnabled = false
    }
  
  func fontAndColor() {
    addressTextView.tintColor = appBarThemeColor
    for vw in [borderView, mapPinborderView, txtFieldBorderView] {
      vw?.layer.borderColor = UIColor.lightGray.cgColor
    }
    textViewBorderView.layer.borderColor = UIColor.lightGray.cgColor
    
    otherTextFieldBorderView.layer.borderColor = UIColor.lightGray.cgColor
    houseNumberTextFieldBorderView.layer.borderColor = UIColor.lightGray.cgColor
    flatNumberTextFieldBorderView.layer.borderColor = UIColor.lightGray.cgColor
    blockTextFieldBorderView.layer.borderColor = UIColor.lightGray.cgColor
    addressTypeTextField.tintColor = appBarThemeColor
    
    let languageIdentifier = UserDefaults.standard.value(forKey: userDefualtKeys.currentLanguage.rawValue) as! String
    if languageIdentifier == Languages.english {
      pinLocationButton.contentHorizontalAlignment = .left
      arrowImage.setImage(UIImage(named: "rightArrow"), for: .normal)
    } else {
         pinLocationButton.contentHorizontalAlignment = .right
      arrowImage.setImage(UIImage(named: "rightArrow"), for: .normal)
    }
    countryCodeTextField.textColor = appTxtfDarkColor
    pinLocationButton.titleLabel?.font = UIFont(name: appFont, size:17)
    countryCodeTextField.font = UIFont(name: appFont, size: 17)
    mobileNumberTextField.textColor = appTxtfDarkColor
    blockTextField.tintColor = appBarThemeColor
    addressTypeTextField.textColor = appTxtfDarkColor
    otherTextField.textColor = appTxtfDarkColor
    otherTextField.tintColor = appBarThemeColor
    houseNumberTextField.tintColor = appBarThemeColor
    flatNumberTextField.tintColor = appBarThemeColor
    addressTypeTextField.customTextAlignment()
    addressTypeTextField.font = UIFont(name: appFont, size: 17)
    mobileNumberTextField.font = UIFont(name: appFont, size: 17)
    mobileNumberTextField.customTextAlignment()
    addressTextView.font = UIFont(name: appFont, size: 17)
    addressTextView.customTextAlignment()
    countryCodeTextField.customTextAlignment()
  }
  
  func applyLocalizedText() {
    self.title = localizedTextFor(key: AddAddressSceneText.addAddressSceneTile.rawValue)
    pinLocationButton.setTitle(localizedTextFor(key: AddAddressSceneText.googlePinButtonTitle.rawValue), for: .normal)
    let mobileTextFieldPlaceholder = NSMutableAttributedString(string:localizedTextFor(key: LoginSceneText.loginSceneMobileTextFieldPlaceholder.rawValue))
    mobileTextFieldPlaceholder.append(asterik)
    mobileNumberTextField.attributedPlaceholder = mobileTextFieldPlaceholder
   otherTextField.placeholder = localizedTextFor(key: AddAddressSceneText.addressOtherInfo.rawValue)
    saveButton.setTitle(localizedTextFor(key: AddAddressSceneText.saveButtonTitle.rawValue), for: .normal)
    mobileNumberTextField.text = getUserData(.phoneNumber)
    countryCodeTextField.text = getUserData(.countryCode)
    let countryObj = countryArr.filter{$0.phoneCode ==  getUserData(.countryCode)}
    if countryObj.count > 0 {
      imgFlag.image = countryObj[0].flag
    }
  
    let addressTextViewPlaceholder = NSMutableAttributedString(string:localizedTextFor(key: AddAddressSceneText.addressTextViewPlaceholder.rawValue))
    addressTextViewPlaceholder.append(asterik)
    addressTextView.attributedPlaceholder = addressTextViewPlaceholder
    
    let addressTypeTextViewPlaceholder = NSMutableAttributedString(string:localizedTextFor(key: AddAddressSceneText.selectAddressTypePlaceholder.rawValue))
    addressTypeTextViewPlaceholder.append(asterik)
    addressTypeTextField.attributedPlaceholder = addressTypeTextViewPlaceholder
    
    
    let houseNumberPlaceholder = NSMutableAttributedString(string:localizedTextFor(key: AddAddressSceneText.addressHouseNumber.rawValue))
    houseNumberPlaceholder.append(asterik)
    houseNumberTextField.attributedPlaceholder = houseNumberPlaceholder
    
    let blockPlaceholder = NSMutableAttributedString(string:localizedTextFor(key: AddAddressSceneText.addressBlock.rawValue))
    blockPlaceholder.append(asterik)
    blockTextField.attributedPlaceholder = blockPlaceholder
    
    flatNumberTextField.placeholder = localizedTextFor(key: AddAddressSceneText.addressFlatNumber.rawValue)
  }
  
  func addKeyboardObserver() {
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: Notification.Name.UIKeyboardWillShow, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: Notification.Name.UIKeyboardWillHide, object: nil)
  }
  
  @IBAction func pinLocationButtonAction(sender: UIButton) {}
  
  @objc public func keyboardWillShow(notification: NSNotification) {
    if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
      var contentInset: UIEdgeInsets = scrollView.contentInset
      contentInset.bottom = keyboardSize.size.height
      scrollView.contentInset = contentInset
      //scrollView.contentOffset.y += keyboardSize.size.height
    }
  }
  
  @objc public func keyboardWillHide(notification: NSNotification) {
    let contentInset: UIEdgeInsets = UIEdgeInsets.zero
    scrollView.contentInset = contentInset
  }
  
  @IBAction func saveOrUpdateAddressButtonAction(sender: UIButton) {
    let request = AddAddress.Request(
        address: addressTextView.text_Trimmed(),
        addressID: "",
        title: addressTypeTextField.text_Trimmed(),
        phoneNumber: mobileNumberTextField.text_Trimmed(),
        countryCode: countryCodeTextField.text_Trimmed(),
        latitude: self.lat,
        longitude: self.lon,
        isDefault: editObj?.isDefault ?? true,
        road: otherTextField.text_Trimmed(),
        flatNumber: flatNumberTextField.text_Trimmed(),
        houseNumber: houseNumberTextField.text_Trimmed(),
        block: blockTextField.text_Trimmed()
    )
    if request.title == "" {
      CustomAlertController.sharedInstance.showErrorAlert(error: localizedTextFor(key: AddAddressSceneText.errorAddressTitle.rawValue))
    }else if request.phoneNumber == "" {
      CustomAlertController.sharedInstance.showErrorAlert(error: localizedTextFor(key: AddAddressSceneText.errorPhoneMessage.rawValue))
    } else if request.phoneNumber.count < 7 {
      CustomAlertController.sharedInstance.showErrorAlert(error: localizedTextFor(key: AddAddressSceneText.errorValidPhoneNumber.rawValue))
    } else if request.address == "" {
      CustomAlertController.sharedInstance.showErrorAlert(error: localizedTextFor(key: AddAddressSceneText.errorAddAddressMessage.rawValue))
    } else  {
      interactor?.addressAddOrUpdateAPI(request: request)
    }
  }
  
  func displayOldData(editObj: AddressList.ViewModel) {
    self.editObj = editObj
    self.lat =  self.editObj?.latitude ?? "0.0"
    self.lon =  self.editObj?.longitude ?? "0.0"
    self.title = localizedTextFor(key: AddAddressSceneText.editAddressTitle.rawValue)
    saveButton.setTitle(localizedTextFor(key: AddAddressSceneText.updateButtonTitle.rawValue), for: .normal)
    let countryObj = countryArr.filter{$0.phoneCode == editObj.countryCode}
    if countryObj.count > 0 {
      imgFlag.image = countryObj[0].flag
    }
    addressType = editObj.title
    countryCodeTextField.text = editObj.countryCode
    mobileNumberTextField.text = editObj.phoneNumber
    addressTextView.text = editObj.address
    addressTypeTextField.text = editObj.title
    otherTextField.text = editObj.road
    houseNumberTextField.text = editObj.houseNumber
    flatNumberTextField.text = editObj.flatNumber
    blockTextField.text = editObj.block
  }
    
    func bookingConfirmed(bookingId:String) {
        router?.routeToPaymentSelectionScreen(bookingId: bookingId)
    }
  
  func displayAddOrUpdateResponse(defaultAddress: AddressList.ViewModel, isEdit: Bool) {
    interactor?.confirmBooking(defaultAddress, isEdit: isEdit)
  }
}

extension AddAddressViewController: UITextFieldDelegate {
  
  func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
    if textField == countryCodeTextField {
      let countryPicker =  MRCountryPicker()
      countryPicker.countryPickerDelegate = self
      countryPicker.showPhoneNumbers = true
      textField.inputView = countryPicker
    } /*else if textField == addressTypeTextField {
     addressTypePicker.dataSource = self
     addressTypePicker.delegate = self
     self.addressTypeTextField.inputView = addressTypePicker
     }*/
    return true
  }
  
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    if textField == mobileNumberTextField {
      guard let text = textField.text else { return true }
      let newLength = text.count + string.count - range.length
      return newLength <= 10
    } else {
      return true
    }
  }
}

extension AddAddressViewController: MRCountryPickerDelegate {
  
  func countryPhoneCodePicker(_ picker: MRCountryPicker, didSelectCountryWithName name: String, countryCode: String, phoneCode: String, flag: UIImage) {
    countryCodeTextField.text = phoneCode
    imgFlag.image = flag
  }
}

//extension AddAddressViewController: UIPickerViewDelegate, UIPickerViewDataSource {
//
//    func numberOfComponents(in pickerView: UIPickerView) -> Int {
//        return 1
//    }
//
//    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
//        return addressTypeArray.count
//    }
//
//    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//        let name = addressTypeArray[row]
//        return name
//    }
//
//    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
//        let name = addressTypeArray[row]
//        addressTypeTextField.text = name
//        addressType = name
//    }
//}

extension AddAddressViewController: UITextViewDelegate {
  
  func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
    let updatedText = (textView.text! as NSString).replacingCharacters(in: range, with: text)
    if updatedText.count > 450 {
      return false
    } else {
      return true
    }
  }
}

extension UITextView {
    
    func customTextAlignment() {
        let languageIdentifier = UserDefaults.standard.value(forKey: userDefualtKeys.currentLanguage.rawValue) as! String
        if languageIdentifier == Languages.english {
            UIView.appearance().semanticContentAttribute = .forceLeftToRight
            self.textAlignment = NSTextAlignment.left
        } else {
            self.textAlignment = NSTextAlignment.right
            UIView.appearance().semanticContentAttribute = .forceRightToLeft
        }
    }
    
}
