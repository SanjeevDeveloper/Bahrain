
import UIKit
import SwipeCellKit


class ListServiceRowTableViewCell: SwipeTableViewCell {

    @IBOutlet weak var serviceRowTitle: UILabel!
    @IBOutlet weak var servicePriceAndTime: UILabel!
    @IBOutlet weak var homeButton: UIButton!
    @IBOutlet weak var salonButton: UIButton!
     @IBOutlet weak var pointImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

}
