
import UIKit

protocol RegisterMobileNumberBusinessLogic
{
   // func fetchRegistrationObject()
    func updateDataStoreWithMobile(request: RegistrationRequest,profileImage:UIImage)
   
}

protocol RegisterMobileNumberDataStore
{
    var registerRequest: RegistrationRequest? { get set }
    var profileImageRequest: UIImage? { get set }
}

class RegisterMobileNumberInteractor: RegisterMobileNumberBusinessLogic, RegisterMobileNumberDataStore
{

    var presenter: RegisterMobileNumberPresentationLogic?
    var worker: RegisterMobileNumberWorker?
    var registerRequest: RegistrationRequest?
    var profileImageRequest: UIImage?
    
    // MARK: Do something
    
//    func fetchRegistrationObject()
//    {
//        presenter?.registrationObjectFetched(obj: self.registerRequest!)
//    }
    
    func updateDataStoreWithMobile(request: RegistrationRequest,profileImage:UIImage) {
        if isRequestValid(request: request) {
            worker = RegisterMobileNumberWorker()
            let parameters = [
                "countryCode":request.countryCode,
                "phoneNumber":request.phoneNumber,
                "key":"signup"
            ]
            worker?.hitVerifyMobileNumberApi(parameters: parameters, apiResponse: { (response) in
                
                if response.code == 200 {
                    self.registerRequest = request
                    self.profileImageRequest = profileImage
                    //                    self.registerRequest = request.phoneNumber
                    //                    self.registerRequest?.name = request.name
                    //                    self.registerRequest?.password = request.password
                    self.presenter?.dataStoreUpdatedWithMobile()
                }
                
                else {
                    CustomAlertController.sharedInstance.showErrorAlert(error: response.error ?? "")
                }
            })
        }
    }
    
    func isRequestValid(request: RegistrationRequest) -> Bool {
        var isValid = true
        let validator = Validator()
        if !validator.validateRequired(request.name, errorKey: ValidationsText.emptyName.rawValue)  {
            isValid = false
        }
        else if !validator.validateRequired(request.countryCode, errorKey: ValidationsText.emptyCountryCode.rawValue)  {
            isValid = false
        }
        else if !validator.validateRequired(request.phoneNumber, errorKey: ValidationsText.emptyPhoneNumber.rawValue)  {
            isValid = false
        }
        else if !validator.validateMinCharactersCount(request.phoneNumber, minCount: 7,  minCountErrorKey: ValidationsText.phoneNumberMinLength.rawValue)  {
            isValid = false
        }
        else if !validator.validateRequired(request.password, errorKey: ValidationsText.emptyPassword.rawValue)  {
            isValid = false
        }
        else if !validator.validateMinCharactersCount(request.password, minCount: 8,  minCountErrorKey: ValidationsText.passwordLength.rawValue)  {
            isValid = false
        }
        return isValid
    }
    
    
}
