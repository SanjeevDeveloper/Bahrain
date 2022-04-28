
import UIKit

class TherapistWorkingHoursTableViewCell: UITableViewCell {

    @IBOutlet weak var weekTextLabel: UILabelFontSize!
    @IBOutlet weak var fromTextLabel: UILabelFontSize!
    @IBOutlet weak var tillTextLabel: UILabelFontSize!
    @IBOutlet weak var fromTextField: UITextField!
    @IBOutlet weak var tillTextField: UITextField!
    @IBOutlet weak var switchButton: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if let languageIdentifier = UserDefaults.standard.value(forKey: userDefualtKeys.currentLanguage.rawValue) as? String {
            if languageIdentifier == Languages.Arabic {
                fromTextField.textAlignment = .right
                tillTextField.textAlignment = .left
            }
            else {
                fromTextField.textAlignment = .left
                tillTextField.textAlignment = .right
            }
        }
    }

}
