
import UIKit

class AddressListTableViewCell: UITableViewCell {
  
  @IBOutlet weak var addressLabel: UILabelFontSize!
  @IBOutlet weak var radioButton: UIButton!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var editButton: UIButton!
  @IBOutlet weak var useAddressButton: UIButton!
  @IBOutlet weak var deleteButton: UIButton!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    //radioButton.isSelected = true
    useAddressButton.backgroundColor = appBarThemeColor
    useAddressButton.setTitleColor(UIColor.darkGray, for: .normal)
    useAddressButton.setTitle(localizedTextFor(key: AddressListString.useThisAddress.rawValue), for: .normal)
    editButton.setTitle(localizedTextFor(key: GeneralText.editRow.rawValue), for: .normal)
    deleteButton.setTitle(localizedTextFor(key: GeneralText.deleteRow.rawValue), for: .normal)
    editButton.setTitleColor(appBarThemeColor, for: .normal)
    deleteButton.setTitleColor(appBarThemeColor, for: .normal)
    editButton.titleLabel?.font = UIFont(name: appFont, size: 16)
    deleteButton.titleLabel?.font = UIFont(name: appFont, size: 16)
    useAddressButton.titleLabel?.font = UIFont(name: appFont, size: 16)
    titleLabel.textColor = UIColor.darkGray
    
    let titleIn = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
    let imageIn = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 15)
    let titleInA = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 0)
    let imageInA = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -15)
    
    let languageIdentifier = UserDefaults.standard.value(forKey: userDefualtKeys.currentLanguage.rawValue) as! String
    if languageIdentifier == Languages.Arabic {
        editButton.imageEdgeInsets = imageInA
        editButton.titleEdgeInsets = titleInA
        deleteButton.imageEdgeInsets = imageInA
        deleteButton.titleEdgeInsets = titleInA
    } else {
        editButton.imageEdgeInsets = imageIn
        editButton.titleEdgeInsets = titleIn
        deleteButton.imageEdgeInsets = imageIn
        deleteButton.titleEdgeInsets = titleIn
    }
  }
  
  func setCellData(addressListObj: AddressList.ViewModel) {
    addressLabel.text = addressListObj.address
    titleLabel.text = addressListObj.title
  }
}
