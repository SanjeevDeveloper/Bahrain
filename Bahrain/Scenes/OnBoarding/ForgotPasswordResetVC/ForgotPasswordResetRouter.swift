
import UIKit

@objc protocol ForgotPasswordResetRoutingLogic
{
    func routeToLogin()
}

protocol ForgotPasswordResetDataPassing
{
    var dataStore: ForgotPasswordResetDataStore? { get }
}

class ForgotPasswordResetRouter: NSObject, ForgotPasswordResetRoutingLogic, ForgotPasswordResetDataPassing
{
    weak var viewController: ForgotPasswordResetViewController?
    var dataStore: ForgotPasswordResetDataStore?
    
    // MARK: Routing
    
    func routeToLogin() {
        for controller in (viewController?.navigationController?.viewControllers)! {
            if controller.isKind(of: LoginViewController.self) {
                viewController?.navigationController?.popToViewController(controller, animated: true)
            }
        }
    }
    
}
