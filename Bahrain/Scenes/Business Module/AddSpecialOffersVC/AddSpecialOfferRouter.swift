
import UIKit

@objc protocol AddSpecialOfferRoutingLogic
{
  func routeToPreview()
}

protocol AddSpecialOfferDataPassing
{
  var dataStore: AddSpecialOfferDataStore? { get }
}

class AddSpecialOfferRouter: NSObject, AddSpecialOfferRoutingLogic, AddSpecialOfferDataPassing
{
  weak var viewController: AddSpecialOfferViewController?
  var dataStore: AddSpecialOfferDataStore?
  
  // MARK: Routing
  
    func routeToPreview() {
        let destinationVC = viewController?.storyboard?.instantiateViewController(withIdentifier: ViewControllersIds.SpecialNewOffersViewControllerID) as! SpecialNewOffersViewController
        var ds = destinationVC.router?.dataStore
        
        passDataToPreview(destination: &ds!)
        viewController?.navigationController?.pushViewController(destinationVC, animated: true)
    }
 
    func passDataToPreview(destination: inout SpecialNewOffersDataStore)
    {
        destination.selectedServicesArray = self.dataStore?.selectedServicesArray
        destination.offerName = self.dataStore?.offerName
        destination.offerObj = self.dataStore?.offerObj
        destination.offerImage = self.dataStore?.offerImage
        destination.isHome = self.dataStore?.isHome
    }
}
