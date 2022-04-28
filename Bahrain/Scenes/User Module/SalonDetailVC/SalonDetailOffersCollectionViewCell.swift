
import UIKit

class SpecialOffersCollectionViewCell: UICollectionViewCell {
    
    // MARK: Cell Interface Builder Outlets
    
    @IBOutlet weak var salonTitleLbl: UILabel!
    @IBOutlet weak var salonSubTitleLbl: UILabel!
    @IBOutlet weak var salonMainImgV: UIImageView!
    @IBOutlet weak var serviceTypeTblView: UITableView!
}


extension SalonDetailOffersCollectionViewCell : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReUseIdentifier, for: indexPath) as! SalonDetailOffersTableViewCell
        cell.addItemBtn.addTarget(self, action: #selector(addItemBtn(_:)), for: .touchUpInside)
        return cell
    }
    
    @objc func addItemBtn(_ sender: UIButton) {
        
    }
}

