
import UIKit

@objc protocol LocationRoutingLogic
{
  func routeToSelectArea(segue: UIStoryboardSegue?)
  func routeToAreaPinPoint()
  func routeToSelectBlock(segue: UIStoryboardSegue?)
}

protocol LocationDataPassing
{
  var dataStore: LocationDataStore? { get }
}

class LocationRouter: NSObject, LocationRoutingLogic, LocationDataPassing
{
  weak var viewController: LocationViewController?
  var dataStore: LocationDataStore?
  
  // MARK: Routing
    
    func routeToSelectArea(segue: UIStoryboardSegue?) {
        let destinationVC = segue!.destination as! SelectAreaUserViewController
        var destinationDS = destinationVC.router!.dataStore!
        passDataToSomewhere(source: self.dataStore!, destination: &destinationDS)
    }
    
    func routeToSelectBlock(segue: UIStoryboardSegue?) {
        let destinationVC = segue!.destination as! SelectBlockViewController
        var destinationDS = destinationVC.router!.dataStore!
        passDataToBlock(source: self.dataStore!, destination: &destinationDS)
    }
    
    func routeToAreaPinPoint() {
        let destinationVC = viewController?.storyboard?.instantiateViewController(withIdentifier: ViewControllersIds.PinLocationViewControllerID) as! PinLocationViewController
        viewController?.navigationController?.pushViewController(destinationVC, animated: true)
    }
  
  // MARK: Passing data
    
    func passDataToSomewhere(source: LocationDataStore, destination: inout SelectAreaUserDataStore)
    {
        destination.screenName = "BusinessLocation"
    }
    
    func passDataToBlock(source: LocationDataStore, destination: inout SelectBlockDataStore)
    {
        destination.screenName = "BusinessLocation"
    }
    
}
