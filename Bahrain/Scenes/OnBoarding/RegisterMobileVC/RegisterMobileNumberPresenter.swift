
import UIKit

protocol RegisterMobileNumberPresentationLogic
{
    //func registrationObjectFetched(obj:RegistrationRequest)
    func dataStoreUpdatedWithMobile()
}

class RegisterMobileNumberPresenter: RegisterMobileNumberPresentationLogic
{
  weak var viewController: RegisterMobileNumberDisplayLogic?
    
  
  // MARK: Do something
  
  func registrationObjectFetched(obj:RegistrationRequest)
  {
   // viewController?.displayName(obj: obj)
  }
    
    func dataStoreUpdatedWithMobile() {
        viewController?.dataStoreUpdated()
    }
}
