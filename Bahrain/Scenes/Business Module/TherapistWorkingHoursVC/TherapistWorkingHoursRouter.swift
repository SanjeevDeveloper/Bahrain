
import UIKit

 protocol TherapistWorkingHoursRoutingLogic
{
    func routeToAddTherapist(segue: UIStoryboardSegue?, hoursArray:
[TherapistWorkingHours.ViewModel.tableCellData])
}

protocol TherapistWorkingHoursDataPassing
{
  var dataStore: TherapistWorkingHoursDataStore? { get }
}

class TherapistWorkingHoursRouter: NSObject, TherapistWorkingHoursRoutingLogic, TherapistWorkingHoursDataPassing
{

  weak var viewController: TherapistWorkingHoursViewController?
  var dataStore: TherapistWorkingHoursDataStore?
  
  // MARK: Routing
  
  func routeToAddTherapist(segue: UIStoryboardSegue?, hoursArray: [TherapistWorkingHours.ViewModel.tableCellData])
  {
    for controller in (viewController?.navigationController?.viewControllers)! {
        if controller.isKind(of: AddTherapistViewController.self) {
            let destinationVC = controller as! AddTherapistViewController
            var destinationDS = destinationVC.router!.dataStore!
            passDataToSomewhere(source: dataStore!, destination: &destinationDS, arr: hoursArray)
            navigateToSomewhere(source: viewController!, destination: destinationVC)
        }
    }
   
  }
   
  // MARK: Navigation
  
  func navigateToSomewhere(source: TherapistWorkingHoursViewController, destination: AddTherapistViewController)
  {
    source.navigationController?.popViewController(animated: true)
  }
  
  // MARK: Passing data
  
  func passDataToSomewhere(source: TherapistWorkingHoursDataStore, destination: inout AddTherapistDataStore, arr: [TherapistWorkingHours.ViewModel.tableCellData])
  {
    destination.hoursArray = arr
    destination.screenName = "therapistWorkingHours"
  }
}
