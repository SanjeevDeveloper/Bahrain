
import UIKit

class ForgotPasswordWorker {
  
    func hitVerifyMobileNumberApi(parameters:[String:String], apiResponse:@escaping(responseHandler)) {
        NetworkingWrapper.sharedInstance.connect(urlEndPoint: ApiEndPoints.Onboarding.verifyNumber, httpMethod: .post, parameters: parameters) { (response) in
            apiResponse(response)
        }
    }
    
}
