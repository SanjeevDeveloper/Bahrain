
import UIKit
import Cosmos

class FavoriteListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var homeAvailabilityImageView: UIImageView!
    @IBOutlet weak var salonAvailabilityImageView: UIImageView!
    @IBOutlet weak var salonImageView: UIImageView!
    @IBOutlet weak var priceFromLabel: UILabelFontSize!
    @IBOutlet weak var salonNameLabel: UILabelFontSize!
    @IBOutlet weak var salonPlaceLabel: UILabelFontSize!
    @IBOutlet weak var starCosmosView: CosmosView!
    @IBOutlet weak var paymentTypeImageView: UIImageView!
    @IBOutlet weak var paymentTypeLabel: UILabelFontSize!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        addBottomShadow(color: .lightGray)
    }
    
    func setData(currentObj:FavoriteList.ApiViewModel.tableCellData) {
        starCosmosView.filledColor = appBarThemeColor
        
        if currentObj.coverImage != "" {
            let coverImage = currentObj.coverImage
            let imageUrl = Configurator().imageBaseUrl + coverImage
            
            coverImageView.sd_setImage(with: URL(string: imageUrl), completed: nil)
        }
        else {
            coverImageView.image = #imageLiteral(resourceName: "businessBackground")
        }
        
        if currentObj.salonImage != "" {
            let salonImage = currentObj.salonImage
            let salonImageUrl = Configurator().imageBaseUrl + salonImage
            salonImageView.sd_setImage(with: URL(string: salonImageUrl)) { (image, error, cacheType, url) in
                if error != nil {
                    self.salonImageView.image = defaultSaloonImage
                }
            }
        }
        else {
            salonImageView.image = defaultSaloonImage
        }
        
        if currentObj.cash {
            //paymentTypeImageView.image = #imageLiteral(resourceName: "favHeart")
            // paymentTypeLabel.text = localizedTextFor(key: FavoriteListSceneText.FavoriteListSceneCashPaymentLabel.rawValue)
        }
        else {
            // paymentTypeImageView.image = #imageLiteral(resourceName: "favHeart")
            // paymentTypeLabel.text = localizedTextFor(key: FavoriteListSceneText.FavoriteListSceneCardPaymentLabel.rawValue)
        }
        
        salonNameLabel.text = currentObj.name
        salonPlaceLabel.text = currentObj.salonPlace
        starCosmosView.rating = Double(currentObj.rating)
        
        let price = currentObj.price.floatValue
        let priceDisplaystring = String(format: "%.3f", price)
        
        let priceFromText = localizedTextFor(key: FavoriteListSceneText.FavoriteListScenePriceFromLabel.rawValue)
        priceFromLabel.text  = priceFromText + " " + priceDisplaystring + " " + localizedTextFor(key: GeneralText.bhd.rawValue)
        
        if currentObj.serviceType == "salon" {
            salonAvailabilityImageView.isHighlighted = true
            homeAvailabilityImageView.isHighlighted = false
        }
        else if currentObj.serviceType == "both" {
            homeAvailabilityImageView.isHighlighted = true
            salonAvailabilityImageView.isHighlighted = true
        }
        else{
            homeAvailabilityImageView.isHighlighted = true
            salonAvailabilityImageView.isHighlighted = false
        }
        
    }
    
}
