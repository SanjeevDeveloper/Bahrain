
import UIKit

@objc protocol SelectAreaUserRoutingLogic
{
    func routeToProfileSetting(selectAreaText:String)
    func routeToFilterScreen(selectAreaText:String)
    func routeToRegisterLocationScreen(selectAreaText:String, capitalName: String)
    func routeToBusinessLocation(selectAreaText:String)
    func routeToFavoriteScreen(selectAreaText:String)
    func routeToSearchScreen(selectAreaText:String)
    
}

protocol SelectAreaUserDataPassing
{
    var dataStore: SelectAreaUserDataStore? { get }
}

class SelectAreaUserRouter: NSObject, SelectAreaUserRoutingLogic, SelectAreaUserDataPassing
{
    
    weak var viewController: SelectAreaUserViewController?
    var dataStore: SelectAreaUserDataStore?
    
    // MARK: Routing
    
    func routeToProfileSetting(selectAreaText:String)
    {
        for controller in (viewController?.navigationController?.viewControllers)! {
            if controller.isKind(of: ProfileSettingViewController.self) {
                let destinationVC = controller as! ProfileSettingViewController
                var destinationDS = destinationVC.router!.dataStore!
                passDataToProfileScreen( destination: &destinationDS, passSelectAreaText: selectAreaText)
                navigateBack(source: viewController!)
            }
        }
        
    }
    
    func routeToFilterScreen(selectAreaText:String)
    {
        for controller in (viewController?.navigationController?.viewControllers)! {
            if controller.isKind(of: FilterViewController.self) {
                let destinationVC = controller as! FilterViewController
                var destinationDS = destinationVC.router!.dataStore!
                passDataToFilterScreen( destination: &destinationDS, passSelectAreaText: selectAreaText)
                navigateBack(source: viewController!)
            }
        }
        
    }
    
  func routeToRegisterLocationScreen(selectAreaText:String, capitalName: String)
    {
        for controller in (viewController?.navigationController?.viewControllers)! {
            if controller.isKind(of: RegisterLocationViewController.self) {
                let destinationVC = controller as! RegisterLocationViewController
                var destinationDS = destinationVC.router!.dataStore!
              passDataToRegisterLocationScreen( destination: &destinationDS, passSelectAreaText: selectAreaText, capitalName: capitalName)
                navigateBack(source: viewController!)
            }
        }
    }
    
    func routeToBusinessLocation(selectAreaText:String) {
        if appDelegateObj.isPageControlActive {
            appDelegateObj.selectedArea = selectAreaText
            navigateBack(source: viewController!)
        }
        else {
            for controller in (viewController?.navigationController?.viewControllers)! {
                printToConsole(item: controller)
                if controller.isKind(of: LocationViewController.self) {
                    let destinationVC = controller as! LocationViewController
                    var destinationDS = destinationVC.router!.dataStore!
                    passDataToBusinessLocationScreen( destination: &destinationDS, passSelectAreaText: selectAreaText)
                    navigateBack(source: viewController!)
                }
            }
        }
    }
    
    func routeToFavoriteScreen(selectAreaText:String)
    {
        for controller in (viewController?.navigationController?.viewControllers)! {
            if controller.isKind(of: FavoriteListViewController.self) {
                let destinationVC = controller as! FavoriteListViewController
                var destinationDS = destinationVC.router!.dataStore!
                passDataToFavoriteScreen( source: dataStore!, destination: &destinationDS, passSelectAreaText: selectAreaText)
                navigateBack(source: viewController!)
            }
        }
    }
  
  func routeToSearchScreen(selectAreaText:String)
  {
    for controller in (viewController?.navigationController?.viewControllers)! {
      if controller.isKind(of: SearchViewController.self) {
        let destinationVC = controller as! SearchViewController
        var destinationDS = destinationVC.router!.dataStore!
        passDataToSearchScreen( source: dataStore!, destination: &destinationDS, passSelectAreaText: selectAreaText)
        navigateBack(source: viewController!)
      }
    }
  }
    
    // MARK: Navigation
    
    func navigateBack(source: SelectAreaUserViewController) {
        source.navigationController?.popViewController(animated: true)
    }
    
    
    // MARK: Passing data
    
    func passDataToProfileScreen(destination: inout ProfileSettingDataStore, passSelectAreaText:String)
    {
        destination.selectedArea = passSelectAreaText
        
    }
    
    func passDataToFilterScreen(destination: inout FilterDataStore, passSelectAreaText:String)
    {
        destination.selectedArea = passSelectAreaText
        destination.fromFav = "selectArea"
        
    }
    
  func passDataToRegisterLocationScreen(destination: inout RegisterLocationDataStore, passSelectAreaText:String, capitalName: String)
    {
        destination.selectedArea = passSelectAreaText
      destination.selectedAreaCapital = capitalName
        
    }
    
    func passDataToBusinessLocationScreen(destination: inout LocationDataStore, passSelectAreaText:String)
    {
        destination.selectedArea = passSelectAreaText
        
    }
    
    func passDataToFavoriteScreen(source: SelectAreaUserDataStore,destination: inout FavoriteListDataStore, passSelectAreaText:String)
    {
        destination.selectedArea = passSelectAreaText
        destination.fromScreen = "selectArea"
        destination.isFavoriteString = source.categoryType
        destination.isclear = true
    }
  
  func passDataToSearchScreen(source: SelectAreaUserDataStore,destination: inout SearchDataStore, passSelectAreaText:String)
  {
    destination.selectedArea = passSelectAreaText
  }
}
