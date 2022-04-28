
import UIKit

class PinLocationWorker
{
    func updateBusinessLocation(parameters:[String:Any],  apiResponse:@escaping(responseHandler)) {
        
        let urlEndpoint = ApiEndPoints.Business.updateBusiness + "/" + getUserData(.businessId)
        NetworkingWrapper.sharedInstance.connect(urlEndPoint: urlEndpoint, httpMethod: .put, headers: ApiHeaders.sharedInstance.headerWithAuth(), parameters: parameters) { (response) in
            apiResponse(response)
        }
    }
}
