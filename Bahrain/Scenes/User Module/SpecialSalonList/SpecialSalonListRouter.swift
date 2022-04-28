
import UIKit

@objc protocol SpecialSalonListRoutingLogic {
    func routeToSaloonDetail(businessId:String)
}

protocol SpecialSalonListDataPassing {
    var dataStore: SpecialSalonListDataStore? { get }
}

class SpecialSalonListRouter: NSObject, SpecialSalonListRoutingLogic, SpecialSalonListDataPassing {
    weak var viewController: SpecialSalonListViewController?
    var dataStore: SpecialSalonListDataStore?
    
    // MARK: Routing
    
    func routeToSaloonDetail(businessId:String)
    {
        let storyboard = AppStoryboard.Main.instance
        let destinationVC = storyboard.instantiateViewController(withIdentifier: ViewControllersIds.SalonDetailViewControllerID) as! SalonDetailViewController
        destinationVC.isFromSpecialSalon = true
        var destinationDS = destinationVC.router!.dataStore!
        passDataToSalonDetail(businessId: businessId, destination: &destinationDS)
        navigateToSomewhere(source: viewController!, destination: destinationVC)
    }
    
    // MARK: Navigation
    
    func navigateToSomewhere(source: SpecialSalonListViewController, destination: SalonDetailViewController)
    {
        viewController?.navigationController?.pushViewController(destination, animated: true)
    }
    
    // MARK: Passing data
    
    func passDataToSalonDetail(businessId: String, destination: inout SalonDetailDataStore)
    {
        destination.saloonId = businessId
    }
}
