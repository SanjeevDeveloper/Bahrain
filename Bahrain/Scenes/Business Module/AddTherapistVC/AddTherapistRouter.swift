
import UIKit

protocol AddTherapistRoutingLogic
{
    func routeToTherapistList()
    func routeToTherapistWorkingHour(segue: UIStoryboardSegue?, HoursArray: [TherapistWorkingHours.ViewModel.tableCellData]?)
    func routeToAddScheduledBreak(segue: UIStoryboardSegue?, therapistID:String, scheduledBreakArray: [AddScheduledBreak.ViewModel.tableCellData]?)
}

protocol AddTherapistDataPassing
{
    var dataStore: AddTherapistDataStore? { get }
}

class AddTherapistRouter: NSObject, AddTherapistRoutingLogic, AddTherapistDataPassing
{
    
    
    weak var viewController: AddTherapistViewController?
    var dataStore: AddTherapistDataStore?
    
    // MARK: Routing
    
    func routeToAddScheduledBreak(segue: UIStoryboardSegue?, therapistID:String, scheduledBreakArray: [AddScheduledBreak.ViewModel.tableCellData]?) {
        let destinationVC = viewController?.storyboard?.instantiateViewController(withIdentifier: ViewControllersIds.ListScheduledBreakViewControllerID) as! ListScheduledBreakViewController
        var destinationDS = destinationVC.router!.dataStore!
        passDataToAddScheduledBreak(source: dataStore!, destination: &destinationDS, therapistID: therapistID, scheduledBreakArray: scheduledBreakArray)
        navigateToAddScheduledBreak(source: viewController!, destination: destinationVC)
    }
    
    func routeToTherapistWorkingHour(segue: UIStoryboardSegue?, HoursArray: [TherapistWorkingHours.ViewModel.tableCellData]?)
    {
        let destinationVC = viewController?.storyboard?.instantiateViewController(withIdentifier: "TherapistWorkingHoursViewControllerID") as! TherapistWorkingHoursViewController
        var destinationDS = destinationVC.router!.dataStore!
        passDataToTherapistWorkingHour(source: dataStore!, destination: &destinationDS, HoursArray: HoursArray)
        navigateToHours(source: viewController!, destination: destinationVC)
        
    }
    
    
    func routeToTherapistList() {
        if appDelegateObj.isPageControlActive {
            viewController?.navigationController?.popViewController(animated: true)
        }
        else {
            for controller in (viewController?.navigationController?.viewControllers)! {
                if controller.isKind(of: TherapistListViewController.self) {
                    let destinationVC = controller as! TherapistListViewController
                    var destinationDS = destinationVC.router!.dataStore!
                    passDataToSomewhere(source: dataStore!, destination: &destinationDS)
                    navigateToSomewhere(source: viewController!, destination: destinationVC)
                }
            }
        }
        
    }
    
    // MARK: Navigation
    
    func navigateToSomewhere(source: AddTherapistViewController, destination: TherapistListViewController)
    {
        source.navigationController?.popViewController(animated: true)
    }
    
    func navigateToHours(source: AddTherapistViewController, destination: TherapistWorkingHoursViewController)
    {
        viewController?.navigationController?.pushViewController(destination, animated: true)
    }
    
    func navigateToAddScheduledBreak(source: AddTherapistViewController, destination: ListScheduledBreakViewController)
    {
        viewController?.navigationController?.pushViewController(destination, animated: true)
    }
    
    // MARK: Passing data
    
    func passDataToTherapistWorkingHour(source: AddTherapistDataStore, destination: inout TherapistWorkingHoursDataStore, HoursArray: [TherapistWorkingHours.ViewModel.tableCellData]?)
    {
        destination.workingHourArray = HoursArray
    }
    
    
    func passDataToSomewhere(source: AddTherapistDataStore, destination: inout TherapistListDataStore)
    {
        //destination.therapistsArray.append(source.therapistObj!)
        destination.screenName = "addTherapistScreen"
    }
    
    func passDataToAddScheduledBreak(source: AddTherapistDataStore, destination: inout ListScheduledBreakDataStore, therapistID:String, scheduledBreakArray: [AddScheduledBreak.ViewModel.tableCellData]?)
    {
        destination.scheduledArray = scheduledBreakArray
        destination.therapistID = therapistID
        destination.screenName = "edit"
    }
    
}
