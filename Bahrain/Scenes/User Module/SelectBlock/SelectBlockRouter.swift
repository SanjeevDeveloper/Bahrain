
import UIKit

@objc protocol SelectBlockRoutingLogic
{
    func routeToRegisterLocationScreen(selectBlockText: String)
    func routeToBusinessLocation(selectBlockText:String)
}

protocol SelectBlockDataPassing
{
    var dataStore: SelectBlockDataStore? { get }
}

class SelectBlockRouter: NSObject, SelectBlockRoutingLogic, SelectBlockDataPassing
{
    weak var viewController: SelectBlockViewController?
    var dataStore: SelectBlockDataStore?
    
    // MARK: Routing
    
    
    func routeToBusinessLocation(selectBlockText:String) {
        if appDelegateObj.isPageControlActive {
            appDelegateObj.selectBlock = selectBlockText
            navigateBack(source: viewController!)
        }
        else {
            for controller in (viewController?.navigationController?.viewControllers)! {
                printToConsole(item: controller)
                if controller.isKind(of: LocationViewController.self) {
                    let destinationVC = controller as! LocationViewController
                    var destinationDS = destinationVC.router!.dataStore!
                    passDataToLocation(destination: &destinationDS, passSelectBlockText: selectBlockText)
                    navigateBack(source: viewController!)
                }
            }
        }
    }
    
    func routeToRegisterLocationScreen(selectBlockText:String) {
        for controller in (viewController?.navigationController?.viewControllers)! {
            if controller.isKind(of: ProfileSettingViewController.self) {
                let destinationVC = controller as! ProfileSettingViewController
                var destinationDS = destinationVC.router!.dataStore!
                passDataToProfileScreen( destination: &destinationDS, passSelectBlockText: selectBlockText)
                navigateBack(source: viewController!)
                break
            } else if controller.isKind(of: RegisterLocationViewController.self) {
                let destinationVC = controller as! RegisterLocationViewController
                var destinationDS = destinationVC.router!.dataStore!
                passDataToRegisterLocationScreen( destination: &destinationDS, passSelectBlockText: selectBlockText)
                navigateBack(source: viewController!)
            }
            
        }
    }
    // MARK: Navigation
    func navigateBack(source: SelectBlockViewController) {
        source.navigationController?.popViewController(animated: true)
    }
    // MARK: Passing data
    func passDataToRegisterLocationScreen(destination: inout RegisterLocationDataStore, passSelectBlockText:String) {
        destination.selectedBlock = passSelectBlockText
    }
    
    func passDataToProfileScreen(destination: inout ProfileSettingDataStore, passSelectBlockText:String) {
        destination.selectedBlock = passSelectBlockText
    }
    
    func passDataToLocation(destination: inout LocationDataStore, passSelectBlockText:String) {
        destination.selectedBlock = passSelectBlockText
    }
}
