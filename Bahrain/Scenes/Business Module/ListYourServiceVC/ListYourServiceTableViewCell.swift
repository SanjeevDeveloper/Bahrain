
import UIKit

class ListYourServiceTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel:UILabel!
    @IBOutlet weak var serviceImageView:UIImageView!
    @IBOutlet weak var separatorLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 7
    }
    
    func setData(obj:ListYourService.ViewModel.service) {
        nameLabel.text = obj.name.uppercased()
        let imageUrlString = Configurator().imageBaseUrl + obj.imageName
        let imageUrl = URL(string: imageUrlString)
        serviceImageView.sd_setImage(with: imageUrl, completed: nil)
    }

}
