
import UIKit

@objc protocol RegisterLocationRoutingLogic
{
  func routeToSelectArea(segue: UIStoryboardSegue?)
}

protocol RegisterLocationDataPassing
{
  var dataStore: RegisterLocationDataStore? { get }
}

class RegisterLocationRouter: NSObject, RegisterLocationRoutingLogic, RegisterLocationDataPassing
{
  weak var viewController: RegisterLocationViewController?
  var dataStore: RegisterLocationDataStore?
  
  
    func routeToSelectArea(segue: UIStoryboardSegue?) {
        let destinationVC = segue!.destination as! SelectAreaUserViewController
        var destinationDS = destinationVC.router!.dataStore!
        passDataToSomewhere(source: self.dataStore!, destination: &destinationDS)
    }
    
    func passDataToSomewhere(source: RegisterLocationDataStore, destination: inout SelectAreaUserDataStore)
    {
        destination.screenName = "RegisterLocation"
    }
}
