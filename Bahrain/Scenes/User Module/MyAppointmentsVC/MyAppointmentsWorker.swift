
import UIKit

class MyAppointmentsWorker
{
    func getListUserUpcomingAppointments(offset:Int,  apiResponse:@escaping(responseHandler)) {
        
        let userId = getUserData(._id)
        
        let url = ApiEndPoints.userModule.listUserAppointments + "/" + userId + "/10" + "/\(offset)" + "/upcoming"
        
        NetworkingWrapper.sharedInstance.connect(urlEndPoint: url, httpMethod: .get, headers: ApiHeaders.sharedInstance.headerWithAuth()) { (response) in
            apiResponse(response)
            
        }
    }
    
    func getListUserPastAppointments(offset:Int,  apiResponse:@escaping(responseHandler)) {
        
        let userId = getUserData(._id)
        
        let url = ApiEndPoints.userModule.listUserAppointments + "/" + userId + "/10" + "/\(offset)" + "/past"
        
        NetworkingWrapper.sharedInstance.connect(urlEndPoint: url, httpMethod: .get, headers: ApiHeaders.sharedInstance.headerWithAuth()) { (response) in
            apiResponse(response)
            
        }
    }
    
    func cancelAppoinmentApi(id:String, apiResponse:@escaping(responseHandler)) {
        let url = ApiEndPoints.userModule.cancelAppoinment + "/" + id + "/user"
        
        NetworkingWrapper.sharedInstance.connect(urlEndPoint: url, httpMethod: .put, headers: ApiHeaders.sharedInstance.headerWithAuth()) { (response) in
            apiResponse(response)
        }
    }
}
