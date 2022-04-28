
import UIKit

protocol ForgotPasswordBusinessLogic
{
  func doSomething(request: ForgotPassword.Request)
  func verifyMobileNumber(request: ForgotPassword.Request)
}

protocol ForgotPasswordDataStore
{
    var mobileNumber:String? { get set }
    var countryCode:String? { get set }
    var userID:String? { get set }
}

class ForgotPasswordInteractor: ForgotPasswordBusinessLogic, ForgotPasswordDataStore
{
  var presenter: ForgotPasswordPresentationLogic?
  var worker: ForgotPasswordWorker?
    
    var mobileNumber:String?
    var countryCode:String?
    var userID:String?
  
  // MARK: Do something
    
    func verifyMobileNumber(request: ForgotPassword.Request) {
         if isRequestValid(request: request) {
            worker = ForgotPasswordWorker()
            self.countryCode = request.countryCode
            self.mobileNumber = request.mobileNumber
            
            let parameters = [
                "countryCode":request.countryCode,
                "phoneNumber":request.mobileNumber,
                "key":"forget"
            ]
            worker?.hitVerifyMobileNumberApi(parameters: parameters, apiResponse: { (response) in
                let errorCode = response.code
                if errorCode == 200 {
                    let resultDict = response.result as! NSDictionary
                    self.userID = resultDict["_id"] as? String ?? ""
                    self.presenter?.mobileNumberVerified()
                }
                else {
    CustomAlertController.sharedInstance.showErrorAlert(error:localizedTextFor(key: ValidationsText.invalidPhoneNumber.rawValue) )
                }
            })
            
        }
    }
        
        func isRequestValid(request: ForgotPassword.Request) -> Bool {
            var isValid = true
            let validator = Validator()
            if !validator.validateRequired(request.countryCode, errorKey: ValidationsText.emptyCountryCode.rawValue)  {
                isValid = false
            }
            else if !validator.validateRequired(request.mobileNumber, errorKey: ValidationsText.emptyPhoneNumber.rawValue)  {
                isValid = false
            }
            else if !validator.validateMinCharactersCount(request.mobileNumber, minCount: 7,  minCountErrorKey: ValidationsText.phoneNumberMinLength.rawValue)  {
                isValid = false
            }
            return isValid
        }
        
  func doSomething(request: ForgotPassword.Request) {
    
  }
}
