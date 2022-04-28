

import UIKit

class BusinessChatTableViewCell: UITableViewCell {

    @IBOutlet weak var receiveBottomView: UIView!
    
    @IBOutlet weak var receiveBaseView: UIView!
    
    @IBOutlet weak var receiveMsgLbl: UILabel!
    
    @IBOutlet weak var receiveTimeLbl: UILabel!
    
    @IBOutlet weak var senderBottomView: UIView!
    
    @IBOutlet weak var senderBaseView: UIView!
    
    @IBOutlet weak var senderMsgLbl: UILabel!
    
    @IBOutlet weak var senderTimeLbl: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
