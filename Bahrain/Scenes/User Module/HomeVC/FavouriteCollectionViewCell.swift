
import UIKit

class FavouriteCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var salonFavoriteImageView: UIImageView!
    
    func setData(currentObj:Home.FavouriteApiViewModel.CellData){
        if currentObj.favImage == nil {
            if currentObj.salonImage != "" {
                let salonImage = currentObj.salonImage
                let imageUrl = Configurator().imageBaseUrl + salonImage
                salonFavoriteImageView.sd_setImage(with: URL(string: imageUrl)) { (image, error, cacheType, url) in
                    if error != nil {
                        self.salonFavoriteImageView.image = defaultSaloonImage
                    }
                }
            }
            else {
                salonFavoriteImageView.image = defaultSaloonImage
            }
        }
        else {
            salonFavoriteImageView.image = currentObj.favImage
        }
    }
}
