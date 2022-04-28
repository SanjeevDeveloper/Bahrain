
import UIKit

@objc protocol AddSalonServiceRoutingLogic
{
  func routeToListService()
}

protocol AddSalonServiceDataPassing
{
  var dataStore: AddSalonServiceDataStore? { get }
}

class AddSalonServiceRouter: NSObject, AddSalonServiceRoutingLogic, AddSalonServiceDataPassing
{
  weak var viewController: AddSalonServiceViewController?
  var dataStore: AddSalonServiceDataStore?
  
  // MARK: Routing
  
  func routeToListService()
  {
    if appDelegateObj.isPageControlActive {
        viewController?.navigationController?.popViewController(animated: true)
    }
    else {
    for controller in (viewController?.navigationController?.viewControllers)! {
        if controller.isKind(of: ListServiceViewController.self) {
            let destinationVC = controller as! ListServiceViewController
            var destinationDS = destinationVC.router!.dataStore!
            passDataToSomewhere(source: dataStore!, destination: &destinationDS)
            navigateBack(source: viewController!)
        }
    }
    }
  }

  // MARK: Navigation
func navigateBack(source: AddSalonServiceViewController) {
        source.navigationController?.popViewController(animated: true)
    }
  
  
  // MARK: Passing data
  
  func passDataToSomewhere(source: AddSalonServiceDataStore, destination: inout ListServiceDataStore)
  {
    destination.fromAddServiceScreen = "fromAddServiceScreen"
  }
}
