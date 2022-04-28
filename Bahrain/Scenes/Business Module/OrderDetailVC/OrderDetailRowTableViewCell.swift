
import UIKit

class OrderDetailRowTableViewCell: UITableViewCell {

    
    @IBOutlet weak var bookingLabel: UILabelFontSize!
    @IBOutlet weak var bookingDateLabel: UILabelFontSize!
    @IBOutlet weak var nameLabel: UILabelFontSize!
    @IBOutlet weak var timeLabel: UILabelFontSize!
    @IBOutlet weak var therapistNameLabel: UILabelFontSize!
    @IBOutlet weak var priceLabel: UILabelFontSize!
    @IBOutlet weak var discountLabel: UILabelFontSize!
    @IBOutlet weak var paybleLabel: UILabelFontSize!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let languageIdentifier = UserDefaults.standard.value(forKey: userDefualtKeys.currentLanguage.rawValue) as! String
        if languageIdentifier == Languages.Arabic {
           bookingDateLabel.textAlignment = .left
           therapistNameLabel.textAlignment = .left
        }
        else {
            bookingDateLabel.textAlignment = .right
            therapistNameLabel.textAlignment = .right
        }
        
    }

}
