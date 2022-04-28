
import UIKit

class SideMenuTableViewCell: UITableViewCell {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgIcon : UIImageView!

    func setData(dict:[String:AnyObject]) {
        imgIcon.image = dict["icon"]! as? UIImage
        lblTitle.text = dict["title"]! as? String
    }
}
