
import UIKit

protocol ForgotPasswordOTPVerifyPresentationLogic
{
    // func otpVerified()
    func getOtpResponse(response:ApiResponse)
}

class ForgotPasswordOTPVerifyPresenter: ForgotPasswordOTPVerifyPresentationLogic
{
  weak var viewController: ForgotPasswordOTPVerifyDisplayLogic?
  
  // MARK: Do something
    
    func getOtpResponse(response:ApiResponse)
    {
        let apiResponseDict = response.result as! NSDictionary
        let otp = apiResponseDict["otp"] as! String
        viewController?.displayOtpResponse(otp: otp)
    }
  
//    func otpVerified()
//    {
//        viewController?.otpVerified()
//    }
}
