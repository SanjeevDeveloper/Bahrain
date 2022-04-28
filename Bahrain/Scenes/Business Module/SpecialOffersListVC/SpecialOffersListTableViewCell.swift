
import UIKit

class SpecialOffersListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var topImageView: UIImageView!
    @IBOutlet weak var deleteButton: UIButtonCustomClass!
    @IBOutlet weak var chairImageView: UIImageView!
    @IBOutlet weak var homeImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabelFontSize!
    @IBOutlet weak var titleDetailLabe: UILabelFontSize!
    @IBOutlet weak var priceLabel: UILabelFontSize!
    @IBOutlet weak var ExpirationDateLabel: UILabelFontSize!
    @IBOutlet weak var totalPriceLabel: UILabelFontSize!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        deleteButton.setTitle(localizedTextFor(key: GeneralText.deleteRow.rawValue), for: .normal)
        
    }
    func setData(currentObj:SpecialOffersList.ViewModel.tableCellData) {
        
        titleLabel.text = currentObj.offerName
        
        if currentObj.offerImage != "" {
            let offerImage = currentObj.offerImage
            let imageUrl = Configurator().imageBaseUrl + offerImage
            topImageView.sd_setImage(with: URL(string: imageUrl), completed: nil)
        }
        else {
            topImageView.image = defaultSaloonImage
        }
        
        let textBhd = localizedTextFor(key: GeneralText.bhd.rawValue)
        let salonPrice = currentObj.totalSalonPrice.floatValue.description + " " + textBhd
        let homePrice = currentObj.totalHomePrice.floatValue.description + " " + textBhd
        
        let offerSalonPrice = currentObj.offerSalonPrice.floatValue.description + " " + textBhd
        let offerHomePrice = currentObj.offerHomePrice.floatValue.description + " " + textBhd
        
        if currentObj.serviceType == "salon" {
            priceLabel.text = offerSalonPrice
            totalPriceLabel.attributedText = NSAttributedString(string: salonPrice, attributes: strikeThroughAttribute)
            chairImageView.isHighlighted = true
            homeImageView.isHighlighted = false
        }
        else {
            priceLabel.text = offerHomePrice
            totalPriceLabel.attributedText = NSAttributedString(string: homePrice, attributes: strikeThroughAttribute)
            chairImageView.isHighlighted = false
            homeImageView.isHighlighted = true
        }
        
        titleDetailLabe.text = currentObj.serviceName
        ExpirationDateLabel.text = localizedTextFor(key: SpecialOffersListSceneText.SpecialOffersListSceneExpiryDateText.rawValue) + ": " + currentObj.expiryDate
       
    }
    
}
