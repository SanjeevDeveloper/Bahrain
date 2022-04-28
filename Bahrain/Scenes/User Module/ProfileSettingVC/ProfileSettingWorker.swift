
import UIKit

class ProfileSettingWorker
{
    func hitEditUserProfileApi(parameters:[String:Any], apiResponse:@escaping(responseHandler)) {
        
        let url = ApiEndPoints.userModule.editUserProfile + "/" + getUserData(._id)
        
        NetworkingWrapper.sharedInstance.connect(urlEndPoint: url, httpMethod: .put, headers: ApiHeaders.sharedInstance.headerWithAuth(), parameters: parameters) { (response) in
            apiResponse(response)
        }
    }
    
    func hitUpdateProfileImageApi(image:UIImage, imageName:String, apiResponse:@escaping(responseHandler)) {
       let url = ApiEndPoints.userModule.updateProfileImage + "/" + getUserData(._id)
        NetworkingWrapper.sharedInstance.connectWithMultiPart(urlEndPoint: url, httpMethod: .put, headers: ApiHeaders.sharedInstance.headerWithAuth(), images: [image], imageName: imageName) { (response) in
            apiResponse(response)
        }
    }
    
    func hitChangePasswordApi(parameters:[String:Any], apiResponse:@escaping(responseHandler)) {
        
        NetworkingWrapper.sharedInstance.connect(urlEndPoint: ApiEndPoints.userModule.changepassword, httpMethod: .post, headers: ApiHeaders.sharedInstance.headerWithAuth(), parameters: parameters) { (response) in
            apiResponse(response)
        }
    }
}
