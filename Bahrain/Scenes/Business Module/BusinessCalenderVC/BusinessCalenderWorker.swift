

import UIKit

class BusinessCalenderWorker
{
    func getListBusinessAppointments(offset:Int, timeStamp:Int64, apiResponse:@escaping(responseHandler)) {
        
        var url = ApiEndPoints.Business.listBusinessAppointments + "/" + getUserData(.businessId)
        
        url.append("/100" + "/0" + "/" + timeStamp.description)
        
        NetworkingWrapper.sharedInstance.connect(urlEndPoint: url, httpMethod: .get, headers: ApiHeaders.sharedInstance.headerWithAuth()) { (response) in
            apiResponse(response)
            
        }
        
    }
    
    
    // MARK:- CHANGED TO CANCEL APPOINTMENT
    func deleteAppoinmentApi(id:String, apiResponse:@escaping(responseHandler)) {
        let url = ApiEndPoints.userModule.cancelAppoinment + "/" + id + "/business"
        
        NetworkingWrapper.sharedInstance.connect(urlEndPoint: url, httpMethod: .put, headers: ApiHeaders.sharedInstance.headerWithAuth()) { (response) in
            apiResponse(response)
        }
    }
    
}
