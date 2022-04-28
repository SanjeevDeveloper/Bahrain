
import UIKit

protocol ChatPresentationLogic
{
     func presentTitle(title:String,image:String,id:String,chatMsgs:NSArray,isFromMsg:Bool)
     func presentBroadcastMessages(chatArr:MessageEntity)
     func presentTypingStatus(typingStatusString:String)
     func showKeyboardManage(keyboardHeight:CGFloat)
     func hideKeyboard()

}

class ChatPresenter: ChatPresentationLogic
{
    
  weak var viewController: ChatDisplayLogic?
  
  // MARK: Do something

    func presentTitle(title:String,image:String,id:String,chatMsgs:NSArray,isFromMsg:Bool) {
        viewController?.displayTitle(title:title,imageName:image,chatId:id, chatMsgs: chatMsgs,isFromMsg:isFromMsg)
    }
    
    func presentBroadcastMessages(chatArr:MessageEntity){
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
