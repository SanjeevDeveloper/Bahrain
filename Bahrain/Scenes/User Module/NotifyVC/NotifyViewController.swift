
import UIKit

protocol NotifyDisplayLogic: class
{
    func displayResponse(viewModel: Notify.ViewModel)
    func displayClearAllResponse()
    func displayReadResponse()
}

class NotifyViewController: UIViewController, NotifyDisplayLogic
{
    
    var interactor: NotifyBusinessLogic?
    var router: (NSObjectProtocol & NotifyRoutingLogic & NotifyDataPassing)?
    
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
        let interactor = NotifyInteractor()
        let presenter = NotifyPresenter()
        let router = NotifyRouter()
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
    
    @IBOutlet weak var notificationTableView: UITableView!
    var notifyArray = [Notify.ViewModel.tableCellData]()
    @IBOutlet weak var clearBarButton: UIBarButtonItem!
    @IBOutlet weak var noDataLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    var offset = 0
    // MARK: View lifecycle
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.edgesForExtendedLayout = UIRectEdge.init(rawValue: 0)
        notificationTableView.tableFooterView = UIView()
        applyLocalizedText()
        hideBackButtonTitle()
        initialFunction()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if notifyArray.count != 0 {
            noDataLabel.isHidden = true
        }else {
            noDataLabel.isHidden = false
        }
    }
    
    
    func applyLocalizedText() {
        CommonFunctions.sharedInstance.setNavigationTitleView(titleStr: localizedTextFor(key: NotifySceneText.NotifySceneTitle.rawValue), onVC: self)
        clearBarButton.title = localizedTextFor(key: NotifySceneText.NotifySceneClearButtonText.rawValue)
        noDataLabel.text = localizedTextFor(key: NotifySceneText.NotifySceneNoDataLabel.rawValue)
    }
    
    func initialFunction() {
        
         if isCurrentLanguageArabic() {
                   backButton.contentHorizontalAlignment = .right
                   backButton.setImage(UIImage(named: "whiteRightArrow"), for: .normal)
               } else {
                   backButton.contentHorizontalAlignment = .left
                   backButton.setImage(UIImage(named: "whiteBackIcon"), for: .normal)
               }
        interactor?.hitListAllNotificationApi(offset: offset)
    }
    
    
    @IBAction func clearBtn(_ sender: Any) {
        showAlert()
    }
    
    func showAlert() {
        
        let alertController = PMAlertController(textForegroundColor:UIColor.darkGray, viewBackgroundColor: UIColor.white, title: "" , description: localizedTextFor(key:    NotifySceneText.NotifySceneClearAllAlert.rawValue), image: nil , style: .alert)
        
        let yesButton = PMAlertAction(title: localizedTextFor(key: GeneralText.yes.rawValue), style: .default, action: {
            
            self.interactor?.hitClearNotificationApi()
            
        })
        
        let noButton = PMAlertAction(title: localizedTextFor(key: GeneralText.no.rawValue), style: .default, action: {
            alertController.dismiss(animated: true, completion: nil)
        })
        
        alertController.addAction(noButton)
        alertController.addAction(yesButton)
        
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func backBarButtonItem(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK :- CASH OUT CONFIRMATION
    func showCashoutConfirmationAlert(notificationId:String, bookingId:String) {
        let alertController = PMAlertController(textForegroundColor:UIColor.darkGray, viewBackgroundColor: UIColor.white, title: "", description: localizedTextFor(key: GeneralText.cashOutWarning.rawValue), image: nil, style: .alert)
        alertController.addAction(PMAlertAction(title: localizedTextFor(key: GeneralText.reject.rawValue), style: .default, action: {
            
            self.interactor?.hitCashoutConfirmationByUserApi(isAccepted: false, isRejected: true, bookingId: bookingId, notificationId: notificationId)
            
        }))
        alertController.addAction(PMAlertAction(title: localizedTextFor(key: GeneralText.accept.rawValue), style: .default, action: {
            self.interactor?.hitCashoutConfirmationByUserApi(isAccepted: true, isRejected: false, bookingId: bookingId, notificationId: notificationId)
        }))
        
        present(alertController, animated: true, completion: nil)
    }
    
    // MARK: ReminderAlert
    func showReminderConfirmationAlert(bookingId:String,bookingLocation:String) {
        
        let alertText = "\(localizedTextFor(key: GeneralText.reminderNotification0.rawValue)) \n\(localizedTextFor(key: GeneralText.reminderNotification1.rawValue)) \(localizedTextFor(key: GeneralText.reminderNotification2.rawValue)) \n\n\(localizedTextFor(key: GeneralText.reminderNotification3.rawValue)) \n\n\(localizedTextFor(key: GeneralText.reminderNotification4.rawValue))"
        
        
        let alertController = PMAlertController(textForegroundColor:UIColor.darkGray, viewBackgroundColor: UIColor.white, title: localizedTextFor(key: GeneralText.reminderHeader.rawValue), description: alertText, image: nil, style: .alert)
        if let languageIdentifier = UserDefaults.standard.value(forKey: userDefualtKeys.currentLanguage.rawValue) as? String {
            if languageIdentifier == Languages.Arabic {
                alertController.alertDescription.textAlignment = .right
            }
            else {
                alertController.alertDescription.textAlignment = .left
            }
        }
        
        alertController.addAction(PMAlertAction(title: localizedTextFor(key: GeneralText.no.rawValue), style: .default, action: {
            
            self.interactor?.hitArrivalConfirmationUserApi(confirmationText: localizedTextFor(key: GeneralText.confirmed.rawValue), bookingId: bookingId)
            appDelegateObj.isReminder = false
            
        }))
        alertController.addAction(PMAlertAction(title: localizedTextFor(key: GeneralText.yes.rawValue).uppercased(), style: .default, action: {
            
            self.interactor?.hitArrivalConfirmationUserApi(confirmationText: localizedTextFor(key: GeneralText.cancelled.rawValue), bookingId: bookingId)
            
            appDelegateObj.isReminder = false
        }))
        
        present(alertController, animated: true, completion: nil)
    }
    
    func passDataToSaloonDetail(saloonId:String, destinationDS: inout SalonDetailDataStore)
    {
        destinationDS.saloonId = saloonId
        
    }
    
    func displayResponse(viewModel: Notify.ViewModel)
    {
        notifyArray = viewModel.tableArray
        notificationTableView.reloadData()
        if notifyArray.count != 0 {
            noDataLabel.isHidden = true
            self.navigationItem.rightBarButtonItems![0].isEnabled = true
            
        }else {
            noDataLabel.isHidden = false
            self.navigationItem.rightBarButtonItems![0].isEnabled = false
        }
    }
    
    func displayClearAllResponse() {
        CustomAlertController.sharedInstance.showAlert(subTitle: localizedTextFor(key: NotifySceneText.NotifySceneClearAllSuccessMessage.rawValue), type: .success)
        notifyArray.removeAll()
        notificationTableView.reloadData()
        noDataLabel.isHidden = false
        self.navigationItem.rightBarButtonItems![0].isEnabled = false
        
    }
    func passDataToAppointmentDetailVC(bookingId:String, destinationDS: inout OrderDetailDataStore)
    {
        //destinationDS.orderDetailArray = orderDetailArray
        destinationDS.bookingId = bookingId
        
    }
    
    func displayReadResponse() {
        initialFunction()
    }
}

extension NotifyViewController : UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return notifyArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReUseIdentifier, for: indexPath) as! NotifyTableViewCell
        let currentObj = notifyArray[indexPath.section]
        cell.setData(currentObj: currentObj)
        if currentObj.isRead {
            cell.infoLabel.textColor = UIColor.lightGray
            cell.dateLabel.textColor = UIColor.lightGray
            cell.circleImageView.isHidden = true
        }
        else {
            cell.circleImageView.isHidden = false
            cell.infoLabel.textColor = UIColor.black
            cell.dateLabel.textColor = UIColor.black
        }
        return cell             
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentObj = notifyArray[indexPath.section]
        if !currentObj.isRead {
            let unreadNotifications = userDefault.value(forKey: userDefualtKeys.unreadNotifications.rawValue) as! NSNumber
            
            if unreadNotifications != 0 {
                let newdata = Int(truncating: unreadNotifications) - 1
                printToConsole(item: newdata)
                userDefault.set(newdata, forKey: userDefualtKeys.unreadNotifications.rawValue)
            }
            interactor?.hitReadNotificationApi(notifyId: currentObj.notificationId)
        }
        
        let msgbodyDict =  CommonFunctions.sharedInstance.convertJsonStringToDictionary(text: currentObj.body)
        
        if currentObj.type == notificationTypes.cashout.rawValue{
            
            let bookingId =  msgbodyDict?["bookingId"] as? String ?? ""
            let isReject = msgbodyDict?["isReject"] as! Bool
            let isAccepted = msgbodyDict?["isAccept"] as! Bool
            
            if !isReject && !isAccepted {
                if !currentObj.isRead {
                    showCashoutConfirmationAlert(notificationId: currentObj.notificationId, bookingId: bookingId)
                }
            }else {
                router?.routeToControllers(data: currentObj.body, type:currentObj.type, isRead: currentObj.isRead, isRated:  currentObj.isRated, notificationId:  currentObj.notificationId)
            }
            
            
            
        } else if currentObj.type == notificationTypes.reminder.rawValue{
            
            let bookingId =  msgbodyDict?["bookingId"] as? String ?? ""
            let bookingType = msgbodyDict?["serviceType"] as? String ?? ""
            
            showReminderConfirmationAlert(bookingId: bookingId, bookingLocation: bookingType)
        } else if currentObj.type == "globalNotification"{
            
            let saloonId =  msgbodyDict?["linkToSalon"] as? String ?? ""
            
            let salondetailVC = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: ViewControllersIds.SalonDetailViewControllerID) as! SalonDetailViewController
            salondetailVC.isFromNotification = false
            var ds = salondetailVC.router?.dataStore
            passDataToSaloonDetail(saloonId: saloonId, destinationDS: &ds!)
            self.navigationController?.pushViewController(salondetailVC, animated: true)
        } else if currentObj.type == "serviceEvaluated"{
            if let bodyDict = msgbodyDict {
                
                let bookingId = bodyDict["bookingId"] as? String ?? ""
                if bookingId != "" {
                    
                    let storyboard = AppStoryboard.Business.instance
                    let destinationVC = storyboard.instantiateViewController(withIdentifier: ViewControllersIds.OrderDetailViewControllerID) as! OrderDetailViewController
                    var destinationDS = destinationVC.router!.dataStore!
                    self.passDataToAppointmentDetailVC(bookingId: bookingId, destinationDS: &destinationDS)
                    self.navigationController?.pushViewController(destinationVC, animated: true)
                }
            }
        } else {
            router?.routeToControllers(data: currentObj.body, type:currentObj.type, isRead: currentObj.isRead, isRated: currentObj.isRated, notificationId: currentObj.notificationId)
        }
    }
}
