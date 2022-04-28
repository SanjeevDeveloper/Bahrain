
import UIKit

@objc protocol messageRoutingLogic
{
    func routeToChat(indexPath:Int,id:String,friendName:String,ProfileImage:String)
}

protocol messageDataPassing
{
  var dataStore: messageDataStore? { get }
}

class messageRouter: NSObject, messageRoutingLogic, messageDataPassing
{
  weak var viewController: messageViewController?
  var dataStore: messageDataStore?
  
  // MARK: Routing
    
    func routeToChat(indexPath:Int,id:String,friendName:String,ProfileImage:String)
    {
        let destinationVC = AppStoryboard.Chat.instance.instantiateViewController(withIdentifier: ViewControllersIds.ChatViewControllerID) as! ChatViewController
        var ds = destinationVC.router?.dataStore
        passDataToChat(id:id,friendName:friendName,ProfileImage:ProfileImage,path:indexPath, destination: &ds!)
        viewController?.navigationController?.pushViewController(destinationVC, animated: true)
    }
    

  // MARK: Navigation
  
  func navigateToSomewhere(source: messageViewController, destination: ChatViewController)
  {
    viewController?.navigationController?.pushViewController(destination, animated: true)
  }
  
  // MARK: Passing data
    
    func passDataToChat(id:String,friendName:String,ProfileImage:String,path:Int, destination: inout ChatDataStore)
    {
        destination.salonName = friendName
        destination.salonImage = ProfileImage
        destination.buisnessId = id
        destination.isFromMessage = true
    }
}
