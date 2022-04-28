

import UIKit

@objc protocol AddPhotosRoutingLogic
{
  //func routeToSomewhere(segue: UIStoryboardSegue?)
}

protocol AddPhotosDataPassing
{
  var dataStore: AddPhotosDataStore? { get }
}

class AddPhotosRouter: NSObject, AddPhotosRoutingLogic, AddPhotosDataPassing
{
  weak var viewController: AddPhotosViewController?
  var dataStore: AddPhotosDataStore?
  
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
  
  //func navigateToSomewhere(source: AddPhotosViewController, destination: SomewhereViewController)
  //{
  //  viewController?.navigationController?.pushViewController(destination, animated: true)
  //}
  
  // MARK: Passing data
  
  //func passDataToSomewhere(source: AddPhotosDataStore, destination: inout SomewhereDataStore)
  //{
  //  destination.name = source.name
  //}
}
