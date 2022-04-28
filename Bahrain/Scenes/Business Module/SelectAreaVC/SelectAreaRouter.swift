
import UIKit

@objc protocol SelectAreaRoutingLogic
{
  //func routeToSomewhere(segue: UIStoryboardSegue?)
}

protocol SelectAreaDataPassing
{
  var dataStore: SelectAreaDataStore? { get }
}

class SelectAreaRouter: NSObject, SelectAreaRoutingLogic, SelectAreaDataPassing
{
  weak var viewController: SelectAreaViewController?
  var dataStore: SelectAreaDataStore?
  
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
  
  //func navigateToSomewhere(source: SelectAreaViewController, destination: SomewhereViewController)
  //{
  //  viewController?.navigationController?.pushViewController(destination, animated: true)
  //}
  
  // MARK: Passing data
  
  //func passDataToSomewhere(source: SelectAreaDataStore, destination: inout SomewhereDataStore)
  //{
  //  destination.name = source.name
  //}
}
