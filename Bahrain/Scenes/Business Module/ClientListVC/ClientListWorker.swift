
import UIKit

class ClientListWorker
{
    func getListBusinessClient(offset:Int, filterText:String, apiResponse:@escaping(responseHandler)) {
        
        var url = ApiEndPoints.Business.listBusinessClient + "/" + getUserData(.businessId) + "/10" + "/\(offset)"
        
        if !(filterText.isEmptyString()) {
            url.append("/\(filterText)")
        }
        
        NetworkingWrapper.sharedInstance.connect(urlEndPoint: url, httpMethod: .get, headers: ApiHeaders.sharedInstance.headerWithAuth()) { (response) in
            apiResponse(response)
            
        }
    }
    
}
