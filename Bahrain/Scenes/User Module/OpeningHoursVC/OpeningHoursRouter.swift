
import UIKit

@objc protocol OpeningHoursRoutingLogic
{
  //func routeToSomewhere(segue: UIStoryboardSegue?)
}

protocol OpeningHoursDataPassing
{
  var dataStore: OpeningHoursDataStore? { get }
}

class OpeningHoursRouter: NSObject, OpeningHoursRoutingLogic, OpeningHoursDataPassing
{
  weak var viewController: OpeningHoursViewController?
  var dataStore: OpeningHoursDataStore?
  
  // MARK: Routing
  
  //func routeToSomewhere(segue: UIStoryboardSegue?)
  //{
  //  if let segue = segue {
  //    let destinationVC = segue.destination as! SomewhereViewController
  //    var destinationDS = destinationVC.router!.dataStore!
  //    passDataToSomewhere(source: dataStore!, destination: &destinationDS)
  //  } else {
  //    let storyboard = UIStoryboard(name: "Main", bundle: nil)
  //    let destinationVC = storyboard.instantiateViewController(withIdentifier: "SomewhereViewController") as! SomewhereViewController
  //    var destinationDS = destinationVC.router!.dataStore!
  //    passDataToSomewhere(source: dataStore!, destination: &destinationDS)
  //    navigateToSomewhere(source: viewController!, destination: destinationVC)
  //  }
  //}

  // MARK: Navigation
  
  //func navigateToSomewhere(source: OpeningHoursViewController, destination: SomewhereViewController)
  //{
  //  viewController?.navigationController?.pushViewController(destination, animated: true)
  //}
  
  // MARK: Passing data
  
  //func passDataToSomewhere(source: OpeningHoursDataStore, destination: inout SomewhereDataStore)
  //{
  //  destination.name = source.name
  //}
}
