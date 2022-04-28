
import UIKit

@objc protocol SearchRoutingLogic
{
    func routeToSaloonDetail(businessId:String)
    func routeToSelectArea(segue: UIStoryboardSegue?)
    func routeToFilterScreen(segue: UIStoryboardSegue?,minimumValue: NSNumber,MaximumValue:NSNumber)
}

protocol SearchDataPassing
{
    var dataStore: SearchDataStore? { get }
}

class SearchRouter: NSObject, SearchRoutingLogic, SearchDataPassing
{
    
    
    weak var viewController: SearchViewController?
    var dataStore: SearchDataStore?
    
    // MARK: Routing
    
    func routeToSaloonDetail(businessId:String)
    {
        let storyboard = AppStoryboard.Main.instance
        let destinationVC = storyboard.instantiateViewController(withIdentifier: ViewControllersIds.SalonDetailViewControllerID) as! SalonDetailViewController
        var destinationDS = destinationVC.router!.dataStore!
        passDataToSalonDetail(businessId: businessId, destination: &destinationDS)
        navigateToSomewhere(source: viewController!, destination: destinationVC)
    }
    
    // MARK: Navigation
    
    func navigateToSomewhere(source: SearchViewController, destination: SalonDetailViewController)
    {
        viewController?.navigationController?.pushViewController(destination, animated: true)
    }
    
    // MARK: Passing data
    
    func passDataToSalonDetail(businessId: String, destination: inout SalonDetailDataStore)
    {
        destination.saloonId = businessId
    }
    
    func routeToSelectArea(segue: UIStoryboardSegue?)
    {
        let destinationVC = viewController?.storyboard?.instantiateViewController(withIdentifier: "PreferredLocationViewController") as! PreferredLocationViewController
        destinationVC.updateListingWithCoordinate = { (lat, long) in
            self.viewController?.showSalonsOnTheBasisOfCoordinates(lat: lat, long: long)
        }
        viewController?.navigationController?.pushViewController(destinationVC, animated: true)
        
//        let destinationVC = segue?.destination as! SelectAreaUserViewController
//        var destinationDS = destinationVC.router!.dataStore!
//        passDataToSelectArea(source: dataStore!, destination: &destinationDS)
    }
    
    func routeToFilterScreen(segue: UIStoryboardSegue?, minimumValue: NSNumber, MaximumValue: NSNumber) {
        let destinationVC = segue!.destination as! FilterViewController
        var destinationDS = destinationVC.router!.dataStore!
        passDataTofilter(source: self.dataStore!, destination: &destinationDS, minimumValue: minimumValue, MaximumValue: MaximumValue)
    }
    
    func passDataTofilter(source: SearchDataStore, destination: inout FilterDataStore,minimumValue: NSNumber,MaximumValue:NSNumber)
    {
        if source.filterDict != nil {
            destination.filterDict = source.filterDict!
        }
        destination.filterCategoryArr = source.filterCategoryArr
        destination.paymentArr = source.paymentArr
        destination.minimumValue = minimumValue
        destination.maximumValue = MaximumValue
        destination.fromFav = "searchVC"
    }
    
    func passDataToSelectArea(source: SearchDataStore, destination: inout SelectAreaUserDataStore)
    {
        destination.screenName = "Search"
        destination.selectedArea = source.selectedArea
    }
}



