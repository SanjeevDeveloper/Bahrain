

import UIKit
import CoreData

protocol messageBusinessLogic
{
    func observeNotification()
    func removeObserveNotification()
    func emitSocketInit()
    func emitPendingMessageSocket()
    func emitUserOfflineSocket()
    func emitDeliveredMsg(broadcastMsg:NSDictionary)
    func fetchChatMessage()
    func emitUserOnlineSocket()
}

protocol messageDataStore
{
    var userName: String? { get set }
    var userProfileImage: String? { get set }
    var businessId: String? { get set }
}

class messageInteractor: messageBusinessLogic, messageDataStore
{
    var userName: String?
    var userProfileImage: String?
    var businessId: String?
    
    var presenter: messagePresentationLogic?
    var worker: messageWorker?
    
    func fetchChatMessage() {
        var fetchMsgArr : [MessageEntity]
        fetchMsgArr = CoreDataWrapper.sharedInstance.fetchMessages()
        self.manageChatResponse(chatArr: fetchMsgArr)
    }
    
    func manageChatResponse(chatArr:[MessageEntity]){
        let allChatArray =  chatArr

        var msgArr = [NSDictionary]()

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
            
            if (!(receiverId == getUserData(._id))){
                
                var unreadCount = 0
                
                if(isRead == false){
                    unreadCount = 1
                }

                let filterDict  = ["id": receiverId!,"name": receiverName!, "profileImage":receiverProfileImage! , "messageTimestamp": messageTimestampStr,"message": messageStr!,"unreadCount":unreadCount] as [String : Any]

                msgArr.append(filterDict as NSDictionary)

            }else if (!(senderId == getUserData(._id))){

                
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
                let msgId = obj["id"] as! String

                if (filterMsgId == msgId) {
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
     
        let presenterResponse = message.Something.Response(allChatArr: filterMsgWithCountArr as NSArray)
        self.presenter?.presentMessageResponse(response: presenterResponse)
    }
    
    func emitDeliveredMsg(broadcastMsg:NSDictionary)  {
        
        //*-- Emit delivered messages --*
        
        var listnenMessageArr = [Any]()
        listnenMessageArr.append(broadcastMsg)
        SocketIOManager.sharedInstance.emitMethod(Key:SocketEndPoints.SocketEmit.socketEmitMessageDelivered, params: listnenMessageArr)
        
    }
  
    func emitSocketInit(){
        
        //**-- Init socket --**
        
        var initChatArr = [Any]()
        let initDict = ["userId":getUserData(._id)]
        initChatArr = [initDict]
        SocketIOManager.sharedInstance.emitMethod(Key:SocketEndPoints.SocketEmit.socketEmitInit, params: initChatArr)
    }
    
    func emitPendingMessageSocket(){
        //**-- Pending Messages socket --**
        
        var getPendingMessagesArr = [Any]()
        let getPendingMessagesDict = ["receiverUserId":getUserData(._id),"receiverBusinessId":getUserData(.businessId),"type":"user"]
        getPendingMessagesArr = [getPendingMessagesDict]
        SocketIOManager.sharedInstance.emitMethod(Key:SocketEndPoints.SocketEmit.socketEmitGetPendingMessages, params: getPendingMessagesArr)
        
    }
    
    func emitUserOfflineSocket(){
        //**-- User offline socket --**
        
        var initChatArr = [Any]()
        let initDict = ["userId":getUserData(._id)]
        initChatArr = [initDict]
        SocketIOManager.sharedInstance.emitMethod(Key:SocketEndPoints.SocketEmit.socketEmitOffLineUser, params: initChatArr)
    }
    
    func emitUserOnlineSocket(){
        //*-- Emit user online --*
        var initChatArr = [Any]()
        let initDict = ["userId": getUserData(._id)]
        initChatArr = [initDict]
        SocketIOManager.sharedInstance.emitMethod(Key:SocketEndPoints.SocketEmit.socketEmitOnLineUser, params: initChatArr)
    }
    
    func  observeNotification() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(userLoggedIn), name: Notification.Name(SocketEndPoints.SocketNotification.socketNotificationAppDidBecomeActive), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(sendPendingMsgsNotification), name: Notification.Name(SocketEndPoints.SocketNotification.socketNotificationSocketSendPendingMessages), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(broadcastMessage), name: Notification.Name(SocketEndPoints.SocketNotification.socketNotificationSocketBroadcastMessage), object: nil)
    }
    
    @objc func userLoggedIn(){
        //**-- Init socket --**
        emitSocketInit()
    }
    
    @objc func sendPendingMsgsNotification(sender: NSNotification) {
        
        let sendPendingMsgsDict = sender.userInfo as! [String : AnyObject]
        emitDeliveredMsg(broadcastMsg:sendPendingMsgsDict as NSDictionary)
        var pendingChatArray  = [NSDictionary]()
        
        pendingChatArray = sendPendingMsgsDict["userMessages"] as! [NSDictionary]
        
        
        printToConsole(item:pendingChatArray )
        for allChatdict in pendingChatArray {
            
            let senderIdDict = allChatdict["senderId"] as! NSDictionary
            
            //**-- Save data in core database --**
            let fromStr = allChatdict["from"] as! String
            let messageStr = allChatdict["message"] as! String
            let messageIDStr = allChatdict["messageId"] as! String
            let messageTimestampStr = allChatdict["messageTimestamp"] as! NSNumber
            let receiverIDStr = getUserData(._id)
            let receiverNameStr = getUserData(.name)
            let receiverProfileImageStr = getUserData(.profileImage)
            let senderIDStr = senderIdDict["_id"] as! String
            let senderNameStr = senderIdDict["name"] as! String
            let senderProfileImageStr = senderIdDict["profileImage"] as! String
            
            _ = CoreDataWrapper.sharedInstance.saveUserChat(From:fromStr,Message:messageStr,MessageID:messageIDStr,MessageTimestamp:messageTimestampStr,ReceiverID:receiverIDStr,ReceiverName:receiverNameStr,ReceiverProfileImage:receiverProfileImageStr,SenderID:senderIDStr,SenderName:senderNameStr,SenderProfileImage:senderProfileImageStr,EntityName:"MessageEntity",isRead: false)
            fetchChatMessage()
            
        }
    }
    
    @objc func broadcastMessage(sender: NSNotification){
        
        var broadcastMessageDict = sender.userInfo as! [String : Any]
        emitDeliveredMsg(broadcastMsg:broadcastMessageDict as NSDictionary)
        
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
        
        _ = CoreDataWrapper.sharedInstance.saveUserChat(From:FromStr,Message:MessageStr,MessageID:MessageIDStr,MessageTimestamp:MessageTimestamp,ReceiverID:ReceiverIDStr,ReceiverName:ReceiverNameStr,ReceiverProfileImage:ReceiverProfileImageStr,SenderID:SenderIDStr,SenderName:SenderNameStr,SenderProfileImage:SenderProfileImageStr,EntityName:"MessageEntity",isRead:false)
        fetchChatMessage()
        
    }
    
    func removeObserveNotification(){
        
        //**-- Remove all notification observations --**
         NotificationCenter.default.removeObserver(self)
    }
    
}
