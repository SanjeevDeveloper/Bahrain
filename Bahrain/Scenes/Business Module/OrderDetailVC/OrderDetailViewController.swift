
import UIKit

protocol OrderDetailDisplayLogic: class
{
    func displayOrderData(viewModel: OrderDetail.ViewModel, viewModelTable: OrderDetail.ViewModel.tableCellData, tableView: Bool)
    
    func displayOrderData(viewModel: OrderDetail.ViewModel, viewModelTable: OrderDetail.ViewModel.tableCellData, isCompleted: Bool, ispending:Bool, serviceStatus: String, txnList: [TransactionList], promoCode: String, discountAvail: String, address: AddressList.ViewModel?, totalAfterDiscountValue: NSNumber, isMaxDiscountLimitExceed: Bool, offerId: String)
    
    func displayCancelAppointmentResponse(msg: String)
    func displayBookingData(bookingArray: [SalonDetail.ViewModel.service], salonName: String, businessID: String)
}

class OrderDetailViewController: UIViewController, OrderDetailDisplayLogic
{
    
    
    var interactor: OrderDetailBusinessLogic?
    var router: (NSObjectProtocol & OrderDetailRoutingLogic & OrderDetailDataPassing)?
    
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
        let interactor = OrderDetailInteractor()
        let presenter = OrderDetailPresenter()
        let router = OrderDetailRouter()
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
    
    ////////////////////////////////////////////////////////////////////
    
    
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabelFontSize!
    @IBOutlet weak var totalPriceLabel: UILabelFontSize! // BookingStatus
    @IBOutlet weak var oderDetailTableView: UITableView!
    @IBOutlet weak var orderDetailTableHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var paymentHeaderTitleLabel: UILabelFontSize!
    @IBOutlet weak var priceLabel: UILabelFontSize!
    @IBOutlet weak var paymentTypeLabel: UILabelFontSize!
    @IBOutlet weak var paymentStatusLabel: UILabelFontSize!
    @IBOutlet weak var bookingStatusTitleLabel: UILabelFontSize!
    @IBOutlet weak var bookingStatusLabel: UILabelFontSize!
    @IBOutlet weak var arrivalStatusTitleLabel: UILabelFontSize!
    @IBOutlet weak var arrivalStatusLabel: UILabelFontSize!
    @IBOutlet weak var specialInstructionTitleLabel: UILabelFontSize!
    @IBOutlet weak var instructionsLabel: UILabelFontSize!
    @IBOutlet weak var paymentModeLabel: UILabelFontSize!
    @IBOutlet weak var callButton: UIButton!
    @IBOutlet weak var pricePaidLabel: UILabelFontSize!
    @IBOutlet weak var paidAmountLbl: UILabelFontSize!
    @IBOutlet weak var cashPaidLabel: UILabelFontSize!
    @IBOutlet weak var remainingAmountLabel: UILabelFontSize!
    @IBOutlet weak var cashRemainingLabel: UILabelFontSize!
    @IBOutlet weak var bottomButton: UIButtonFontSize!
    @IBOutlet weak var homeButton: UIButtonFontSize!
    
    @IBOutlet weak var paymentDetailPopup: UIView!
    @IBOutlet weak var paymentDetailTitleLbl: UILabelFontSize!
    @IBOutlet weak var closeButton: UIButtonFontSize!
    
    @IBOutlet weak var typeTitleLabel: UILabel!
    @IBOutlet weak var amountTitleLabel: UILabel!
    @IBOutlet weak var transactionTitleLabel: UILabel!
    
    @IBOutlet weak var totalAmountTitleLabel: UILabel!
    @IBOutlet weak var totalAmountLabel: UILabel!
    @IBOutlet weak var transactionsTableView: UITableView!
    @IBOutlet weak var trnxTableHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var arrowImageView: UIImageView!
    @IBOutlet weak var paymentDetailView: UIView!
    
    
    @IBOutlet weak var promoCodeTitleLabel: UILabelFontSize!
    @IBOutlet weak var promoCodeLabel: UILabelFontSize!
    
    @IBOutlet weak var discountAvailTitleLabel: UILabelFontSize!
    @IBOutlet weak var discountAvailLabel: UILabelFontSize!
    
    @IBOutlet weak var addressLabel: UILabelFontSize!
    @IBOutlet weak var addressButton: UIButton!
    
    var transactionsList = [TransactionList]()
    
    @IBOutlet weak var totalAfterDiscountTitle: UILabelFontSize!
    @IBOutlet weak var totalAfterDiscountValue: UILabelFontSize!
    @IBOutlet weak var totalAfterDiscountView: UIView!
    @IBOutlet weak var promoView: UIView!
    @IBOutlet weak var discountView: UIView!
    
    @IBOutlet weak var promoAmountExceedView: UIView!
    @IBOutlet weak var promoAmountExceedTitle: UILabelFontSize!
    @IBOutlet weak var promoAmountExceedValue: UILabelFontSize!
    
    
    @IBOutlet weak var isSpecialOfferView: UIView!
    @IBOutlet weak var isSpecialOfferTitle: UILabelFontSize!
    @IBOutlet weak var isSpecialOfferValue: UILabelFontSize!
    
    var businessId = ""
    
    
    var orderDetailArray = [OrderDetail.ViewModel.tableCellData]()
    var appointmentId = ""
    var isNavigationHidden = false
    var couponCode = ""
    var salonNumber = ""
    
    var addresObj:AddressList.ViewModel?
    
    // MARK: View lifecycle
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        addObserverOnTableViewReload()
        transactionsTableView.tableFooterView = UIView()
        hideBackButtonTitle()
        if isCurrentLanguageArabic() {
            let flippedImage = UIImage(named: "rightArrow")?.imageFlippedForRightToLeftLayoutDirection()
            arrowImageView.image = flippedImage
        }
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "whiteBackIcon"), style: .done, target: self, action: #selector(self.backToInitial(sender:)))
        self.tabBarController?.tabBar.isHidden = true
        
        bottomButton.setTitle(localizedTextFor(key: OrderDetailSceneText.OrderDetailSceneBottomBookingButtonTitle.rawValue), for: .normal)
        homeButton.setTitle(localizedTextFor(key: HomeSceneText.homeSceneTitle.rawValue).capitalized, for: .normal)
        homeButton.backgroundColor = appBarThemeColor
        bottomButton.isHidden = true
        paymentDetailView.backgroundColor = appBarThemeColor
        closeButton.backgroundColor = appBarThemeColor
    }
    
    @objc func backToInitial(sender: AnyObject) {
        if isComingFromPayment() {
            routeToHomeVC()
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
    
    func isComingFromPayment() -> Bool {
        var isComing = false
        for viewcontroller in (navigationController?.viewControllers)! {
            if viewcontroller.isKind(of: PaymentMethodViewController.self) {
                isComing = true
            } else if viewcontroller.isKind(of: BookingSummaryViewController.self) {
                isComing = true
            }
        }
        return isComing
    }
    
    func routeToHomeVC() {
        for controller in navigationController!.viewControllers {
            if controller.isKind(of: HomeViewController.self) {
                navigationController?.popToViewController(controller, animated: true)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if  self.navigationController?.isNavigationBarHidden == true {
            self.navigationController?.isNavigationBarHidden = false
            isNavigationHidden = true
        }
        
        applyLocalizedText()
        applyFontAndColor()
        interactor?.showData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if  isNavigationHidden {
            self.navigationController?.isNavigationBarHidden = true
        }
    }
    
    // MARK: addObserverOnTableViewReload
    
    func addObserverOnTableViewReload() {
        oderDetailTableView.addObserver(self, forKeyPath: tableContentSize, options: .new, context: nil)
        transactionsTableView.addObserver(self, forKeyPath: tableContentSize, options: .new, context: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let obj = object as? UITableView {
            if obj == oderDetailTableView && keyPath == tableContentSize {
                if (change?[NSKeyValueChangeKey.newKey] as? CGSize) != nil {
                    orderDetailTableHeightConstraint.constant = oderDetailTableView.contentSize.height
                }
            } else if obj == transactionsTableView && keyPath == tableContentSize {
                if (change?[NSKeyValueChangeKey.newKey] as? CGSize) != nil {
                    let trnxCount = transactionsList.count
                    if trnxCount < 4 {
                        transactionsTableView.isScrollEnabled = false
                        trnxTableHeightConstraint.constant = transactionsTableView.contentSize.height
                    } else {
                        transactionsTableView.isScrollEnabled = true
                        trnxTableHeightConstraint.constant = 128
                    }
                }
            }
        }
    }
    
    deinit {
        //oderDetailTableView.removeObserver(self, forKeyPath: tableContentSize)
        
    }
    
    // MARK: Apply Font And Color
    func applyFontAndColor() {
        userNameLabel.textColor = appBarThemeColor
        paymentHeaderTitleLabel.textColor = UIColor.white
        paymentTypeLabel.textColor = appTxtfDarkColor
        paymentModeLabel.textColor = appTxtfDarkColor
        bottomButton.backgroundColor = UIColor.lightGray
    }
    
    // MARK: Apply LocalizedText
    func applyLocalizedText() {
        specialInstructionTitleLabel.text = localizedTextFor(key: SpecialOffersText.specialInstructions.rawValue)
        isSpecialOfferTitle.text = localizedTextFor(key: OrderDetailSceneText.isSpecialOfferTitle.rawValue)
        isSpecialOfferValue.text = localizedTextFor(key: OrderDetailSceneText.isSpecialOfferValue.rawValue)
        
        promoAmountExceedTitle.text = localizedTextFor(key: OrderDetailSceneText.maxDiscountLimitExceedTitle.rawValue)
        promoAmountExceedValue.text = localizedTextFor(key: OrderDetailSceneText.maxDiscountLimitExceedValue.rawValue)
        
        totalAfterDiscountTitle.text = localizedTextFor(key: OrderDetailSceneText.totalAfterDiscountTitle.rawValue)
        promoCodeTitleLabel.text = localizedTextFor(key: OrderDetailSceneText.OrderDetailPromoCodeText.rawValue)
        discountAvailTitleLabel.text = localizedTextFor(key: OrderDetailSceneText.OrderDetailDiscountAvailText.rawValue)
        
        totalAmountTitleLabel.text = localizedTextFor(key: OrderDetailSceneText.OrderDetailTotalAmountText.rawValue)
        CommonFunctions.sharedInstance.setNavigationTitleView(titleStr:   localizedTextFor(key: OrderDetailSceneText.OrderDetailSceneTitle.rawValue), onVC: self)
        paymentHeaderTitleLabel.text = localizedTextFor(key: OrderDetailSceneText.OrderDetailScenePaymentHeaderLabel.rawValue)
        paymentTypeLabel.text = localizedTextFor(key: OrderDetailSceneText.OrderDetailScenePaymentTypeLabel.rawValue)
        paymentStatusLabel.text = localizedTextFor(key: OrderDetailSceneText.OrderDetailScenePaymentStatusLabel.rawValue)
        paidAmountLbl.text = localizedTextFor(key: OrderDetailSceneText.OrderDetailPaidAmountLabelText.rawValue)
        remainingAmountLabel.text = localizedTextFor(key: OrderDetailSceneText.OrderDetailRemainingAmountLabelText.rawValue)
        bookingStatusTitleLabel.text = localizedTextFor(key: OrderDetailSceneText.OrderDetailBookingStatusTitleLabelText.rawValue)
        paymentDetailTitleLbl.text = localizedTextFor(key: OrderDetailSceneText.OrderDetailPaymentDetailtLabelText.rawValue)
        closeButton.setTitle(localizedTextFor(key: OrderDetailSceneText.OrderDetailCloseButtonTitle.rawValue), for: .normal)
        arrivalStatusTitleLabel.text = localizedTextFor(key: GeneralText.reminderHeader.rawValue)
        typeTitleLabel.text = localizedTextFor(key: OrderDetailSceneText.OrderDetailTypeTitleLabelText.rawValue)
        amountTitleLabel.text = localizedTextFor(key: OrderDetailSceneText.OrderDetailAmountTitleLabelText.rawValue)
        transactionTitleLabel.text = localizedTextFor(key: OrderDetailSceneText.OrderDetailTransactionTitleLabelText.rawValue)
    }
    
    // MARK: Button Action
    @IBAction func bottomButtonAction(_ sender: Any) {
        if bottomButton.isSelected {
            if bottomButton.titleLabel?.text == localizedTextFor(key: OrderDetailSceneText.OrderDetailSceneBottomCancelButtonTitle.rawValue)
            {
                // appointmentCancelshowAlert()
                router?.routeToCancelAppointment(appoinmentId: appointmentId)
            }
        }
        else {
            interactor?.getBookingData()
        }
    }
    
    @IBAction func homeButtonAction(sender: UIButton) {
        router?.routeToHome()
    }
    
    @IBAction func callButtonAction(sender: UIButton) {
        if let url = URL(string: "tel://\(salonNumber)") {
            UIApplication.shared.open(url)
        }
    }
    
    @IBAction func paymentPopupBtn(_ sender: Any) {
        paymentDetailPopup.isHidden = false
    }
    
    @IBAction func profileBtn(_ sender: Any) {
        router?.routeToSaloonDetail(businessId: businessId)
    }
    
    
    @IBAction func closeButton(_ sender: Any) {
        paymentDetailPopup.isHidden = true
    }
    
    // MARK: Display Response
    func displayBookingData(bookingArray: [SalonDetail.ViewModel.service], salonName: String, businessID: String) {
        
        router?.routeToBooking(bookingArray: bookingArray, salonName: salonName, businessID: businessID)
    }
    
    func displayCancelAppointmentResponse(msg: String) {
        CustomAlertController.sharedInstance.showAlert(subTitle: msg, type: .success)
        bottomButton.setTitle(localizedTextFor(key: OrderDetailSceneText.OrderDetailSceneBookingCancelledButtonTitle.rawValue), for: .selected)
        bottomButton.isSelected = true
        
    }
    
    func displayOrderData(viewModel: OrderDetail.ViewModel, viewModelTable: OrderDetail.ViewModel.tableCellData, tableView: Bool) {
        
        if viewModel.salonPhoneNumber != "" {
            self.salonNumber = viewModel.salonPhoneNumber
            callButton.isHidden = false
        } else {
            callButton.isHidden = true
        }
        
        printToConsole(item: viewModel)
        printToConsole(item: viewModelTable)
        appointmentId = viewModel.appointmentId
        orderDetailArray = [viewModelTable]
        userNameLabel.text = viewModel.salonName
        priceLabel.text = viewModel.totalAmount.floatValue.description + " " + localizedTextFor(key: GeneralText.bhd.rawValue)
        pricePaidLabel.text = " " + viewModel.paymentStatus + " "
        paymentModeLabel.text = viewModel.paymentType
        cashPaidLabel.text = viewModel.paidAmount + " " + localizedTextFor(key: GeneralText.bhd.rawValue)
        
        cashRemainingLabel.text = viewModel.remainingAmount + " " + localizedTextFor(key: GeneralText.bhd.rawValue)
        
        if viewModel.specialInstructions != "" {
            instructionsLabel.isHidden = false
            specialInstructionTitleLabel.superview?.isHidden = false
        } else {
            instructionsLabel.isHidden = true
            specialInstructionTitleLabel.superview?.isHidden = true
        }
        
        instructionsLabel.text = viewModel.specialInstructions
        
        if viewModel.profileImage != "" {
            let image = viewModel.profileImage
            let imageUrl = Configurator().imageBaseUrl +  image
            userImageView.sd_setImage(with: URL(string: imageUrl)) { (image, error, cacheType, url) in
                if error != nil {
                    self.userImageView.image = defaultSaloonImage
                }
            }
        }
        else {
            userImageView.image = defaultSaloonImage
        }
        
        
        if tableView == true {
            totalPriceLabel.text = ""
            if viewModel.isCancel{
                bottomButton.setTitle(localizedTextFor(key: OrderDetailSceneText.OrderDetailSceneBookingCancelledButtonTitle.rawValue), for: .selected)
                
                bottomButton.isSelected = true
                bottomButton.isHidden = false
            }
            else {
                bottomButton.setTitle(localizedTextFor(key: OrderDetailSceneText.OrderDetailSceneBottomCancelButtonTitle.rawValue), for: UIControlState.selected)
                
                bottomButton.isSelected = true
                bottomButton.backgroundColor = UIColor.lightGray
                bottomButton.isHidden = false
            }
        }
        else {
            //For rebooking not used now
            bottomButton.isHidden = true
            bottomButton.isSelected = false
            bottomButton.backgroundColor = UIColor(red: 101.0/256, green: 194.0/256, blue: 90.0/256, alpha: 1.0)
            totalPriceLabel.text = (localizedTextFor(key: OrderDetailSceneText.OrderDetailSpecialCancelScene.rawValue))
        }
    }
    
    @IBAction func addressButtonAction(sender: UIButton) {
        if let address = addresObj {
            router?.routeToAddressInfoVc(editObj: address)
        }
    }
    
    
    // Now this one is used
    func displayOrderData(viewModel: OrderDetail.ViewModel, viewModelTable: OrderDetail.ViewModel.tableCellData, isCompleted: Bool, ispending:Bool, serviceStatus: String, txnList: [TransactionList], promoCode: String, discountAvail: String, address: AddressList.ViewModel?, totalAfterDiscountValue: NSNumber, isMaxDiscountLimitExceed: Bool, offerId: String) {
        let priceText = localizedTextFor(key: GeneralText.bhd.rawValue)
        
        if offerId != "" {
            isSpecialOfferView.isHidden = false
            totalAfterDiscountView.isHidden = false
            discountView.isHidden = false
            discountAvailLabel.text = discountAvail
            self.totalAfterDiscountValue.text = String(format: "%.3f", totalAfterDiscountValue.floatValue) + " " + priceText
            let strikeAttribute = [NSAttributedStringKey.strikethroughStyle: NSNumber(value: NSUnderlineStyle.styleSingle.rawValue), NSAttributedStringKey.foregroundColor: UIColor.darkGray, NSAttributedStringKey.strikethroughColor: UIColor.darkGray]
            totalAmountLabel.attributedText = NSAttributedString(string: String(format: "%.3f", viewModel.totalAmount.floatValue) + " " + priceText, attributes: strikeAttribute)
        }
        
        
        if let addressObj = address {
            let attributedString = NSAttributedString(string:   localizedTextFor(key:OrderDetailSceneText.OrderDetailViewAdressText.rawValue), attributes:
                [.underlineStyle: NSUnderlineStyle.styleSingle.rawValue])
            addressLabel.attributedText = attributedString
            addressButton.isEnabled = true
            self.addresObj = addressObj
        }
        self.couponCode = viewModel.couponCode
        if promoCode != "" {
            promoCodeLabel.text = promoCode
            discountAvailLabel.text = discountAvail
            
            self.totalAfterDiscountValue.text = String(format: "%.3f", totalAfterDiscountValue.floatValue) + " " + priceText
            let strikeAttribute = [NSAttributedStringKey.strikethroughStyle: NSNumber(value: NSUnderlineStyle.styleSingle.rawValue), NSAttributedStringKey.foregroundColor: UIColor.darkGray, NSAttributedStringKey.strikethroughColor: UIColor.darkGray]
            totalAmountLabel.attributedText = NSAttributedString(string: String(format: "%.3f", viewModel.totalAmount.floatValue) + " " + priceText, attributes: strikeAttribute)
            
            totalAfterDiscountView.isHidden = false
            discountView.isHidden = false
            promoView.isHidden = false
            
            if isMaxDiscountLimitExceed {
                promoAmountExceedView.isHidden = false
            }
            
        } else {
            totalAmountLabel.text = String(format: "%.3f", viewModel.totalAmount.floatValue) + " " + priceText
        }
        
        transactionsList = txnList
        transactionsTableView.reloadData()
        
        
        
        businessId = viewModel.ClientId
        
        bookingStatusLabel.text = serviceStatus.capitalized
        if viewModel.isCancel {
            bookingStatusLabel.textColor = UIColor.red
        }
        
        appointmentId = viewModel.appointmentId
        orderDetailArray = [viewModelTable]
        if orderDetailArray.count == 1 {
            //oderDetailTableView.separatorStyle = .none
        }
        userNameLabel.text = viewModel.salonName.capitalized
        priceLabel.text = String(format: "%.3f", viewModel.totalAmount.floatValue) + " " + localizedTextFor(key: GeneralText.bhd.rawValue)
        printToConsole(item: viewModel.paymentStatus)
        //        if viewModel.paymentStatus == "fully paid" {
        pricePaidLabel.backgroundColor = #colorLiteral(red: 0.9529411765, green: 0.6784313725, blue: 0.1333333333, alpha: 1)
        pricePaidLabel.textColor = UIColor.white
        
        
        pricePaidLabel.text = " " + viewModel.paymentStatus.capitalized + " "
        paymentModeLabel.text = viewModel.paymentType.capitalized
        cashPaidLabel.text = String(format: "%.3f", viewModel.paidAmount.floatValue()) + " " + localizedTextFor(key: GeneralText.bhd.rawValue)
        arrivalStatusLabel.text = viewModel.arrivalStatus.capitalized
        
        cashRemainingLabel.text = String(format: "%.3f", viewModel.remainingAmount.floatValue()) + " " + localizedTextFor(key: GeneralText.bhd.rawValue)
        
        
        if viewModel.profileImage != "" {
            let image = viewModel.profileImage
            let imageUrl = Configurator().imageBaseUrl +  image
            userImageView.sd_setImage(with: URL(string: imageUrl)) { (image, error, cacheType, url) in
                if error != nil {
                    self.userImageView.image = defaultSaloonImage
                }
            }
        }
        else {
            userImageView.image = defaultSaloonImage
        }
        
        if !isCompleted {
            totalPriceLabel.text = ""
            if viewModel.isCancel{
                bottomButton.setTitle(localizedTextFor(key: OrderDetailSceneText.OrderDetailSceneBookingCancelledButtonTitle.rawValue), for: .selected)
                totalPriceLabel.text = localizedTextFor(key: OrderDetailSceneText.OrderDetailSceneBookingCancelledButtonTitle.rawValue).capitalized + " " + localizedTextFor(key: GeneralText.by.rawValue) + " " +  viewModel.cancelledBy + "\n" + viewModel.cancelledDate
                totalPriceLabel.textColor = UIColor(red: 255.0/256, green: 0.0/256, blue: 0.0/256, alpha: 1.0)
                bottomButton.isSelected = true
                bottomButton.isHidden = false
                bottomButton.isUserInteractionEnabled = false
                //bookingStatusLabel.text = "Cancelled"
            }
            else {
                bottomButton.setTitle(localizedTextFor(key: OrderDetailSceneText.OrderDetailSceneBottomCancelButtonTitle.rawValue), for: UIControlState.selected)
                totalPriceLabel.text = ""
                bottomButton.isSelected = true
                bottomButton.isHidden = false
                bottomButton.isUserInteractionEnabled = true
                if ispending{
                    //bookingStatusLabel.text = "Pending"
                }else {
                    //bookingStatusLabel.text = "Due"
                }
            }
        }
        else {
            //For rebooking not used now
            
            //bookingStatusLabel.text = "Completed"
            bottomButton.isUserInteractionEnabled = true
            bottomButton.isHidden = true
            bottomButton.isSelected = false
            totalPriceLabel.text = localizedTextFor(key: GeneralText.serviceCompleted.rawValue)
            totalPriceLabel.textColor = #colorLiteral(red: 0.3515368104, green: 0.7509177923, blue: 0, alpha: 1)
        }
        
        
        oderDetailTableView.reloadData()
    }
    
    // MARK: appointmentCancelshowAlert
    func appointmentCancelshowAlert() {
        
        let alertController = PMAlertController(textForegroundColor:UIColor.darkGray, viewBackgroundColor: UIColor.white, title: "" , description:localizedTextFor(key: MyAppointmentSceneText.MyAppointmentSceneCancelAlertTitle.rawValue), image: nil , style: .alert)
        
        let yesButton = PMAlertAction(title: localizedTextFor(key: GeneralText.yes.rawValue), style: .default, action: {
            
            self.interactor?.hitCancelAppoinmentApi(id: self.appointmentId)
            
        })
        
        let noButton = PMAlertAction(title: localizedTextFor(key: GeneralText.no.rawValue), style: .default, action: {
            alertController.dismiss(animated: true, completion: nil)
        })
        
        alertController.addAction(noButton)
        alertController.addAction(yesButton)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func convertUptoNDecimal(uptoDecimal: Int, amount: Double) -> String {
        let convertedString = String(format: "%.\(uptoDecimal)f", amount)
        return convertedString
    }
    
}

// MARK: UITableViewDelegate
extension OrderDetailViewController : UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == oderDetailTableView {
            return orderDetailArray.count
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if tableView == oderDetailTableView {
            let headerCell = tableView.dequeueReusableCell(withIdentifier: "HeaderCell") as! OrderDetailHeaderTableViewCell
            headerCell.contentView.backgroundColor = appBarThemeColor
            let sectionObject = orderDetailArray[section]
            headerCell.orderIdTitleLabel.text = localizedTextFor(key: GeneralText.bookingId.rawValue) + " : " + sectionObject.header.orderId
            headerCell.orderIdLabel.text = sectionObject.header.headerTitle  + " : " + sectionObject.header.time
            //headerCell.headerTitleLabel.text = ""
            //headerCell.timeLabel.text = ""
            
            return headerCell
        } else {
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if tableView == oderDetailTableView {
            return 50
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == oderDetailTableView {
            let sectionObject = orderDetailArray[section]
            let rowsObject = sectionObject.row
            return rowsObject.count
        } else {
            return transactionsList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == oderDetailTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellReUseIdentifier, for: indexPath) as! OrderDetailRowTableViewCell
            let sectionObject = orderDetailArray[indexPath.section]
            let rowsObject = sectionObject.row
            
            cell.bookingLabel.text = localizedTextFor(key: OrderDetailSceneText.OrderDetailBookingTableCell.rawValue)
            cell.bookingDateLabel.text = rowsObject[indexPath.row].bookingDate
            cell.nameLabel.text = rowsObject[indexPath.row].name
            
            
            let discountMain = NSMutableAttributedString()
            let payableMain = NSMutableAttributedString()
            
            
            
            let discountPrefix = NSAttributedString(string: localizedTextFor(key: OrderDetailSceneText.OrderDetailDiscountAmountText.rawValue) + ":", attributes: [NSAttributedString.Key.foregroundColor: appTxtfDarkColor])
            
            let payablePrefix = NSAttributedString(string: localizedTextFor(key: OrderDetailSceneText.OrderDetailPayableAmountText.rawValue) + ":", attributes: [NSAttributedString.Key.foregroundColor: appTxtfDarkColor])
            
            let bhd = localizedTextFor(key: GeneralText.bhd.rawValue)
            
            var discountStr = ""
            let da = self.convertUptoNDecimal(uptoDecimal: 3, amount: rowsObject[indexPath.row].discountAvailed.doubleValue)
            if rowsObject[indexPath.row].discountAvailed.doubleValue > 0.0 {
                discountStr = "\(da) \(bhd)"
            } else {
                discountStr = "N/A"
            }
            
            let ac = self.convertUptoNDecimal(uptoDecimal: 3, amount: rowsObject[indexPath.row].price.doubleValue)
            
            let pa = self.convertUptoNDecimal(uptoDecimal: 3, amount: rowsObject[indexPath.row].paidAmount.doubleValue)
            
            
            
            
            
            let discountSufix = NSAttributedString(string: discountStr, attributes: [NSAttributedString.Key.foregroundColor: appBarThemeColor])
            
            let payableSufix = NSAttributedString(string: "\(pa) \(bhd)", attributes: [NSAttributedString.Key.foregroundColor: appBarThemeColor])
            
            let common = NSAttributedString(string: " ")
            
            payableMain.append(payablePrefix)
            payableMain.append(common)
            payableMain.append(payableSufix)
            
            discountMain.append(discountPrefix)
            discountMain.append(common)
            discountMain.append(discountSufix)
            
            
            
            if self.couponCode != "" {
                cell.paybleLabel.attributedText = payableMain
                cell.discountLabel.attributedText = discountMain
                
                let actualMain = NSMutableAttributedString()
                let actualPrefix = NSAttributedString(string: localizedTextFor(key: OrderDetailSceneText.OrderDetailTotalAmmountText.rawValue) + ":", attributes: [NSAttributedString.Key.foregroundColor: appTxtfDarkColor])
                let actualSufix = NSAttributedString(string: "\(ac) \(bhd)" , attributes: [NSAttributedString.Key.foregroundColor: appBarThemeColor, NSAttributedStringKey.strikethroughStyle: NSNumber(value: NSUnderlineStyle.styleSingle.rawValue), NSAttributedStringKey.strikethroughColor: ac==pa ? UIColor.clear : appBarThemeColor])
                actualMain.append(actualPrefix)
                actualMain.append(common)
                actualMain.append(actualSufix)
                
                cell.priceLabel.attributedText = actualMain
                
            } else {
                cell.paybleLabel.text = ""
                cell.discountLabel.text = ""
                
                let actualMain = NSMutableAttributedString()
                let actualPrefix = NSAttributedString(string: localizedTextFor(key: OrderDetailSceneText.OrderDetailTotalAmmountText.rawValue) + ":", attributes: [NSAttributedString.Key.foregroundColor: appTxtfDarkColor])
                let actualSufix = NSAttributedString(string: "\(ac) \(bhd)" , attributes: [NSAttributedString.Key.foregroundColor: appBarThemeColor])
                actualMain.append(actualPrefix)
                actualMain.append(common)
                actualMain.append(actualSufix)
                
                cell.priceLabel.attributedText = actualMain
            }
            
            let timeText = localizedTextFor(key: OrderDetailSceneText.OrderDetailSceneTimeLabel.rawValue)
            let therapistText = localizedTextFor(key: OrderDetailSceneText.OrderDetailSceneTherapistLabel.rawValue)
            
            cell.therapistNameLabel.text = timeText + "- " + rowsObject[indexPath.row].time
            cell.timeLabel.text = therapistText + "-" + rowsObject[indexPath.row].therapistName
            
            return cell
        } else {
            let priceText = localizedTextFor(key: GeneralText.bhd.rawValue)
            let transaction = transactionsList[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: cellReUseIdentifier, for: indexPath) as! TransactionsTableViewCell
            cell.paymentMethodLabel.text = transaction.paymentMethod
            cell.paidAmountLabel.text = transaction.paidAmount + " " + priceText
            cell.transactionIdLabel.text = transaction.id
            return cell
        }
    }
}

