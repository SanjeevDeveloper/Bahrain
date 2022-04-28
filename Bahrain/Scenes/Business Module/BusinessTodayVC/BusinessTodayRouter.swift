
import UIKit

 protocol BusinessTodayRoutingLogic
{
  func routeToAppoinmentDetail(segue: UIStoryboardSegue?, orderDetailArray: BusinessToday.ViewModel.tableCellData)
}

protocol BusinessTodayDataPassing
{
  var dataStore: BusinessTodayDataStore? { get }
}

class BusinessTodayRouter: NSObject, BusinessTodayRoutingLogic, BusinessTodayDataPassing
{
    
    
  weak var viewController: BusinessTodayViewController?
  var dataStore: BusinessTodayDataStore?
  
  // MARK: Routing
  
    func routeToAppoinmentDetail(segue: UIStoryboardSegue?, orderDetailArray: BusinessToday.ViewModel.tableCellData) {
        let destinationVC = viewController?.storyboard?.instantiateViewController(withIdentifier: ViewControllersIds.BusinessAppointmentDetailViewControllerID) as! BusinessAppointmentDetailViewController
        var destinationDS = destinationVC.router!.dataStore!
        passDataToSomewhere(source: dataStore!, destination: &destinationDS, orderDetailArray: orderDetailArray)
        navigateToSomewhere(source: viewController!, destination: destinationVC)
    }

  // MARK: Navigation
  
  func navigateToSomewhere(source: BusinessTodayViewController, destination: BusinessAppointmentDetailViewController)
  {
    viewController?.navigationController?.pushViewController(destination, animated: true)
  }
  
  // MARK: Passing data
  
  func passDataToSomewhere(source: BusinessTodayDataStore, destination: inout BusinessAppointmentDetailDataStore, orderDetailArray: BusinessToday.ViewModel.tableCellData)
  {
    destination.orderDetailArray = orderDetailArray
  }
}
