
import UIKit

@objc protocol ListYourServiceRoutingLogic
{
  func routeToPageController()
}

protocol ListYourServiceDataPassing
{
  var dataStore: ListYourServiceDataStore? { get }
}

class ListYourServiceRouter: NSObject, ListYourServiceRoutingLogic, ListYourServiceDataPassing
{
  weak var viewController: ListYourServiceViewController?
  var dataStore: ListYourServiceDataStore?
  
  // MARK: Routing
  
    func routeToPageController() {
        let businessPageViewControllerObj = viewController?.storyboard?.instantiateViewController(withIdentifier: ViewControllersIds.BusinessPageViewControllerID)
        viewController?.navigationController?.pushViewController(businessPageViewControllerObj!, animated: true)
    }

  // MARK: Navigation
  
  //func navigateToSomewhere(source: ListYourServiceViewController, destination: SomewhereViewController)
  //{
  //  viewController?.navigationController?.pushViewController(destination, animated: true)
  //}
  
  // MARK: Passing data
  
  //func passDataToSomewhere(source: ListYourServiceDataStore, destination: inout SomewhereDataStore)
  //{
  //  destination.name = source.name
  //}
}
