

import UIKit

@objc protocol BusinessMessageRoutingLogic
{
    func businessRouteToChat(indexPath:Int,id:String,friendName:String,ProfileImage:String)
}

protocol BusinessMessageDataPassing
{
  var dataStore: BusinessMessageDataStore? { get }
}

class BusinessMessageRouter: NSObject, BusinessMessageRoutingLogic, BusinessMessageDataPassing
{
  weak var viewController: BusinessMessageViewController?
  var dataStore: BusinessMessageDataStore?
  
     // MARK: Routing
    
    func businessRouteToChat(indexPath:Int,id:String,friendName:String,ProfileImage:String)
    {
        let destinationVC = AppStoryboard.Chat.instance.instantiateViewController(withIdentifier: ViewControllersIds.BusinessChatViewControllerID) as! BusinessChatViewController
        var ds = destinationVC.router?.dataStore
        passBusinessDataToChat(id:id,friendName:friendName,ProfileImage:ProfileImage,path:indexPath, destination: &ds!)
        viewController?.navigationController?.pushViewController(destinationVC, animated: true)
    }
    
    
    
    // MARK: Passing data
    
    func passBusinessDataToChat(id:String,friendName:String,ProfileImage:String,path:Int, destination: inout BusinessChatDataStore)
    {
        destination.salonName = friendName
        destination.salonImage = ProfileImage
        destination.buisnessId = id
        destination.isFromMessage = true
    }
}
