
import UIKit

class chatTableViewCell: UITableViewCell {

    @IBOutlet weak var outgoingMsgLbl: UILabel!
    
    @IBOutlet weak var outgoingBottomView: UIView!
    
    @IBOutlet weak var outgoingBaseView: UIView!
    
    @IBOutlet weak var incomingMsgLbl: UILabel!
    
    @IBOutlet weak var incomingBottomView: UIView!
    
    @IBOutlet weak var incomingBaseView: UIView!
    
    @IBOutlet weak var receiverTimeLbl: UILabel!
    
    @IBOutlet weak var senderTimeLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
     outgoingBaseView.backgroundColor = appBarThemeColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

}
