
import UIKit
import TTGTagCollectionView

protocol BookingSummaryDisplayLogic: class
{
    func updateUI(viewModel:BookingSummary.ViewModel, totalPrice: Float, payablePrice: String, isOffer: Bool)
    func bookingConfirmed(bookingId:String)
    func displaySelectedServicesData(servicesArray:[BookingSummary.SelectedService.tableCellData], type: String)
    func promoCodeInfo(info: [String: Any])
    func clearPromoCodeInfo()
    func displaySelectedAddress(address: AddressList.ViewModel)
    func deleteAddress()
    func displayAddressList(viewModel: [AddressList.ViewModel])
    func presentBookingForAddress(address: [String : Any])
}

class BookingSummaryViewController: UIViewController, BookingSummaryDisplayLogic
{
    
    
    var interactor: BookingSummaryBusinessLogic?
    var router: (NSObjectProtocol & BookingSummaryRoutingLogic & BookingSummaryDataPassing)?
    
    // MARK: Object lifecycle
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?)
    {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK: Setup
    
    private func setup()
    {
        let viewController = self
        let interactor = BookingSummaryInteractor()
        let presenter = BookingSummaryPresenter()
        let router = BookingSummaryRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
    
    // MARK: Routing
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if let scene = segue.identifier {
            let selector = NSSelectorFromString("routeTo\(scene)WithSegue:")
            if let router = router, router.responds(to: selector) {
                router.perform(selector, with: segue)
            }
        }
    }
    
    ////////////////////////////////////////////////////
    
    @IBOutlet weak var selectAddressTxtf: UITextField!
    @IBOutlet weak var addressTxtfHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var selectedServiceTableView: UITableView!
    @IBOutlet weak var yourServicesLabel: UILabel!
    @IBOutlet weak var dateTitleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var saloonNameLabel: UILabel!
    @IBOutlet weak var paymentMethodLabel: UILabel!
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var bookingButton: UIButton!
    @IBOutlet weak var offerBookingButton: UIButton!
    @IBOutlet weak var collectionView:TTGTextTagCollectionView!
    @IBOutlet weak var paymentTableView: UITableView!
    @IBOutlet weak var totalSalonPrice: UILabelFontSize! // if comes from offer screen
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var labelPromoApply: UILabel!
    @IBOutlet weak var textFieldCode: UITextField!
    @IBOutlet weak var applyButton: UIButton!
    @IBOutlet weak var promoViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var exceedLimitLabel: UILabel!
    @IBOutlet weak var offerAmountView: UIView!
    
    @IBOutlet weak var labelOfferTotalPrice: UILabel!
    @IBOutlet weak var labelOfferDiscountPrice: UILabel!
    @IBOutlet weak var labelOfferPayablePrice: UILabel!
    
    
    
    var paymentArray = [Filter.PaymentViewModel.tableCellData]()
    var selectedServiceArray = [BookingSummary.SelectedService.tableCellData]()
    var selectedAddress: AddressList.ViewModel?
    var selectedType = ""
    var bookingIdd = ""
    var bookingDate = ""
    
    var isPromoApplied = false
    var addressListArray = [AddressList.ViewModel]()
    
    var totalServicesPrice:Float = 0
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialFunction()
        selectAddressTxtf.addRightImageViewInTextField()
        selectAddressTxtf.textColor = appTxtfDarkColor
        yourServicesLabel.textColor = appBarThemeColor
        bookingButton.setTitleColor(appBarThemeColor, for: .normal)
        offerBookingButton.setTitleColor(appBarThemeColor, for: .normal)
        bottomView.backgroundColor = appBarThemeColor
        selectedServiceTableView.tableFooterView = UIView()
        selectAddressTxtf.placeholder = localizedTextFor(key: BookingSummarySceneText.selectAddress.rawValue)
        NotificationCenter.default.addObserver(self, selector: #selector(allAddressDeleted), name: Notification.Name("allAddressDeleted"), object: nil)
    }
    
    @objc func allAddressDeleted(sender: NSNotification) {
        interactor?.deleteAddress()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        interactor?.getAddressList()
        interactor?.showSelectedAddress()
        CommonFunctions.sharedInstance.setNavigationTitleView(titleStr: localizedTextFor(key: BookingSummarySceneText.bookingSummarySceneSceneTitle.rawValue), onVC: self)
        yourServicesLabel.text = localizedTextFor(key: BookingSummarySceneText.bookingSummarySceneYourServiceText.rawValue)
        dateTitleLabel.text = localizedTextFor(key: BookingSummarySceneText.bookingSummarySceneDateTitleText.rawValue)
        paymentMethodLabel.text = localizedTextFor(key: BookingSummarySceneText.bookingSummaryScenePaymentMethodText.rawValue)
        bookingButton.setTitle(localizedTextFor(key: BookingSummarySceneText.bookingSummarySceneConfirmBookingText.rawValue), for: .normal)
        offerBookingButton.setTitle(localizedTextFor(key: BookingSummarySceneText.bookingSummarySceneConfirmBookingText.rawValue), for: .normal)
    }
    
    func initialFunction() {
        hideBackButtonTitle()
        applyButton.backgroundColor = appBarThemeColor
        textFieldCode.placeholder = localizedTextFor(key: BookingSummarySceneText.enterPromoCode.rawValue)
        applyButton.setTitle(localizedTextFor(key: BookingSummarySceneText.apply.rawValue), for: .normal)
        labelPromoApply.textColor = appBarThemeColor
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "whiteBackIcon"), style: .done, target: self, action: #selector(self.backButtonAction(sender:)))
        let languageIdentifier = UserDefaults.standard.value(forKey: userDefualtKeys.currentLanguage.rawValue) as! String
        if languageIdentifier == Languages.Arabic {
            self.navigationItem.leftBarButtonItem?.image = #imageLiteral(resourceName: "whiteRightArrow")
        }
        else {
            self.navigationItem.leftBarButtonItem?.image = #imageLiteral(resourceName: "whiteBackIcon")
        }
        
        // update UI
        interactor?.getSelectedServicesData()
        
        
        // update payment array
        let obj1 = Filter.PaymentViewModel.tableCellData(name: localizedTextFor(key: FilterSceneText.FilterSceneCashText.rawValue), isSelected: true)
        paymentArray.append(obj1)
        
        // Update collection view
        collectionView.scrollDirection = .horizontal
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.alignment = .fillByExpandingWidth
        collectionView.numberOfLines = 1
    }
    
    // MARK: UpdateUI
    
    func displaySelectedServicesData(servicesArray: [BookingSummary.SelectedService.tableCellData], type: String) {
        selectedType = type
        selectAddressTxtf.isHidden = true
        addressTxtfHeightConstraint.constant = 0
        selectedServiceArray = servicesArray
        bookingDate = servicesArray[0].bookingDate
        interactor?.updateUI()
        selectedServiceTableView.reloadData()
    }
    
    func displaySelectedAddress(address: AddressList.ViewModel) {
        self.selectedAddress = address
        selectAddressTxtf.text = address.title
    }
    
    func deleteAddress() {
        self.selectedAddress = nil
        selectAddressTxtf.text = ""
    }
    
    func updateUI(viewModel:BookingSummary.ViewModel, totalPrice: Float, payablePrice: String, isOffer: Bool) {
        totalServicesPrice = payablePrice.floatValue()
        dateLabel.text = viewModel.bookingDate + " " + localizedTextFor(key: FilterSceneText.FilterSceneSmallatText.rawValue) + " " + viewModel.bookingLeastTime
        saloonNameLabel.text = localizedTextFor(key: FilterSceneText.FilterSceneAtText.rawValue) + " " + viewModel.saloonName
        totalPriceLabel.text = viewModel.totalPrice
        if viewModel.totalSalonPrice != "" { // means coming from offer
            
            if isOffer {
                textFieldCode.isHidden = true
                applyButton.isHidden = true
            } else {
                textFieldCode.isHidden = false
                applyButton.isHidden = false
            }
            
            offerAmountView.isHidden = false
            
            let strikeThroughAttribute = [NSAttributedStringKey.strikethroughStyle: NSNumber(value: NSUnderlineStyle.styleThick.rawValue), NSAttributedStringKey.strikethroughColor: UIColor.white]
            let totallPrice = viewModel.totalPrice.floatValue()
            
            if isCurrentLanguageArabic() {
                let priceText = ltrMark + viewModel.totalSalonPrice + " " + localizedTextFor(key: GeneralText.bhd.rawValue)
                let bookingPrice = localizedTextFor(key: BookingSummarySceneText.bookingSummarySceneDiscountPriceText.rawValue) + " : " + priceText
                labelOfferDiscountPrice.text = bookingPrice
                
                let totalPriceText = ltrMark + String(format: "%.3f",totallPrice.description.floatValue()) + " " + localizedTextFor(key: GeneralText.bhd.rawValue)
                //let totalStrikedPriceText = NSAttributedString(string: totalPriceText, attributes: strikeThroughAttribute)
                
                let totalStrikedPriceText = NSMutableAttributedString()
                
                if viewModel.totalSalonPrice.doubleValue() == 0.000 {
                    labelOfferDiscountPrice.isHidden = true
                    labelOfferPayablePrice.isHidden = true
                    totalStrikedPriceText.append(NSAttributedString(string: totalPriceText))
                } else {
                    labelOfferDiscountPrice.isHidden = false
                    labelOfferPayablePrice.isHidden = false
                    totalStrikedPriceText.append(NSAttributedString(string: totalPriceText, attributes: strikeThroughAttribute))
                }
                
                let attributedPrefix = NSMutableAttributedString(string: localizedTextFor(key: BookingSummarySceneText.bookingSummarySceneTotalAmountText.rawValue) + " : " )
                attributedPrefix.append(totalStrikedPriceText)
                labelOfferTotalPrice.attributedText = attributedPrefix
                
                let payablePriceText = ltrMark + payablePrice + " " + localizedTextFor(key: GeneralText.bhd.rawValue)
                labelOfferPayablePrice.text = localizedTextFor(key: BookingSummarySceneText.bookingSummaryScenePayablePriceText.rawValue) + " : " + payablePriceText
            } else {
                let bookingPrice = localizedTextFor(key: BookingSummarySceneText.bookingSummarySceneDiscountPriceText.rawValue) + " : " + viewModel.totalSalonPrice + " " + localizedTextFor(key: GeneralText.bhd.rawValue)
                labelOfferDiscountPrice.text = bookingPrice
                
                let totalPriceText = String(format: "%.3f",totallPrice.description.floatValue()) + " " + localizedTextFor(key: GeneralText.bhd.rawValue)
                
                let attributedSuffix = NSMutableAttributedString()
                
                if viewModel.totalSalonPrice.doubleValue() == 0.000 {
                    labelOfferDiscountPrice.isHidden = true
                    labelOfferPayablePrice.isHidden = true
                    attributedSuffix.append(NSAttributedString(string: totalPriceText))
                } else {
                    labelOfferDiscountPrice.isHidden = false
                    labelOfferPayablePrice.isHidden = false
                    attributedSuffix.append(NSAttributedString(string: totalPriceText, attributes: strikeThroughAttribute))
                }
                
                // let attributedSuffix = NSMutableAttributedString(string: totalPriceText, attributes: strikeThroughAttribute)
                
                attributedSuffix.insert(NSAttributedString(string: localizedTextFor(key: BookingSummarySceneText.bookingSummarySceneTotalAmountText.rawValue) + " : "), at: 0)
                labelOfferTotalPrice.attributedText = attributedSuffix
                
                let payablePriceText = localizedTextFor(key: BookingSummarySceneText.bookingSummaryScenePayablePriceText.rawValue) + " : " + String(format: "%.3f",payablePrice.floatValue()) + " " + localizedTextFor(key: GeneralText.bhd.rawValue)
                labelOfferPayablePrice.text = payablePriceText
            }
        }
        else {
            totalSalonPrice.isHidden = true
        }
        
        let tagConfiguration = TTGTextTagConfig()
        tagConfiguration.tagBackgroundColor = appBarThemeColor
        collectionView.addTags(viewModel.servicesNames, with: tagConfiguration)
    }
    
    // MARK: BookingConfirmed
    func bookingConfirmed(bookingId:String) {
        bookingIdd = bookingId
        router?.routeToPaymentSelectionScreen(bookingId: bookingId, bookingDate: self.bookingDate)
    }
    
    // MARK: PopThreeViewControllers
    func popThreeViewControllers() {
        let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController]
        self.navigationController!.popToViewController(viewControllers[viewControllers.count - 4], animated: true)
    }
    
    // MARK: UIButton Actions
    
    @IBAction func confirmBookingAction(_ sender: Any) {
        if selectedType == "home" {
            interactor?.passBookingToAddress()
        } else {
            interactor?.confirmBooking()
        }
    }
    
    @IBAction func applyAction(_ sender: Any) {
        let promoCode = textFieldCode.text_Trimmed()
        if promoCode != "" {
            interactor?.getPromoCodeInfo(code: promoCode)
        } else {
            CustomAlertController.sharedInstance.showErrorAlert(error: localizedTextFor(key: BookingSummarySceneText.noPromoCode.rawValue))
        }
    }
    
    @objc func backButtonAction(sender: AnyObject) {
        interactor?.deleteBooking()
        self.navigationController?.popViewController(animated: true)
    }
    
    func promoCodeInfo(info: [String: Any]) {
        let isMaxDiscountAvail = info["isMaxDiscountAvail"] as? Bool ?? false
        let actualDiscountReceived = info["discountAvailed"] as? String ?? ""
        if isMaxDiscountAvail {
            exceedLimitLabel.text = localizedTextFor(key: BookingSummarySceneText.maximumDiscount.rawValue) + " \(actualDiscountReceived) " + localizedTextFor(key: BookingSummarySceneText.limitHasExceed.rawValue)
        }
        
        let priceAfterDiscount = info["priceAfterDiscount"] as? String ?? ""
        if let servicesArray = info["services"] as? [[String: Any]] {
            updateServicesArray(servicesArray)
            isPromoApplied = true
            selectedServiceTableView.reloadData()
        }
        
        labelPromoApply.text = localizedTextFor(key: BookingSummarySceneText.promoCodeAppliedSuccessfully.rawValue)
        labelPromoApply.textColor = #colorLiteral(red: 0.3515368104, green: 0.7509177923, blue: 0, alpha: 1)
        exceedLimitLabel.textColor = #colorLiteral(red: 0.3515368104, green: 0.7509177923, blue: 0, alpha: 1)
        promoViewHeightConstraint.constant = 103
        
        let strikeThroughAttribute = [NSAttributedStringKey.strikethroughStyle: NSNumber(value: NSUnderlineStyle.styleThick.rawValue), NSAttributedStringKey.strikethroughColor: UIColor.white]
        if isCurrentLanguageArabic() {
            let suffix = NSMutableAttributedString(string: ltrMark + totalServicesPrice.description + " " + localizedTextFor(key: GeneralText.bhd.rawValue), attributes: strikeThroughAttribute)
            suffix.insert(NSAttributedString(string: localizedTextFor(key: BookingSummarySceneText.bookingSummarySceneTotalPriceText.rawValue) + " - "), at: 0)
            totalPriceLabel.attributedText = suffix
        } else {
            let prefix = NSAttributedString(string: localizedTextFor(key: BookingSummarySceneText.bookingSummarySceneTotalPriceText.rawValue) + " - ")
            let strikeText = NSMutableAttributedString(string: totalServicesPrice.description + " " + localizedTextFor(key: GeneralText.bhd.rawValue), attributes: strikeThroughAttribute)
            strikeText.insert(prefix, at: 0)
            totalPriceLabel.attributedText = strikeText
        }
        
        
        totalSalonPrice.isHidden = false
        if isCurrentLanguageArabic() {
            let priceText = ltrMark + priceAfterDiscount + " " + localizedTextFor(key: GeneralText.bhd.rawValue)
            let bookingPrice = localizedTextFor(key: BookingSummarySceneText.bookingSummaryScenePayablePriceText.rawValue) + " - " + priceText
            totalSalonPrice.text = bookingPrice
        } else {
            let bookingPrice = localizedTextFor(key: BookingSummarySceneText.bookingSummaryScenePayablePriceText.rawValue) + " - " + priceAfterDiscount + " " + localizedTextFor(key: GeneralText.bhd.rawValue)
            totalSalonPrice.text = bookingPrice
        }
        
        var dict = info
        dict["couponCode"] = textFieldCode.text_Trimmed()
        interactor?.updatePromoCodeDict(dict: dict)
    }
    
    func displayAddressList(viewModel: [AddressList.ViewModel]) {
        addressListArray = viewModel
    }
    
    func presentBookingForAddress(address: [String : Any]) {
        if addressListArray.count > 0 {
            router?.routeToAddressList(booking: address)
        } else {
            router?.routeToAddAddress(booking: address)
        }
    }
    
    func formatNumber(_ number: NSNumber) -> String {
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 3 // minimum number of fraction digits on right
        formatter.maximumFractionDigits = 3 // maximum number of fraction digits on right, or comment for all available
        formatter.minimumIntegerDigits = 1 // minimum number of integer digits on left (necessary so that 0.5 don't return .500)
        let formattedNumber = formatter.string(from: number)
        return formattedNumber ?? String(format: "%.3f", number.floatValue)
    }
    
    func updateServicesArray(_ services: [[String: Any]]) {
        for service in services {
            let serviceId = service["businessServiceId"] as! String
            
            for (index,item) in selectedServiceArray.enumerated() {
                if item.id == serviceId {
                    if let discountAvailed = service["discountAvailed"] as? NSNumber {
                        
                        let discountLimitExceed = service["discountLimitExceed"] as? Bool ?? false
                        selectedServiceArray[index].isdiscountLimitExceed = discountLimitExceed
                        
                        let payabaleAmount = service["payableAmount"] as? NSNumber ?? 0
                        
                        selectedServiceArray[index].discountAmount = String(format: "%.3f", discountAvailed.floatValue) + " " + localizedTextFor(key: GeneralText.bhd.rawValue)
                        selectedServiceArray[index].payabaleAmount = formatNumber(payabaleAmount) + " " + localizedTextFor(key: GeneralText.bhd.rawValue)
                    } else {
                        let payabaleAmount = service["payableAmount"] as? NSNumber ?? 0
                        
                        selectedServiceArray[index].discountAmount = service["discountAvailed"] as? String ?? ""
                        selectedServiceArray[index].payabaleAmount = formatNumber(payabaleAmount) + " " + localizedTextFor(key: GeneralText.bhd.rawValue)
                    }
                    break
                }
            }
        }
    }
    
    func clearPromoCodeInfo() {
        interactor?.deletePromoCode()
        labelPromoApply.text = ""
        textFieldCode.text = ""
        totalSalonPrice.isHidden = true
        promoViewHeightConstraint.constant = 40
        let prefix = NSAttributedString(string: localizedTextFor(key: BookingSummarySceneText.bookingSummarySceneTotalPriceText.rawValue) + " - ")
        let strikeText = NSMutableAttributedString(string: totalServicesPrice.description + " " + localizedTextFor(key: GeneralText.bhd.rawValue))
        strikeText.insert(prefix, at: 0)
        totalPriceLabel.attributedText = strikeText
    }
}

// MARK: UITableViewDelegate
extension BookingSummaryViewController : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == selectedServiceTableView {
            return selectedServiceArray.count
        }
        else {
            return paymentArray.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == selectedServiceTableView {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: cellReUseIdentifier, for: indexPath) as! BookingSummaryServicesTableViewCell
            
            let rowsObject = selectedServiceArray[indexPath.row]
            cell.serviceNameLabel.text = rowsObject.serviceName
            cell.bookingdateInfoLabel.text = rowsObject.bookingDate
            cell.therapistInfoLabel.text = rowsObject.therapistName
            cell.salonInfoLabel.text = rowsObject.salonName
            cell.noteLabel.text = localizedTextFor(key: BookingSummarySceneText.note.rawValue) + " \(rowsObject.description)"
            
            if let languageIdentifier = UserDefaults.standard.value(forKey: userDefualtKeys.currentLanguage.rawValue) as? String {
                if languageIdentifier == Languages.Arabic {
                    cell.noteLabel.textAlignment = .right
                }else {
                    cell.noteLabel.textAlignment = .left
                }
            }
            
            if rowsObject.description != "" {
                cell.noteLabel.isHidden = false
            } else {
                cell.noteLabel.isHidden = true
            }
            let text = String(format: "%.3f", rowsObject.price.floatValue()) + " " + localizedTextFor(key: GeneralText.bhd.rawValue)
            
            if rowsObject.offerPrice != "" {
                cell.offerPriceInfoLabel.isHidden = false
                cell.priceInfoLabel.attributedText = NSAttributedString(string: text, attributes: [NSAttributedStringKey.strikethroughStyle: 1, NSAttributedStringKey.strikethroughColor: appBarThemeColor])
                cell.offerPriceInfoLabel.text = String(format: "%.3f", rowsObject.offerPrice.floatValue()) + " " + localizedTextFor(key: GeneralText.bhd.rawValue)
            } else {
                cell.offerPriceInfoLabel.isHidden = true
                cell.priceInfoLabel.text = text
            }
            
            cell.discountAmountLabel.text = rowsObject.discountAmount
            cell.payabaleAmountLabel.text = rowsObject.payabaleAmount
            
            
            if isPromoApplied {
                cell.promoLabelViewHeightConstraint.constant = 54
            } else {
                cell.promoLabelViewHeightConstraint.constant = 0
            }
            
            return cell
        }
        else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: cellReUseIdentifier, for: indexPath) as! FilterTableViewCell
            
            let rowsObject = paymentArray[indexPath.row]
            cell.nameLabel.text = rowsObject.name
            cell.checkBoxButton.isSelected = rowsObject.isSelected
            return cell
        }
        
    }
}

extension BookingSummaryViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        isPromoApplied = false
        selectedServiceTableView.reloadData()
        clearPromoCodeInfo()
        return true
    }
    
}


extension UITextField {
    func addRightImageViewInTextField() {
        let imageVw = UIImageView()
        imageVw.frame = CGRect(x: CGFloat(self.frame.size.width), y: CGFloat(5), width: CGFloat(50), height: CGFloat(40))
        imageVw.contentMode = UIViewContentMode.center
        
        
        let languageIdentifier = UserDefaults.standard.value(forKey: userDefualtKeys.currentLanguage.rawValue) as! String
        if languageIdentifier == Languages.Arabic {
            imageVw.image = UIImage(named: "leftArrow")
            self.leftView = imageVw
            self.leftViewMode = .always
        }
        else {
            imageVw.image = UIImage(named: "rightArrow")
            self.rightView = imageVw
            self.rightViewMode = .always
        }
    }
}
