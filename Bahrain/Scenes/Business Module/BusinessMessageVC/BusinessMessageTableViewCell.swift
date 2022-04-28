

import UIKit

class BusinessMessageTableViewCell: UITableViewCell {

    
    @IBOutlet weak var userProfileImage: UIImageView!
    
    @IBOutlet weak var userNameLbl: UILabel!
    
    @IBOutlet weak var userChatLbl: UILabel!
    
    @IBOutlet weak var msgTimeLbl: UILabel!
    
    @IBOutlet weak var msgCountLbl: UILabel!
    
    @IBOutlet weak var pendingMsgView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func setData(obj:BusinessMessage.Something.ViewModel.showMessage) {
        userNameLbl.text = obj.name
        userChatLbl.text = obj.message
        
        pendingMsgView.isHidden = true
        
        let countStr = obj.count
        
        
        let countInt: Int? = countStr.intValue()
        
        if (!(countInt ==  0) ) {
            pendingMsgView.isHidden = false
            msgCountLbl.text = obj.count
        }
        
        
        let messageTimestampStr = (obj.messageTimestamp).stringValue
        let truncateTimeStamp = Double(messageTimestampStr.dropLast(3))
        let date = Date(timeIntervalSince1970: truncateTimeStamp!)
        //let dateFormatter = DateFormatter()
        //dateFormatter.timeZone = TimeZone(abbreviation: "GMT") //Set timezone that you want
        //dateFormatter.locale = NSLocale.current
        //dateFormatter.dateFormat = "yyyy-MM-dd HH:mm" //Specify your format that you want
        
        let date2 = Date()
        
        
        let timeAgo:String = timeStamp.sharedInstance.timeAgoSinceDate(date, currentDate: date2, numericDates: false)
        
        msgTimeLbl.text = timeAgo
                
        if let profileImageUrl = URL(string:Configurator().imageBaseUrl + obj.profileImage) {
            userProfileImage.sd_setImage(with: profileImageUrl, placeholderImage: #imageLiteral(resourceName: "PlaceHolderIcon"), options: .retryFailed, completed: nil)
        }
    }

}
