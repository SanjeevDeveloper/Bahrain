
import UIKit

protocol ListScheduledBreakRoutingLogic
{
  func routeToAddTherapist(segue: UIStoryboardSegue?, scheduledArray: [AddScheduledBreak.ViewModel.tableCellData])
}

protocol ListScheduledBreakDataPassing
{
  var dataStore: ListScheduledBreakDataStore? { get }
}

class ListScheduledBreakRouter: NSObject, ListScheduledBreakRoutingLogic, ListScheduledBreakDataPassing
{
  
    
  weak var viewController: ListScheduledBreakViewController?
  var dataStore: ListScheduledBreakDataStore?
  
  // MARK: Routing
  
  func routeToAddTherapist(segue: UIStoryboardSegue?, scheduledArray: [AddScheduledBreak.ViewModel.tableCellData])
  {
    for controller in (viewController?.navigationController?.viewControllers)! {
        if controller.isKind(of: AddTherapistViewController.self) {
            let destinationVC = controller as! AddTherapistViewController
            var destinationDS = destinationVC.router!.dataStore!
            passDataToSomewhere(source: dataStore!, destination: &destinationDS, arr: scheduledArray)
            navigateToSomewhere(source: viewController!, destination: destinationVC)
        }
    }
  }

  // MARK: Navigation
  
  func navigateToSomewhere(source: ListScheduledBreakViewController, destination: AddTherapistViewController)
  {
    source.navigationController?.popViewController(animated: true)
  }
  
  // MARK: Passing data
  
  func passDataToSomewhere(source: ListScheduledBreakDataStore, destination: inout AddTherapistDataStore, arr: [AddScheduledBreak.ViewModel.tableCellData])
  {
    destination.scheduledArray = arr
    destination.screenName = "ListScheduledBreak"
  }
}
