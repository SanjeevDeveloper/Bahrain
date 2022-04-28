
import UIKit

@objc protocol ForgotPasswordOTPVerifyRoutingLogic
{
  func routeToPasswordReset(segue: UIStoryboardSegue?)
}

protocol ForgotPasswordOTPVerifyDataPassing
{
  var dataStore: ForgotPasswordOTPVerifyDataStore? { get }
}

class ForgotPasswordOTPVerifyRouter: NSObject, ForgotPasswordOTPVerifyRoutingLogic, ForgotPasswordOTPVerifyDataPassing
{
  weak var viewController: ForgotPasswordOTPVerifyViewController?
  var dataStore: ForgotPasswordOTPVerifyDataStore?
  
  // MARK: Routing
  
  func routeToPasswordReset(segue: UIStoryboardSegue?)
  {
      let destinationVC = segue?.destination as! ForgotPasswordResetViewController
      var destinationDS = destinationVC.router!.dataStore!
      passDataToSomewhere(source: dataStore!, destination: &destinationDS)
    
  }

  // MARK: Passing data
  
  func passDataToSomewhere(source: ForgotPasswordOTPVerifyDataStore, destination: inout ForgotPasswordResetDataStore)
  {
    destination.userID = source.userID
  }
}
