
import UIKit

class TransactionsTableViewCell: UITableViewCell {
  
  @IBOutlet weak var paymentMethodLabel: UILabelFontSize!
  @IBOutlet weak var paidAmountLabel: UILabelFontSize!
  @IBOutlet weak var transactionIdLabel: UILabelFontSize!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

}
