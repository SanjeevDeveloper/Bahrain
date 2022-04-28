
import UIKit

protocol OTPVerificationPresentationLogic
{
    func getOtpResponse(response:ApiResponse)
}

class OTPVerificationPresenter: OTPVerificationPresentationLogic
{
  weak var viewController: OTPVerificationDisplayLogic?
  
  // MARK: Do something
  
  func getOtpResponse(response:ApiResponse)
  {
    let apiResponseDict = response.result as! NSDictionary
    let otp = apiResponseDict["otp"] as! String
     viewController?.displayOtpResponse(otp: otp)
   }
}
