
import UIKit

@objc protocol RegisterNameRoutingLogic
{
  func routeToRegisterMobile(segue: UIStoryboardSegue?)
}

protocol RegisterNameDataPassing
{
  var dataStore: RegisterNameDataStore? { get }
}

class RegisterNameRouter: NSObject, RegisterNameRoutingLogic, RegisterNameDataPassing
{
  weak var viewController: RegisterNameViewController?
  var dataStore: RegisterNameDataStore?
  
  // MARK: Routing
  
  func routeToRegisterMobile(segue: UIStoryboardSegue?)
  {
    let destinationVC = segue?.destination as! RegisterMobileNumberViewController
      var destinationDS = destinationVC.router!.dataStore!
      passDataToSomewhere(source: dataStore!, destination: &destinationDS)
  }

  
  // MARK: Passing data
  
  func passDataToSomewhere(source: RegisterNameDataStore, destination: inout RegisterMobileNumberDataStore) {
    printToConsole(item: source.registerRequest?.name)
    destination.registerRequest = source.registerRequest
  }
}
