
import UIKit

@objc protocol SpecialNewOffersRoutingLogic
{
  func routeToSettingVC()
}

protocol SpecialNewOffersDataPassing
{
  var dataStore: SpecialNewOffersDataStore? { get }
}

class SpecialNewOffersRouter: NSObject, SpecialNewOffersRoutingLogic, SpecialNewOffersDataPassing
{
  weak var viewController: SpecialNewOffersViewController?
  var dataStore: SpecialNewOffersDataStore?
  
  // MARK: Routing
  
    func routeToSettingVC() {
        let destinationVC = viewController?.storyboard?.instantiateViewController(withIdentifier: ViewControllersIds.SettingViewControllerID) as! SettingViewController
        
        viewController?.navigationController?.pushViewController(destinationVC, animated: true)
    }

  // MARK: Navigation
  
  //func navigateToSomewhere(source: SpecialNewOffersViewController, destination: SomewhereViewController)
  //{
  //  viewController?.navigationController?.pushViewController(destination, animated: true)
  //}
  
  // MARK: Passing data
  
  //func passDataToSomewhere(source: SpecialNewOffersDataStore, destination: inout SomewhereDataStore)
  //{
  //  destination.name = source.name
  //}
}
