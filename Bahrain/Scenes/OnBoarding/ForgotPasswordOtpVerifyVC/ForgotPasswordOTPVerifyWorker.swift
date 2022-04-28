
import UIKit

class ForgotPasswordOTPVerifyWorker
{
    func getOtpApi(number:String, apiResponse:@escaping(responseHandler)) {
        
        let url = ApiEndPoints.userModule.sendOtp + "/" + number + "/forgot"
        
        NetworkingWrapper.sharedInstance.connect(urlEndPoint: url, httpMethod: .get) { (response) in
            apiResponse(response)
            printToConsole(item: response)
        }
    }
}
