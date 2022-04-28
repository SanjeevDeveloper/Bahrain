
import UIKit

@objc protocol SendFeedBackRoutingLogic
{
  //func routeToSomewhere(segue: UIStoryboardSegue?)
}

protocol SendFeedBackDataPassing
{
  var dataStore: SendFeedBackDataStore? { get }
}

class SendFeedBackRouter: NSObject, SendFeedBackRoutingLogic, SendFeedBackDataPassing
{
  weak var viewController: SendFeedBackViewController?
  var dataStore: SendFeedBackDataStore?
  
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
  
  //func navigateToSomewhere(source: SendFeedBackViewController, destination: SomewhereViewController)
  //{
  //  viewController?.navigationController?.pushViewController(destination, animated: true)
  //}
  
  // MARK: Passing data
  
  //func passDataToSomewhere(source: SendFeedBackDataStore, destination: inout SomewhereDataStore)
  //{
  //  destination.name = source.name
  //}
}
