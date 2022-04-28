
import UIKit

@objc protocol CardDetailRoutingLogic
{
   func routeToHomeVC()
}

protocol CardDetailDataPassing
{
  var dataStore: CardDetailDataStore? { get }
}

class CardDetailRouter: NSObject, CardDetailRoutingLogic, CardDetailDataPassing
{
  weak var viewController: CardDetailViewController?
  var dataStore: CardDetailDataStore?
  
  // MARK: Routing
  
    func routeToHomeVC() {
        for controller in (viewController?.navigationController?.viewControllers)! {
            if controller.isKind(of: HomeViewController.self) {
                viewController?.navigationController?.popToViewController(controller, animated: true)
            }
        }
    }

  // MARK: Navigation
  
  //func navigateToSomewhere(source: CardDetailViewController, destination: SomewhereViewController)
  //{
  //  viewController?.navigationController?.pushViewController(destination, animated: true)
  //}
  
  // MARK: Passing data
  
  //func passDataToSomewhere(source: CardDetailDataStore, destination: inout SomewhereDataStore)
  //{
  //  destination.name = source.name
  //}
}
