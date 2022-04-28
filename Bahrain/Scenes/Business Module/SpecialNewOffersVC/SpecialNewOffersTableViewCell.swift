
import UIKit

class SpecialNewOffersTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabelFontSize!
    @IBOutlet weak var priceLabel: UILabelFontSize!
    @IBOutlet weak var timeLabel: UILabelFontSize!
    @IBOutlet weak var deleteButton: UIButtonCustomClass!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        deleteButton.setTitle(localizedTextFor(key: GeneralText.deleteRow.rawValue), for: .normal)
    }
}
