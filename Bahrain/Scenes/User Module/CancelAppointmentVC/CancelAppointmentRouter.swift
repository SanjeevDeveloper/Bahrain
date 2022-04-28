
import UIKit

@objc protocol CancelAppointmentRoutingLogic
{
    func routeToMyAppoinmentVC()
}

protocol CancelAppointmentDataPassing
{
    var dataStore: CancelAppointmentDataStore? { get }
}

class CancelAppointmentRouter: NSObject, CancelAppointmentRoutingLogic, CancelAppointmentDataPassing
{
    weak var viewController: CancelAppointmentViewController?
    var dataStore: CancelAppointmentDataStore?
    
    // MARK: Routing
    func routeToMyAppoinmentVC() {
        for controller in (viewController?.navigationController?.viewControllers)! {
            if controller.isKind(of: MyAppointmentsViewController.self) {
                viewController?.navigationController?.popToViewController(controller, animated: true)
            }
        }
    }
    
    // MARK: Navigation
    
    //func navigateToSomewhere(source: CancelAppointmentViewController, destination: SomewhereViewController)
    //{
    //  viewController?.navigationController?.pushViewController(destination, animated: true)
    //}
    
    // MARK: Passing data
    
    //func passDataToSomewhere(source: CancelAppointmentDataStore, destination: inout SomewhereDataStore)
    //{
    //  destination.name = source.name
    //}
}
