

import UIKit

class ListscheduledBreakTableViewCell: UITableViewCell {
    
    @IBOutlet weak var repeatlabel: UILabelFontSize!
    @IBOutlet weak var repeatInfo: UILabelFontSize!
    @IBOutlet weak var titleLabel: UILabelFontSize!
    @IBOutlet weak var startTimeLabel: UILabelFontSize!
    @IBOutlet weak var endTimeLabel: UILabelFontSize!
    @IBOutlet weak var deleteButton: UIButtonCustomClass!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        deleteButton.backgroundColor = appBarThemeColor
        deleteButton.setTitle(localizedTextFor(key: ListScheduledBreakSceneText.ListScheduledBreakSceneDeleteButton.rawValue), for: .normal)
        repeatlabel.text = "REPEAT"
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
