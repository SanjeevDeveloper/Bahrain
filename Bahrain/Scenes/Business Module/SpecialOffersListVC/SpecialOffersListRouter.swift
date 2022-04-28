
import UIKit

@objc protocol SpecialOffersListRoutingLogic
{
  func routeToEditOffer()
}

protocol SpecialOffersListDataPassing
{
  var dataStore: SpecialOffersListDataStore? { get }
}

class SpecialOffersListRouter: NSObject, SpecialOffersListRoutingLogic, SpecialOffersListDataPassing
{
  weak var viewController: SpecialOffersListViewController?
  var dataStore: SpecialOffersListDataStore?
  
  // MARK: Routing
  
  func routeToEditOffer()
  {
    let destinationVC = viewController?.storyboard?.instantiateViewController(withIdentifier: ViewControllersIds.AddSpecialOfferViewControllerID) as! AddSpecialOfferViewController
      var destinationDS = destinationVC.router!.dataStore!
      passDataToSomewhere(source: dataStore!, destination: &destinationDS)
      navigateToSomewhere(source: viewController!, destination: destinationVC)
    
  }

  // MARK: Navigation
  
  func navigateToSomewhere(source: SpecialOffersListViewController, destination: AddSpecialOfferViewController)
  {
    viewController?.navigationController?.pushViewController(destination, animated: true)
  }
  
  // MARK: Passing data
  
  func passDataToSomewhere(source: SpecialOffersListDataStore, destination: inout AddSpecialOfferDataStore)
  {
    let selectedIndex = viewController?.offerListTableView.indexPathForSelectedRow
    destination.offerObj = source.offersArray.object(at: selectedIndex!.section) as AnyObject
  }
}
