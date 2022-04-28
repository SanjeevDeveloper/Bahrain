
import UIKit

class WorkingHourRowTableViewCell: UITableViewCell {

  @IBOutlet weak var weekTextLabel: UILabel!
  @IBOutlet weak var fromTextLabel: UILabel!
  @IBOutlet weak var tillTextLabel: UILabel!
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
        switchButton.transform = CGAffineTransform(scaleX: 0.8, y: 0.8);
        fromTextLabel.text = localizedTextFor(key: WorkingHourSceneText.workingHourFromLabel.rawValue)
        tillTextLabel.text = localizedTextFor(key: WorkingHourSceneText.workingHourTillLabel.rawValue)
        tillTextField.tintColor = appBarThemeColor
        fromTextField.tintColor = appBarThemeColor
    }

}
