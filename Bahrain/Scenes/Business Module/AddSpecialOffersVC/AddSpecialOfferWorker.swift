
import UIKit

class AddSpecialOfferWorker
{
    func getBusinessById(saloonId:String, apiResponse:@escaping(responseHandler)) {
        let url = ApiEndPoints.userModule.getBusinessById + "/" + saloonId + "/" + getUserData(._id)
        NetworkingWrapper.sharedInstance.connect(urlEndPoint: url, httpMethod: .get, headers: ApiHeaders.sharedInstance.headerWithLang()) { (response) in
            apiResponse(response)
            
        }
    }
}
