
import UIKit

class ClientReviewsWorker
{
    func getListReviewsByBusinessId(offset:Int, apiResponse:@escaping(responseHandler)) {
        
        let url = ApiEndPoints.Business.listReviewsByBusinessId + "/" + getUserData(.businessId) + "/10" + "/\(offset)"
        
        NetworkingWrapper.sharedInstance.connect(urlEndPoint: url, httpMethod: .get, headers: ApiHeaders.sharedInstance.headerWithAuth()) { (response) in
            apiResponse(response)
            
        }
    }
}
