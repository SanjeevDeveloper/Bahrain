
import UIKit

class rateReviewWorker
{
    func getUserListReviews(salonId:String?, offset:Int, apiResponse:@escaping(responseHandler)) {
        
        if salonId != nil {
            let url = ApiEndPoints.userModule.userListAllReviews + "/" + salonId! + "/10" + "/\(offset)"
            
            NetworkingWrapper.sharedInstance.connect(urlEndPoint: url, httpMethod: .get, headers: ApiHeaders.sharedInstance.headerWithAuth()) { (response) in
                apiResponse(response)
        }
        
            
        }
    }
}
