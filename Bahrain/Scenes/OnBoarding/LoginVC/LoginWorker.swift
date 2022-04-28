
import UIKit

class LoginWorker {
    
    func hitLoginApi(parameters:[String:String], apiResponse:@escaping(responseHandler)) {
        NetworkingWrapper.sharedInstance.connect(urlEndPoint: ApiEndPoints.Onboarding.signIn, httpMethod: .post, parameters: parameters) { (response) in
            apiResponse(response)
        }
    }
    
    func hitChangePasswordApi(parameters:[String:Any], apiResponse:@escaping(responseHandler)) {
        
        NetworkingWrapper.sharedInstance.connect(urlEndPoint: ApiEndPoints.userModule.changepassword, httpMethod: .post, headers: ApiHeaders.sharedInstance.headerWithAuth(), parameters: parameters) { (response) in
            apiResponse(response)
        }
    }
    
    func hitEditUserProfileApi(parameters:[String:Any], apiResponse:@escaping(responseHandler)) {
        let url = ApiEndPoints.userModule.editUserProfile + "/" + getUserData(._id)
        NetworkingWrapper.sharedInstance.connect(urlEndPoint: url, httpMethod: .put, headers: ApiHeaders.sharedInstance.headerWithAuth(), parameters: parameters) { (response) in
            apiResponse(response)
        }
    }
}

