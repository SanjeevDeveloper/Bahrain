
import UIKit

class BusinessBookingTableViewCell: UITableViewCell {

    @IBOutlet weak var servicesDetailLabel: UILabelFontSize!
    @IBOutlet weak var timeLabel: UILabelFontSize!
    @IBOutlet weak var bookingCollectionView: UICollectionView!
    @IBOutlet weak var bottomLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
