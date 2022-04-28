
import UIKit

class SpecialOfferUserWorker
{
    func getListAllOffers(offset:Int, apiResponse:@escaping(responseHandler)) {
        
        let url = ApiEndPoints.userModule.listAllOffers + "/500" + "/\(offset)"
        NetworkingWrapper.sharedInstance.connect(urlEndPoint: url, httpMethod: .get, headers: ApiHeaders.sharedInstance.headerWithLang()) { (response) in
            apiResponse(response)
        }
    }
    
    func listAllOffersFilterApi(offset:Int, parameters:[String:Any], apiResponse:@escaping(responseHandler)) {
        
        // let url = ApiEndPoints.userModule.searchSalonFilter + "/10" + "/\(offset)"
        
        let url = ApiEndPoints.userModule.listAllOffersFilter + "/500" + "/0/\(CommonFunctions.sharedInstance.genderValue())"
        
        NetworkingWrapper.sharedInstance.connect(urlEndPoint: url, httpMethod: .post, headers: ApiHeaders.sharedInstance.headerWithAuth(), parameters:  parameters) { (response) in
            apiResponse(response)
        }
    }
}
