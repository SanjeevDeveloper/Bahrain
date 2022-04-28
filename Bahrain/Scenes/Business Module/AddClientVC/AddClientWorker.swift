
import UIKit

class AddClientWorker {
    
    func hitCreateClientApi(image:UIImage?, imageName:String?, parameters:[String:Any], apiResponse:@escaping(responseHandler)) {
        
        if let unwrappedImage = image {
            NetworkingWrapper.sharedInstance.connectWithMultiPart(urlEndPoint: ApiEndPoints.Business.addBusinessClient, httpMethod: .post, parameters: parameters, headers: ApiHeaders.sharedInstance.headerWithAuthAndUserId(), images: [unwrappedImage], imageName: imageName!) { (response) in
                apiResponse(response)
            }
        }
        else {
            NetworkingWrapper.sharedInstance.connectWithMultiPart(urlEndPoint:ApiEndPoints.Business.addBusinessClient, httpMethod:.post, headers:ApiHeaders.sharedInstance.headerWithAuthAndUserId(), parameters:parameters) { (response) in
                apiResponse(response)
            }
        }
        
    }
    
    func hitEditBusinessClientInfoApi(clientId:String, image:UIImage?, imageName:String?, parameters:[String:Any], apiResponse:@escaping(responseHandler)) {
        
        printToConsole(item: clientId)
        
        let url = ApiEndPoints.Business.editBusinessClientInfo + "/" + clientId
        
        if let unwrappedImage = image {
            NetworkingWrapper.sharedInstance.connectWithMultiPart(urlEndPoint: url, httpMethod: .put, parameters: parameters, headers: ApiHeaders.sharedInstance.headerWithAuthAndUserId(), images: [unwrappedImage], imageName: imageName!) { (response) in
                apiResponse(response)
            }
        }
        else {
            NetworkingWrapper.sharedInstance.connectWithMultiPart(urlEndPoint: url, httpMethod:.put, headers:ApiHeaders.sharedInstance.headerWithAuthAndUserId(), parameters:parameters) { (response) in
                apiResponse(response)
            }
        }
        
    }
    
    func deleteBusinessClientApi(clientId:String, apiResponse:@escaping(responseHandler)) {
        let url = ApiEndPoints.Business.deleteBusinessClient + "/" + clientId + "/" + getUserData(.businessId)
        
        NetworkingWrapper.sharedInstance.connect(urlEndPoint: url, httpMethod: .put, headers: ApiHeaders.sharedInstance.headerWithAuth()) { (response) in
            apiResponse(response)
        }
    }
    
}
