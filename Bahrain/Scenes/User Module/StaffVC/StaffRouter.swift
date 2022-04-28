
import UIKit

@objc protocol StaffRoutingLogic
{
  //func routeToSomewhere(segue: UIStoryboardSegue?)
}

protocol StaffDataPassing
{
  var dataStore: StaffDataStore? { get }
}

class StaffRouter: NSObject, StaffRoutingLogic, StaffDataPassing
{
  weak var viewController: StaffViewController?
  var dataStore: StaffDataStore?
  
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
  
  //func navigateToSomewhere(source: StaffViewController, destination: SomewhereViewController)
  //{
  //  viewController?.navigationController?.pushViewController(destination, animated: true)
  //}
  
  // MARK: Passing data
  
  //func passDataToSomewhere(source: StaffDataStore, destination: inout SomewhereDataStore)
  //{
  //  destination.name = source.name
  //}
}
