
import UIKit

protocol NotifyRoutingLogic
{
    func routeToControllers(data:String, type:String, isRead:Bool, isRated: Bool, notificationId: String)
}

protocol NotifyDataPassing
{
    var dataStore: NotifyDataStore? { get }
}

class NotifyRouter: NSObject, NotifyRoutingLogic, NotifyDataPassing
{
    
    weak var viewController: NotifyViewController?
    var dataStore: NotifyDataStore?
    
    // MARK: Routing
    
    func routeToControllers(data:String, type:String, isRead:Bool, isRated: Bool, notificationId: String) {
        
        let msgbodyDict =  CommonFunctions.sharedInstance.convertJsonStringToDictionary(text: data)
        
        printToConsole(item: msgbodyDict)
        
        if type == notificationTypes.message.rawValue {
            let storyboard = AppStoryboard.Chat.instance
            let destinationVC = storyboard.instantiateViewController(withIdentifier: ViewControllersIds.ChatViewControllerID) as! ChatViewController
            var destinationDS = destinationVC.router!.dataStore!
            passDataToChatVC(buisnessId: msgbodyDict?["senderId"] as! String, salonName: msgbodyDict?["senderName"] as! String, salonImage: msgbodyDict?["profileImage"] as! String, destinationDS: &destinationDS)
            navigateToChatVC(source: viewController!, destination: destinationVC)
        }
        
        else if type == "bookingCompleted" {
            if let appointmentId =  msgbodyDict?["bookingId"] as? String {
                let storyboard = AppStoryboard.Main.instance
                let destinationVC = storyboard.instantiateViewController(withIdentifier: ViewControllersIds.OrderDetailViewControllerID) as! OrderDetailViewController
                var destinationDS = destinationVC.router!.dataStore!
                passDataToMyAppointmentDetailVC(appoinmentId: appointmentId, destinationDS: &destinationDS)
                navigateToMyAppointmentVC(source: viewController!, destination: destinationVC)
            }
        }
            
        else if type == notificationTypes.booking.rawValue {
            
            let bookingDataDict =  msgbodyDict?["bookingData"] as! NSDictionary
            let appointmentId = bookingDataDict["_id"] as? String ?? ""
          
            let storyboard = AppStoryboard.Main.instance
            let destinationVC = storyboard.instantiateViewController(withIdentifier: ViewControllersIds.OrderDetailViewControllerID) as! OrderDetailViewController
            var destinationDS = destinationVC.router!.dataStore!
            passDataToMyAppointmentDetailVC(appoinmentId: appointmentId, destinationDS: &destinationDS)
            navigateToMyAppointmentVC(source: viewController!, destination: destinationVC)
        }
        else if type == notificationTypes.rateUs.rawValue {
            let storyboard = AppStoryboard.Main.instance
            let destinationVC = storyboard.instantiateViewController(withIdentifier: ViewControllersIds.rateReviewViewControllerID) as! rateReviewViewController
            var destinationDS = destinationVC.router!.dataStore!
            
            var  dataArray = [RateServices.ViewModel.tableCellData]()
            
           
            let bookingDict = msgbodyDict?["bookingDetails"] as? NSDictionary
            
            let serviceArray = bookingDict?["bookingServices"] as! NSArray
            
            for item in serviceArray {
                
                let dataDict = item as! NSDictionary
                
               let obj = RateServices.ViewModel.tableCellData(serviceName: dataDict["serviceName"] as! String, therapistId: dataDict["therapistId"] as! String, therapistName: dataDict["therapistName"] as! String)
                
                dataArray.append(obj)
                
            }
            
    
            print(dataArray)
            
            passDataToRateReviewVC(notificationId: notificationId, isRated: isRated, salonId:  msgbodyDict?["businessId"] as? String, isRead: isRead, dataArray: dataArray, destinationDS: &destinationDS)
            navigateToRateReviewVC(source: viewController!, destination: destinationVC)
        }
        
         else if type == notificationTypes.wallet.rawValue {
            let storyboard = AppStoryboard.Main.instance
            let destinationVC = storyboard.instantiateViewController(withIdentifier: ViewControllersIds.WalletViewControllerID) as! WalletViewController
          
            navigateToCustomerWallet(source: viewController!, destination: destinationVC)
            
        }
        else if type == notificationTypes.cashout.rawValue {
            
            let bookingId =  msgbodyDict?["bookingId"] as? String ?? ""
            
            let storyboard = AppStoryboard.Main.instance
            let destinationVC = storyboard.instantiateViewController(withIdentifier: ViewControllersIds.OrderDetailViewControllerID) as! OrderDetailViewController
            var destinationDS = destinationVC.router!.dataStore!
            passDataToOrderDetailVC(appoinmentId: bookingId, destinationDS: &destinationDS)
            navigateToMyAppointmentVC(source: viewController!, destination: destinationVC)
            
        }
        
    }
    
    // MARK: Navigation
    func navigateToChatVC(source: NotifyViewController, destination: ChatViewController)
    {
        viewController?.navigationController?.pushViewController(destination, animated: true)
    }
    
    func navigateToMyAppointmentVC(source: NotifyViewController, destination: OrderDetailViewController)
    {
        viewController?.navigationController?.pushViewController(destination, animated: true)
    }
    func navigateToRateReviewVC(source: NotifyViewController, destination: rateReviewViewController)
    {
        viewController?.navigationController?.pushViewController(destination, animated: true)
    }
    
    func navigateToCustomerWallet(source: NotifyViewController, destination: WalletViewController)
    {
        viewController?.navigationController?.pushViewController(destination, animated: true)
    }
    
    // MARK: Passing data
    func passDataToChatVC(buisnessId: String,salonName:String,salonImage:String, destinationDS: inout ChatDataStore)
    {
        destinationDS.buisnessId = buisnessId
        destinationDS.salonName = salonName
        destinationDS.salonImage = salonImage
        destinationDS.isFromMessage = true
    }
    
//    func passDataToMyAppointmentDetailVC(appoinmentId:String,orderDetailObj: MyAppointments.ViewModel.tableCellData?, cancelBtnBool:Bool, destinationDS: inout OrderDetailDataStore)
//    {
////        destinationDS.orderDetailArray = orderDetailObj
////        destinationDS.tableScreen = cancelBtnBool
//        destinationDS.bookingId = appoinmentId
//    }
  
  func passDataToMyAppointmentDetailVC(appoinmentId:String, destinationDS: inout OrderDetailDataStore)
  {
    //        destinationDS.orderDetailArray = orderDetailObj
    //        destinationDS.tableScreen = cancelBtnBool
    destinationDS.bookingId = appoinmentId
  }
  
    func passDataToOrderDetailVC(appoinmentId:String, destinationDS: inout OrderDetailDataStore)
    {
        destinationDS.bookingId = appoinmentId
    }
    
    func passDataToRateReviewVC(notificationId: String, isRated: Bool, salonId: String?, isRead:Bool, dataArray:[RateServices.ViewModel.tableCellData], destinationDS: inout rateReviewDataStore)
    {
        destinationDS.salonId = salonId
        destinationDS.dataArray = dataArray
        destinationDS.notificationId = notificationId
        destinationDS.isRated = isRated
    }
}

