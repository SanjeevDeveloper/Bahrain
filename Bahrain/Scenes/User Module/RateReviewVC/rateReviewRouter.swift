
import UIKit

@objc protocol rateReviewRoutingLogic
{
  func routeToRateUs(segue: UIStoryboardSegue?)
}

protocol rateReviewDataPassing
{
  var dataStore: rateReviewDataStore? { get }
}

class rateReviewRouter: NSObject, rateReviewRoutingLogic, rateReviewDataPassing
{
  weak var viewController: rateReviewViewController?
  var dataStore: rateReviewDataStore?
  
  // MARK: Routing
  
  func routeToRateUs(segue: UIStoryboardSegue?)
  {
    let destinationVC = segue?.destination as! RateServicesViewController
    var destinationDS = destinationVC.router!.dataStore!
    passDataToSomewhere(source: dataStore!, destination: &destinationDS)
  }

  // MARK: Navigation
  
//  func navigateToSomewhere(source: rateReviewViewController, destination: SomewhereViewController)
//  {
//    viewController?.navigationController?.pushViewController(destination, animated: true)
//  }
  
  // MARK: Passing data
  
  func passDataToSomewhere(source: rateReviewDataStore, destination: inout RateServicesDataStore)
  {
    destination.salonId = source.salonId
    destination.dataArray = source.dataArray
    destination.notificationId = source.notificationId
  }
}
