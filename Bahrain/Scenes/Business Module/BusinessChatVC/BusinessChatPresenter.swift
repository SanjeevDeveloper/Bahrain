

import UIKit

protocol BusinessChatPresentationLogic
{
    func presentTitle(title:String,image:String,id:String,chatMsgs:NSArray,isFromMsg:Bool)
    func presentBroadcastMessages(chatArr:BusinessChatEntity)
    func presentTypingStatus(typingStatusString:String)
    func showKeyboardManage(keyboardHeight:CGFloat)
    func hideKeyboard()
}

class BusinessChatPresenter: BusinessChatPresentationLogic
{
  weak var viewController: BusinessChatDisplayLogic?
  
  // MARK: Do something
    
    func presentTitle(title:String,image:String,id:String,chatMsgs:NSArray,isFromMsg:Bool) {
        
        viewController?.displayTitle(title:title,imageName:image,chatId:id, chatMsgs: chatMsgs,isFromMsg:isFromMsg)
    }
    
    func presentBroadcastMessages(chatArr:BusinessChatEntity){
        viewController?.broadcastMessages(charMsgArr: chatArr)
    }
    
    func presentTypingStatus(typingStatusString:String){
        viewController?.displayTypingStatus(typingStatusStr:typingStatusString)
    }
    
    func showKeyboardManage(keyboardHeight:CGFloat){
        viewController?.showKeyboard(displayKeyboardHeight:keyboardHeight)
    }
    
    func hideKeyboard(){
        viewController?.hideKeyboard()
    }
}
