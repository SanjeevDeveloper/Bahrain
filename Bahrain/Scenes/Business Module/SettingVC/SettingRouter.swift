
import UIKit

@objc protocol SettingRoutingLogic
{
  func routeToAnotherScreen(identifier:String)
}

protocol SettingDataPassing
{
  var dataStore: SettingDataStore? { get }
}

class SettingRouter: NSObject, SettingRoutingLogic, SettingDataPassing
{
  weak var viewController: SettingViewController?
  var dataStore: SettingDataStore?
  
  // MARK: Routing
  
    func routeToAnotherScreen(identifier:String)
  {
      let storyboard = AppStoryboard.Business.instance
      let destinationVC = storyboard.instantiateViewController(withIdentifier: identifier)
    viewController?.navigationController?.pushViewController(destinationVC, animated: true)
  }
  
  
}
