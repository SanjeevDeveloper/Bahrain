
import UIKit

class SpecialOffersCollectionViewCell: UICollectionViewCell {
    
    // MARK: Cell Interface Builder Outlets
    
    @IBOutlet weak var salonTitleLbl: UILabel!
    @IBOutlet weak var salonSubTitleLbl: UILabel!
    @IBOutlet weak var serviceCountOnImgLbl: UILabel!
    @IBOutlet weak var checkoutLbl: UILabel!
    @IBOutlet weak var outofLbl: UILabel!
    @IBOutlet weak var totalPriceLbl: UILabel!
    @IBOutlet weak var offerPriceLbl: UILabel!
    @IBOutlet weak var salonMainImgV: UIImageView!
    @IBOutlet weak var serviceTypeTblView: UITableView!
    @IBOutlet weak var checkoutBtnBgVw: UIView!
    @IBOutlet weak var checkoutBtn: UIButton!
    
    var servicesArray = [SalonDetail.SpecialOfferService]()
    var serviceType = ""
    var offerType = ""
    var currentVC = SalonDetailViewController()
    var dynamicServiceCount = 0
    var specialOffer: SalonDetail.SpecialOfferDetail?
    var spTotalPrice = 0.0
    var spofferPrice = 0.0
    
    override func awakeFromNib() {
        serviceTypeTblView.rowHeight = 40
        outofLbl.textColor = .white
        checkoutLbl.text = localizedTextFor(key: SpecialOffersText.checkout.rawValue)
    }
    
    func displayCellData(specialOffer: SalonDetail.SpecialOfferDetail, vc: SalonDetailViewController) {
        dynamicServiceCount = 0
        spTotalPrice = 0.0
        spofferPrice = 0.0
        currentVC = vc
        self.specialOffer = specialOffer
        if let heading = specialOffer.heading {
            salonTitleLbl.text = heading
        }
        
        if isCurrentLanguageArabic() {
            if let offerName = specialOffer.offerNameArabic {
                salonSubTitleLbl.text = offerName
            }
        } else {
            if let offerName = specialOffer.offerName {
                salonSubTitleLbl.text = offerName
            }
        }
        
        if let coverPhoto = specialOffer.businessId?.coverPhoto {
            let coverImage = Configurator().imageBaseUrl + coverPhoto
            salonMainImgV.sd_setImage(with: URL(string: coverImage), completed: nil)
        }
        
        if let services = specialOffer.businessServicesId {
            servicesArray = services
            serviceTypeTblView.reloadData()
        }
        
        if let type = specialOffer.serviceType {
            serviceType = type
            var totalPrice = 0.0
            var offerPrice = 0.0
            if type == "home" {
                totalPrice = specialOffer.totalHomePrice ?? 0.0
                offerPrice = specialOffer.offerHomePrice ?? 0.0
            } else {
                totalPrice = specialOffer.totalSalonPrice ?? 0.0
                offerPrice = specialOffer.offerSalonPrice ?? 0.0
            }
            
            let servicePrice = String(format: "%.3f", totalPrice)
            let completePrice = servicePrice.description + " " +  localizedTextFor(key: GeneralText.bhd.rawValue)
            totalPriceLbl.attributedText = NSAttributedString(string: completePrice, attributes: [NSAttributedString.Key.strikethroughStyle: 1, NSAttributedString.Key.strikethroughColor: UIColor.white])
            offerPriceLbl.text = String(format: "%.3f", offerPrice) + " " + localizedTextFor(key: GeneralText.bhd.rawValue)
        }
        
        if let offerT = specialOffer.offerType {
            offerType = offerT
            if offerT == "static" {
                totalPriceLbl.isHidden = false
                offerPriceLbl.isHidden = false
                serviceCountOnImgLbl.text = "\(servicesArray.count)"
                outofLbl.text = "(\(servicesArray.count) \(localizedTextFor(key: SpecialOffersText.outOf.rawValue)) \(servicesArray.count))"
                checkoutBtnBgVw.backgroundColor = appBarThemeColor
                checkoutBtnBgVw.isUserInteractionEnabled = true
            } else  {
                checkoutLogicForDymanicOffer()
            }
        }
    }
    
    func checkoutLogicForDymanicOffer() {
        if offerType == "dynamic" {
            outofLbl.isHidden = false
            outofLbl.textColor = .white
            if dynamicServiceCount == self.specialOffer?.canBookServices! {
                totalPriceLbl.isHidden = false
                checkoutBtnBgVw.backgroundColor = appBarThemeColor
                checkoutBtnBgVw.isUserInteractionEnabled = true
            } else {
                totalPriceLbl.isHidden = true
                checkoutBtnBgVw.backgroundColor = UIColor.lightGray
                checkoutBtnBgVw.isUserInteractionEnabled = false
                if dynamicServiceCount == 0 {
                } else {
                    if dynamicServiceCount > self.specialOffer!.canBookServices! {
                        CustomAlertController.sharedInstance.showErrorAlert(error: localizedTextFor(key: SpecialOffersText.maxSelection.rawValue))
                    }
                }
            }
            serviceCountOnImgLbl.text = "\(dynamicServiceCount)"
            outofLbl.text = "(\(dynamicServiceCount) \(localizedTextFor(key: SpecialOffersText.outOf.rawValue)) \(self.specialOffer?.canBookServices ?? 0))"
        }
        else {
            outofLbl.isHidden = true
            if dynamicServiceCount == 0 {
                serviceCountOnImgLbl.text = "0"
                totalPriceLbl.isHidden = true
                checkoutBtnBgVw.backgroundColor = UIColor.lightGray
                checkoutBtnBgVw.isUserInteractionEnabled = false
            } else {
                serviceCountOnImgLbl.text = "\(dynamicServiceCount)"
                totalPriceLbl.isHidden = false
                checkoutBtnBgVw.backgroundColor = appBarThemeColor
                checkoutBtnBgVw.isUserInteractionEnabled = true
            }
        }
    }
}

extension SpecialOffersCollectionViewCell : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return servicesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SpecialOfferServiceTableViewCell", for: indexPath) as! SpecialOfferServiceTableViewCell
        cell.displayCellData(service: servicesArray[indexPath.row], serviceType: serviceType, offerType: self.offerType)
        
        if offerType == "static" || offerType == "single service"{
            cell.priceLbl.isHidden = false
            if offerType == "static" {
                cell.addItemBtn.isHidden = true
                cell.offerPriceLbl.isHidden = true
            } else {
                cell.addItemBtn.isHidden = false
                cell.offerPriceLbl.isHidden = false
            }
        } else {
            cell.addItemBtn.isHidden = false
            cell.offerPriceLbl.isHidden = true
            if !servicesArray[indexPath.row].isServiceAdded {
                cell.priceLbl.isHidden = true
            } else {
                cell.priceLbl.isHidden = false
            }
        }
        
        
        if !servicesArray[indexPath.row].isServiceAdded {
            cell.addItemBtn.isSelected = false
            cell.addItemBtn.layer.borderWidth = 1.0
            cell.addItemBtn.layer.cornerRadius = 5.0
            cell.addItemBtn.layer.borderColor = appBarThemeColor.cgColor
            cell.addItemBtn.titleLabel?.textColor = appBarThemeColor
            cell.addItemBtn.setBackgroundColor(color: .white, forState: .normal)
            cell.addItemBtn.setTitle(localizedTextFor(key: SpecialOffersText.addItem.rawValue), for: .normal)
        } else {
            cell.addItemBtn.isSelected = true
            cell.addItemBtn.layer.borderWidth = 0
            cell.addItemBtn.layer.cornerRadius = 5.0
            cell.addItemBtn.titleLabel?.textColor = UIColor.white
            cell.addItemBtn.setBackgroundColor(color: appBarThemeColor, forState: .normal)
            cell.addItemBtn.setTitle(localizedTextFor(key: UserListSceneText.UserListSceneAddedButton.rawValue).uppercased(), for: .normal)
        }
        
//        if isCurrentLanguageArabic() {
//            if servicesArray[indexPath.row].serviceDescriptionArabic != "" {
//                cell.infoBtn.isHidden = false
//            } else {
//                cell.infoBtn.isHidden = true
//            }
//        } else {
            if servicesArray[indexPath.row].serviceDescription != "" {
                cell.infoBtn.isHidden = false
            } else {
                cell.infoBtn.isHidden = true
            }
        //}
        
        cell.addItemBtn.tag = indexPath.row
        cell.addItemBtn.addTarget(self, action: #selector(addItemBtn(_:)), for: .touchUpInside)
        cell.infoBtn.tag = indexPath.row
        cell.infoBtn.addTarget(self, action: #selector(infoButtonAction(sender:)), for: .touchUpInside)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    @objc func addItemBtn(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            dynamicServiceCount += 1
            servicesArray[sender.tag].isServiceAdded = true
            if offerType != "static" {
                if let type = self.specialOffer?.serviceType {
                    serviceType = type
                    if type == "home" {
                        if offerType != "dynamic" {
                            spTotalPrice += servicesArray[sender.tag].totalHomePrice ?? 0.0
                            spofferPrice += servicesArray[sender.tag].offerHomePrice ?? 0.0
                        } else {
                            spTotalPrice += servicesArray[sender.tag].homePrice ?? 0.0
                            spofferPrice = self.specialOffer?.offerHomePrice ?? 0.0
                        }
                    } else {
                        
                        if offerType != "dynamic" {
                            spTotalPrice += servicesArray[sender.tag].totalSalonPrice ?? 0.0
                            spofferPrice += servicesArray[sender.tag].offerSalonPrice ?? 0.0
                        } else {
                            spTotalPrice += servicesArray[sender.tag].salonPrice ?? 0.0
                            spofferPrice = self.specialOffer?.offerSalonPrice ?? 0.0
                        }
                    }
                    
                    let servicePrice = String(format: "%.3f", spTotalPrice)
                    let completePrice = servicePrice.description + " " +  localizedTextFor(key: GeneralText.bhd.rawValue)
                    totalPriceLbl.attributedText = NSAttributedString(string: completePrice, attributes: [NSAttributedString.Key.strikethroughStyle: 1, NSAttributedString.Key.strikethroughColor: UIColor.white])
                    offerPriceLbl.text = String(format: "%.3f", spofferPrice) + " " + localizedTextFor(key: GeneralText.bhd.rawValue)
                }
            }
        } else {
            if dynamicServiceCount > 0 {
                dynamicServiceCount -= 1
                if offerType != "static" {
                    if let type = self.specialOffer?.serviceType {
                        serviceType = type
                        if type == "home" {
                            if offerType != "dynamic" {
                                spTotalPrice -= servicesArray[sender.tag].totalHomePrice ?? 0.0
                                spofferPrice -= servicesArray[sender.tag].offerHomePrice ?? 0.0
                            } else {
                                spTotalPrice -= servicesArray[sender.tag].homePrice ?? 0.0
                                spofferPrice = self.specialOffer?.offerHomePrice ?? 0.0
                            }
                        } else {
                            
                            if offerType != "dynamic" {
                                spTotalPrice -= servicesArray[sender.tag].totalSalonPrice ?? 0.0
                                spofferPrice -= servicesArray[sender.tag].offerSalonPrice ?? 0.0
                            } else {
                                spTotalPrice -= servicesArray[sender.tag].salonPrice ?? 0.0
                                spofferPrice = self.specialOffer?.offerSalonPrice ?? 0.0
                            }
                        }
                        currentVC.calculatedTotalPrice = Float(spTotalPrice)
                        let servicePrice = String(format: "%.3f", spTotalPrice)
                        let completePrice = servicePrice.description + " " +  localizedTextFor(key: GeneralText.bhd.rawValue)
                        totalPriceLbl.attributedText = NSAttributedString(string: completePrice, attributes: [NSAttributedString.Key.strikethroughStyle: 1, NSAttributedString.Key.strikethroughColor: UIColor.white])
                        offerPriceLbl.text = String(format: "%.3f", spofferPrice) + " " + localizedTextFor(key: GeneralText.bhd.rawValue)
                    }
                }
            } else {
                spTotalPrice = 0.0
                spofferPrice = 0.0
            }
            servicesArray[sender.tag].isServiceAdded = false
        }
        checkoutLogicForDymanicOffer()
        serviceTypeTblView.reloadData()
    }
    
    @objc func infoButtonAction(sender: UIButton) {
        
        //var aboutText = ""
//        if isCurrentLanguageArabic() {
//            aboutText = servicesArray[sender.tag].serviceDescriptionArabic ?? ""
//        } else {
          let aboutText = servicesArray[sender.tag].serviceDescription ?? ""
       // }
        
        if aboutText != "" {
            let alertController: UIAlertController = UIAlertController(title: aboutText, message: nil, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: localizedTextFor(key: GeneralText.ok.rawValue), style: .default, handler: { (_) in
                alertController.dismiss(animated: true, completion: nil)
            }))
            currentVC.present(alertController, animated: true, completion: nil)
        }
    }
}
