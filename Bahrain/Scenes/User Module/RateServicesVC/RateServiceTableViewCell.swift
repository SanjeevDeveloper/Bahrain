

import UIKit
import Cosmos

class RateServiceTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var therapistRating: CosmosView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
