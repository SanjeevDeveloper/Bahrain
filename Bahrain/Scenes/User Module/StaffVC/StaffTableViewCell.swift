
import UIKit
import Cosmos

class StaffTableViewCell: UITableViewCell {

    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLabel:  UILabelFontSize!
    @IBOutlet weak var userServiceLabel: UILabelFontSize!
    @IBOutlet weak var servicesLabel: UILabel!
    @IBOutlet weak var therapistRatingView: CosmosView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        userImageView.layer.cornerRadius = userImageView.frame.size.width/2
        userImageView.clipsToBounds = true
        
    }
    
    
    func setData(currentObj:Staff.ViewModel.tableCellData){
        
        
        
        
       
    }
    
    
  
    

}


