
import UIKit

@objc protocol HomeRoutingLogic
{
    func routeToFavoriteList(serviceId:String?, categoryId:String?, name:String?, reqTitle:String?)
    func routeToSearch()
    func routeToSaloonDetail(businessId:String)
    func routeToRateReview()
    func routeToSpecialSalonListing()
}

protocol HomeDataPassing
{
  var dataStore: HomeDataStore? { get }
}

class HomeRouter: NSObject, HomeRoutingLogic, HomeDataPassing
{
   
  weak var viewController: HomeViewController?
  var dataStore: HomeDataStore?
  
  // MARK: Routing
  
    func routeToSearch() {
        let storyboard = AppStoryboard.Main.instance
        let destinationVC = storyboard.instantiateViewController(withIdentifier: ViewControllersIds.SearchViewControllerID) as! SearchViewController
        navigateToSearch(source: viewController!, destination: destinationVC)
    }
    
    func routeToSaloonDetail(businessId:String) {
        let storyboard = AppStoryboard.Main.instance
        let destinationVC = storyboard.instantiateViewController(withIdentifier: ViewControllersIds.SalonDetailViewControllerID) as! SalonDetailViewController
        var destinationDS = destinationVC.router!.dataStore!
        passDataToSalonDetail(businessId: businessId, destination: &destinationDS)
        navigateToSalonDetail(source: viewController!, destination: destinationVC)
    }
    
    func routeToRateReview() {
        let storyboard = AppStoryboard.Main.instance
        let destinationVC = storyboard.instantiateViewController(withIdentifier: ViewControllersIds.rateReviewViewControllerID) as! rateReviewViewController
        var destinationDS = destinationVC.router!.dataStore!
        passDataToRateReview(destination: &destinationDS)
        navigateToRateReview(source: viewController!, destination: destinationVC)
    }
    
    func routeToSpecialSalonListing() {
        let destinationVC = viewController?.storyboard?.instantiateViewController(withIdentifier: ViewControllersIds.specialSalonListViewControllerId) as! SpecialSalonListViewController
       viewController?.navigationController?.pushViewController(destinationVC, animated: true)
    }
    
  func routeToFavoriteList(serviceId:String?, categoryId:String?, name:String?, reqTitle:String?)
  {
      let storyboard = AppStoryboard.Main.instance
      let destinationVC = storyboard.instantiateViewController(withIdentifier: ViewControllersIds.FavoriteListViewControllerID) as! FavoriteListViewController
      var destinationDS = destinationVC.router!.dataStore!
      passDataToSomewhere(serviceId:serviceId, categoryId: categoryId, name: name, reqName: reqTitle, destination: &destinationDS)
      navigateToSomewhere(source: viewController!, destination: destinationVC)
    
  }

  // MARK: Navigation
  
  func navigateToSomewhere(source: HomeViewController, destination: FavoriteListViewController)
  {
    viewController?.navigationController?.pushViewController(destination, animated: true)
  }
    
   func navigateToSearch(source: HomeViewController, destination: SearchViewController)
    {
        viewController?.navigationController?.pushViewController(destination, animated: true)
    }
    
    func navigateToSalonDetail(source: HomeViewController, destination: SalonDetailViewController)
    {
        viewController?.navigationController?.pushViewController(destination, animated: true)
    }
    
    func navigateToRateReview(source: HomeViewController, destination: rateReviewViewController)
    {
        viewController?.navigationController?.pushViewController(destination, animated: true)
    }

  // MARK: Passing data
    
    func passDataToSalonDetail(businessId: String, destination: inout SalonDetailDataStore)
    {
        destination.saloonId = businessId
    }
    
    func passDataToRateReview(destination: inout rateReviewDataStore)
    {
        destination.salonId = appDelegateObj.salonId
        destination.notificationId = appDelegateObj.notifyId
        destination.dataArray = appDelegateObj.rateDataArray
    }
  
    func passDataToSomewhere(serviceId:String?, categoryId:String?, name:String?, reqName:String?, destination: inout FavoriteListDataStore)
  {
    destination.categoryId = categoryId
    destination.name = name
    destination.reqName = reqName
    destination.serviceId = serviceId
  }
}
