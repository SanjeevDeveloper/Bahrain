

import UIKit

class BookingSettingWorker
{
    func getBusinessById(apiResponse:@escaping(responseHandler)) {
        
        let url = ApiEndPoints.userModule.getBusinessById + "/" + getUserData(.businessId) + "/" + getUserData(._id)
        NetworkingWrapper.sharedInstance.connect(urlEndPoint: url, httpMethod: .get, headers: ApiHeaders.sharedInstance.headerWithLang()) { (response) in
            apiResponse(response)
            
        }
    }
    
    func hitUpdateBusinessApi(parameters:[String:Any], apiResponse:@escaping(responseHandler)) {
        
        let url = ApiEndPoints.Business.updateBusiness + "/" + getUserData(.businessId)
        NetworkingWrapper.sharedInstance.connectWithMultiPart(urlEndPoint: url, httpMethod: .put, headers: ApiHeaders.sharedInstance.headerWithAuthAndUserId(), parameters: parameters) { (response) in
            apiResponse(response)
        }
    }
    
}
