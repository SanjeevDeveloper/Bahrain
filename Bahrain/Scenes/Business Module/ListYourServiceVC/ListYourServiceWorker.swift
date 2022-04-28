
import UIKit

class ListYourServiceWorker
{
    func getServicesList(apiResponse:@escaping(responseHandler)) {
        NetworkingWrapper.sharedInstance.connect(urlEndPoint: ApiEndPoints.Business.getServicesList, httpMethod: .get, headers:ApiHeaders.sharedInstance.headerWithAuth()) { (response) in
            apiResponse(response)
        }
    }
    
    func registerBusiness(parameters:[String:Any], apiResponse:@escaping(responseHandler)) {
        NetworkingWrapper.sharedInstance.connect(urlEndPoint: ApiEndPoints.Business.registerBusiness, httpMethod: .post, headers: ApiHeaders.sharedInstance.headerWithAuth(), parameters: parameters) { (response) in
            apiResponse(response)
        }
    }
    
    func getBusinessSelectedServices(apiResponse:@escaping(responseHandler)) {
        
         let url = ApiEndPoints.Business.getBusinessSelectedServices + "/" + getUserData(.businessId)
        
        NetworkingWrapper.sharedInstance.connect(urlEndPoint: url, httpMethod: .get, headers:ApiHeaders.sharedInstance.headerWithAuth()) { (response) in
            apiResponse(response)
        }
    }
    
    func hitUpdateBusinessApi(parameters:[String:Any], apiResponse:@escaping(responseHandler)) {
        
        let url = ApiEndPoints.Business.updateBusiness + "/" + getUserData(.businessId)
        
        NetworkingWrapper.sharedInstance.connect(urlEndPoint: url, httpMethod: .put, headers: ApiHeaders.sharedInstance.headerWithAuth(), parameters: parameters) { (response) in
            apiResponse(response)
        }
        
    }
}
