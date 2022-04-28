
import UIKit

class StaticGridCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var backgroundImageView:UIImageView!
    @IBOutlet weak var title:UILabel!
    
    func setData(obj:ListYourService.ViewModel.service){
        let backGroundImageUrlString = Configurator().imageBaseUrl + obj.bgImageName
        let backGroundImageUrl = URL(string: backGroundImageUrlString)
        backgroundImageView.sd_setImage(with: backGroundImageUrl, completed: nil)
        
        title.text = obj.name.uppercased()
    }
    
}
