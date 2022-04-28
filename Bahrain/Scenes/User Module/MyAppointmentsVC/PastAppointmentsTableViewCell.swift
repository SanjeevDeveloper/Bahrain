
import UIKit

class PastAppointmentsTableViewCell: UITableViewCell {
    @IBOutlet weak var dateLabel: UILabelFontSize!
    @IBOutlet weak var timeLabel: UILabelFontSize!
    @IBOutlet weak var nameLabel: UILabelFontSize!
    @IBOutlet weak var categoriesLabel: UILabelFontSize!
    @IBOutlet weak var totalAmountLabel: UILabelFontSize!
    @IBOutlet weak var successMsgLabel: UILabelFontSize!
    @IBOutlet weak var refreshButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

}
