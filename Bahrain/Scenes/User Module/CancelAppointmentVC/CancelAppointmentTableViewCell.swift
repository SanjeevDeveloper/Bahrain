
import UIKit

class CancelAppointmentTableViewCell: UITableViewCell {
    
    @IBOutlet weak var selectionBtn: UIButton!
    @IBOutlet weak var reasonsLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
