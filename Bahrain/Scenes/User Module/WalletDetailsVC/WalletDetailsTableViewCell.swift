
import UIKit

class WalletDetailsTableViewCell: UITableViewCell {
  
  @IBOutlet weak var bookingIDLabel: UILabel!
  @IBOutlet weak var validTillLabel: UILabel!
  @IBOutlet weak var totalAmountLabel: UILabel!
  @IBOutlet weak var backgroundLabel: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    backgroundLabel.layer.borderColor = UIColor.darkGray.withAlphaComponent(0.5).cgColor
    let currentLanguage = userDefault.value(forKey: userDefualtKeys.currentLanguage.rawValue) as! String
    
    if currentLanguage == Languages.english {
        totalAmountLabel.textAlignment = .right
    }
    else {
        totalAmountLabel.textAlignment = .left
    }
  }
  
  func setCellData(walletObject: Wallet.ViewModel.refundDetails.walletDetail) {
    self.bookingIDLabel.text = localizedTextFor(key: GeneralText.bookingId.rawValue) + " - " +  walletObject.orderId
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = dateFormats.format11
    dateFormatter.timeZone = UaeTimeZone
    let date = Date(largeMilliseconds: walletObject.validTill)
    validTillLabel.text = localizedTextFor(key: GeneralText.validTill.rawValue) + dateFormatter.string(from: date)
    totalAmountLabel.text = String(format: "%.3f", walletObject.walletAmount.floatValue) + " " + localizedTextFor(key: GeneralText.bhd.rawValue)
  }
}
