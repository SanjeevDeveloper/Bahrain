
import UIKit

class CancelAppointmentWorker
{
    func getBookingCancelReasonsApi(apiResponse:@escaping(responseHandler)) {
        let url = ApiEndPoints.userModule.getBookingCancelReasons + "/user"
        NetworkingWrapper.sharedInstance.connect(urlEndPoint: url, httpMethod: .get, headers: ApiHeaders.sharedInstance.headerWithAuth()) { (response) in
            apiResponse(response)
        }
    }
    
    func cancelAppoinmentApi(id:String, parameters:[String:String], apiResponse:@escaping(responseHandler)) {
        let url = ApiEndPoints.userModule.cancelAppoinment + "/" + id + "/user"
        
        NetworkingWrapper.sharedInstance.connect(urlEndPoint: url, httpMethod: .put, headers: ApiHeaders.sharedInstance.headerWithAuth(), parameters: parameters) { (response) in
            apiResponse(response)
        }
    }
    
}
