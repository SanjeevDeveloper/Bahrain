
import UIKit

class TherapistWorkingHoursWorker
{
    func getListBusinessWorkingHours(apiResponse:@escaping(responseHandler)) {
        
        let url = ApiEndPoints.userModule.listBusinessWorkingHours + "/" + getUserData(.businessId)
        
        NetworkingWrapper.sharedInstance.connect(urlEndPoint: url, httpMethod: .get, headers: ApiHeaders.sharedInstance.headerWithAuth()) { (response) in
            apiResponse(response)
            
        }
    }
}
