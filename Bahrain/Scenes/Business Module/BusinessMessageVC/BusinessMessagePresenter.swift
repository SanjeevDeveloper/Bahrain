

import UIKit

protocol BusinessMessagePresentationLogic
{
    func presentBusinessMessageResponse(response: BusinessMessage.Something.Response)
}

class BusinessMessagePresenter: BusinessMessagePresentationLogic
{
  weak var viewController: BusinessMessageDisplayLogic?
  
  // MARK: Do something
  
    func presentBusinessMessageResponse(response: BusinessMessage.Something.Response){
        
        var viewModelArray = [BusinessMessage.Something.ViewModel.showMessage]()
        
        for obj in response.allBusinessChatArr {
            let dict = obj as! NSDictionary
            
            let _id = dict["id"] as! String
            let messages = dict["message"] as! String
            let messageTimestamp = dict["messageTimestamp"] as! NSNumber
            let name = dict["name"] as! String
            let profileImage = dict["profileImage"] as? String ?? ""
            let count : Int = dict["unreadCount"] as! Int
            let countStr = String(count)
            
            let serviceModelObj = BusinessMessage.Something.ViewModel.showMessage(_id:_id,message:messages,messageTimestamp:messageTimestamp,name:name,profileImage:profileImage, count: countStr)
            
            viewModelArray.append(serviceModelObj)
        }
        viewController?.presentBusinessMessageResponse(viewModelArray: viewModelArray)
    }
}
