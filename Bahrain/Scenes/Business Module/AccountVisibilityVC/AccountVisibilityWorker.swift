

import UIKit

class AccountVisibilityWorker
{
    func getBusinessById(apiResponse:@escaping(responseHandler)) {
        
        let url = ApiEndPoints.Business.getBusinessById + "/" + getUserData(.businessId) + "/" + getUserData(._id)
        
        NetworkingWrapper.sharedInstance.connect(urlEndPoint: url, httpMethod: .get, headers: ApiHeaders.sharedInstance.headerWithAuthAndUserId()) { (response) in
            apiResponse(response)
            
        }
    }
    
    func hitUpdateBusinessApi(parameters:[String:Any], apiResponse:@escaping(responseHandler)) {
        
        let url = ApiEndPoints.Business.updateBusiness + "/" + getUserData(.businessId)
        
        NetworkingWrapper.sharedInstance.connect(urlEndPoint: url, httpMethod: .put, headers: ApiHeaders.sharedInstance.headerWithAuthAndUserId(), parameters: parameters) { (response) in
            apiResponse(response)
        }
    }
    
    func hitDeleteBusinessAccountApi(apiResponse:@escaping(responseHandler)) {
        let url = ApiEndPoints.Business.deleteBusinessAccount + "/" + getUserData(.businessId)
        
        NetworkingWrapper.sharedInstance.connect(urlEndPoint: url, httpMethod: .put, headers: ApiHeaders.sharedInstance.headerWithAuth()) { (response) in
            apiResponse(response)
        }
    }
}
