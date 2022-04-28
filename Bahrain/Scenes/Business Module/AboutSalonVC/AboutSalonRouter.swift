
import UIKit

@objc protocol AboutSalonRoutingLogic
{
  //func routeToSomewhere(segue: UIStoryboardSegue?)
}

protocol AboutSalonDataPassing
{
  var dataStore: AboutSalonDataStore? { get }
}

class AboutSalonRouter: NSObject, AboutSalonRoutingLogic, AboutSalonDataPassing
{
  weak var viewController: AboutSalonViewController?
  var dataStore: AboutSalonDataStore?
  
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
  
  //func navigateToSomewhere(source: AboutSalonViewController, destination: SomewhereViewController)
  //{
  //  viewController?.navigationController?.pushViewController(destination, animated: true)
  //}
  
  // MARK: Passing data
  
  //func passDataToSomewhere(source: AboutSalonDataStore, destination: inout SomewhereDataStore)
  //{
  //  destination.name = source.name
  //}
}
