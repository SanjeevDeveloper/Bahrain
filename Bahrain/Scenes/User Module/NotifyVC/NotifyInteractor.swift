
import UIKit

protocol NotifyBusinessLogic
{
  func hitListAllNotificationApi(offset:Int)
  func hitReadNotificationApi(notifyId:String)
  func hitClearNotificationApi()
  func hitCashoutConfirmationByUserApi(isAccepted:Bool, isRejected:Bool, bookingId:String, notificationId:String)
  func hitArrivalConfirmationUserApi(confirmationText: String, bookingId:String)
}

protocol NotifyDataStore
{
  //var name: String { get set }
}

class NotifyInteractor: NotifyBusinessLogic, NotifyDataStore
{
   
  var presenter: NotifyPresentationLogic?
  var worker: NotifyWorker?
  //var name: String = ""
  
  // MARK: Do something
    func hitListAllNotificationApi(offset:Int)
    {
        worker = NotifyWorker()
        worker?.getListAllNotification(offset: offset, apiResponse: { (response) in
            if response.code == 200 {
                self.presenter?.presentResponse(response: response)
            }
            else if response.code == 404 {
                CommonFunctions.sharedInstance.showSessionExpireAlert()
            }
            else {
                CustomAlertController.sharedInstance.showErrorAlert(error: response.error!)
            }
        })
    }
    
    func hitReadNotificationApi(notifyId: String) {
        worker?.readNotificationsApi(notifyid: notifyId, apiResponse: { (response) in
            if response.code == 200 {
                 self.presenter?.presentReadResponse()
            }
            else if response.code == 404 {
                CommonFunctions.sharedInstance.showSessionExpireAlert()
            }
            else {
                CustomAlertController.sharedInstance.showErrorAlert(error: response.error!)
            }
        })
    }
    
    func hitClearNotificationApi() {
        worker?.clearNotificationsApi(apiResponse: { (response) in
            
            printToConsole(item: response)
            if response.code == 200 {
               self.presenter?.presentClearResponse()
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
}
