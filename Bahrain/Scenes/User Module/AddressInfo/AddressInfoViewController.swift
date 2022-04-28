
import UIKit

class AddressInfoViewController: UIViewController {
    
    @IBOutlet weak var navigateButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var addressTextView: UITextView!
    @IBOutlet weak var addressTypeTextField: UITextField!
    @IBOutlet weak var mobileNumberTextField: UITextField!
    @IBOutlet weak var countryCodeTextField: UITextField!
    @IBOutlet weak var imgFlag: UIImageView!
    @IBOutlet weak var borderView: UIView!
    @IBOutlet weak var txtFieldBorderView: UIView!
    @IBOutlet weak var textViewBorderView: UIView!
    @IBOutlet weak var otherTextField: UITextField!
    @IBOutlet weak var houseNumberTextField: UITextField!
    @IBOutlet weak var flatNumberTextField: UITextField!
    
    @IBOutlet weak var otherTextFieldBorderView: UIView!
    @IBOutlet weak var houseNumberTextFieldBorderView: UIView!
    @IBOutlet weak var flatNumberTextFieldBorderView: UIView!
    
    @IBOutlet weak var blockTextFieldBorderView: UIView!
    @IBOutlet weak var blockTextField: UITextField!
    
    var countryArr = [Country]()
    var countryPicker = MRCountryPicker()
    var editObj: AddressList.ViewModel!
    
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideBackButtonTitle()
        applyLocalizedText()
        countryArr = countryPicker.countryNamesByCode()
        fontAndColor()
        displayOldData()
    }
    
    func fontAndColor() {
        addressTextView.tintColor = appBarThemeColor
        for vw in [borderView, txtFieldBorderView] {
            vw?.layer.borderColor = UIColor.lightGray.cgColor
        }
        textViewBorderView.layer.borderColor = UIColor.lightGray.cgColor
        houseNumberTextFieldBorderView.layer.borderColor = UIColor.lightGray.cgColor
        flatNumberTextFieldBorderView.layer.borderColor = UIColor.lightGray.cgColor
        otherTextFieldBorderView.layer.borderColor = UIColor.lightGray.cgColor
        blockTextFieldBorderView.layer.borderColor = UIColor.lightGray.cgColor
        addressTypeTextField.tintColor = appBarThemeColor
        otherTextField.placeholder = localizedTextFor(key: AddAddressSceneText.addressOtherInfo.rawValue)
        flatNumberTextField.placeholder = localizedTextFor(key: AddAddressSceneText.addressFlatNumber.rawValue)
        houseNumberTextField.placeholder = localizedTextFor(key: AddAddressSceneText.addressHouseNumber.rawValue)
        countryCodeTextField.textColor = appTxtfDarkColor
        navigateButton.titleLabel?.font = UIFont(name: appFont, size:17)
        countryCodeTextField.font = UIFont(name: appFont, size: 17)
        mobileNumberTextField.textColor = appTxtfDarkColor
        addressTypeTextField.textColor = appTxtfDarkColor
        otherTextField.textColor = appTxtfDarkColor
        blockTextField.tintColor = appBarThemeColor
        otherTextField.tintColor = appBarThemeColor
        addressTypeTextField.customTextAlignment()
        addressTypeTextField.font = UIFont(name: appFont, size: 17)
        mobileNumberTextField.font = UIFont(name: appFont, size: 17)
        mobileNumberTextField.customTextAlignment()
        addressTextView.font = UIFont(name: appFont, size: 17)
        addressTextView.customTextAlignment()
        countryCodeTextField.customTextAlignment()
        navigateButton.backgroundColor = appBarThemeColor
    }
    
    func applyLocalizedText() {
        let blockPlaceholder = NSMutableAttributedString(string:localizedTextFor(key: AddAddressSceneText.addressBlock.rawValue))
        blockPlaceholder.append(asterik)
        blockTextField.attributedPlaceholder = blockPlaceholder
        self.title = localizedTextFor(key: AddAddressSceneText.addressInfoSceneTitle.rawValue)
        navigateButton.setTitle(localizedTextFor(key: AddAddressSceneText.addressInfoNavigate.rawValue), for: .normal)
        let mobileTextFieldPlaceholder = NSMutableAttributedString(string:localizedTextFor(key: LoginSceneText.loginSceneMobileTextFieldPlaceholder.rawValue))
        mobileTextFieldPlaceholder.append(asterik)
        mobileNumberTextField.attributedPlaceholder = mobileTextFieldPlaceholder
        let countryObj = countryArr.filter{$0.phoneCode ==  getUserData(.countryCode)}
        if countryObj.count > 0 {
            imgFlag.image = countryObj[0].flag
        }
    }
    
    @IBAction func navigateAction(sender: UIButton) {
        if LocationWrapper.sharedInstance.latitude != 0.0 {
            let lat = editObj!.latitude.doubleValue()
            let long = editObj!.longitude.doubleValue()
            CommonFunctions.sharedInstance.openGoogleMap(destinationLatitude: lat, destinationLongitude: long)
        }
    }
    
    func displayOldData() {
        countryCodeTextField.text = editObj.countryCode
        mobileNumberTextField.text = editObj.phoneNumber
        addressTextView.text = editObj.address
        addressTypeTextField.text = editObj.title
        otherTextField.text = editObj.road
        houseNumberTextField.text = editObj.houseNumber
        flatNumberTextField.text = editObj.flatNumber
        blockTextField.text = editObj.block
    }
}

extension AddressInfoViewController: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == mobileNumberTextField {
            if let url = URL(string: "tel://" + editObj!.phoneNumber) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
        return false
    }
    
}
