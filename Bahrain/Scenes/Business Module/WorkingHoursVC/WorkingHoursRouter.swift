
import UIKit

@objc protocol WorkingHoursRoutingLogic
{
  //func routeToSomewhere(segue: UIStoryboardSegue?)
}

protocol WorkingHoursDataPassing
{
  var dataStore: WorkingHoursDataStore? { get }
}

class WorkingHoursRouter: NSObject, WorkingHoursRoutingLogic, WorkingHoursDataPassing
{
  weak var viewController: WorkingHoursViewController?
  var dataStore: WorkingHoursDataStore?
  
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
  
  //func navigateToSomewhere(source: WorkingHoursViewController, destination: SomewhereViewController)
  //{
  //  viewController?.navigationController?.pushViewController(destination, animated: true)
  //}
  
  // MARK: Passing data
  
  //func passDataToSomewhere(source: WorkingHoursDataStore, destination: inout SomewhereDataStore)
  //{
  //  destination.name = source.name
  //}
}
