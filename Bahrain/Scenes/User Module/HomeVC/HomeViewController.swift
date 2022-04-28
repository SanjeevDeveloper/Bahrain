
import UIKit

protocol HomeDisplayLogic: class
{
    func displayCategoriesResponse(viewModel: Home.ViewModel)
    func displayFavouriteResponse(viewModel: Home.FavouriteApiViewModel)
    func presentServicesResponse(viewModelArray: [ListYourService.ViewModel.service])
}


class HomeViewController: BaseViewControllerUser, HomeDisplayLogic
{
    
    var interactor: HomeBusinessLogic?
    var router: (NSObjectProtocol & HomeRoutingLogic & HomeDataPassing)?
    
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
        let interactor = HomeInteractor()
        let presenter = HomePresenter()
        let router = HomeRouter()
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
    
    //////////////////////////////////////////////////////
    
    @IBOutlet weak var specialOfferButton: UIButton!
    @IBOutlet weak var browseCategoriesLabel: UILabel!
    @IBOutlet weak var servicesCollectionView: UICollectionView!
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    
    @IBOutlet weak var buttonNotificationCount: UIButton!
    @IBOutlet weak var buttonMessageCount: UIButton!
    
    var categoriesArray = [Home.ViewModel.Category]()
    var servicesListArray = [ListYourService.ViewModel.service]()
    var offset = 0
    
    // MARK: View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(showCashoutConfirmationAlert), name: Notification.Name("cashout"), object: nil)
        nc.addObserver(self, selector: #selector(showReminderConfirmationAlert), name: Notification.Name("reminder"), object: nil)
        
        if isUserLoggedIn() {
            if appDelegateObj.isRateUs {
                router?.routeToRateReview()
            }
        }
        initialFunction()
        NotificationCenter.default.addObserver(self, selector: #selector(countOfNotification), name: Notification.Name(SocketEndPoints.SocketNotification.socketUnreadNotificationsName), object: nil)
    }
    
    @objc func countOfNotification(sender: NSNotification) {
        let countDict = sender.userInfo as! [String : AnyObject]
        
        let msgCount = countDict["unreadMsgsCount"] as? NSNumber ?? 0
        if msgCount.intValue > 99 {
            buttonMessageCount.addBadgeToButon(badge: "99+")
        } else {
            buttonMessageCount.addBadgeToButon(badge: msgCount.stringValue)
        }
        
        let notificationCount = countDict["unreadNotificationsCount"] as? NSNumber ?? 0
        if notificationCount.intValue > 99 {
            buttonNotificationCount.addBadgeToButon(badge: "99+")
        } else {
            buttonNotificationCount.addBadgeToButon(badge: notificationCount.stringValue)
        }
        printToConsole(item: countDict)
    }
    
    func emitSocketInit() {
        
        //**-- Init socket --**
        
        var initChatArr = [Any]()
        let initDict = ["userId":getUserData(._id)]
        initChatArr = [initDict]
        SocketIOManager.sharedInstance.emitMethod(Key:SocketEndPoints.SocketEmit.socketEmitInit, params: initChatArr)
    }
    
    func emitSocketUnreadNotificationAndMessage() {
        
        //**-- Init socket --**
        
        var initChatArr = [Any]()
        let initDict = [
            "userId":getUserData(._id),
            "businessId": ""
        ]
        initChatArr = [initDict]
        SocketIOManager.sharedInstance.emitMethod(Key:SocketEndPoints.SocketEmit.getUnreadMsgNotifications, params: initChatArr)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if isUserLoggedIn() {
            emitSocketInit()
            emitSocketUnreadNotificationAndMessage()
            
            DispatchQueue.main.asyncAfter(deadline: .now()+2) {
                if appDelegateObj.isCashout{
                    let paramDict = [
                        "bookingId":appDelegateObj.bookingId,
                        "notificationId":appDelegateObj.notificationId
                        ] as [String : Any]
                    let nc = NotificationCenter.default
                    nc.post(name: Notification.Name("cashout"), object: paramDict)
                }
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now()+2) {
                if appDelegateObj.isReminder{
                    let paramDict = [
                        "bookingId":appDelegateObj.bookingId,
                        "notificationId":appDelegateObj.notificationId,
                        "bookinglocation":appDelegateObj.bookingLocation
                        ] as [String : Any]
                    let nc = NotificationCenter.default
                    nc.post(name: Notification.Name("reminder"), object: paramDict)
                }
            }
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        applyLocalizedText()
        interactor?.hitGetCategoriesApi()
        if isUserLoggedIn() {
            interactor?.getCountUnreadNotification()
            interactor?.getBenefitPayDetail()
        }
        
    }
    
    
    // MARK: Apply LocalizedText
    func applyLocalizedText() {
        CommonFunctions.sharedInstance.setNavigationTitleView(titleStr: localizedTextFor(key: HomeSceneText.homeSceneTitle.rawValue), onVC: self)
        specialOfferButton.setTitle(localizedTextFor(key: HomeSceneText.homeSceneSpecialOffer.rawValue), for: .normal)
        browseCategoriesLabel.text = localizedTextFor(key: HomeSceneText.homeSceneBrowseCategories.rawValue)
    }
    
    // MARK: Other Functions
    
    func initialFunction() {
        addFavoriteNotificationObserver()
        addSlideMenuButton()
        if isUserLoggedIn() {
            interactor?.getAllChatApi()
        }
        
        interactor?.getServicesList()
    }
    
    func addFavoriteNotificationObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfReceivedNotification(notification:)), name: Notification.Name("FavoriteUpdated"), object: nil)
    }
    
    @objc func methodOfReceivedNotification(notification: Notification){
        //interactor?.hitListFavouriteApi(offset: offset)
    }
    
    // MARK: CashoutAlert
    @objc func showCashoutConfirmationAlert(notification: NSNotification) {
        
        let obj = notification.object as! NSDictionary
        
        let notificationId = obj["notificationId"] as! String
        let bookingId = obj["bookingId"] as! String
        
        let alertController = PMAlertController(textForegroundColor:UIColor.darkGray, viewBackgroundColor: UIColor.white, title: "", description: localizedTextFor(key: GeneralText.cashOutWarning.rawValue), image: nil, style: .alert)
        
        alertController.addAction(PMAlertAction(title: localizedTextFor(key: GeneralText.reject.rawValue), style: .default, action: {
            
            self.interactor?.hitCashoutConfirmationByUserApi(isAccepted: false, isRejected: true, bookingId: bookingId, notificationId: notificationId)
            appDelegateObj.isCashout = false
            alertController.dismiss(animated: true, completion: nil)
            
        }))
        alertController.addAction(PMAlertAction(title: localizedTextFor(key: GeneralText.accept.rawValue), style: .default, action: {
            self.interactor?.hitCashoutConfirmationByUserApi(isAccepted: true, isRejected: false, bookingId: bookingId, notificationId: notificationId)
            appDelegateObj.isCashout = false
            alertController.dismiss(animated: true, completion: nil)
        }))
        
        present(alertController, animated: true, completion: nil)
    }
    
    // MARK: ReminderAlert
    @objc func showReminderConfirmationAlert(notification: NSNotification) {
        
        let obj = notification.object as! NSDictionary
        
        //        let notificationId = obj["notificationId"] as! String
        let bookingId = obj["bookingId"] as! String
        
        let bookingTimeMill = obj["bookingTime"] as? NSNumber ?? 0
        let bookingTime = Date(largeMilliseconds: bookingTimeMill.int64Value)
        let dateFormatter = getDateFormatter()
        dateFormatter.dateFormat = dateFormats.format10
        let bookingDateString = dateFormatter.string(from: bookingTime)
        
       // let bookingLocation = obj["bookinglocation"] as! String
        
       let alertText = "\(localizedTextFor(key: GeneralText.reminderNotification0.rawValue)) \n\(localizedTextFor(key: GeneralText.reminderNotification1.rawValue)) \(localizedTextFor(key: GeneralText.reminderNotification2.rawValue)) \n\n\(localizedTextFor(key: GeneralText.reminderNotification3.rawValue)) \n\n\(localizedTextFor(key: GeneralText.reminderNotification4.rawValue))"
//        if bookingLocation == "salon" {
//            alertText = localizedTextFor(key: GeneralText.salonAvailService.rawValue)
//        }else {
//            alertText = localizedTextFor(key: GeneralText.availService.rawValue)
//        }
        
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
    
    func displayCategoriesResponse(viewModel: Home.ViewModel) {
        categoriesArray = viewModel.categoriesArray
        categoryCollectionView.reloadData()
    }
    
    func displayFavouriteResponse(viewModel: Home.FavouriteApiViewModel) {
        if offset == 0 {
            let viewModelArrayCount = viewModel.tableArray.count
            if viewModelArrayCount < 4 {
                let startingIndex = 4 - viewModelArrayCount
                for _ in stride(from: startingIndex, through: 1, by: -1) {
                    let obj = Home.FavouriteApiViewModel.CellData(salonImage: "", favImage: #imageLiteral(resourceName: "addFavorite"), saloonId: "")
                }
            }
        }
    }
    
    func presentServicesResponse(viewModelArray: [ListYourService.ViewModel.service]) {
        self.servicesListArray = viewModelArray
        servicesCollectionView.reloadData()
    }
    
    @IBAction func actionSearchBtn(_ sender: Any) {
        self.router?.routeToSearch()
    }
    
    @IBAction func actionNotificationBtn(_ sender: UIButton) {
        let destViewController : UIViewController = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: ViewControllersIds.NotifyViewControllerID)
        buttonNotificationCount.addBadgeToButon(badge: nil)
        self.navigationController!.pushViewController(destViewController, animated: true)
    }
    
    @IBAction func actionChatBtn(_ sender: UIButton) {
        let destViewController : UIViewController = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: ViewControllersIds.messageViewController)
        buttonMessageCount.addBadgeToButon(badge: nil)
        self.navigationController!.pushViewController(destViewController, animated: true)
    }
    
    @IBAction func specialOfferBtnAction(_ sender: UIButton) {
        router?.routeToSpecialSalonListing()
    }
}

// MARK: UICollectionViewDelegate

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag == 2 {
            return servicesListArray.count
        }
        else {
            return categoriesArray.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView.tag == 2 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReUseIdentifier, for: indexPath) as! StaticGridCollectionViewCell
            let currentObj = servicesListArray[indexPath.item]
            cell.setData(obj:currentObj)
            return cell
        }
        else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReUseIdentifier, for: indexPath) as! CategoriesCollectionViewCell
            let currentObj = categoriesArray[indexPath.item]
            let image = currentObj.categoryImageUrl
            let imageUrl = Configurator().imageBaseUrl + image
            cell.categoryImage.sd_setImage(with: URL(string: imageUrl), completed: nil)
            cell.categoryName.text = currentObj.categoryName.uppercased()
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView.tag == 2 {
            let width = collectionView.bounds.size.width
            let requiredWidth = (width) * 0.5
            return CGSize(width: requiredWidth, height: 100)
        }
        else {
            let width = collectionView.bounds.size.width
            let requiredWidth = (width / 3)
            return CGSize(width: requiredWidth, height: 80)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView.tag == 2 {
            let obj = servicesListArray[indexPath.item]
            let name = obj.name
            let reqName = obj.keyName
            let id = obj.id
            router?.routeToFavoriteList(serviceId: id, categoryId:nil , name:name, reqTitle:reqName)
        }
        else if collectionView.tag == 3 {
            let obj = categoriesArray[indexPath.item]
            let name = obj.categoryName
            let id = obj.categoryId
            router?.routeToFavoriteList(serviceId: nil, categoryId: id, name:name, reqTitle: nil)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if collectionView.tag == 1 {
            if indexPath.item == (((self.offset + 1)*10) - 1) {
                self.offset += 1
                // interactor?.hitListFavouriteApi(offset: offset)
            }
        }
    }
}
