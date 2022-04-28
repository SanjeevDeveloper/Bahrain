

import UIKit

protocol BusinessAppointmentDetailDisplayLogic: class
{
    func displayOrderData(viewModel: OrderDetail.ViewModel, viewModelTable: OrderDetail.ViewModel.tableCellData)
}

class BusinessAppointmentDetailViewController: UIViewController, BusinessAppointmentDetailDisplayLogic
{
    
    
    var interactor: BusinessAppointmentDetailBusinessLogic?
    var router: (NSObjectProtocol & BusinessAppointmentDetailRoutingLogic & BusinessAppointmentDetailDataPassing)?
    
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
        let interactor = BusinessAppointmentDetailInteractor()
        let presenter = BusinessAppointmentDetailPresenter()
        let router = BusinessAppointmentDetailRouter()
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
    
    //////////////////////////////////////////////////////////////////////////
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabelFontSize!
    @IBOutlet weak var totalPriceLabel: UILabelFontSize!
    @IBOutlet weak var oderDetailTableView: UITableView!
    @IBOutlet weak var orderDetailTableHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var paymentHeaderTitleLabel: UILabelFontSize!
    @IBOutlet weak var priceLabel: UILabelFontSize!
    @IBOutlet weak var paymentTypeLabel: UILabelFontSize!
    @IBOutlet weak var paymentStatusLabel: UILabelFontSize!
    @IBOutlet weak var paymentModeLabel: UILabelFontSize!
    @IBOutlet weak var pricePaidLabel: UILabelFontSize!
    @IBOutlet weak var specialTypeLable: UILabelFontSize!
    @IBOutlet weak var specialTypeDetailsLabel: UILabelFontSize!
    var orderDetailArray = [OrderDetail.ViewModel.tableCellData]()
    var appointmentId = ""
    var ClientId = ""
    
    // MARK: View lifecycle
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        initialFunction()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        CommonFunctions.sharedInstance.setNavigationTitleView(titleStr:   localizedTextFor(key: BusinessAppointmentDetailSceneText.BusinessAppointmentDetailSceneTitle.rawValue), onVC: self)
        paymentHeaderTitleLabel.text = localizedTextFor(key: OrderDetailSceneText.OrderDetailScenePaymentHeaderLabel.rawValue)
        paymentTypeLabel.text = localizedTextFor(key: OrderDetailSceneText.OrderDetailScenePaymentTypeLabel.rawValue)
        paymentStatusLabel.text = localizedTextFor(key: OrderDetailSceneText.OrderDetailScenePaymentStatusLabel.rawValue)
        specialTypeLable.text = localizedTextFor(key: OrderDetailSceneText.OrderDetailSpecialTypeScene.rawValue)
    }
    
    // MARK: InitialFunction
    func initialFunction() {
        addObserverOnTableViewReload()
        interactor?.showData()
    }
    
    
    func addObserverOnTableViewReload() {
        oderDetailTableView.addObserver(self, forKeyPath: tableContentSize, options: .new, context: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let obj = object as? UITableView {
            if obj == oderDetailTableView && keyPath == tableContentSize {
                if (change?[NSKeyValueChangeKey.newKey] as? CGSize) != nil {
                    orderDetailTableHeightConstraint.constant = oderDetailTableView.contentSize.height
                }
            }
        }
    }
    
    deinit {
        oderDetailTableView.removeObserver(self, forKeyPath: tableContentSize)
        
    }
    
    // MARK: Button Action
    
    func addCustomRightBarButton() {
        let btnReport = UIButton(type: UIButtonType.system)
        btnReport.frame = CGRect(x: 0, y: 0, width: 80, height: 16)
        btnReport.layer.cornerRadius = 5
        btnReport.backgroundColor = appBarThemeColor
        btnReport.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        let title = " " + localizedTextFor(key: BusinessAppointmentDetailSceneText.BusinessAppointmentDetailSceneReportButtonTitle.rawValue) + " "
        btnReport.setTitle(title, for: .normal)
        btnReport.tintColor = UIColor.white
        btnReport.addTarget(self, action: #selector(self.reportButtonAction), for: .touchUpInside)
        let customBarItem = UIBarButtonItem(customView: btnReport)
        self.navigationItem.rightBarButtonItem = customBarItem;
    }
    
    @objc func reportButtonAction() {
        wantToReportshowAlert()
    }
    
    // MARK: WantToReportshowAlert
    func wantToReportshowAlert() {
        let alertController = PMAlertController(textForegroundColor:UIColor.darkGray, viewBackgroundColor: UIColor.white, title: "" , description:localizedTextFor(key: BusinessAppointmentDetailSceneText.BusinessAppointmentDetailSceneReportAlertText.rawValue), image: nil , style: .alert)
        
        let yesButton = PMAlertAction(title: localizedTextFor(key: GeneralText.yes.rawValue), style: .default, action: {
            
            self.interactor?.hitAddToSpamApi(ClientId: self.ClientId)
            
        })
        
        let noButton = PMAlertAction(title: localizedTextFor(key: GeneralText.no.rawValue), style: .default, action: {
            alertController.dismiss(animated: true, completion: nil)
        })
        
        alertController.addAction(noButton)
        alertController.addAction(yesButton)
        present(alertController, animated: true, completion: nil)
    }
    
    // MARK: Display Response
    func displayOrderData(viewModel: OrderDetail.ViewModel, viewModelTable: OrderDetail.ViewModel.tableCellData) {
        ClientId = viewModel.ClientId
        appointmentId = viewModel.appointmentId
        orderDetailArray = [viewModelTable]
        userNameLabel.text = viewModel.salonName.uppercased()
        totalPriceLabel.text = localizedTextFor(key: BusinessAppointmentDetailSceneText.BusinessAppointmentPriceLabelText.rawValue) + "- " + viewModel.totalAmount.floatValue.description + " " + localizedTextFor(key: GeneralText.bhd.rawValue)
        priceLabel.text = viewModel.totalAmount.floatValue.description + " " + localizedTextFor(key: GeneralText.bhd.rawValue)
        pricePaidLabel.text = " " + viewModel.paymentStatus + " "
        paymentModeLabel.text = viewModel.paymentType
        
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
    }
}


// MARK: UITableViewDataSource
extension BusinessAppointmentDetailViewController : UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return orderDetailArray.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerCell = tableView.dequeueReusableCell(withIdentifier: "HeaderCell") as! AppointmentHeaderTableViewCell
        let sectionObject = orderDetailArray[section]
        
        headerCell.headerTitleLabel.text = sectionObject.header.headerTitle
        headerCell.timeLabel.text = sectionObject.header.time
        
        return headerCell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 30
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let sectionObject = orderDetailArray[section]
        let rowsObject = sectionObject.row
        return rowsObject.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReUseIdentifier, for: indexPath) as! AppointmentRowTableViewCell
        let sectionObject = orderDetailArray[indexPath.section]
        let rowsObject = sectionObject.row
        
        cell.bookingLabel.text = localizedTextFor(key: OrderDetailSceneText.OrderDetailBookingTableCell.rawValue)
        cell.bookingDateLabel.text = rowsObject[indexPath.row].bookingDate
        cell.nameLabel.text = rowsObject[indexPath.row].name
        
        let timeText = localizedTextFor(key: OrderDetailSceneText.OrderDetailSceneTimeLabel.rawValue)
        
        cell.timeLabel.text = timeText + "- " + rowsObject[indexPath.row].time + " " + localizedTextFor(key: BusinessCalenderSceneText.BusinessCalenderSceneServiceDurationMinuteText.rawValue)
        
        let therapistText = localizedTextFor(key: OrderDetailSceneText.OrderDetailSceneTherapistLabel.rawValue)
        cell.therapistNameLabel.text = therapistText + "- " + rowsObject[indexPath.row].therapistName
        
        let priceText = localizedTextFor(key: GeneralText.bhd.rawValue)
        cell.priceLabel.text = rowsObject[indexPath.row].price.floatValue.description + " " + priceText
        return cell
    }
}
