
import UIKit

protocol RegisterNameBusinessLogic
{
    func updateDataStoreWithName(request: RegistrationRequest)
}

protocol RegisterNameDataStore
{
    var registerRequest: RegistrationRequest? { get set }
}

class RegisterNameInteractor: RegisterNameBusinessLogic, RegisterNameDataStore
{
    var presenter: RegisterNamePresentationLogic?
    var worker: RegisterNameWorker?
    var registerRequest: RegistrationRequest?
    
    // MARK: Do something
    
    func updateDataStoreWithName(request: RegistrationRequest)
    {
        if isRequestValid(request: request) {
            self.registerRequest = request
            presenter?.dataStoreUpdatedWithName()
        }
    }
    
    func isRequestValid(request: RegistrationRequest) -> Bool {
        var isValid = true
        let validator = Validator()
        if !validator.validateRequired(request.name, errorKey: ValidationsText.emptyName.rawValue)  {
            isValid = false
        }
        return isValid
    }
}
