
import UIKit

class AddSalonServiceTableViewCell: UITableViewCell {

    @IBOutlet weak var serviceNameLabel: UILabelFontSize!
    @IBOutlet weak var priceLabel: UILabelFontSize!
    @IBOutlet weak var deleteButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 8
    }

}
