
import UIKit

@objc protocol AddClientRoutingLogic
{
  func routeToClientList()
}

protocol AddClientDataPassing
{
  var dataStore: AddClientDataStore? { get }
}

class AddClientRouter: NSObject, AddClientRoutingLogic, AddClientDataPassing
{
  weak var viewController: AddClientViewController?
  var dataStore: AddClientDataStore?
  
  // MARK: Routing
  
  func routeToClientList() {
    for controller in (viewController?.navigationController?.viewControllers)! {
        if controller.isKind(of: ClientListViewController.self) {
            let destinationVC = controller as! ClientListViewController
            var destinationDS = destinationVC.router!.dataStore!
            passDataToSomewhere(source: dataStore!, destination: &destinationDS)
            navigateToSomewhere(source: viewController!, destination: destinationVC)
        }
    }
    
  }

  // MARK: Navigation
  
  func navigateToSomewhere(source: AddClientViewController, destination: ClientListViewController)
  {
    source.navigationController?.popViewController(animated: true)
  }
  
  // MARK: Passing data
  
  func passDataToSomewhere(source: AddClientDataStore, destination: inout ClientListDataStore)
  {
    //destination.clientsArray.append(source.clientObj!)
    destination.fromAddScreen = "addClient"
  }
}
