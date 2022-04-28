
import UIKit


protocol HomeBusinessLogic
{
    func getAllChatApi()
    func hitGetCategoriesApi()
    func hitListFavouriteApi(offset:Int)
    func getServicesList()
    func getBenefitPayDetail()
    func getCountUnreadNotification()
    func hitCashoutConfirmationByUserApi(isAccepted:Bool, isRejected:Bool, bookingId:String, notificationId:String)
    func hitArrivalConfirmationUserApi(confirmationText: String, bookingId:String)
}

protocol HomeDataStore
{
    var servicesArray: NSArray? { get set }
    //    var notificationId: String? { get set }
    //    var bookingId: String? { get set }
}

class HomeInteractor: HomeBusinessLogic, HomeDataStore
{
    
    var presenter: HomePresentationLogic?
    var worker: HomeWorker?
    var servicesArray: NSArray?
    var notificationId: String?
    var bookingId: String?
    
    // MARK: Do something
    func getServicesList() {
        worker = HomeWorker()
        worker?.getServicesList(apiResponse: { (response) in
            if response.code == 200 {
                self.servicesArray = response.result as? NSArray
                let presenterResponse = ListYourService.Response(servicesArray: self.servicesArray!)
                self.presenter?.presentListResponse(response: presenterResponse)
            }
            else if response.code == 404 {
                CommonFunctions.sharedInstance.showSessionExpireAlert()
            }
            else {
                CustomAlertController.sharedInstance.showErrorAlert(error: response.error!)
            }
        })
    }
    
    func getBenefitPayDetail() {
        worker = HomeWorker()
        worker?.getBenefitPayResponse(apiResponse: { (response) in
            if response.code == 200 {
//                print(response.result);
                appDelegateObj.benefitPayDetail = response.result as! Dictionary<String, Any>
            }
            else if response.code == 404 {
                CommonFunctions.sharedInstance.showSessionExpireAlert()
            }
            else {
                CustomAlertController.sharedInstance.showErrorAlert(error: response.error!)
            }
            
        })
    }
    
    func callChatApi(){
        worker = HomeWorker()
        
        worker?.getChatMessageResponse(apiResponse: { (response) in
            
            if response.code == 200 {
                
                let responseResult =  response.result as! [String : Any]
                
                //**-- Save User chat --**
                var userChatArray = [NSDictionary]()
                userChatArray = responseResult["userMessages"] as! [NSDictionary]
                self.manageUserChat(arr:userChatArray)
                
                
                //**-- Save Business chat --**
                var businessChatArray = [NSDictionary]()
                businessChatArray = responseResult["businessMessages"] as! [NSDictionary]
                self.manageBusinessChat(arr:businessChatArray)
                
                
            }
            else if response.code == 404 {
                CommonFunctions.sharedInstance.showSessionExpireAlert()
            }
            else {
                CustomAlertController.sharedInstance.showErrorAlert(error: response.error!)
            }
        })
    }
    
    func hitGetCategoriesApi()
    {
        worker = HomeWorker()
        worker?.getCategoriesList(apiResponse: { (response) in
            if response.code == 200 {
                self.presenter?.presentCategoriesResponse(response: response)
            }
            else if response.code == 404 {
                CommonFunctions.sharedInstance.showSessionExpireAlert()
            }
            else {
                CustomAlertController.sharedInstance.showErrorAlert(error: response.error!)
            }
            
        })
        
    }
    
    func hitListFavouriteApi(offset:Int) {
        worker = HomeWorker()
        worker?.getListFavorite(offset:offset, apiResponse: { (response) in
            if response.code == 200 {
                self.presenter?.presentFavouriteResponse(response: response)
            }
            else if response.code == 404 {
                CommonFunctions.sharedInstance.showSessionExpireAlert()
            }
            else {
                CustomAlertController.sharedInstance.showErrorAlert(error: response.error!)
            }
            
        })
        
    }
    
    func hitCashoutConfirmationByUserApi(isAccepted:Bool, isRejected:Bool, bookingId:String, notificationId:String) {
        worker = HomeWorker()
        
        let param = [
            "isAccept":isAccepted,
            "isReject":isRejected
        ]
        
        
        worker?.cashoutConfirmationByUserApi(parameters: param, bookingId: bookingId, notifyId: notificationId, apiResponse: { (response) in
            if response.code == 200 {
                printToConsole(item: response)
            }
            else if response.code == 404 {
                CommonFunctions.sharedInstance.showSessionExpireAlert()
            }
            else {
                CustomAlertController.sharedInstance.showErrorAlert(error: response.error!)
            }
        })
    }
    
    
    func hitArrivalConfirmationUserApi(confirmationText: String, bookingId: String) {
        worker = HomeWorker()
        
        let param = [
            "arrivalStatus":confirmationText
        ]
        
        
        worker?.arrivalConfirmationByUserApi(parameters: param, bookingId: bookingId, apiResponse: { (response) in
            if response.code == 200 {
                printToConsole(item: response)
            }
            else if response.code == 404 {
                CommonFunctions.sharedInstance.showSessionExpireAlert()
            }
            else {
                CustomAlertController.sharedInstance.showErrorAlert(error: response.error!)
            }
        })
    }
    
    func getCountUnreadNotification(){
        worker = HomeWorker()
        worker?.getCountUnreadNotification(apiResponse: { (response) in
            if response.code == 200 {
                printToConsole(item: response)
                let data = response.result as! NSDictionary
                let unreadNotifyCount = data["unreadNotifications"] as? NSNumber ?? 0
                userDefault.set(unreadNotifyCount, forKey: userDefualtKeys.unreadNotifications.rawValue)
            }
            else if response.code == 404 {
                CommonFunctions.sharedInstance.showSessionExpireAlert()
                userDefault.set(0, forKey: userDefualtKeys.unreadNotifications.rawValue)
            }
            else {
                if isUserLoggedIn() {
                    CustomAlertController.sharedInstance.showErrorAlert(error: response.error!)
                }
                userDefault.set(0, forKey: userDefualtKeys.unreadNotifications.rawValue)
            }
        })
    }
    
    func getAllChatApi(){
        
        var fetchMsgArr : [MessageEntity]
        fetchMsgArr = CoreDataWrapper.sharedInstance.fetchMessages()
        
        var fetchBusinessMsgArr : [BusinessChatEntity]
        fetchBusinessMsgArr = CoreDataWrapper.sharedInstance.fetchBusinessMessages()
        
        if (fetchMsgArr.count == 0 && fetchBusinessMsgArr.count == 0) {
            self.callChatApi()
        }
    }
    
    func  manageUserChat(arr:[NSDictionary])  {
        
        for allChatdict in arr {
            
            let receiverIdDict = allChatdict["receiverId"] as! NSDictionary
            let senderIdDict = allChatdict["senderId"] as! NSDictionary
            
            let FromStr = allChatdict["from"] as! String
            let MessageStr = allChatdict["message"] as! String
            let MessageIDStr = allChatdict["messageId"] as! String
            let MessageTimestampStr = allChatdict["messageTimestamp"] as! NSNumber
            let ReceiverIDStr = receiverIdDict["_id"] as! String
            let ReceiverNameStr = receiverIdDict["name"] as! String
            let ReceiverProfileImageStr = receiverIdDict["profileImage"] as! String
            let SenderIDStr = senderIdDict["_id"] as! String
            let SenderNameStr = senderIdDict["name"] as! String
            let SenderProfileImageStr = senderIdDict["profileImage"] as! String
            
            _ = CoreDataWrapper.sharedInstance.saveUserChat(From:FromStr,Message:MessageStr,MessageID:MessageIDStr,MessageTimestamp:MessageTimestampStr,ReceiverID:ReceiverIDStr,ReceiverName:ReceiverNameStr,ReceiverProfileImage:ReceiverProfileImageStr,SenderID:SenderIDStr,SenderName:SenderNameStr,SenderProfileImage:SenderProfileImageStr,EntityName:"MessageEntity",isRead:true)
        }
    }
    
   
    
    func  manageBusinessChat(arr:[NSDictionary])  {
        
        printToConsole(item: arr)
        
        for allChatdict in arr {
            
            let receiverIdDict = allChatdict["receiverId"] as! NSDictionary
            let senderIdDict = allChatdict["senderId"] as! NSDictionary
            
            let FromStr = allChatdict["from"] as! String
            let MessageStr = allChatdict["message"] as! String
            let MessageIDStr = allChatdict["messageId"] as! String
            let MessageTimestampStr = allChatdict["messageTimestamp"] as! NSNumber
            let ReceiverIDStr = receiverIdDict["_id"] as! String
            let ReceiverNameStr = receiverIdDict["name"] as! String
            let ReceiverProfileImageStr = receiverIdDict["profileImage"] as! String
            let SenderIDStr = senderIdDict["_id"] as? String ?? ""
            let SenderNameStr = senderIdDict["name"] as! String
            let SenderProfileImageStr = senderIdDict["profileImage"] as! String
            
            _ = CoreDataWrapper.sharedInstance.saveUserChat(From:FromStr,Message:MessageStr,MessageID:MessageIDStr,MessageTimestamp:MessageTimestampStr,ReceiverID:ReceiverIDStr,ReceiverName:ReceiverNameStr,ReceiverProfileImage:ReceiverProfileImageStr,SenderID:SenderIDStr,SenderName:SenderNameStr,SenderProfileImage:SenderProfileImageStr,EntityName:"BusinessChatEntity", isRead: true)
        }
    }
    
    
}
