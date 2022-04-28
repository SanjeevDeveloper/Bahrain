
import UIKit

class ListScheduledBreakWorker
{
    func getListScheduleBreaks(offset:Int, therapistID:String,  apiResponse:@escaping(responseHandler)) {
        
        let url = ApiEndPoints.Business.listScheduleBreaks + "/" + therapistID
        NetworkingWrapper.sharedInstance.connect(urlEndPoint: url, httpMethod: .get, headers: ApiHeaders.sharedInstance.headerWithAuth()) { (response) in
            apiResponse(response)
            
        }
    }
    
    func hitEditTherapistApi(id:String, parameters:[String:Any], apiResponse:@escaping(responseHandler)) {
        
        let url = ApiEndPoints.Business.editTherapistInfo + "/" + id
        
        NetworkingWrapper.sharedInstance.connect(urlEndPoint: url, httpMethod: .put, headers: ApiHeaders.sharedInstance.headerWithAuth(), parameters: parameters) { (response) in
            apiResponse(response)
        }
    }
}
