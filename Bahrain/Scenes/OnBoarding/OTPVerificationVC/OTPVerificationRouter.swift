
import UIKit

@objc protocol OTPVerificationRoutingLogic
{
  func routeToRegisterLocation(segue: UIStoryboardSegue?)
}

protocol OTPVerificationDataPassing
{
  var dataStore: OTPVerificationDataStore? { get }
}

class OTPVerificationRouter: NSObject, OTPVerificationRoutingLogic, OTPVerificationDataPassing
{
  weak var viewController: OTPVerificationViewController?
  var dataStore: OTPVerificationDataStore?
  
  // MARK: Routing
  
  func routeToRegisterLocation(segue: UIStoryboardSegue?)
  {
    let destinationVC = segue?.destination as! RegisterLocationViewController
      var destinationDS = destinationVC.router!.dataStore!
      passDataToSomewhere(source: dataStore!, destination: &destinationDS)
  }

  
  // MARK: Passing data
  
  func passDataToSomewhere(source: OTPVerificationDataStore, destination: inout RegisterLocationDataStore)
  {
    printToConsole(item: source.registerRequest?.name)
    destination.registerRequest = source.registerRequest
    destination.profileImageRequest = source.profileImageRequest
  }
}
