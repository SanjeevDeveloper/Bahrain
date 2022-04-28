

import UIKit

@objc protocol LoginRoutingLogic
{
  func routeToHome(segue: UIStoryboardSegue?)
}

protocol LoginDataPassing
{
  var dataStore: LoginDataStore? { get }
}

class LoginRouter: NSObject, LoginRoutingLogic, LoginDataPassing
{
  weak var viewController: LoginViewController?
  var dataStore: LoginDataStore?
  
  // MARK: Routing
  
  func routeToHome(segue: UIStoryboardSegue?)
  {
    
  }

}
