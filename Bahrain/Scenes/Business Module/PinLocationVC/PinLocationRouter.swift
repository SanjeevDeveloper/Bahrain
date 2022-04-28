
import UIKit

@objc protocol PinLocationRoutingLogic
{
  //func routeToSomewhere(segue: UIStoryboardSegue?)
}

protocol PinLocationDataPassing
{
  var dataStore: PinLocationDataStore? { get }
}

class PinLocationRouter: NSObject, PinLocationRoutingLogic, PinLocationDataPassing
{
  weak var viewController: PinLocationViewController?
  var dataStore: PinLocationDataStore?
  
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
  
  //func navigateToSomewhere(source: PinLocationViewController, destination: SomewhereViewController)
  //{
  //  viewController?.navigationController?.pushViewController(destination, animated: true)
  //}
  
  // MARK: Passing data
  
  //func passDataToSomewhere(source: PinLocationDataStore, destination: inout SomewhereDataStore)
  //{
  //  destination.name = source.name
  //}
}
