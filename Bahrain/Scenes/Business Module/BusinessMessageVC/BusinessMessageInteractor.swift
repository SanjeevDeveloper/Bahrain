

import UIKit
import CoreData

protocol BusinessMessageBusinessLogic
{
    func observeNotification()
    func removeObserveNotification()
    func emitSocketInit()
    func emitUserOfflineSocket()
    func emitPendingMessagesSocket()
    func fetchBusinessMessage()
    func emitDeliveredMsg(sendPendingMsg:NSDictionary)
}

protocol BusinessMessageDataStore
{
}

class BusinessMessageInteractor: BusinessMessageBusinessLogic, BusinessMessageDataStore
{
    var presenter: BusinessMessagePresentationLogic?
    var worker: BusinessMessageWorker?
    
    // MARK: Do something
    
    func fetchBusinessMessage() {
        var fetchMsgArr : [BusinessChatEntity]
        fetchMsgArr = CoreDataWrapper.sharedInstance.fetchBusinessMessages()
        self.manageBusinessChatResponse(chatArr: fetchMsgArr)
    }
    
    func manageBusinessChatResponse(chatArr:[BusinessChatEntity]) {
        
        let allChatArray =  chatArr
        var msgArr = [NSDictionary]()
        
        printToConsole(item: allChatArray)
        
        for allChatdict in allChatArray {
            
            let  messageTimestampStr  =  allChatdict.messageTimeStamp
            let  messageStr           =  allChatdict.message
            let  receiverId           =  allChatdict.receiverId
            let  senderId             =  allChatdict.senderID
            let  senderName           =  allChatdict.senderName
            let  senderProfileImage   =  allChatdict.senderProfileImage
            let  receiverName         =  allChatdict.receiverName
            let  receiverProfileImage =  allChatdict.receiverProfileImage
            let  isRead               =  allChatdict.isRead
            
            if (!(receiverId == getUserData(.businessId))){
                
                var unreadCount = 0
                
                if(isRead == false){
                    unreadCount = 1
                }
                
                let filterDict  = ["id": receiverId!,"name": receiverName!, "profileImage":receiverProfileImage! , "messageTimestamp": messageTimestampStr,"message": messageStr!,"unreadCount":unreadCount] as [String : Any]
                
                msgArr.append(filterDict as NSDictionary)
                
            }else if (!(senderId == getUserData(.businessId))){
                
                var unreadCount = 0
                
                if(isRead == false){
                    unreadCount = 1
                }
                
                let filterDict  = ["id": senderId!,"name": senderName!, "profileImage":senderProfileImage! , "messageTimestamp": messageTimestampStr,"message": messageStr!,"unreadCount":unreadCount] as [String : Any]
                
                msgArr.append(filterDict as NSDictionary)
            }
        }
        
        var filterMsgArr = [NSDictionary]()
        var filterMsgWithCountArr = [NSDictionary]()
        var isMatch = false
        
        for obj in msgArr{
            
            isMatch = false
            
            for filterObj in filterMsgArr{
                
                let filterMsgId = filterObj["id"] as! String
                let MsgId = obj["id"] as! String
                
                if (filterMsgId == MsgId) {
                    isMatch = true
                }
            }
            
            if (isMatch == false){
                filterMsgArr.append(obj)
            }
        }
        
        for filterObj in filterMsgArr{
            var unreadCount = 0 as Int
            for obj in msgArr{
                let filterMsgId = filterObj["id"] as! String
                let msgId = obj["id"] as! String
                if(filterMsgId == msgId){
                    
                    let unreadCountVal = obj["unreadCount"] as! Int
                    if(unreadCountVal == 1){
                        unreadCount = unreadCount+1
                    }
                }
            }
            
            let filterDict  = ["id": filterObj["id"]!,"name": filterObj["name"]!, "profileImage":filterObj["profileImage"]! , "messageTimestamp": filterObj["messageTimestamp"]!,"message": filterObj["message"]!,"unreadCount":unreadCount] as [String : Any]
            
            filterMsgWithCountArr.append(filterDict as NSDictionary)
            
        }
        
        let presenterResponse = BusinessMessage.Something.Response(allBusinessChatArr: filterMsgWithCountArr as NSArray)
        self.presenter?.presentBusinessMessageResponse(response: presenterResponse)
        
    }
    
    func emitSocketInit(){
        //*-- Emit Scket Initialization --*
        var initChatArr = [Any]()
        let initDict = ["userId":getUserData(.businessId)]
        initChatArr = [initDict]
        SocketIOManager.sharedInstance.emitMethod(Key:SocketEndPoints.SocketEmit.socketEmitInit, params: initChatArr)
    }
    
    func emitPendingMessagesSocket(){
        //**-- Emit Pending Messages socket --**
        var getPendingMessagesArr = [Any]()
        let getPendingMessagesDict = ["receiverUserId":getUserData(._id),"receiverBusinessId":getUserData(.businessId),"type":"business"]
        getPendingMessagesArr = [getPendingMessagesDict]
        SocketIOManager.sharedInstance.emitMethod(Key:SocketEndPoints.SocketEmit.socketEmitGetPendingMessages, params: getPendingMessagesArr)
    }
    
    func emitUserOfflineSocket(){
        //**-- Emit User Offline socket --**
        var initChatArr = [Any]()
        let initDict = ["userId":getUserData(.businessId)]
        initChatArr = [initDict]
        SocketIOManager.sharedInstance.emitMethod(Key:SocketEndPoints.SocketEmit.socketEmitOffLineUser, params: initChatArr)
    }
    
    func emitDeliveredMsg(sendPendingMsg:NSDictionary)  {
        
        //*-- Emit delivered messages --*
        
        printToConsole(item: "emitDeliveredMsg msg")
        
        var listnenMessageArr = [Any]()
        listnenMessageArr.append(sendPendingMsg)
        
         printToConsole(item: listnenMessageArr)
        SocketIOManager.sharedInstance.emitMethod(Key:SocketEndPoints.SocketEmit.socketEmitMessageDelivered, params: listnenMessageArr)
        
    }
    
    func  observeNotification() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(userLoggedIn), name: Notification.Name(SocketEndPoints.SocketNotification.socketNotificationAppDidBecomeActive), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(sendPendingMsgsNotification), name: Notification.Name(SocketEndPoints.SocketNotification.socketNotificationSocketSendPendingMessages), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(broadcastMessage), name: Notification.Name(SocketEndPoints.SocketNotification.socketNotificationSocketBroadcastMessage), object: nil)
    }
    
    @objc func userLoggedIn(){
        //**-- Emit Init socket --**
        emitSocketInit()
    }
    
    @objc func broadcastMessage(sender: NSNotification){
        
        var broadcastMessageDict = sender.userInfo as! [String : Any]
        emitDeliveredMsg(sendPendingMsg:broadcastMessageDict as NSDictionary)
        
        printToConsole(item: broadcastMessageDict)
        
        //**-- Save data in core database --**
        
        let FromStr = broadcastMessageDict["from"] as! String
        let MessageStr = broadcastMessageDict["message"] as! String
        let MessageIDStr = broadcastMessageDict["messageId"] as! String
        let MessageTimestamp = broadcastMessageDict["messageTimestamp"] as! NSNumber
        let ReceiverIDStr = broadcastMessageDict["receiverId"] as! String
        let ReceiverNameStr = getUserData(.name)
        let ReceiverProfileImageStr = getUserData(.profileImage)
        let SenderIDStr = broadcastMessageDict["senderId"] as! String
        let SenderNameStr = broadcastMessageDict["senderName"] as! String
        let SenderProfileImageStr = broadcastMessageDict["profileImage"] as! String
        
        _ = CoreDataWrapper.sharedInstance.saveUserChat(From:FromStr,Message:MessageStr,MessageID:MessageIDStr,MessageTimestamp:MessageTimestamp,ReceiverID:ReceiverIDStr,ReceiverName:ReceiverNameStr,ReceiverProfileImage:ReceiverProfileImageStr,SenderID:SenderIDStr,SenderName:SenderNameStr,SenderProfileImage:SenderProfileImageStr,EntityName:"BusinessChatEntity",isRead: false)
        
        fetchBusinessMessage()
    }
    
    @objc func sendPendingMsgsNotification(sender: NSNotification) {
        
        let sendPendingMsgsDict = sender.userInfo as! [String : AnyObject]
        
        emitDeliveredMsg(sendPendingMsg:sendPendingMsgsDict as NSDictionary)
        
        var pendingChatArray = [NSDictionary]()
        pendingChatArray = sendPendingMsgsDict["businessMessages"] as! [NSDictionary]
        
        for allChatdict in pendingChatArray {
            
            let senderIdDict = allChatdict["senderId"] as! NSDictionary
            
            //**-- Save data in core database --**
            
            let fromStr = allChatdict["from"] as! String
            let messageStr = allChatdict["message"] as! String
            let messageIDStr = allChatdict["messageId"] as! String
            let messageTimestampStr = allChatdict["messageTimestamp"] as! NSNumber
            let receiverIDStr = getUserData(.businessId)
            let receiverNameStr = getUserData(.name)
            let receiverProfileImageStr = getUserData(.profileImage)
            let senderIDStr = senderIdDict["_id"] as! String
            let senderNameStr = senderIdDict["name"] as! String
            let senderProfileImageStr = senderIdDict["profileImage"] as! String
            
            _ = CoreDataWrapper.sharedInstance.saveUserChat(From:fromStr,Message:messageStr,MessageID:messageIDStr,MessageTimestamp:messageTimestampStr,ReceiverID:receiverIDStr,ReceiverName:receiverNameStr,ReceiverProfileImage:receiverProfileImageStr,SenderID:senderIDStr,SenderName:senderNameStr,SenderProfileImage:senderProfileImageStr,EntityName:"BusinessChatEntity",isRead: false)
            fetchBusinessMessage()
        }
    }
    
    func  removeObserveNotification(){
        NotificationCenter.default.removeObserver(self)
    }
}
