
import UIKit

class OTPVerificationWorker
{
    func getOtpApi(number:String, apiResponse:@escaping(responseHandler)) {
        
        let url = ApiEndPoints.userModule.sendOtp + "/" + number + "/signup"
    
        NetworkingWrapper.sharedInstance.connect(urlEndPoint: url, httpMethod: .get) { (response) in
            apiResponse(response)
            printToConsole(item: response)
        }
    }
}
