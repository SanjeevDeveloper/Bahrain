
import UIKit

class ListServiceWorker
{
    func getListServicesByBusinessId(offset:Int, apiResponse:@escaping(responseHandler)) {
        
        let url = ApiEndPoints.Business.listServicesByBusinessId + "/" + getUserData(.businessId) + "/business" + "/200" + "/\(offset)"
        NetworkingWrapper.sharedInstance.connect(urlEndPoint: url, httpMethod: .get, headers: ApiHeaders.sharedInstance.headerWithAuth()) { (response) in
            apiResponse(response)
            
        }
    }
    
    
    func deleteBusinessServiceApi(id:String, apiResponse:@escaping(responseHandler)) {
        
        let url = ApiEndPoints.Business.deleteBusinessService + "/" + id
        
        NetworkingWrapper.sharedInstance.connect(urlEndPoint: url, httpMethod: .put, headers: ApiHeaders.sharedInstance.headerWithAuth()) { (response) in
            apiResponse(response)
        }
        
    }
    
    
}
