
import UIKit

@objc protocol ForgotPasswordRoutingLogic
{
  func routeToOtpVerify(segue: UIStoryboardSegue?)
}

protocol ForgotPasswordDataPassing
{
  var dataStore: ForgotPasswordDataStore? { get }
}

class ForgotPasswordRouter: NSObject, ForgotPasswordRoutingLogic, ForgotPasswordDataPassing
{
  weak var viewController: ForgotPasswordViewController?
  var dataStore: ForgotPasswordDataStore?
  
  // MARK: Routing
  
  func routeToOtpVerify(segue: UIStoryboardSegue?) {
    let destinationVC = segue?.destination as! ForgotPasswordOTPVerifyViewController
      var destinationDS = destinationVC.router!.dataStore!
      passDataToSomewhere(source: dataStore!, destination: &destinationDS)
    
  }
  
  // MARK: Passing data
  
  func passDataToSomewhere(source: ForgotPasswordDataStore, destination: inout ForgotPasswordOTPVerifyDataStore)
  {
    destination.mobileNumber = source.mobileNumber
    destination.countryCode = source.countryCode
    destination.userID = source.userID
  }
}
