
import UIKit

protocol ForgotPasswordPresentationLogic
{
  func presentSomething(response: ForgotPassword.Response)
    func mobileNumberVerified()
}

class ForgotPasswordPresenter: ForgotPasswordPresentationLogic
{
  weak var viewController: ForgotPasswordDisplayLogic?
  
  // MARK: Do something
  
  func presentSomething(response: ForgotPassword.Response)
  {
    let viewModel = ForgotPassword.ViewModel()
  }
    
    func mobileNumberVerified() {
        viewController?.mobileNumberVerified()
    }
}
