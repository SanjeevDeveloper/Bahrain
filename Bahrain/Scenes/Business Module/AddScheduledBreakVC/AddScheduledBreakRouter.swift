
import UIKit

 protocol AddScheduledBreakRoutingLogic
{
    func routeToSomewhere(scheduledArray: AddScheduledBreak.ViewModel.tableCellData?)
}

protocol AddScheduledBreakDataPassing
{
  var dataStore: AddScheduledBreakDataStore? { get }
}

class AddScheduledBreakRouter: NSObject, AddScheduledBreakRoutingLogic, AddScheduledBreakDataPassing
{
   
  weak var viewController: AddScheduledBreakViewController?
  var dataStore: AddScheduledBreakDataStore?
  
  // MARK: Routing
  
  func routeToSomewhere(scheduledArray: AddScheduledBreak.ViewModel.tableCellData?)
  {
    for controller in (viewController?.navigationController?.viewControllers)! {
        if controller.isKind(of: ListScheduledBreakViewController.self) {
            let destinationVC = controller as! ListScheduledBreakViewController
            var destinationDS = destinationVC.router!.dataStore!
            passDataToSomewhere( destination: &destinationDS, scheduledArray: scheduledArray)
            navigateToSomewhere(source: viewController!)
        }
    }
  }

  // MARK: Navigation
  
  func navigateToSomewhere(source: AddScheduledBreakViewController)
  {
     source.navigationController?.popViewController(animated: true)
  }
  
  // MARK: Passing data
  
  func passDataToSomewhere(destination: inout ListScheduledBreakDataStore, scheduledArray: AddScheduledBreak.ViewModel.tableCellData?)
  {
    destination.scheduledBreakArray = scheduledArray
    destination.screenName = "addBraek"
  }
}

