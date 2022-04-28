

import UIKit

class ViewProfileWorker
{
    func getBusinessById(apiResponse:@escaping(responseHandler)) {
        let url = ApiEndPoints.userModule.getBusinessById + "/" + getUserData(.businessId) + "/" + getUserData(._id)
        NetworkingWrapper.sharedInstance.connect(urlEndPoint: url, httpMethod: .get, headers: ApiHeaders.sharedInstance.headerWithLang()) { (response) in
            apiResponse(response)
        }
    }
}
