

import UIKit

@objc protocol BusinessBookingRoutingLogic
{
  func routeToClientList()
    func routeToTodayList()
}

protocol BusinessBookingDataPassing
{
  var dataStore: BusinessBookingDataStore? { get }
}

class BusinessBookingRouter: NSObject, BusinessBookingRoutingLogic, BusinessBookingDataPassing
{
   
  weak var viewController: BusinessBookingViewController?
  var dataStore: BusinessBookingDataStore?
  
  // MARK: Routing
  
    func routeToClientList()
    {
        let destinationVC = viewController?.storyboard?.instantiateViewController(withIdentifier: ViewControllersIds.ClientListViewControllerID) as! ClientListViewController
        var destinationDS = destinationVC.router!.dataStore!
        passDataToSomewhere(source: dataStore!, destination: &destinationDS)
        navigateToSomewhere(source: viewController!, destination: destinationVC)
    }
    
    func routeToTodayList() {
        let vcObj = self.viewController?.storyboard?.instantiateViewController(withIdentifier: ViewControllersIds.BusinessTodayViewControllerID) as? BusinessTodayViewController
        self.viewController?.navigationController?.pushViewController(vcObj!, animated: true)
    }
    
    
    // MARK: Navigation
    
    func navigateToSomewhere(source: BusinessBookingViewController, destination: ClientListViewController)
    {
        viewController?.navigationController?.pushViewController(destination, animated: true)
    }
    
    // MARK: Passing data
    
    func passDataToSomewhere(source: BusinessBookingDataStore, destination: inout ClientListDataStore)
    {
       destination.fromBusinessBookingScreen = "BusinessBooking"
    }

  
}
