
import UIKit

class SearchTableViewCell: UITableViewCell {

    @IBOutlet weak var salonImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabelFontSize!
    @IBOutlet weak var subTitleLabel: UILabelFontSize!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setData(currentObj:Search.ViewModel.tableCellData){
        
        if currentObj.image != "" {
            let salonImage = currentObj.image
            let imageUrl = Configurator().imageBaseUrl + salonImage
            salonImageView.sd_setImage(with: URL(string: imageUrl)) { (image, error, cacheType, url) in
                if error != nil {
                    self.salonImageView.image = defaultSaloonImage
                }
            }
        }
        else {
            salonImageView.image = defaultSaloonImage
        }
        
        salonImageView.layer.cornerRadius = 25
        
        titleLabel.text = currentObj.title
        subTitleLabel.text = currentObj.subTitle
    }
}
