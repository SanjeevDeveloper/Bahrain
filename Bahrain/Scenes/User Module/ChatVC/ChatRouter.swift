
import UIKit

@objc protocol ChatRoutingLogic
{

}

protocol ChatDataPassing
{
  var dataStore: ChatDataStore? { get }
}

class ChatRouter: NSObject, ChatRoutingLogic, ChatDataPassing
{
  weak var viewController: ChatViewController?
  var dataStore: ChatDataStore?
}
