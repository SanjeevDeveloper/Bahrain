

import UIKit

class messageTableViewCell: UITableViewCell {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var usrNameLbl: UILabel!
    @IBOutlet weak var usrChatDescLbl: UILabel!
    @IBOutlet weak var messageTimeLbl: UILabel!
    @IBOutlet weak var pendingMsgBkgView: UIView!
    @IBOutlet weak var pendingMsgLbl: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setData(obj:message.Something.ViewModel.showMessage) {
        usrNameLbl.text = obj.name
        usrChatDescLbl.text = obj.message
        
        
        pendingMsgBkgView.isHidden = true
        let countStr = obj.count
        
       
        let countInt: Int? = countStr.intValue()
        
        if (!(countInt ==  0) ) {
             pendingMsgBkgView.isHidden = false
            pendingMsgLbl.text = obj.count
        }
        
        let messageTimestampStr = (obj.messageTimestamp).stringValue
        let truncateTimeStamp = Double(messageTimestampStr.dropLast(3))
        let date = Date(timeIntervalSince1970: truncateTimeStamp!)
        //let dateFormatter = DateFormatter()
        //dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        //dateFormatter.locale = NSLocale.current
        //dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        
        let date2 = Date()
        let timeAgo:String = timeStamp.sharedInstance.timeAgoSinceDate(date, currentDate: date2, numericDates: false)
     
        messageTimeLbl.text = timeAgo
        
        if let profileImageUrl = URL(string:Configurator().imageBaseUrl + obj.profileImage) {
            profileImage.sd_setImage(with: profileImageUrl, placeholderImage: #imageLiteral(resourceName: "PlaceHolderIcon"), options: .retryFailed, completed: nil)
        }
    }
}


