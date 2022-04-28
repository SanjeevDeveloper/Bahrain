
import UIKit

protocol ListServiceRoutingLogic
{
    func routeToEditService(segue: UIStoryboardSegue?, dict: ListService.ViewModel.tableRowData)
}

protocol ListServiceDataPassing
{
    var dataStore: ListServiceDataStore? { get }
}

class ListServiceRouter: NSObject, ListServiceRoutingLogic, ListServiceDataPassing
{
    weak var viewController: ListServiceViewController?
    var dataStore: ListServiceDataStore?
    
    // MARK: Routing
    
    func routeToEditService(segue: UIStoryboardSegue?, dict: ListService.ViewModel.tableRowData)
    {
            let destinationVC = viewController?.storyboard?.instantiateViewController(withIdentifier: "AddSalonServiceViewControllerID") as! AddSalonServiceViewController
            var destinationDS = destinationVC.router!.dataStore!
            passDataToSomewhere(source: dataStore!, destination: &destinationDS, dict: dict)
            navigateToSomewhere(source: viewController!, destination: destinationVC)
        
    }
    
    // MARK: Navigation
    
    func navigateToSomewhere(source: ListServiceViewController, destination: AddSalonServiceViewController)
    {
        viewController?.navigationController?.pushViewController(destination, animated: true)
    }
    
    // MARK: Passing data
    
    func passDataToSomewhere(source: ListServiceDataStore, destination: inout AddSalonServiceDataStore, dict: ListService.ViewModel.tableRowData)
    {
        destination.dataDict = dict
        destination.editService = "edit"
    }
}
