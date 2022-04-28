
import UIKit
import SDWebImage

class SpecialSalonTableViewCell: UITableViewCell {
    
    // MARK: Cell Interface Builder Outlets
    
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var salonImageView: UIImageView!
    @IBOutlet weak var salonNameLbl: UILabelFontSize!
    @IBOutlet weak var uptoOffLbl: UILabelFontSize!
    @IBOutlet weak var homeServicesLbl: UILabelFontSize!
    @IBOutlet weak var homeServicesValueLbl: UILabelFontSize!
    @IBOutlet weak var homePackageLbl: UILabelFontSize!
    @IBOutlet weak var homePackageValueLbl: UILabelFontSize!
    @IBOutlet weak var salonServicesLbl: UILabelFontSize!
    @IBOutlet weak var salonServicesValueLbl: UILabelFontSize!
    @IBOutlet weak var salonPackageLbl: UILabelFontSize!
    @IBOutlet weak var salonPackageValueLbl: UILabelFontSize!
    
    // MARK: Awake From Nib
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.salonImageView.layer.cornerRadius = self.salonImageView.frame.height / 2
        self.salonImageView.clipsToBounds = true
        self.contentView.bringSubview(toFront: salonImageView)
        
        if let languageIdentifier = UserDefaults.standard.value(forKey: userDefualtKeys.currentLanguage.rawValue) as? String {
            if languageIdentifier == Languages.Arabic {
                self.homeServicesLbl.textAlignment = .right
                self.homePackageLbl.textAlignment = .right
            }
            else {
                self.homeServicesLbl.textAlignment = .left
                self.homePackageLbl.textAlignment = .left
            }
        }
        
        self.homeServicesLbl.text = localizedTextFor(key: SpecialOffersText.homeServices.rawValue)
        self.homeServicesLbl.textColor = appTxtfDarkColor
        self.homePackageLbl.text = localizedTextFor(key: SpecialOffersText.homePackages.rawValue)
        self.homePackageLbl.textColor = appTxtfDarkColor
        self.salonServicesLbl.text = localizedTextFor(key: SpecialOffersText.salonServices.rawValue)
        self.salonServicesLbl.textColor = appTxtfDarkColor
        self.salonPackageLbl.text = localizedTextFor(key: SpecialOffersText.salonPackages.rawValue)
        self.salonPackageLbl.textColor = appTxtfDarkColor
        
        self.homeServicesValueLbl.textColor = appBarThemeColor
        self.homePackageValueLbl.textColor = appBarThemeColor
        self.salonServicesValueLbl.textColor = appBarThemeColor
        self.salonPackageValueLbl.textColor = appBarThemeColor
        
        self.salonNameLbl.textColor = appBtnWhiteColor
        self.uptoOffLbl.textColor = appBtnWhiteColor
    }
    
    func displayCellData(salonObj: SpecialSalonList.SalonObject) {
        
        salonNameLbl.text = salonObj.businessName ?? ""
        
        if let coverPhoto = salonObj.coverPhoto {
            let coverImage = Configurator().imageBaseUrl + coverPhoto
            coverImageView.sd_setImage(with: URL(string: coverImage), completed: nil)
        }
        
        if let profilePhoto = salonObj.profileImage {
            let profileImage = Configurator().imageBaseUrl + profilePhoto
            salonImageView.sd_setImage(with: URL(string: profileImage), placeholderImage: #imageLiteral(resourceName: "PlaceHolderIcon"), options: .retryFailed, completed: nil)
        }
        
        if salonObj.percentageOff ?? 0 != 0 {
            uptoOffLbl.isHidden = false
            uptoOffLbl.text = "\(salonObj.percentageOff ?? 0)% \(localizedTextFor(key: SpecialOffersText.off.rawValue))"
        } else {
            uptoOffLbl.isHidden = true
        }
        
        self.homeServicesValueLbl.text = "\(salonObj.homeServices ?? 0)"
        self.homePackageValueLbl.text = "\(salonObj.homePackages ?? 0)"
        self.salonServicesValueLbl.text = "\(salonObj.salonServices ?? 0)"
        self.salonPackageValueLbl.text = "\(salonObj.salonPackages ?? 0)"
    }
}
