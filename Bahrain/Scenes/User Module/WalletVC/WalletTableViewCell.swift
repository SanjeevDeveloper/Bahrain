
import UIKit

class WalletTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var salonNameLbl: UILabel!
    @IBOutlet weak var refundLbl: UILabel!
    @IBOutlet weak var refundAmtLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        refundLbl.text = localizedTextFor(key: GeneralText.amount.rawValue)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
