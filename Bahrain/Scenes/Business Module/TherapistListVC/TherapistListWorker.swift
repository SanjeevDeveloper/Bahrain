
import UIKit

class TherapistListWorker
{
    func getListTherapistByBusinessId(offset:Int, apiResponse:@escaping(responseHandler)) {
        
        let url = ApiEndPoints.Business.listTherapistByBusinessId + "/" + getUserData(.businessId) + "/business" + "/300" + "/\(0)"
        NetworkingWrapper.sharedInstance.connect(urlEndPoint: url, httpMethod: .get, headers: ApiHeaders.sharedInstance.headerWithAuth()) { (response) in
            apiResponse(response)
            
        }
    }
    
    func getcheckTherapistAssigned(apiResponse:@escaping(responseHandler)) {
        
        let url = ApiEndPoints.Business.checkTherapistAssigned + "/" + getUserData(.businessId)
        NetworkingWrapper.sharedInstance.connect(urlEndPoint: url, httpMethod: .get, headers: ApiHeaders.sharedInstance.headerWithAuth()) { (response) in
            apiResponse(response)
            
        }
    }
}
