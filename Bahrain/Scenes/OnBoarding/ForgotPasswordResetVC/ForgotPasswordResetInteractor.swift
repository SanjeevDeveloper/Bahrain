
import UIKit

protocol ForgotPasswordResetBusinessLogic
{
    func hitResetPasswordApi(request:ForgotPasswordReset.Request)
    
    
}

protocol ForgotPasswordResetDataStore
{
    var userID:String? { get set }
}

class ForgotPasswordResetInteractor: ForgotPasswordResetBusinessLogic, ForgotPasswordResetDataStore
{
    var presenter: ForgotPasswordResetPresentationLogic?
    var worker: ForgotPasswordResetWorker?
    var userID:String?
    
    // MARK: Do something
    
    func hitResetPasswordApi(request:ForgotPasswordReset.Request)
    {
        if isRequestValid(request: request) {
            worker = ForgotPasswordResetWorker()
            let parameters = [
                "newPassword":request.newPassword,
                "verifyPassword":request.confirmPassword
            ]
            worker?.hitResetPasswordApi(urlPathComponent:self.userID!, parameters: parameters, apiResponse: { (response) in
                self.presenter?.presentResetResponse(response: response)
            })
        }
    }
    
    func isRequestValid(request: ForgotPasswordReset.Request) -> Bool {
        var isValid = true
        let validator = Validator()
        if !validator.validateRequired(request.newPassword, errorKey: ValidationsText.emptyNewPassword.rawValue)  {
            isValid = false
        }
        else if !validator.validateRequired(request.confirmPassword, errorKey: ValidationsText.emptyConfirmPassword.rawValue)  {
            isValid = false
        }
        else if !validator.validateEquality(request.newPassword, secondItem: request.confirmPassword, errorKey:ValidationsText.confirmPasswordMatch.rawValue) {
            isValid = false
        }
        else if !validator.validateMinCharactersCount(request.newPassword, minCount: 8,  minCountErrorKey: ValidationsText.passwordLength.rawValue)  {
            isValid = false
        }
        else if !validator.validateMinCharactersCount(request.confirmPassword, minCount: 8,  minCountErrorKey: ValidationsText.passwordLength.rawValue)  {
            isValid = false
        }
        return isValid
    }
}
