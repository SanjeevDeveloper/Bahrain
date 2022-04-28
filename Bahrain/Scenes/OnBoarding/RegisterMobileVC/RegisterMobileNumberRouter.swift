
import UIKit

@objc protocol RegisterMobileNumberRoutingLogic
{
  func routeToVerify(segue: UIStoryboardSegue?)
}

protocol RegisterMobileNumberDataPassing
{
  var dataStore: RegisterMobileNumberDataStore? { get }
}

class RegisterMobileNumberRouter: NSObject, RegisterMobileNumberRoutingLogic, RegisterMobileNumberDataPassing
{
  weak var viewController: RegisterMobileNumberViewController?
  var dataStore: RegisterMobileNumberDataStore?
  
  // MARK: Routing
  
  func routeToVerify(segue: UIStoryboardSegue?)
  {
    let destinationVC = segue?.destination as! OTPVerificationViewController
      var destinationDS = destinationVC.router!.dataStore!
      passDataToSomewhere(source: dataStore!, destination: &destinationDS)
    
  }
  
  // MARK: Passing data
  
  func passDataToSomewhere(source: RegisterMobileNumberDataStore, destination: inout OTPVerificationDataStore)
  {
    destination.registerRequest = source.registerRequest
    destination.profileImageRequest = source.profileImageRequest
  }
}
