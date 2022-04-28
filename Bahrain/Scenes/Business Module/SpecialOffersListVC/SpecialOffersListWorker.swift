
import UIKit

class SpecialOffersListWorker
{
    func getListBusinessOffers(offset:Int, apiResponse:@escaping(responseHandler)) {
        
        let url = ApiEndPoints.Business.listBusinessOffers + "/" + getUserData(.businessId) + "/10" + "/\(offset)"
        NetworkingWrapper.sharedInstance.connect(urlEndPoint: url, httpMethod: .get, headers: ApiHeaders.sharedInstance.headerWithAuth()) { (response) in
            apiResponse(response)
            
        }
    }
    
    func deleteOfferApi(id:String, apiResponse:@escaping(responseHandler)) {
        let url = ApiEndPoints.Business.deleteOffer + "/" + id
        
        NetworkingWrapper.sharedInstance.connect(urlEndPoint: url, httpMethod: .delete, headers: ApiHeaders.sharedInstance.headerWithAuth()) { (response) in
            apiResponse(response)
        }
    }
    
}
