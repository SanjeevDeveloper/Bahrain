
import UIKit

class SelectAreaUserWorker
{
    func getAreasList(apiResponse:@escaping(responseHandler)) {
        
        let url = ApiEndPoints.userModule.getAreasList
        NetworkingWrapper.sharedInstance.connect(urlEndPoint: url, httpMethod: .get, headers: ApiHeaders.sharedInstance.headerWithLang()) { (response) in
            apiResponse(response)
        }
    }
}
