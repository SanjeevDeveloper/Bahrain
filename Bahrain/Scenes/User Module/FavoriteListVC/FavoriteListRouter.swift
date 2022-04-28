
import UIKit

 protocol FavoriteListRoutingLogic
{
    func routeToSaloonDetail(businessId:String)
    func routeToFilterScreen(segue: UIStoryboardSegue?,minimumValue: NSNumber,MaximumValue:NSNumber,isFavorite:String)
    func routeToMap(segue: UIStoryboardSegue?, saloonArray:[FavoriteList.ApiViewModel.tableCellData])
    func routeToSelectArea(segue: UIStoryboardSegue?,isFavorite:String)
}

protocol FavoriteListDataPassing
{
  var dataStore: FavoriteListDataStore? { get }
}

class FavoriteListRouter: NSObject, FavoriteListRoutingLogic, FavoriteListDataPassing
{
  weak var viewController: FavoriteListViewController?
  var dataStore: FavoriteListDataStore?
  
  // MARK: Routing
  
  func routeToSaloonDetail(businessId:String) {
    let storyboard = AppStoryboard.Main.instance
        let destinationVC = storyboard.instantiateViewController(withIdentifier: ViewControllersIds.SalonDetailViewControllerID) as! SalonDetailViewController
        var destinationDS = destinationVC.router!.dataStore!
        passDataToSalonDetail(businessId: businessId, destination: &destinationDS)
        navigateToSomewhere(source: viewController!, destination: destinationVC)
  }
    
    
    func routeToMap(segue: UIStoryboardSegue?, saloonArray:[FavoriteList.ApiViewModel.tableCellData]) {
        let destinationVC = segue?.destination as! SaloonMapListVC
        destinationVC.saloonsArray = saloonArray
    }
    
    
  func routeToFilterScreen(segue: UIStoryboardSegue?,minimumValue: NSNumber,MaximumValue:NSNumber,isFavorite:String) {
    let destinationVC = segue!.destination as! FilterViewController
    var destinationDS = destinationVC.router!.dataStore!
    passDataTofilter(source: self.dataStore!, destination: &destinationDS, minimumValue: minimumValue, MaximumValue: MaximumValue,isFavorite:isFavorite)
  }
    
    func routeToSelectArea(segue: UIStoryboardSegue?,isFavorite:String)
    {
        let destinationVC = segue?.destination as! SelectAreaUserViewController
        var destinationDS = destinationVC.router!.dataStore!
        passDataToSelectArea(source: dataStore!, destination: &destinationDS, isFavorite: isFavorite)
    }
    
    // MARK: Navigation
    
    func navigateToSomewhere(source: FavoriteListViewController, destination: SalonDetailViewController)
    {
      viewController?.navigationController?.pushViewController(destination, animated: true)
    }
  
  // MARK: Passing data
  
  func passDataToSalonDetail(businessId: String, destination: inout SalonDetailDataStore)
  {
    destination.saloonId = businessId
  }
    
    func passDataTofilter(source: FavoriteListDataStore, destination: inout FilterDataStore,minimumValue: NSNumber,MaximumValue:NSNumber,isFavorite:String)
    {
        destination.filterDict = source.filterDict
        destination.filterCategoryArr = source.filterCategoryArr
        printToConsole(item: source.filterDict)
        destination.paymentArr = source.paymentArr
        destination.fromFav = isFavorite
        destination.minimumValue = minimumValue
        destination.maximumValue = MaximumValue
        destination.isFavorite = isFavorite // not used
        destination.serviceName = source.name
    }
    
    func passDataToSelectArea(source: FavoriteListDataStore, destination: inout SelectAreaUserDataStore, isFavorite:String)
    {
        destination.screenName = "Favorite"
        destination.categoryType = isFavorite
      destination.selectedArea = source.selectedArea
    }
}
