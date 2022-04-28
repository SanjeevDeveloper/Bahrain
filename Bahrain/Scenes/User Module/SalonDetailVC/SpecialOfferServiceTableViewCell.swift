
import UIKit

class SpecialOfferServiceTableViewCell: UITableViewCell {
    
    // MARK: Cell Interface Builder Outlets
    
    @IBOutlet weak var addItemBtn: UIButton!
    @IBOutlet weak var infoBtn: UIButton!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var offerPriceLbl: UILabel!
    @IBOutlet weak var serviceTypeLbl: UILabel!
    @IBOutlet weak var packageTypeImgV: UIImageView!
    
    // MARK: Awake From Nib
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        if isCurrentLanguageArabic() {
            priceLbl.textAlignment = .left
            offerPriceLbl.textAlignment = .left
        } else {
            priceLbl.textAlignment = .right
            offerPriceLbl.textAlignment = .right
        }
        
        self.addItemBtn.isSelected = false
        self.addItemBtn.layer.borderWidth = 1.0
        self.addItemBtn.layer.cornerRadius = 5.0
        self.addItemBtn.layer.borderColor = appBarThemeColor.cgColor
        self.addItemBtn.titleLabel?.textColor = appBarThemeColor
        self.addItemBtn.setBackgroundColor(color: .white, forState: .normal)
        
        packageTypeImgV.layer.cornerRadius = packageTypeImgV.frame.height/2
        serviceTypeLbl.textColor = appTxtfLighterGrayColor
        priceLbl.textColor = appTxtfLighterGrayColor
        offerPriceLbl.textColor = appTxtfLighterGrayColor
    }
    
    func displayCellData(service: SalonDetail.SpecialOfferService, serviceType: String, offerType: String) {
        
        if isCurrentLanguageArabic() {
            serviceTypeLbl.text = service.serviceNameArabic ?? ""
        } else {
            serviceTypeLbl.text = service.serviceName ?? ""
        }
        
        //serviceTypeLbl.text = service.serviceName ?? ""
        
        var servicePrice = "0.0"
        
        if offerType == "static" || offerType == "dynamic" {
            servicePrice = String(format: "%.3f", service.servicePrice ?? 0.0)
        } else {
            if serviceType == "home" {
                offerPriceLbl.text = String(format: "%.3f", service.offerHomePrice ?? 0.0) + " " +  localizedTextFor(key: GeneralText.bhd.rawValue)
                servicePrice = String(format: "%.3f", service.homePrice ?? 0.0)
            } else {
                offerPriceLbl.text = String(format: "%.3f", service.offerSalonPrice ?? 0.0) + " " +  localizedTextFor(key: GeneralText.bhd.rawValue)
                servicePrice = String(format: "%.3f", service.salonPrice ?? 0.0)
            }
        }
        
        let completePrice = servicePrice.description + " " +  localizedTextFor(key: GeneralText.bhd.rawValue)
        
        priceLbl.attributedText = NSAttributedString(string: completePrice, attributes: [NSAttributedString.Key.strikethroughStyle: 1, NSAttributedString.Key.strikethroughColor: appBarThemeColor])
        if serviceType == "home" {
            packageTypeImgV.image = #imageLiteral(resourceName: "homeOn")
        } else {
            packageTypeImgV.image = #imageLiteral(resourceName: "chairOn")
        }
    }
}
