
import UIKit

class BasicInformationWorker
{
    func updateBusinessImage(image:UIImage, imageName:String, apiResponse:@escaping(responseHandler)) {
        NetworkingWrapper.sharedInstance.connectWithMultiPart(urlEndPoint: ApiEndPoints.Business.updateBusinessProfileImage + "/" + getUserData(.businessId), httpMethod: .put, headers: ApiHeaders.sharedInstance.headerWithAuthAndUserId(), images: [image], imageName: imageName) { (response) in
            apiResponse(response)
        }
    }
    
    func getBusinessById(apiResponse:@escaping(responseHandler)) {
        let url = ApiEndPoints.userModule.getBusinessById + "/" + getUserData(.businessId) + "/" + getUserData(._id)
        NetworkingWrapper.sharedInstance.connect(urlEndPoint: url, httpMethod: .get, headers: ApiHeaders.sharedInstance.headerWithLang()) { (response) in
            apiResponse(response)
        }
    }
    
    func updateBasicInfo(parameters:[String:String],  apiResponse:@escaping(responseHandler)) {
       
        let urlEndpoint = ApiEndPoints.Business.updateBusiness + "/" + getUserData(.businessId)
        NetworkingWrapper.sharedInstance.connect(urlEndPoint: urlEndpoint, httpMethod: .put, headers: ApiHeaders.sharedInstance.headerWithAuthAndUserId(), parameters: parameters) { (response) in
            apiResponse(response)
        }
    }
}
