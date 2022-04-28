
import UIKit

class ForgotPasswordResetWorker
{
    func hitResetPasswordApi(urlPathComponent:String, parameters:[String:String], apiResponse:@escaping(responseHandler)) {
       let url = ApiEndPoints.Onboarding.resetPassword + "/" + urlPathComponent
        NetworkingWrapper.sharedInstance.connect(urlEndPoint: url, httpMethod: .put, parameters: parameters) { (response) in
            apiResponse(response)
        }
    }
}
