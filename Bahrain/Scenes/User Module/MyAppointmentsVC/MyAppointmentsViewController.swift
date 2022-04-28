
import UIKit

protocol MyAppointmentsDisplayLogic: class
{
    func displayResponse(viewModel: MyAppointments.ViewModel, isPast: Bool)
    func displayCancelAppointmentResponse(msg: String, index:Int)
}

class MyAppointmentsViewController: BaseViewControllerUser, MyAppointmentsDisplayLogic
{
    
    var interactor: MyAppointmentsBusinessLogic?
    var router: (NSObjectProtocol & MyAppointmentsRoutingLogic & MyAppointmentsDataPassing)?
    
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
        let interactor = MyAppointmentsInteractor()
        let presenter = MyAppointmentsPresenter()
        let router = MyAppointmentsRouter()
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
    
    //////////////////////////////////////////////////////////////////
    
    @IBOutlet weak var upcomingTableView: UITableView!
    @IBOutlet weak var pastAppointmentTableView: UITableView!
    @IBOutlet weak var upcomingButton: UIButtonCustomClass!
    @IBOutlet weak var pastAppointmentButton: UIButtonCustomClass!
    @IBOutlet weak var upcomingNoAppoinmentLabel: UILabelFontSize!
    @IBOutlet weak var pastNoAppointmentLabel: UILabelFontSize!
    @IBOutlet weak var topView: UIView!
    
    var upcomingAppointentsListArray = [MyAppointments.ViewModel.tableCellData]()
    var pastAppointentsListArray = [MyAppointments.ViewModel.tableCellData]()
    var upComingOffset = 0
    var pastOffset = 0
    var isPastSelected = false
    
    
    // MARK: View lifecycle
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        hideBackButtonTitle()
        applyLocalizedText()
        applyFontAndColor()
        upcomingTableView.tableFooterView = UIView()
        pastAppointmentTableView.tableFooterView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        
        if isPastSelected{
            upcomingButton.isSelected = false
            pastAppointmentButton.isSelected = true
            upcomingTableView.isHidden = true
            pastAppointmentTableView.isHidden = false
          
        }else {
            upcomingButton.isSelected = true
            pastAppointmentButton.isSelected = false
            upcomingTableView.isHidden = false
            pastAppointmentTableView.isHidden = true
            
        }
        upcomingButton.isUserInteractionEnabled = true
        pastAppointmentButton.isUserInteractionEnabled = true
        
        
        initialFunction()
        
        if self.pastAppointentsListArray.count == 0 {
            if pastAppointmentTableView.isHidden == false{
                pastNoAppointmentLabel.isHidden = false
            }
        }
        else {
            if pastAppointmentTableView.isHidden == false{
                pastNoAppointmentLabel.isHidden = true
            }
            
        }
        if self.upcomingAppointentsListArray.count == 0 {
            if upcomingTableView.isHidden == false {
                upcomingNoAppoinmentLabel.isHidden = false
            }
        }
        else {
            if upcomingTableView.isHidden == false {
                upcomingNoAppoinmentLabel.isHidden = true
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        upComingOffset = 0
        pastOffset = 0
        upcomingAppointentsListArray.removeAll()
        pastAppointentsListArray.removeAll()
        
    }
    
    // MARK: Apply Font And Color
    func applyFontAndColor() {
        upcomingButton.setBackgroundColor(color: appMyAppointmentsBtnColor, forState: .selected)
        pastAppointmentButton.setBackgroundColor(color: appMyAppointmentsBtnColor, forState: .selected)
        pastNoAppointmentLabel.textColor = appBarThemeColor
        upcomingNoAppoinmentLabel.textColor = appBarThemeColor
        topView.backgroundColor = appBarThemeColor
    }
    
    // MARK: Apply LocalizedText
    func applyLocalizedText() {
        CommonFunctions.sharedInstance.setNavigationTitleView(titleStr:  localizedTextFor(key: MyAppointmentSceneText.MyAppointmentSceneTitle.rawValue), onVC: self)
        upcomingButton.setTitle(localizedTextFor(key: MyAppointmentSceneText.MyAppointmentSceneUpcomingButtonTitle.rawValue), for: .normal)
        pastAppointmentButton.setTitle(localizedTextFor(key: MyAppointmentSceneText.MyAppointmentScenePastAppointmentButtonTitle.rawValue), for: .normal)
        pastNoAppointmentLabel.text = localizedTextFor(key: GeneralText.noAppointmentsAvailableMessage.rawValue)
        upcomingNoAppoinmentLabel.text = localizedTextFor(key: GeneralText.noAppointmentsAvailableMessage.rawValue)
    }
    
    
    // MARK: Button Actions
   
    
    @IBAction func upcominButtonAction(_ sender: Any) {
        
        upComingOffset = 0
        upcomingAppointentsListArray.removeAll()
        interactor?.hitGetListUserUpcomingAppointmentsApi(offset: upComingOffset)
        upcomingTableView.isHidden = false
        pastAppointmentTableView.isHidden = true
        upcomingButton.isUserInteractionEnabled = false
        pastAppointmentButton.isUserInteractionEnabled = true
        upcomingButton.isSelected = true
        pastAppointmentButton.isSelected = false
        isPastSelected = false
    }
    
    @IBAction func pastAppointmentButtonAction(_ sender: Any) {
        pastOffset = 0
        pastAppointentsListArray.removeAll()
        interactor?.hitGetListUserPastAppointmentsApi(offset: pastOffset)
        upcomingTableView.isHidden = true
        pastAppointmentTableView.isHidden = false
        upcomingButton.isUserInteractionEnabled = true
        pastAppointmentButton.isUserInteractionEnabled = false
        pastAppointmentButton.isSelected = true
        upcomingButton.isSelected = false
        isPastSelected = true
    }
    
    @objc func cancelButtonAction(sender:UIButton) {
        
        var v:UIView = sender
        repeat { v = v.superview! } while !(v is UITableViewCell)
        let cell = v as! UpcomingAppointmentTableViewCell
        let indexPath = upcomingTableView.indexPath(for:cell)!
        
        let obj = upcomingAppointentsListArray[indexPath.section]
        
        router?.routeToCancelAppointment(appoinmentId: obj.appointmentId)
        
        //        let req = MyAppointments.Request(appointmentId: obj.appointmentId, indexPath: indexPath.section)
        //        showAlert(request: req)
        
    }
    
    
    // MARK: Other Functions
    
    func initialFunction() {
        if isPastSelected{
          interactor?.hitGetListUserPastAppointmentsApi(offset: pastOffset)
        }else {
          interactor?.hitGetListUserUpcomingAppointmentsApi(offset: upComingOffset)
        }
        
    }
    
    func displayResponse(viewModel: MyAppointments.ViewModel, isPast: Bool)
    {
        
        if let errorString = viewModel.errorString {
            CustomAlertController.sharedInstance.showErrorAlert(error: errorString)
        }
        else {
            
            if isPast {
                pastAppointentsListArray.append(contentsOf: viewModel.tableArray)
                pastAppointmentTableView.reloadData()
                upcomingNoAppoinmentLabel.isHidden = true
                if self.pastAppointentsListArray.count == 0 {
                    pastNoAppointmentLabel.isHidden = false
                }
                else {
                    pastNoAppointmentLabel.isHidden = true
                }
            }
            else {
                upcomingAppointentsListArray.append(contentsOf: viewModel.tableArray)
                upcomingTableView.reloadData()
                pastNoAppointmentLabel.isHidden = true
                if self.upcomingAppointentsListArray.count == 0 {
                    upcomingNoAppoinmentLabel.isHidden = false
                }
                else {
                    upcomingNoAppoinmentLabel.isHidden = true
                }
            }
        }
    }
    
    // MARK: Display Cancel Appointment
    func displayCancelAppointmentResponse(msg: String, index:Int) {
        
        //        upcomingAppointentsListArray.remove(at: index)
        //        let indexPath = IndexPath(row: 0, section: index)
        //        let indexSet = IndexSet(indexPath)
        //        upcomingTableView.deleteSections(indexSet, with: .fade)
        
        CustomAlertController.sharedInstance.showAlert(subTitle: msg, type: .success)
    }
    
    // MARK: ShowAlert
    func showAlert(request: MyAppointments.Request) {
        let alertController = PMAlertController(textForegroundColor:UIColor.darkGray, viewBackgroundColor: UIColor.white, title: "", description: localizedTextFor(key: MyAppointmentSceneText.MyAppointmentSceneCancelAlertTitle.rawValue), image: nil, style: .alert)
        alertController.addAction(PMAlertAction(title: localizedTextFor(key: GeneralText.no.rawValue), style: .default, action: {
            alertController.dismiss(animated: true, completion: nil)
            
        }))
        
        alertController.addAction(PMAlertAction(title: localizedTextFor(key: GeneralText.yes.rawValue), style: .default, action: {
            let request = MyAppointments.Request(appointmentId: request.appointmentId, indexPath: request.indexPath)
            self.interactor?.hitCancelAppoinmentApi(request: request)
        }))
        
        present(alertController, animated: true, completion: nil)
    }
    
}

// MARK: UITableViewDelegate
extension MyAppointmentsViewController : UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == upcomingTableView {
            return upcomingAppointentsListArray.count
        }
        else {
            return pastAppointentsListArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        let footerView = view as! UITableViewHeaderFooterView
        footerView.tintColor = UIColor.clear
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let amountText = localizedTextFor(key: MyAppointmentSceneText.MyAppointmentSceneTotalAmountLabelTitle.rawValue)
        if tableView == upcomingTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellReUseIdentifier, for: indexPath) as! UpcomingAppointmentTableViewCell
            
            let currentObj = upcomingAppointentsListArray[indexPath.section]
            cell.dateLabel.text = currentObj.date
            cell.timeLabel.text = currentObj.time
            cell.nameLabel.text = currentObj.name
            cell.categoriesLabel.text = localizedTextFor(key: GeneralText.bookingId.rawValue) + " - " + currentObj.categories
            
            let priceText = ltrMark + String(format: "%.3f", currentObj.totalAmount.floatValue) + " " + localizedTextFor(key: GeneralText.bhd.rawValue)
            cell.totalAmountLabel.text = amountText + "- " + priceText
            
            
           // let stringText = currentObj.paymentMode
            
            if currentObj.isCancelled == false {
              
              let serviceStatus = currentObj.serviceStatus
              if serviceStatus == "completed" {
                cell.cancelButton.isHidden = true
                cell.cashImage.isHidden = true
                cell.paymentModeLabel.text = "  " + "Completed" + "    "
                cell.paymentModeLabel.backgroundColor = UIColor(red: 53.0/256, green: 181.0/256, blue: 74.0/256, alpha: 1.0)
                cell.paymentModeLabel.textColor = UIColor.white
                
              } else {
                cell.cancelButton.isHidden = false
//
//                if stringText == "Full Paid"  {
//                  cell.paymentModeLabel.text = "" + currentObj.paymentMode.capitalized + ""
//                  cell.paymentModeLabel.backgroundColor = UIColor(red: 76.0/256, green: 183.0/256, blue: 72.0/256, alpha: 1.0)
//                  cell.paymentModeLabel.textColor = UIColor.white
//                  cell.cashImage.isHidden = true
//
//
//                }else if stringText == "CASH"{
//                  cell.paymentModeLabel.text = currentObj.paymentMode.capitalized
//                  cell.paymentModeLabel.backgroundColor = UIColor.white
//                  cell.paymentModeLabel.textColor = appBarThemeColor
//                  cell.cashImage.isHidden = false
//
//                }
                //else{
                  cell.paymentModeLabel.text = "  " + serviceStatus.capitalized + "  "
                  cell.paymentModeLabel.backgroundColor = #colorLiteral(red: 0.9529411765, green: 0.6784313725, blue: 0.1333333333, alpha: 1)
                  cell.paymentModeLabel.textColor = UIColor.white
                  cell.cashImage.isHidden = true
                //}
              }
            }
            else {
                
                let cancelText = localizedTextFor(key: MyAppointmentSceneText.MyAppointmentSceneCancelledTitle.rawValue)
                cell.cancelButton.isHidden = true
                cell.cashImage.isHidden = true
                cell.paymentModeLabel.text = "  " + cancelText + "  "
                //                cell.paymentModeLabel.backgroundColor = UIColor(red: 76.0/256, green: 183.0/256, blue: 72.0/256, alpha: 1.0)
                cell.paymentModeLabel.backgroundColor = UIColor.red
                cell.paymentModeLabel.textColor = UIColor.white
            }
            
            cell.cancelButton.addTarget(self, action: #selector(self.cancelButtonAction(sender:)), for: .touchUpInside)
            
            return cell
            
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: cellReUseIdentifier, for: indexPath) as! PastAppointmentsTableViewCell
            
            let currentObj = pastAppointentsListArray[indexPath.section]
            
            cell.dateLabel.text = currentObj.date
            cell.timeLabel.text = currentObj.time
            cell.nameLabel.text = currentObj.name
            cell.categoriesLabel.text = "Booking Id - " + currentObj.categories
            
            let priceText = ltrMark + String(format: "%.3f", currentObj.totalAmount.floatValue) + " " + localizedTextFor(key: GeneralText.bhd.rawValue)
            cell.totalAmountLabel.text = amountText + "- " + priceText
           // cell.successMsgLabel.text = currentObj.paymentMode.capitalized
            
            
            ////////////////
            
            let serviceStatus = currentObj.serviceStatus
            if currentObj.isCancelled == false {
                
                if serviceStatus == "completed" {
                    cell.successMsgLabel.text = "  " + serviceStatus.capitalized + "  "
                    cell.successMsgLabel.textColor = UIColor(red: 53.0/256, green: 181.0/256, blue: 74.0/256, alpha: 1.0)
                } else {
                    cell.successMsgLabel.text = "  " + serviceStatus.capitalized + "  "
                    cell.successMsgLabel.textColor = UIColor.gray
                }
            }
            else {
                cell.successMsgLabel.text = "  " + serviceStatus.capitalized + "  "
                cell.successMsgLabel.textColor = UIColor.red
            }
            
            
            ///////////////
            
            
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if tableView == upcomingTableView {
            if indexPath.section == (((self.upComingOffset + 1)*10) - 1) {
                self.upComingOffset += 1
                interactor?.hitGetListUserUpcomingAppointmentsApi(offset: upComingOffset)
            }
            
        }
        else {
            if indexPath.section == (((self.pastOffset + 1)*10) - 1) {
                self.pastOffset += 1
                interactor?.hitGetListUserPastAppointmentsApi(offset: pastOffset)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView == upcomingTableView {
            isPastSelected = false
            let currentObj = upcomingAppointentsListArray[indexPath.section]
            self.router?.routeToOrderDetail(segue: nil, orderDetailArray: currentObj, tableViewName: true, appoinmentId: currentObj.appointmentId)
        }
        else {
            isPastSelected = true
            let currentObj = pastAppointentsListArray[indexPath.section]
            self.router?.routeToOrderDetail(segue: nil, orderDetailArray: currentObj, tableViewName: false, appoinmentId: currentObj.appointmentId)
        }
    }
}
