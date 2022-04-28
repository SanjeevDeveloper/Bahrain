
import UIKit

protocol ForgotPasswordResetPresentationLogic
{
    func presentResetResponse(response: ApiResponse)
}

class ForgotPasswordResetPresenter: ForgotPasswordResetPresentationLogic
{
  weak var viewController: ForgotPasswordResetDisplayLogic?
  
  // MARK: Do something
  
  func presentResetResponse(response: ApiResponse)
  {
    let viewModel = ForgotPasswordReset.ViewModel(error: response.error)
    viewController?.resetPasswordResponse(response: viewModel)
  }
}
