
import UIKit

class RegisterLocationWorker {
    
    func hitRegistrationApi(parameters:[String:Any], apiResponse:@escaping(responseHandler)) {
        NetworkingWrapper.sharedInstance.connect(urlEndPoint: ApiEndPoints.Onboarding.signup, httpMethod: .post, parameters: parameters) { (response) in
            apiResponse(response)
        }
    }
    
    func hitUpdateProfileImageApi(image:UIImage, apiResponse:@escaping(responseHandler)) {
        let url = ApiEndPoints.userModule.updateProfileImage + "/" + getUserData(._id)
        NetworkingWrapper.sharedInstance.connectWithMultiPart(urlEndPoint: url, httpMethod: .put, headers: ApiHeaders.sharedInstance.headerWithAuth(), images: [image], imageName: "profileImage") { (response) in
            apiResponse(response)
        }
    }
}
