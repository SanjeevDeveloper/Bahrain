
import UIKit

class BusinessTodayWorker
{
    func getListBusinessAppointments(offset:Int, fromDate: String, toDate: String, apiResponse:@escaping(responseHandler)) {
        
        var url = ApiEndPoints.Business.listBusinessAppointments + "/" + getUserData(.businessId)
        
        url.append("/10" + "/\(offset)" + "/" + fromDate + "/" + toDate)
            
            NetworkingWrapper.sharedInstance.connect(urlEndPoint: url, httpMethod: .get, headers: ApiHeaders.sharedInstance.headerWithAuth()) { (response) in
                apiResponse(response)
                
        }
        
    }
    
    
    
}
