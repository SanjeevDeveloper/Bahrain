
import UIKit

class AppointmentRowTableViewCell: UITableViewCell {

    
    @IBOutlet weak var bookingLabel: UILabelFontSize!
    @IBOutlet weak var bookingDateLabel: UILabelFontSize!
    @IBOutlet weak var nameLabel: UILabelFontSize!
    @IBOutlet weak var timeLabel: UILabelFontSize!
    @IBOutlet weak var therapistNameLabel: UILabelFontSize!
    @IBOutlet weak var priceLabel: UILabelFontSize!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
