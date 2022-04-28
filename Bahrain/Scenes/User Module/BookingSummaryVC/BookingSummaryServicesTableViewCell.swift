

import UIKit

class BookingSummaryServicesTableViewCell: UITableViewCell {
    
    @IBOutlet weak var serviceNameLabel: UILabelCustomClass!
    @IBOutlet weak var bookingDateLabel: UILabel!
    @IBOutlet weak var therapistNameLabel: UILabel!
    @IBOutlet weak var salonNameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var bookingdateInfoLabel: UILabel!
    @IBOutlet weak var therapistInfoLabel: UILabel!
    @IBOutlet weak var salonInfoLabel: UILabel!
    @IBOutlet weak var priceInfoLabel: UILabel!
    @IBOutlet weak var offerPriceInfoLabel: UILabel!
    @IBOutlet weak var noteLabel: UILabel!
    
    @IBOutlet weak var discountAmountTitleLabel: UILabel!
    @IBOutlet weak var discountAmountLabel: UILabel!
    @IBOutlet weak var payabaleAmountTitleLabel: UILabel!
    @IBOutlet weak var payabaleAmountLabel: UILabel!
    
    @IBOutlet weak var promoLabelsView: UIView!
    @IBOutlet weak var promoLabelViewHeightConstraint: NSLayoutConstraint!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        discountAmountTitleLabel.text = localizedTextFor(key: BookingSummarySceneText.summaryDiscountAmount.rawValue)
        payabaleAmountTitleLabel.text = localizedTextFor(key: BookingSummarySceneText.summaryPayableAmount.rawValue)
        serviceNameLabel.backgroundColor = appBarThemeColor
        bookingDateLabel.text = localizedTextFor(key: BookingSummarySceneText.bookingSummarySceneBookingDateCellLabel.rawValue)
        therapistNameLabel.text = localizedTextFor(key: BookingSummarySceneText.bookingSummarySceneTherapistCellLabel.rawValue)
        salonNameLabel.text = localizedTextFor(key: BookingSummarySceneText.bookingSummarySceneSalonNameCellLabel.rawValue)
        priceLabel.text = localizedTextFor(key: BookingSummarySceneText.bookingSummaryScenepriceCellLabel.rawValue)
            
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
