
import UIKit

class SpecialOfferUserTableViewCell: UITableViewCell {
    
    @IBOutlet weak var offerImageView: UIImageView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var salonNameLabel: UILabelFontSize!
    @IBOutlet weak var offerNameLabel: UILabelFontSize!
    @IBOutlet weak var offerPriceLabel: UILabelFontSize!
    @IBOutlet weak var totalPriceLabel: UILabelFontSize!
    @IBOutlet weak var serviceNameLabel: UILabelFontSize!
    @IBOutlet weak var forAllLabel: UILabelFontSize!
    @IBOutlet weak var bookNowButton: UIButton!
    @IBOutlet weak var serviceImageView: UIImageView!
    @IBOutlet weak var expirationDateLabel: UILabelFontSize!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        addBottomShadow(color: .lightGray)
        bookNowButton.setTitle(localizedTextFor(key: SpecialOfferListUserSceneText.specialOfferListUserSceneBookNow.rawValue), for: .normal)
        
        forAllLabel.text = localizedTextFor(key: SpecialOfferListUserSceneText.specialOfferListUserSceneForAll.rawValue)
    }
    
    func setData(currentObj:SpecialOfferUser.ViewModel.tableCellData){
        
        if currentObj.coverImage != "" {
            let coverImage = currentObj.coverImage
            let imageUrl = Configurator().imageBaseUrl + coverImage
            offerImageView.sd_setImage(with: URL(string: imageUrl), completed: nil)
        }
        else {
            offerImageView.image = #imageLiteral(resourceName: "businessBackground")
        }
        
        if currentObj.salonImage != "" {
            let salonImage = currentObj.salonImage
            let imageUrl = Configurator().imageBaseUrl + salonImage

            profileImageView.sd_setImage(with: URL(string: imageUrl), completed: nil)
        }
        else {
            profileImageView.image = #imageLiteral(resourceName: "businessBackground")
        }
        
       salonNameLabel.text = currentObj.salonName.uppercased()
       offerNameLabel.text = currentObj.offerName.uppercased()
        
       let textBhd = localizedTextFor(key: GeneralText.bhd.rawValue)
        
       offerPriceLabel.text = String(format: "%.3f", currentObj.offerPrice.floatValue) + " " + textBhd
       totalPriceLabel.attributedText = NSAttributedString(string: String(format: "%.3f", currentObj.totalPrice.floatValue) + " " + textBhd, attributes: strikeThroughAttribute)
       serviceNameLabel.text = currentObj.serviceName
        
        if currentObj.serviceType == "salon" {
            serviceImageView.isHighlighted = false
        }
        else  {
            serviceImageView.isHighlighted = true
        }
        
        expirationDateLabel.text = localizedTextFor(key: SpecialOffersListSceneText.SpecialOffersListSceneExpiryDateText.rawValue) + ": " + currentObj.expiryDate
    }

}

