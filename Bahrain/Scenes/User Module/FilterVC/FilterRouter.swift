
import UIKit

protocol FilterRoutingLogic
{
    func routeToSelectArea(segue: UIStoryboardSegue?)
    func routeToFavouriteScreen(segue: UIStoryboardSegue?, dict: NSDictionary, categoriesArr: [Filter.ViewModel.tableCellData], paymentArr: [Filter.PaymentViewModel.tableCellData],isClearFilter : Bool)
}

protocol FilterDataPassing
{
    var dataStore: FilterDataStore? { get }
}

class FilterRouter: NSObject, FilterRoutingLogic, FilterDataPassing
{
    
    weak var viewController: FilterViewController?
    var dataStore: FilterDataStore?
    
    // MARK: Routing
    
    func routeToSelectArea(segue: UIStoryboardSegue?)
    {
        let destinationVC = segue?.destination as! SelectAreaUserViewController
        var destinationDS = destinationVC.router!.dataStore!
        passDataToSomewhere(source: dataStore!, destination: &destinationDS)
    }
    
    
    func routeToFavouriteScreen(segue: UIStoryboardSegue?, dict: NSDictionary, categoriesArr: [Filter.ViewModel.tableCellData], paymentArr: [Filter.PaymentViewModel.tableCellData],isClearFilter : Bool) {
        //        if let segue = segue {
        //            let destinationVC = segue.destination as! FavoriteListViewController
        //            var destinationDS = destinationVC.router!.dataStore!
        //            passDataToFavorite(source: dataStore!, destination: &destinationDS, dict: dict, categoriesArr: categoriesArr, paymentArr: paymentArr, isClearFilter: isClearFilter)
        //        } else {
        
        for controller in (viewController?.navigationController?.viewControllers)! {
            if controller.isKind(of: FavoriteListViewController.self) {
                let destinationVC = controller as! FavoriteListViewController
                var destinationDS = destinationVC.router!.dataStore!
                passDataToFavorite(source: dataStore!, destination: &destinationDS, dict: dict, categoriesArr: categoriesArr, paymentArr: paymentArr,isClearFilter : isClearFilter)
                navigateToSomewhere(source: viewController!, destination: destinationVC)
            }
            else if controller.isKind(of: SearchViewController.self){
                let destinationVC = controller as! SearchViewController
                var destinationDS = destinationVC.router!.dataStore!
                
                passDataToSearch(source: dataStore!, destination: &destinationDS, dict: dict, categoriesArr: categoriesArr, paymentArr: paymentArr,isClearFilter : isClearFilter)
                navigateToSearch(source: viewController!, destination: destinationVC)
            }
            else if controller.isKind(of: SpecialOfferUserViewController.self){
                let destinationVC = controller as! SpecialOfferUserViewController
                var destinationDS = destinationVC.router!.dataStore!
                
                passDataToSpecialOffer(source: dataStore!, destination: &destinationDS, dict: dict, categoriesArr: categoriesArr, paymentArr: paymentArr,isClearFilter : isClearFilter)
                navigateToSpecialOffer(source: viewController!, destination: destinationVC)
            }
        }
        //        }
    }
    
    // MARK: Navigation
    
    func navigateToSomewhere(source: FilterViewController, destination: FavoriteListViewController)
    {
        source.navigationController?.popViewController(animated: true)
    }
    func navigateToSearch(source: FilterViewController, destination: SearchViewController)
    {
        source.navigationController?.popViewController(animated: true)
    }
    
    func navigateToSpecialOffer(source: FilterViewController, destination: SpecialOfferUserViewController)
    {
        source.navigationController?.popViewController(animated: true)
    }
    
    // MARK: Passing data
    
    func passDataToSomewhere(source: FilterDataStore, destination: inout SelectAreaUserDataStore)
    {
        destination.screenName = "filter"
    }
    
    func passDataToFavorite(source: FilterDataStore, destination: inout FavoriteListDataStore, dict: NSDictionary, categoriesArr: [Filter.ViewModel.tableCellData], paymentArr: [Filter.PaymentViewModel.tableCellData],isClearFilter : Bool)
    {
        destination.filterDict = dict
        if isClearFilter{
            destination.fromScreen = "clearFilter"
        }else{
            destination.fromScreen = "filter"
        }
        destination.filterCategoryArr = categoriesArr
        destination.paymentArr = paymentArr
        destination.isFavoriteString = source.isFavorite
        destination.isclear = isClearFilter
        destination.selectedArea = nil
    }
    
    func passDataToSearch(source: FilterDataStore, destination: inout SearchDataStore, dict: NSDictionary, categoriesArr: [Filter.ViewModel.tableCellData], paymentArr: [Filter.PaymentViewModel.tableCellData],isClearFilter : Bool)
    {
        destination.filterDict = dict
        if isClearFilter{
            destination.filterData = "clearFilter"
        }else{
            destination.filterData = "filter"
        }
        destination.filterCategoryArr = categoriesArr
        destination.paymentArr = paymentArr
        destination.isclear = isClearFilter
      destination.selectedArea = nil
    }
    
    func passDataToSpecialOffer(source: FilterDataStore, destination: inout SpecialOfferUserDataStore, dict: NSDictionary, categoriesArr: [Filter.ViewModel.tableCellData], paymentArr: [Filter.PaymentViewModel.tableCellData],isClearFilter : Bool)
    {
        destination.filterDict = dict
        if isClearFilter{
            destination.filterData = "clearFilter"
        }else{
            destination.filterData = "filter"
        }
        destination.filterCategoryArr = categoriesArr
        destination.paymentArr = paymentArr
        destination.isclear = isClearFilter
    }
    
}
