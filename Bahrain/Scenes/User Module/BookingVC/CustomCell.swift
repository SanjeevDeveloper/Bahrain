import JTAppleCalendar
import UIKit

class CustomCell: JTAppleCell {
  
  @IBOutlet weak var dateLabel: UILabel!
  @IBOutlet weak var selectedView: UIView!
  @IBOutlet weak var currentDateView: UIView!
    @IBOutlet weak var selectedViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var currentDateViewHeightConstraint: NSLayoutConstraint!
  
  override func awakeFromNib() {
    selectedView.backgroundColor = appBarThemeColor
    if (UIScreen.main.bounds.height == 568){
        selectedViewHeightConstraint.constant = 34
        currentDateViewHeightConstraint.constant = 34
        for vw in [selectedView, currentDateView] {
            vw?.layer.cornerRadius = 17
            vw?.clipsToBounds = true
        }
    } else {
        for vw in [selectedView, currentDateView] {
            vw?.layer.cornerRadius = 22.5
            vw?.clipsToBounds = true
        }
    }
  }
}

