
import UIKit

class UpcomingAppointmentTableViewCell: UITableViewCell {

    @IBOutlet weak var dateLabel: UILabelFontSize!
    @IBOutlet weak var timeLabel: UILabelFontSize!
    @IBOutlet weak var nameLabel: UILabelFontSize!
    @IBOutlet weak var categoriesLabel: UILabelFontSize!
    @IBOutlet weak var totalAmountLabel: UILabelFontSize!
    @IBOutlet weak var paymentModeLabel: UILabel!
    @IBOutlet weak var cashImage: UIImageView!
    @IBOutlet weak var cancelButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

}
