
import UIKit

class LocationWorker
{
    func updateBusinessLocation(parameters:[String:Any],  apiResponse:@escaping(responseHandler)) {
        
        let urlEndpoint = ApiEndPoints.Business.updateBusiness + "/" + getUserData(.businessId)
        NetworkingWrapper.sharedInstance.connect(urlEndPoint: urlEndpoint, httpMethod: .put, headers: ApiHeaders.sharedInstance.headerWithAuthAndUserId(), parameters: parameters) { (response) in
            apiResponse(response)
        }
    }
    
    func updateLocation(pdf:URL?, image:UIImage?, parameters:[String:Any],  apiResponse:@escaping(responseHandler)) {
        
        let urlEndpoint = ApiEndPoints.Business.updateBusiness + "/" + getUserData(.businessId)
        
        if pdf == nil && image == nil {
            NetworkingWrapper.sharedInstance.connect(urlEndPoint: urlEndpoint, httpMethod: .put, headers: ApiHeaders.sharedInstance.headerWithAuthAndUserId(), parameters: parameters) { (response) in
                apiResponse(response)
            }
        }
        else {
            NetworkingWrapper.sharedInstance.connectWithMultiPartDocument(urlEndPoint: urlEndpoint, httpMethod: .put, parameters: parameters, headers: ApiHeaders.sharedInstance.headerWithAuthAndUserId(), pdfData: pdf ?? nil, images: [image ?? nil], imageName: "crNumber") { (response) in
                apiResponse(response)
            }
        }
    }
    
    func getBusinessById(apiResponse:@escaping(responseHandler)) {
        let url = ApiEndPoints.userModule.getBusinessById + "/" + getUserData(.businessId) + "/" + getUserData(._id)
        NetworkingWrapper.sharedInstance.connect(urlEndPoint: url, httpMethod: .get, headers: ApiHeaders.sharedInstance.headerWithLang()) { (response) in
            apiResponse(response)
        }
    }
}
