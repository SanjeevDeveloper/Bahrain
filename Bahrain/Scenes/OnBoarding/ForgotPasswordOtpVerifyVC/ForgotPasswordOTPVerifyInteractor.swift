
import UIKit

protocol ForgotPasswordOTPVerifyBusinessLogic
{
//    func generateAndSendOtp()
//    func verifyOtp(userEnteredOtp:String)
    func hitSendApi()
}

protocol ForgotPasswordOTPVerifyDataStore
{
    var mobileNumber:String? { get set }
    var countryCode:String? { get set }
    var userID:String? { get set }
}

class ForgotPasswordOTPVerifyInteractor: ForgotPasswordOTPVerifyBusinessLogic, ForgotPasswordOTPVerifyDataStore
{
  var presenter: ForgotPasswordOTPVerifyPresentationLogic?
  var worker: ForgotPasswordOTPVerifyWorker?
    
    var mobileNumber:String?
    var countryCode:String?
    var userID:String?
    var verificationID = ""
  
  // MARK: Do something
    
    func hitSendApi() {
        worker = ForgotPasswordOTPVerifyWorker()
        let completeNumber = countryCode! + mobileNumber!
        worker?.getOtpApi(number: completeNumber, apiResponse: { (response) in
            if response.code == 200 {
                self.presenter?.getOtpResponse(response: response)
            }
            else {
                CustomAlertController.sharedInstance.showErrorAlert(error: response.error!)
            }
        })
    }
    
//    func generateAndSendOtp()
//    {
//        let otpWrapperObj = OtpWrapper()
//        let completeNumber = countryCode! + mobileNumber!
//        otpWrapperObj.sendOtp(toNumber: completeNumber) { (vId) in
//
//            if vId != nil {
//                self.verificationID = vId!
//            }
//            else {
//                CustomAlertController.sharedInstance.showErrorAlert(error: localizedTextFor(key: OTPVerifySceneText.OTPNotSent.rawValue))
//            }
//        }
//    }
//
//    func verifyOtp(userEnteredOtp:String) {
//        if userEnteredOtp == "" {
//            CustomAlertController.sharedInstance.showErrorAlert(error: localizedTextFor(key: OTPVerifySceneText.emptyOTP.rawValue))
//        }
//        else  {
//            let otpWrapperObj = OtpWrapper()
//            otpWrapperObj.verifyOtp(verificationId: verificationID, otp: userEnteredOtp) { (responseBool) in
//
//                if responseBool{
//                    self.presenter?.otpVerified()
//                }
//                else
//                {
//                CustomAlertController.sharedInstance.showErrorAlert(error: localizedTextFor(key: OTPVerifySceneText.validOTP.rawValue))
//                }
//            }
//
//        }
//
//    }
//
  
}


//let otp = CommonFunctions.sharedInstance.generateRandomNumber(length: 4)
//userDefault.set(otp, forKey: userDefualtKeys.otp.rawValue)
//TwilioWrapper.sharedInstance.sendOtp(otp:otp, toNumber:(mobileNumber!), countryCode:countryCode!)

//if userEnteredOtp == "" {
//    CustomAlertController.sharedInstance.showErrorAlert(error: localizedTextFor(key: OTPVerifySceneText.emptyOTP.rawValue))
//}
//else if userEnteredOtp != userDefault.value(forKey: userDefualtKeys.otp.rawValue) as? String ?? "" {
//    CustomAlertController.sharedInstance.showErrorAlert(error: localizedTextFor(key: OTPVerifySceneText.validOTP.rawValue))
//}
//else {
//    presenter?.otpVerified()
//}
