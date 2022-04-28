
import UIKit

@objc protocol ClientReviewsRoutingLogic
{
  //func routeToSomewhere(segue: UIStoryboardSegue?)
}

protocol ClientReviewsDataPassing
{
  var dataStore: ClientReviewsDataStore? { get }
}

class ClientReviewsRouter: NSObject, ClientReviewsRoutingLogic, ClientReviewsDataPassing
{
  weak var viewController: ClientReviewsViewController?
  var dataStore: ClientReviewsDataStore?
  
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
  
  //func navigateToSomewhere(source: ClientReviewsViewController, destination: SomewhereViewController)
  //{
  //  viewController?.navigationController?.pushViewController(destination, animated: true)
  //}
  
  // MARK: Passing data
  
  //func passDataToSomewhere(source: ClientReviewsDataStore, destination: inout SomewhereDataStore)
  //{
  //  destination.name = source.name
  //}
}
