
import UIKit

 protocol ClientListRoutingLogic
{
  func routeToEditClient(segue: UIStoryboardSegue?, dict: ClientList.ViewModel.tableCellData)
    
  func routeToBusinessBooking(segue: UIStoryboardSegue?, dict: ClientList.ViewModel.tableCellData)
}

protocol ClientListDataPassing
{
  var dataStore: ClientListDataStore? { get }
}

class ClientListRouter: NSObject, ClientListRoutingLogic, ClientListDataPassing
{
    func routeToBusinessBooking(segue: UIStoryboardSegue?, dict: ClientList.ViewModel.tableCellData) {
        for controller in (viewController?.navigationController?.viewControllers)! {
            if controller.isKind(of: BusinessBookingViewController.self) {
                let destinationVC = controller as! BusinessBookingViewController
                var destinationDS = destinationVC.router!.dataStore!
                passDataToBooking(source: dataStore!, destination: &destinationDS, dict: dict)
                navigateToBooking(source: viewController!, destination: destinationVC)
            }
        }
    }
    
  weak var viewController: ClientListViewController?
  var dataStore: ClientListDataStore?
  
  // MARK: Routing
  
  func routeToEditClient(segue: UIStoryboardSegue?, dict: ClientList.ViewModel.tableCellData)
  {
    let destinationVC = viewController?.storyboard?.instantiateViewController(withIdentifier: "AddClientViewControllerID") as! AddClientViewController
    var destinationDS = destinationVC.router!.dataStore!
    passDataToSomewhere(source: dataStore!, destination: &destinationDS, dict: dict)
    navigateToSomewhere(source: viewController!, destination: destinationVC)
  }

  // MARK: Navigation
    
    
    func navigateToBooking(source: ClientListViewController, destination: BusinessBookingViewController)
    {
        source.navigationController?.popViewController(animated: true)
    }
  
  func navigateToSomewhere(source: ClientListViewController, destination: AddClientViewController)
  {
    viewController?.navigationController?.pushViewController(destination, animated: true)
  }
  
  // MARK: Passing data
    
    func passDataToBooking(source: ClientListDataStore, destination: inout BusinessBookingDataStore, dict: ClientList.ViewModel.tableCellData)
    {
        destination.ClintDataObj = dict
    }
  
  func passDataToSomewhere(source: ClientListDataStore, destination: inout AddClientDataStore, dict: ClientList.ViewModel.tableCellData)
  {
    destination.ClintDataObj = dict
    destination.editClient = "editClient"
  }
}
