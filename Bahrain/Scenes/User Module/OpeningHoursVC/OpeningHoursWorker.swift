
import UIKit

class OpeningHoursWorker
{
    func getListBusinessWorkingHours(saloonBusinessId:String, apiResponse:@escaping(responseHandler)) {
        
        let url = ApiEndPoints.userModule.listBusinessWorkingHours + "/" + saloonBusinessId
        
        NetworkingWrapper.sharedInstance.connect(urlEndPoint: url, httpMethod: .get, headers: ApiHeaders.sharedInstance.headerWithAuth()) { (response) in
            apiResponse(response)
        }
    }
    
    
    func getBusinessById(saloonId:String, apiResponse:@escaping(responseHandler)) {
        
        let url = ApiEndPoints.userModule.getBusinessById + "/" + saloonId + "/" + getUserData(._id)
        NetworkingWrapper.sharedInstance.connect(urlEndPoint: url, httpMethod: .get, headers: ApiHeaders.sharedInstance.headerWithLang()) { (response) in
            apiResponse(response)
            
        }
    }
}
