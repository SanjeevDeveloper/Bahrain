
import UIKit

class FilterWorker
{
    func getServicesList(apiResponse:@escaping(responseHandler)) {
        
        let currentLanguageIdentifier = "/" + (userDefault.value(forKey: userDefualtKeys.currentLanguage.rawValue) as! String)
        
        let url = ApiEndPoints.Business.getServicesList + currentLanguageIdentifier
        
        NetworkingWrapper.sharedInstance.connect(urlEndPoint: url, httpMethod: .get, headers:ApiHeaders.sharedInstance.headerWithAuth()) { (response) in
            apiResponse(response)
        }
    }
}
