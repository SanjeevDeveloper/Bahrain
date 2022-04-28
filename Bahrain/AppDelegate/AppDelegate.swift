
import UIKit
import GoogleMaps
import CoreData
import SocketIO
import Fabric
import Crashlytics
import Firebase
import UserNotifications
import GooglePlaces
import BenefitInAppSDK
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var userDataDictionary = NSMutableDictionary()
    var isPageControlActive = false
    var saloonStep1Data:BasicInformation.Request?
    var selectedArea:String?
    var selectBlock:String?
    var currentScreen = ""
    var isRateUs = false
    var salonId = "" // For rate functionality
    var isCashout = false
    var bookingId = "" // For cashout functionality
    var notificationId = "" // For cashout functionality
    var isReminder = false
    var bookingLocation = ""
    var notifyId = ""
    var rateDataArray = [RateServices.ViewModel.tableCellData]()
    var benefitPayDetail:Dictionary<String,Any> = [:]
    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        UINavigationBar.appearance().barTintColor = UIColor(red:0.08, green:0.23, blue:0.62, alpha:1.0)
        
        if #available(iOS 13.0, *) {
            // In iOS 13 setup is done in SceneDelegate
        } else {
            let window = UIWindow(frame: UIScreen.main.bounds)
            self.window = window
            let mainstoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let newViewcontroller:UIViewController = mainstoryboard.instantiateViewController(withIdentifier: "AnimatedSplashViewController") as! AnimatedSplashViewController
            window.rootViewController = newViewcontroller
        }
        return true
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        if #available(iOS 13.0, *) {
            // In iOS 13 setup is done in SceneDelegate
        } else {
            self.window?.makeKeyAndVisible()
        }
        
        if UserDefaults.standard.value(forKey: "Selected_Server") == nil {
            UserDefaults.standard.set("Local", forKey: "Selected_Server")
        }
        
        if let languageIdentifier = UserDefaults.standard.value(forKey: userDefualtKeys.currentLanguage.rawValue) as? String {
            if languageIdentifier == Languages.Arabic {
                UIView.appearance().semanticContentAttribute = .forceRightToLeft
            }
            else {
                UIView.appearance().semanticContentAttribute = .forceLeftToRight
            }
        }
        GMSPlacesClient.provideAPIKey(Configurator.googleApiKey)
        GMSServices.provideAPIKey(Configurator.googleApiKey)
        Fabric.with([Crashlytics.self])
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        registerForPushNotifications()
        
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        if isUserLoggedIn() {
            
            var initChatArr = [Any]()
            
            if (currentScreen == "UserMessageScreen" || currentScreen == "UserChatScreen") {
                let initDict = ["userId":getUserData(._id)]
                initChatArr = [initDict]
                SocketIOManager.sharedInstance.emitMethod(Key:SocketEndPoints.SocketEmit.socketEmitOffLineUser, params: initChatArr)
            } else{
                var initChatArr2 = [Any]()
                let initDict2 = ["userId":getUserData(.businessId)]
                initChatArr2 = [initDict2]
                SocketIOManager.sharedInstance.emitMethod(Key:SocketEndPoints.SocketEmit.socketEmitOffLineUser, params: initChatArr2)
            }
        }
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        if isUserLoggedIn() {
            var initChatArr = [Any]()
            
            if (currentScreen == "UserMessageScreen" || currentScreen == "UserChatScreen") {
                let initDict = ["userId":getUserData(._id)]
                initChatArr = [initDict]
                SocketIOManager.sharedInstance.emitMethod(Key:SocketEndPoints.SocketEmit.socketEmitOffLineUser, params: initChatArr)
                SocketIOManager.sharedInstance.closeConnection()
            }else{
                var initChatArr2 = [Any]()
                let initDict2 = ["userId":getUserData(.businessId)]
                initChatArr2 = [initDict2]
                SocketIOManager.sharedInstance.emitMethod(Key:SocketEndPoints.SocketEmit.socketEmitOffLineUser, params: initChatArr2)
            }
        }
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        if isUserLoggedIn() {
            DispatchQueue.main.asyncAfter(deadline: .now()+3) {
                self.emitSocketInit()
                self.emitSocketUnreadNotificationAndMessage()
            }
        }
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
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        
        UIApplication.shared.applicationIconBadgeNumber = 0
        SocketIOManager.sharedInstance.establishConnection()
        
        if isUserLoggedIn() {
            
            NotificationCenter.default.post(name: NSNotification.Name(SocketEndPoints.SocketNotification.socketNotificationAppDidBecomeActive), object: nil)
            
            //**-- Pending Messages socket --**
            if (currentScreen == "UserMessageScreen" || currentScreen == "UserChatScreen") {
                var getPendingMessagesArr = [Any]()
                let getPendingMessagesDict = ["receiverUserId":getUserData(._id),"receiverBusinessId":getUserData(.businessId),"type":"user"]
                getPendingMessagesArr = [getPendingMessagesDict]
                SocketIOManager.sharedInstance.emitMethod(Key:SocketEndPoints.SocketEmit.socketEmitGetPendingMessages, params: getPendingMessagesArr)
            }else{
                
                //**-- Emit Pending Messages socket --**
                var getPendingMessagesArr = [Any]()
                let getPendingMessagesDict = ["receiverUserId":getUserData(._id),"receiverBusinessId":getUserData(.businessId),"type":"business"]
                getPendingMessagesArr = [getPendingMessagesDict]
                SocketIOManager.sharedInstance.emitMethod(Key:SocketEndPoints.SocketEmit.socketEmitGetPendingMessages, params: getPendingMessagesArr)
            }
        }
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        if isUserLoggedIn() {
            if (currentScreen == "UserMessageScreen" || currentScreen == "UserChatScreen") {
                var initChatArr = [Any]()
                let initDict = ["userId":getUserData(._id)]
                initChatArr = [initDict]
                SocketIOManager.sharedInstance.emitMethod(Key:SocketEndPoints.SocketEmit.socketEmitOffLineUser, params: initChatArr)
            } else {
                var initChatArr2 = [Any]()
                let initDict2 = ["userId":getUserData(.businessId)]
                initChatArr2 = [initDict2]
                SocketIOManager.sharedInstance.emitMethod(Key:SocketEndPoints.SocketEmit.socketEmitOffLineUser, params: initChatArr2)
            }
        }
    }
    
    //Firebase
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        // Pass device token to auth
        Auth.auth().setAPNSToken(deviceToken, type: AuthAPNSTokenType.sandbox)
        
        //        let tokenParts = deviceToken.map { data -> String in
        //            return String(format: "%02.2hhx", data)
        //        }
        //
        //        let token = tokenParts.joined()
        //        print("Device Token: \(token)")
        //        userDefault.set(token as? String, forKey:"DeviceToken")
    }
    
    func application(_ application: UIApplication,
                     didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register: \(error)")
        userDefault.set("dummy", forKey:"DeviceToken")
    }
    
    
    func application(_ application: UIApplication,
                     didReceiveRemoteNotification notification: [AnyHashable : Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        if Auth.auth().canHandleNotification(notification) {
            completionHandler(UIBackgroundFetchResult.noData)
            return
        }
        // This notification is not auth related, developer should handle it.
    }
    
    
    func passDataToChatView(buisnessId: String,salonName:String,salonImage:String,isFromMessage:Bool, destinationDS: inout ChatDataStore)
    {
        destinationDS.buisnessId = buisnessId
        destinationDS.salonName = salonName
        destinationDS.salonImage = salonImage
        destinationDS.isFromMessage = isFromMessage
    }
    
    func passDataToBusinessChatView(buisnessId: String,salonName:String,salonImage:String, destinationDS: inout BusinessChatDataStore)
    {
        destinationDS.buisnessId = buisnessId
        destinationDS.salonName = salonName
        destinationDS.salonImage = salonImage
        destinationDS.isFromMessage = false
    }
    
    
    func passDataToAppotmentDetailView(orderDetailArray: BusinessToday.ViewModel.tableCellData?, destinationDS: inout BusinessAppointmentDetailDataStore)
    {
        destinationDS.orderDetailArray = orderDetailArray
        
    }
    
    func passDataToMyAppointmentDetail(appoinmentId:String, destinationDS: inout OrderDetailDataStore)
    {
        //        destinationDS.orderDetailArray = orderDetailArray
        //        destinationDS.tableScreen = true
        destinationDS.bookingId = appoinmentId
        
    }
    
    func passDataToSaloonDetail(saloonId:String, destinationDS: inout SalonDetailDataStore)
    {
        destinationDS.saloonId = saloonId
        
    }
    
    func passDataToRateReviewVC(notificationId: String, salonId: String?, dataArray:[RateServices.ViewModel.tableCellData],destinationDS: inout rateReviewDataStore)
    {
        destinationDS.salonId = salonId
        destinationDS.dataArray = dataArray
        destinationDS.notificationId = notificationId
    }
    
    func passDataToHomeVC(NotificationId: String?, bookingId: String?, destinationDS: inout HomeDataStore)
    {
        
    }
    
    func application(_ application: UIApplication, handleOpen url: URL) -> Bool {
        if url.absoluteString .contains("bahrainsalons://"){
            
            return true
        }
        else {
        let detail = BPDLPaymentCallBackItem(deepLinkURL: url)
        print(detail!)
        return true
        }
    }
    
    // For iOS 9+
    func application(_ application: UIApplication, open url: URL,
                     options: [UIApplicationOpenURLOptionsKey : Any]) -> Bool {
        if url.absoluteString .contains("bahrainsalons://"){
            ApiCall()
            return true
        }
        else {
        let detail = BPDLPaymentCallBackItem(deepLinkURL: url)
        NotificationCenter.default.post(name: NSNotification.Name("benefitPayCallBack"), object: detail)
        print(detail!)
        if Auth.auth().canHandle(url) {
            return true
        }
        // URL not auth related, developer should handle it.
        return true
        }
    }
    
    func ApiCall()
    {
        let baseURL = NetworkingWrapper.sharedInstance.selectedServerURL().baseURL
        let deepLinkUrl = baseURL + "getBusinessCode/FGaYgHqyag"
        
    }
    
   
    // MARK: Other functions
    

    func setStatusBarBackgroundColor() {
        
        if #available(iOS 13.0, *) {
            let statusBar = UIView(frame: UIApplication.shared.keyWindow?.windowScene?.statusBarManager?.statusBarFrame ?? CGRect.zero)
            statusBar.backgroundColor = statusBarColor
            UIApplication.shared.keyWindow?.addSubview(statusBar)
        } else {
            guard let statusBar = UIApplication.shared.statusBarUIView else { return }
            statusBar.backgroundColor = statusBarColor
        }
    }
    
    func unarchiveUserData() {
        // UnArchiving user attributes object
        if let userData:Data = userDefault.value(forKey: userDefualtKeys.UserObject.rawValue) as? Data {
            if let userDict = NSKeyedUnarchiver.unarchiveObject(with: userData) {
                self.userDataDictionary = userDict as! NSMutableDictionary
            }
        }
    }
    
    func checkUserLoginStatus() {
        if userDefault.bool(forKey: userDefualtKeys.userLoggedIn.rawValue) {
            let storyboard = AppStoryboard.Main.instance
            let tabBarController = storyboard.instantiateViewController(withIdentifier: AppDelegatePaths.Identifiers.UserModuleNavigationControllerID)
            self.window?.rootViewController = tabBarController
            self.window?.makeKeyAndVisible()
        }
    }
    
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "chatModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func registerForPushNotifications() {
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
            (granted, error) in
            print("Permission granted: \(granted)")
            guard granted else {
                return
            }
            self.getNotificationSettings()
        }
    }
    
    func getNotificationSettings() {
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            print("Notification settings: \(settings)")
            
            guard settings.authorizationStatus == .authorized else { return }
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }
    
}

// [START ios_10_message_handling]
@available(iOS 10, *)
extension AppDelegate : UNUserNotificationCenterDelegate {
    
    // Receive displayed notifications for iOS 10 devices.
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        
        let userInfo = notification.request.content.userInfo as! [String:Any]
        printToConsole(item: userInfo)
        let data = userInfo["gcm.notification.message"] as? String
        
        if let msgbody =  CommonFunctions.sharedInstance.convertJsonStringToDictionary(text: data!) {
            printToConsole(item: msgbody)
            
            let createdBy = msgbody["createdBy"] as? String ?? ""
            if createdBy != "user" {
                completionHandler([.alert, .sound])
                let type = msgbody["type"] as! String
                if type == "delete" {
                    CommonFunctions.sharedInstance.showSessionExpireAlert()
                }
            }
            
        }
    }
    
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo as! [String:Any]
        printToConsole(item: userInfo)
        let data = userInfo["gcm.notification.message"] as? String
        
        if let msgbody =  CommonFunctions.sharedInstance.convertJsonStringToDictionary(text: data!) {
            printToConsole(item: msgbody)
            
            
            let type = msgbody["type"] as! String
            //        let type = dictData["type"] as! String
            
            
            
            let adminBusinessID = userDataDictionary["businessId"] as? String
            let mainStoryBoard = AppStoryboard.Main.instance
            let chatStoryBoard = AppStoryboard.Chat.instance
            let businessStoryBoard = AppStoryboard.Business.instance
            
            var buisnessId : String?
            var salonName : String?
            var salonImage:String?
            var isFromMessage:Bool?
            var orderDetailArray = [BusinessToday.ViewModel.tableCellData]()
            //        var userInfo = notification
            //        let msgbody = userInfo["msgBody"] as? NSDictionary
            
            
            if type == "message"{
                
                buisnessId = msgbody["senderId"] as? String
                salonName = msgbody["senderName"] as? String
                salonImage = msgbody["profileImage"] as? String
                isFromMessage = true
                let from = msgbody["from"] as? String
                
                if from == "business" {
                    
                    if let navController = window?.rootViewController as? UINavigationController {
                        
                        if (navController.visibleViewController?.isKind(of: ChatViewController.self))! {
                            printToConsole(item: "same screen")
                        }
                        else {
                            let vcObj = chatStoryBoard.instantiateViewController(withIdentifier: ViewControllersIds.ChatViewControllerID) as? ChatViewController
                            var ds = vcObj!.router?.dataStore
                            passDataToChatView(buisnessId: buisnessId! ,salonName:salonName! ,salonImage:salonImage!,isFromMessage: isFromMessage!, destinationDS: &ds!)
                            navController.visibleViewController?.navigationController?.pushViewController(vcObj!, animated: true)
                        }
                    }
                    
                }else if from == "user" {
                    
                }else {
                    let receiverId = msgbody["receiverId"] as? String
                    if adminBusinessID == receiverId{
                        
                    }else{
                        
                        let navController = window?.rootViewController as? UINavigationController
                        
                        if (navController?.visibleViewController?.isKind(of: ChatViewController.self))! {
                            printToConsole(item: "same screen")
                        }
                        else {
                            
                            let vcObj = chatStoryBoard.instantiateViewController(withIdentifier: ViewControllersIds.ChatViewControllerID) as? ChatViewController
                            var ds = vcObj!.router?.dataStore
                            passDataToChatView(buisnessId: buisnessId! ,salonName:salonName! ,salonImage:salonImage!,isFromMessage: isFromMessage!, destinationDS: &ds!)
                            navController?.visibleViewController?.navigationController?.pushViewController(vcObj!, animated: true)
                        }
                    }
                }
            }
            else if type == "globalNotification" {
                
                if let saloonId = msgbody["linkToSalon"] as? String, let notificationId = msgbody["notificationId"] as? String {
                    
                    readNotificationsApi(notifyid: notificationId)
                    
                    if let navController = window?.rootViewController as? UINavigationController {
                        
                        if (navController.visibleViewController?.isKind(of: SalonDetailViewController.self))! {
                            printToConsole(item: "same screen")
                        }
                        else {
                            let vcObj = mainStoryBoard.instantiateViewController(withIdentifier: ViewControllersIds.SalonDetailViewControllerID) as? SalonDetailViewController
                            var ds = vcObj!.router?.dataStore
                            passDataToSaloonDetail(saloonId: saloonId, destinationDS: &ds!)
                            navController.visibleViewController?.navigationController?.pushViewController(vcObj!, animated: true)
                        }
                    } else {
                        let salondetailVC = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: ViewControllersIds.SalonDetailViewControllerID) as? SalonDetailViewController
                        salondetailVC?.isFromNotification = true
                        var ds = salondetailVC!.router?.dataStore
                        passDataToSaloonDetail(saloonId: saloonId, destinationDS: &ds!)
                        let navCtrl = UserModuleNavigationController(rootViewController: salondetailVC!)
                        appDelegateObj.window?.rootViewController = navCtrl
                        appDelegateObj.window?.makeKeyAndVisible()
                    }
                }
                
            } else if type == "bookingCompleted" || type == "serviceEvaluated" {
                
                if let appointmentId = msgbody["bookingId"] as? String, let notificationId = msgbody["notificationId"] as? String {
                    
                    readNotificationsApi(notifyid: notificationId)
                    
                    if let navController = window?.rootViewController as? UINavigationController {
                        if (navController.visibleViewController?.isKind(of: OrderDetailViewController.self))! {
                            printToConsole(item: "same screen")
                        }
                        else {
                            let vcObj = mainStoryBoard.instantiateViewController(withIdentifier: ViewControllersIds.OrderDetailViewControllerID) as? OrderDetailViewController
                            var ds = vcObj!.router?.dataStore
                            passDataToMyAppointmentDetail(appoinmentId: appointmentId, destinationDS: &ds!)
                            //               navController.visibleViewController?.navigationController?.isNavigationBarHidden = false
                            navController.visibleViewController?.navigationController?.pushViewController(vcObj!, animated: true)
                        }
                    }
                }
                
            } else if type == "booking" {
                
                var viewModelArray = [BusinessToday.ViewModel.tableCellData]()
                let responseDict = msgbody
                let bodyDict = responseDict["body"] as! NSDictionary
                
                //Notification Id
                let notificationId = responseDict["notificationId"] as! String
                
                //Client Name
                let bookingDataDict =  bodyDict["bookingData"] as! NSDictionary
                
                printToConsole(item: bookingDataDict)
                
                if  let clientId = bookingDataDict["clientId"] as? NSDictionary {
                    
                }
                else {
                    
                    //Api Hit
                    readNotificationsApi(notifyid: notificationId)
                    
                    //                    var serviceName = String()
                    //                    let bookingDate = bookingDataDict["bookingDate"] as! Int64
                    //
                    //                    printToConsole(item: bookingDate)
                    //                    let date = Date(milliseconds: Int(bookingDate))
                    //                    let dateFormatter = DateFormatter()
                    //                    dateFormatter.dateFormat = dateFormats.format2
                    //                    let time = dateFormatter.string(from: date)
                    //                    printToConsole(item: time)
                    //
                    //                    dateFormatter.dateFormat = dateFormats.format4
                    //                    let day = dateFormatter.string(from: date)
                    //                    printToConsole(item: date)
                    
                    // Service Array
                    //                    let serviceDataArray = bookingDataDict["services"] as! NSArray
                    //                    for serviceObj in serviceDataArray {
                    //                        let serviceDict = serviceObj as! NSDictionary
                    //                        let name = serviceDict["serviceName"] as! String
                    //
                    //                        if serviceName.isEmptyString() {
                    //                            serviceName.append(name)
                    //                        }
                    //                        else {
                    //                            serviceName.append(", \(name)")
                    //                        }
                    //                    }
                    
                    // let businessDataDict = bookingDataDict["businessId"] as! NSDictionary
                    
                    let appointmentId = bookingDataDict["_id"] as? String ?? ""
                    
                    //                    let obj = MyAppointments.ViewModel.tableCellData(
                    //                        date: day,
                    //                        time: time,
                    //                        name: businessDataDict["saloonName"] as! String,
                    //                        appointmentId: bookingDataDict["_id"] as! String,
                    //                        categories: serviceName,
                    //                        paymentMode: bookingDataDict["paymentStatus"] as! String,
                    //                        totalAmount: bookingDataDict["totalAmount"] as! NSNumber,
                    //                        isCancelled: bookingDataDict["isCancelled"] as! Bool,
                    //                        categoriesArr: serviceDataArray,
                    //                        profileImage: businessDataDict["profileImage"] as! String,
                    //                        paymentType: bookingDataDict["paymentType"] as! String,
                    //                        businessId: businessDataDict["_id"] as! String, createdAt: bookingDataDict["bookingDate"] as? Int64 ?? 0, paidAmt: bookingDataDict["paidAmount"] as! NSNumber, remainingAmt: bookingDataDict["remainingAmount"] as! NSNumber,
                    //                        serviceStatus: bookingDataDict["status"] as? String ?? ""
                    //                    )
                    
                    if let navController = window?.rootViewController as? UINavigationController {
                        
                        if (navController.visibleViewController?.isKind(of: OrderDetailViewController.self))! {
                            printToConsole(item: "same screen")
                        }
                        else {
                            let vcObj = mainStoryBoard.instantiateViewController(withIdentifier: ViewControllersIds.OrderDetailViewControllerID) as? OrderDetailViewController
                            var ds = vcObj!.router?.dataStore
                            passDataToMyAppointmentDetail(appoinmentId: appointmentId, destinationDS: &ds!)
                            //               navController.visibleViewController?.navigationController?.isNavigationBarHidden = false
                            navController.visibleViewController?.navigationController?.pushViewController(vcObj!, animated: true)
                        }
                    }
                }
                
            }else if type == "rateUs"{
                
                isRateUs = true
                
                
                let businessId = msgbody["businessId"] as! String
                
                //Notification Id
                let notificationId = msgbody["notificationId"] as! String
                self.notifyId = notificationId
                
                //Api Hit
                readNotificationsApi(notifyid: notificationId)
                
                var  dataArray = [RateServices.ViewModel.tableCellData]()
                
                
                let bookingDict = msgbody["bookingDetails"] as? NSDictionary
                
                let serviceArray = bookingDict?["bookingServices"] as! NSArray
                
                for item in serviceArray {
                    
                    let dataDict = item as! NSDictionary
                    
                    let obj = RateServices.ViewModel.tableCellData(serviceName: dataDict["serviceName"] as! String, therapistId: dataDict["therapistId"] as! String, therapistName: dataDict["therapistName"] as! String)
                    
                    dataArray.append(obj)
                    
                }
                
                rateDataArray = dataArray
                
                salonId = businessId
                
                if let navController = window?.rootViewController as? UINavigationController {
                    let vcObj = mainStoryBoard.instantiateViewController(withIdentifier: ViewControllersIds.rateReviewViewControllerID) as? rateReviewViewController
                    var ds = vcObj!.router?.dataStore
                    passDataToRateReviewVC(notificationId: notificationId, salonId: businessId, dataArray: dataArray, destinationDS: &ds!)
                    navController.visibleViewController?.navigationController?.pushViewController(vcObj!, animated: true)
                }
            }else if type == "request"{
                
            }
            else if type == notificationTypes.wallet.rawValue {
                
                if let navController = window?.rootViewController as? UINavigationController {
                    
                    if (navController.visibleViewController?.isKind(of: WalletViewController.self))! {
                        printToConsole(item: "same screen")
                    }
                    else {
                        let vcObj = mainStoryBoard.instantiateViewController(withIdentifier: ViewControllersIds.WalletViewControllerID) as? WalletViewController
                        navController.visibleViewController?.navigationController?.pushViewController(vcObj!, animated: true)
                    }
                    
                }
                
            }
            else if type == "cashout"{
                
                isCashout = true
                bookingId = msgbody["bookingId"] as? String ?? ""
                notificationId = msgbody["notificationId"] as? String ?? ""
                
                readNotificationsApi(notifyid: notificationId)
                
                
                
                let paramDict = [
                    "bookingId":msgbody["bookingId"] as? String ?? "",
                    "notificationId":msgbody["notificationId"] as? String ?? ""
                ] as [String : Any]
                
                
                if let navController = window?.rootViewController as? UINavigationController {
                    
                    if (navController.visibleViewController?.isKind(of: HomeViewController.self))! {
                        printToConsole(item: "same screen")
                        let nc = NotificationCenter.default
                        nc.post(name: Notification.Name("cashout"), object: paramDict)
                        
                        
                    }
                    else {
                        let vcObj = mainStoryBoard.instantiateViewController(withIdentifier: ViewControllersIds.HomeViewControllerIds) as? HomeViewController
                        //
                        //                        var a = navController.viewControllers
                        //                        a.append(vcObj!)
                        //                        navController.setViewControllers(a, animated: false)
                        navController.visibleViewController?.navigationController?.pushViewController(vcObj!, animated: true)
                        //                        DispatchQueue.main.asyncAfter(deadline: .now()+30) {
                        //                            let nc = NotificationCenter.default
                        //                            nc.post(name: Notification.Name("cashout"), object: paramDict)
                        //                        }
                    }
                    
                    
                }
                
            }
            else if type == "reminder"{
                
                isReminder = true
                bookingId = msgbody["bookingId"] as? String ?? ""
                notificationId = msgbody["notificationId"] as? String ?? ""
                bookingLocation = msgbody["serviceType"] as? String ?? ""
                
                let paramDict = [
                    "bookingId":msgbody["bookingId"] as? String ?? "",
                    "notificationId":msgbody["notificationId"] as? String ?? "",
                    "bookinglocation":msgbody["serviceType"] as? String ?? ""
                ] as [String : Any]
                
                
                if let navController = window?.rootViewController as? UINavigationController {
                    
                    if (navController.visibleViewController?.isKind(of: HomeViewController.self))! {
                        printToConsole(item: "same screen")
                        let nc = NotificationCenter.default
                        nc.post(name: Notification.Name("reminder"), object: paramDict)
                        
                        
                    }
                    else {
                        let vcObj = mainStoryBoard.instantiateViewController(withIdentifier: ViewControllersIds.HomeViewControllerIds) as? HomeViewController
                        navController.visibleViewController?.navigationController?.pushViewController(vcObj!, animated: true)
                        
                    }
                    
                    
                }
                
            }
            else{
                if let navController = window?.rootViewController as? UINavigationController {
                    
                    if (navController.visibleViewController?.isKind(of: NotifyViewController.self))! {
                        printToConsole(item: "same screen")
                    }
                    else {
                        let vcObj = mainStoryBoard.instantiateViewController(withIdentifier: ViewControllersIds.NotifyViewControllerID) as? NotifyViewController
                        navController.visibleViewController?.navigationController?.pushViewController(vcObj!, animated: true)
                    }
                } else {
                    let notificationVC = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: ViewControllersIds.NotifyViewControllerID) as? NotifyViewController
                    let navCtrl = UserModuleNavigationController(rootViewController: notificationVC!)
                    appDelegateObj.window?.rootViewController = navCtrl
                    appDelegateObj.window?.makeKeyAndVisible()
                }
            }
            
            completionHandler()
        }
    }
    
    //Api Hit
    
    func readNotificationsApi(notifyid:String) {
        let url = ApiEndPoints.userModule.readNotifications + "/" + notifyid
        NetworkingWrapper.sharedInstance.connect(urlEndPoint: url, httpMethod: .put, headers: ApiHeaders.sharedInstance.headerWithAuth()) { (response) in
            if response.code == 200 {
                
            }
            else {
                //                CustomAlertController.sharedInstance.showErrorAlert(error: response.error!)
            }
        }
    }
    
}

extension AppDelegate: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        printToConsole(item: "Firebase registration token: \(fcmToken)")
        //        let token = Messaging.messaging().fcmToken as? String ?? ""
        //        printToConsole(item: token)
        userDefault.set(fcmToken, forKey:userDefualtKeys.firebaseToken.rawValue)
    }
    
    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
        printToConsole(item: "Received data message: \(remoteMessage.appData)")
    }
}



