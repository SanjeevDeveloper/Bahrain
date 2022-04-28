
import UIKit

protocol MyAppointmentsRoutingLogic
{
    func routeToOrderDetail(segue: UIStoryboardSegue?, orderDetailArray: MyAppointments.ViewModel.tableCellData, tableViewName: Bool, appoinmentId:String)
    func routeToCancelAppointment(appoinmentId:String)
}

protocol MyAppointmentsDataPassing
{
    var dataStore: MyAppointmentsDataStore? { get }
}

class MyAppointmentsRouter: NSObject, MyAppointmentsRoutingLogic, MyAppointmentsDataPassing
{
    
    
    weak var viewController: MyAppointmentsViewController?
    var dataStore: MyAppointmentsDataStore?
    
    // MARK: Routing
    
    func routeToOrderDetail(segue: UIStoryboardSegue?, orderDetailArray: MyAppointments.ViewModel.tableCellData, tableViewName: Bool, appoinmentId:String)
    {
        let destinationVC = viewController?.storyboard?.instantiateViewController(withIdentifier: ViewControllersIds.OrderDetailViewControllerID) as! OrderDetailViewController
        var destinationDS = destinationVC.router!.dataStore!
        passDataToSomewhere(source: dataStore!, destination: &destinationDS, orderDetailArray: orderDetailArray, tableViewName: tableViewName, id: appoinmentId)
        navigateToSomewhere(source: viewController!, destination: destinationVC)
    }
    
    func routeToCancelAppointment(appoinmentId:String) {
        let destinationVC = viewController?.storyboard?.instantiateViewController(withIdentifier: ViewControllersIds.CancelAppointmentViewControllerID) as! CancelAppointmentViewController
        var destinationDS = destinationVC.router!.dataStore!
        passDataToCancelAppointment(source: dataStore!, destination: &destinationDS, id: appoinmentId)
        navigateToCancelAppointment(source: viewController!, destination: destinationVC)
    }
    
    // MARK: Navigation
    
    func navigateToSomewhere(source: MyAppointmentsViewController, destination: OrderDetailViewController)
    {
        viewController?.navigationController?.pushViewController(destination, animated: true)
    }
    
    func navigateToCancelAppointment(source: MyAppointmentsViewController, destination: CancelAppointmentViewController)
    {
        viewController?.navigationController?.pushViewController(destination, animated: true)
    }
    
    // MARK: Passing data
    
    func passDataToSomewhere(source: MyAppointmentsDataStore, destination: inout OrderDetailDataStore, orderDetailArray: MyAppointments.ViewModel.tableCellData, tableViewName: Bool, id:String)
    {
        //destination.orderDetailArray = orderDetailArray
        destination.tableScreen = tableViewName
        destination.bookingId = id
    }
    
    func passDataToCancelAppointment(source: MyAppointmentsDataStore, destination: inout CancelAppointmentDataStore, id:String)
    {
        destination.appoinmentId = id
    }
    
}
