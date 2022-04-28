

import UIKit

@objc protocol BusinessChatRoutingLogic
{
}

protocol BusinessChatDataPassing
{
  var dataStore: BusinessChatDataStore? { get }
}

class BusinessChatRouter: NSObject, BusinessChatRoutingLogic, BusinessChatDataPassing
{
  weak var viewController: BusinessChatViewController?
  var dataStore: BusinessChatDataStore?
  
  // MARK: Routing

}
