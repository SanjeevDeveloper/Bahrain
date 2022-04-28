
import UIKit

class NotifyWorker
{
    func getListAllNotification(offset:Int, apiResponse:@escaping(responseHandler)) {
        let url = ApiEndPoints.userModule.listAllNotification + "/" + getUserData(._id) + "/user" + "/300" + "/\(offset)"
        NetworkingWrapper.sharedInstance.connect(urlEndPoint: url, httpMethod: .get, headers: ApiHeaders.sharedInstance.headerWithAuth()) { (response) in
            apiResponse(response)
        }
    }
    
    func readNotificationsApi(notifyid:String, apiResponse:@escaping(responseHandler)) {
        let url = ApiEndPoints.userModule.readNotifications + "/" + notifyid
        NetworkingWrapper.sharedInstance.connect(urlEndPoint: url, httpMethod: .put, headers: ApiHeaders.sharedInstance.headerWithAuth()) { (response) in
            apiResponse(response)
        }
    }
    
    func clearNotificationsApi(apiResponse:@escaping(responseHandler)) {
        let url = ApiEndPoints.userModule.clearNotifications + "/" + getUserData(._id)  + "/user"
        NetworkingWrapper.sharedInstance.connect(urlEndPoint: url, httpMethod: .delete, headers: ApiHeaders.sharedInstance.headerWithAuth()) { (response) in
            apiResponse(response)
        }
    }
    
    func cashoutConfirmationByUserApi(parameters:[String:Any],bookingId:String,notifyId:String, apiResponse:@escaping(responseHandler)) {
        let url = ApiEndPoints.userModule.cashoutConfirmationByUser + "/" + bookingId + "/" + notifyId
        NetworkingWrapper.sharedInstance.connect(urlEndPoint: url, httpMethod: .put, headers: ApiHeaders.sharedInstance.headerWithAuth(), parameters: parameters) { (response) in
            apiResponse(response)
        }
    }
    
    func arrivalConfirmationByUserApi(parameters:[String:Any],bookingId:String, apiResponse:@escaping(responseHandler)) {
        let url = ApiEndPoints.userModule.updateArrivalStatus + "/" + bookingId
        NetworkingWrapper.sharedInstance.connect(urlEndPoint: url, httpMethod: .put, headers: ApiHeaders.sharedInstance.headerWithAuth(), parameters: parameters) { (response) in
            apiResponse(response)
        }
    }
    
}

