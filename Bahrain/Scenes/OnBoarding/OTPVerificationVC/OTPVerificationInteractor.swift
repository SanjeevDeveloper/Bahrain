
import UIKit


protocol OTPVerificationBusinessLogic
{
//    func generateAndSendOtp()
//    func verifyOtp(userEnteredOtp:String)
    func hitSendApi()
}

protocol OTPVerificationDataStore
{
    var registerRequest: RegistrationRequest? { get set }
    var profileImageRequest: UIImage? { get set }
}

class OTPVerificationInteractor: OTPVerificationBusinessLogic, OTPVerificationDataStore
{

    var presenter: OTPVerificationPresentationLogic?
    var worker: OTPVerificationWorker?
    var registerRequest: RegistrationRequest?
    var verificationID = ""
    var profileImageRequest: UIImage?
    
    // MARK: Do something
    
    func hitSendApi() {
       worker = OTPVerificationWorker()
        let completeNumber = registerRequest!.countryCode + registerRequest!.phoneNumber
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
//        let completeNumber = registerRequest!.countryCode + registerRequest!.phoneNumber
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
    
    
//    func verifyOtp(userEnteredOtp:String) {
//        if userEnteredOtp == "" {
//            CustomAlertController.sharedInstance.showErrorAlert(error: localizedTextFor(key: OTPVerifySceneText.emptyOTP.rawValue))
//        }
//        else if
//            userEnteredOtp == "111111" {
//            self.presenter?.otpVerified()
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
//                    CustomAlertController.sharedInstance.showErrorAlert(error: localizedTextFor(key: OTPVerifySceneText.validOTP.rawValue))
//                }
//            }
//
//        }
//    }
}
