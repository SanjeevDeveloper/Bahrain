
import UIKit

@objc protocol ProfileSettingRoutingLogic
{
  func routeToSelectArea(segue: UIStoryboardSegue?)
}

protocol ProfileSettingDataPassing
{
  var dataStore: ProfileSettingDataStore? { get }
}

class ProfileSettingRouter: NSObject, ProfileSettingRoutingLogic, ProfileSettingDataPassing
{
    
  weak var viewController: ProfileSettingViewController?
  var dataStore: ProfileSettingDataStore?
    
    func routeToSelectArea(segue: UIStoryboardSegue?) {
        let destinationVC = segue!.destination as! SelectAreaUserViewController
        var destinationDS = destinationVC.router!.dataStore!
        passDataToSomewhere(source: self.dataStore!, destination: &destinationDS)
    }
  
  
  // MARK: Passing data
  
  func passDataToSomewhere(source: ProfileSettingDataStore, destination: inout SelectAreaUserDataStore)
  {
    destination.screenName = "profileSetting"
  }
}
