
import UIKit

@objc protocol RateServicesRoutingLogic
{
   func routeToRateReview()
}

protocol RateServicesDataPassing
{
  var dataStore: RateServicesDataStore? { get }
}

class RateServicesRouter: NSObject, RateServicesRoutingLogic, RateServicesDataPassing
{
  weak var viewController: RateServicesViewController?
  var dataStore: RateServicesDataStore?
  
  // MARK: Routing
  
  func routeToRateReview()
  {
    for controller in (viewController?.navigationController?.viewControllers)! {
        if controller.isKind(of: rateReviewViewController.self) {
    
            let destinationVC = controller as! rateReviewViewController
            var destinationDS = destinationVC.router!.dataStore!
            passDataToSomewhere(source: dataStore!, destination: &destinationDS)
            navigateToSomewhere(source: viewController!, destination: destinationVC)
            appDelegateObj.isRateUs = false
            
        }
    }
  }

  // MARK: Navigation
  
  func navigateToSomewhere(source: RateServicesViewController, destination: rateReviewViewController)
  {
    source.navigationController?.popViewController(animated: true)
  }
  
  // MARK: Passing data
  
  func passDataToSomewhere(source: RateServicesDataStore, destination: inout rateReviewDataStore)
  {
    destination.isRated = true
    
  }
}
