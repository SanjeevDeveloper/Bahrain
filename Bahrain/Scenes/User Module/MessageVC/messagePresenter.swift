

import UIKit

protocol messagePresentationLogic
{
    func presentMessageResponse(response: message.Something.Response)
}

class messagePresenter: messagePresentationLogic
{
  weak var viewController: messageDisplayLogic?
 
    func presentMessageResponse(response: message.Something.Response){
        
        var viewModelArray = [message.Something.ViewModel.showMessage]()
        
        for obj in response.allChatArr {
            let dict = obj as! NSDictionary
            
            let _id = dict["id"] as! String
            let messages = dict["message"] as! String
            let messageTimestamp = dict["messageTimestamp"] as! NSNumber
            let name = dict["name"] as! String
            let profileImage = dict["profileImage"] as? String ?? ""
            
            let count : Int = dict["unreadCount"] as! Int
            let countStr = String(count)
            
            
            let serviceModelObj = message.Something.ViewModel.showMessage(_id:_id,message:messages,messageTimestamp:messageTimestamp,name:name,profileImage:profileImage, count: countStr)
            
            viewModelArray.append(serviceModelObj)
        }
        viewController?.presentMessageResponse(viewModelArray: viewModelArray)
    }
}
