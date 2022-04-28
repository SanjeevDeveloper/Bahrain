
import UIKit

@objc protocol BasicInformationRoutingLogic
{
  func routeToLocationController()
}

protocol BasicInformationDataPassing
{
  var dataStore: BasicInformationDataStore? { get }
}

class BasicInformationRouter: NSObject, BasicInformationRoutingLogic, BasicInformationDataPassing
{
  weak var viewController: BasicInformationViewController?
  var dataStore: BasicInformationDataStore?
  
  // MARK: Routing
  
    func routeToLocationController() {
        let destinationVC = viewController?.storyboard?.instantiateViewController(withIdentifier: ViewControllersIds.LocationViewControllerID) as! LocationViewController
      var destinationDS = destinationVC.router!.dataStore!
      passDataToSomewhere(source: dataStore!, destination: &destinationDS)
  }

  // MARK: Passing data

  func passDataToSomewhere(source: BasicInformationDataStore, destination: inout LocationDataStore)
  {
    destination.saloonData = source.saloonData
  }
}
