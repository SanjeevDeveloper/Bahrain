

import UIKit
import CoreData

protocol BusinessChatBusinessLogic
{
    func observeNotification()
    func removeObserveNotification()
    func doSomething(request: BusinessChat.Something.Request)
    func emitSendMessage(message:String,randomId:String,stampTime:Int64)
    func emitPendingMessagesSocket()
    func emitDeliveredMsg(broadcastMsg:NSDictionary)
    func fetchLocalMessage()
    func emitUserOfflineSocket()
    func emitSocketInit()
    func emitTyping()
    func stopTyping()
}

protocol BusinessChatDataStore
{
    var buisnessId:String? { get set }
    var salonName:String? { get set }
    var salonImage:String? { get set }
    var isFromMessage:Bool? { get set }
}

class BusinessChatInteractor: BusinessChatBusinessLogic, BusinessChatDataStore
{
    var buisnessId: String?
    var salonImage: String?
    var salonName: String?
    var isFromMessage:Bool?
   
  var presenter: BusinessChatPresentationLogic?
  var worker: BusinessChatWorker?

  // MARK: Do something
  
    func doSomething(request: BusinessChat.Something.Request) {
        worker = BusinessChatWorker()
        worker?.doSomeWork()
        
        if (buisnessId == nil) {
            buisnessId = ""
        }
        if (salonName == nil) {
            salonName = ""
        }
        if (salonImage == nil) {
            salonImage = ""
        }
        
         self.emitgetUserStatus()
         self.fetchLocalMessage()
    }
    
    func emitSocketInit(){
        //*-- Emit Scket Initialization --*
        var initChatArr = [Any]()
        let initDict = ["userId":getUserData(.businessId)]
        initChatArr = [initDict]
        SocketIOManager.sharedInstance.emitMethod(Key:"init", params: initChatArr)
    }
    
    func emitSendMessage(message:String,randomId:String,stampTime:Int64){
        
        //*-- Listen Messages from socket --*
        
        var listnenMessageArr = [Any]()
        let listnenMessageDict = ["senderId": getUserData(.businessId),"receiverId":buisnessId as Any,"message":message,"messageId":randomId,"from":"business","messageTimestamp":stampTime as Any,"receiverUserType":"user"]
        listnenMessageArr = [listnenMessageDict]
        SocketIOManager.sharedInstance.emitMethod(Key:SocketEndPoints.SocketEmit.socketEmitListnenMessage, params: listnenMessageArr)
    }
    
    func emitgetUserStatus()  {
        
        //*-- Get user status socket --*
        
        var listnenMessageArr = [Any]()
        let listnenMessageDict = ["senderId": getUserData(.businessId),"receiverId":buisnessId as Any]
        listnenMessageArr = [listnenMessageDict]
        SocketIOManager.sharedInstance.emitMethod(Key:SocketEndPoints.SocketEmit.socketEmitGetUserStatus, params: listnenMessageArr)
        
    }
    
    func emitPendingMessagesSocket(){
        //**-- Emit Pending Messages socket --**
        var getPendingMessagesArr = [Any]()
        let getPendingMessagesDict = ["receiverUserId":getUserData(._id),"receiverBusinessId":getUserData(.businessId),"type":"business"]
        getPendingMessagesArr = [getPendingMessagesDict]
        SocketIOManager.sharedInstance.emitMethod(Key:SocketEndPoints.SocketEmit.socketEmitGetPendingMessages, params: getPendingMessagesArr)
    }
    
    func emitDeliveredMsg(broadcastMsg:NSDictionary)  {
        
        //*-- Emit delivered messages --*
        printToConsole(item: "emitDeliveredMsg chat")
        var listnenMessageArr = [Any]()
        listnenMessageArr.append(broadcastMsg)
        
        printToConsole(item: listnenMessageArr)
        SocketIOManager.sharedInstance.emitMethod(Key:SocketEndPoints.SocketEmit.socketEmitMessageDelivered, params: listnenMessageArr)
        
    }
    
    func emitTyping(){
        
        //*-- Listen emitTyping from socket --*
        
        var listnenMessageArr = [Any]()
        let listnenMessageDict = ["senderId": getUserData(.businessId),"receiverId":buisnessId as Any]
        listnenMessageArr = [listnenMessageDict]
        SocketIOManager.sharedInstance.emitMethod(Key:SocketEndPoints.SocketEmit.socketEmitStartTyping, params: listnenMessageArr)
    }
    
    func stopTyping(){
        
        //*-- Listen emitTyping from socket --*
        
        var listnenMessageArr = [Any]()
        let listnenMessageDict = ["senderId": getUserData(.businessId),"receiverId":buisnessId as Any]
        listnenMessageArr = [listnenMessageDict]
        SocketIOManager.sharedInstance.emitMethod(Key:SocketEndPoints.SocketEmit.socketEmitStopTyping, params: listnenMessageArr)
        
    }
    
    func emitUserOfflineSocket(){
        //**-- Emit User Offline socket --**
        var initChatArr = [Any]()
        let initDict = ["userId":getUserData(.businessId)]
        initChatArr = [initDict]
        SocketIOManager.sharedInstance.emitMethod(Key:SocketEndPoints.SocketEmit.socketEmitOffLineUser, params: initChatArr)
    }
    
    func fetchLocalMessage() {
        CoreDataWrapper.sharedInstance.updateBusinessDatabaseCount(RecieveId: buisnessId!,SenderId:getUserData(.businessId))
        
        var fetchMsgArr : [BusinessChatEntity]
        fetchMsgArr = CoreDataWrapper.sharedInstance.fetchBusinessMessages()
        printToConsole(item: fetchMsgArr)
        self.manageBusinessMessageResponse(chatArr: fetchMsgArr )
    }
    
    func manageBusinessMessageResponse(chatArr:[BusinessChatEntity]){
         var selectedArr = [Any]()
        
        for allChatdict in chatArr{
            
            let  allArrReceiverIdStr = allChatdict.receiverId
            let  allArrSenderIdStr = allChatdict.senderID
            
            if(buisnessId == allArrReceiverIdStr || buisnessId == allArrSenderIdStr  ){
                selectedArr.append(allChatdict)
            }
        }
        selectedArr.reverse()
        
        presenter?.presentTitle(title:salonName!,image:salonImage!,id:buisnessId!, chatMsgs: selectedArr as NSArray,isFromMsg:self.isFromMessage!)
    }
    
    func observeNotification(){
        
        NotificationCenter.default.addObserver(self, selector: #selector(sendPendingMsgsNotification), name: Notification.Name(SocketEndPoints.SocketNotification.socketNotificationSocketSendPendingMessages), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(userLoggedIn), name: Notification.Name(SocketEndPoints.SocketNotification.socketNotificationAppDidBecomeActive), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(broadcastMessage), name: Notification.Name(SocketEndPoints.SocketNotification.socketNotificationSocketBroadcastMessage), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(listenUserStatus), name: Notification.Name(SocketEndPoints.SocketNotification.socketNotificationSocketListenUserStatus), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(startTypingNotification), name: Notification.Name(SocketEndPoints.SocketNotification.socketNotificationSocketStartTyping), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(stopTypingNotification), name: Notification.Name(SocketEndPoints.SocketNotification.socketNotificationSocketStopTyping), object: nil)
        
        NotificationCenter.default.addObserver(self,selector: #selector(keyboardWillShow),name: NSNotification.Name.UIKeyboardWillShow,object: nil)
        
        NotificationCenter.default.addObserver(self,selector: #selector(keyboardWillHide),name: NSNotification.Name.UIKeyboardWillHide,object: nil)
        
    }
    
    @objc func sendPendingMsgsNotification(sender: NSNotification) {
        
        let sendPendingMsgsDict = sender.userInfo as! [String : AnyObject]
        
        emitDeliveredMsg(broadcastMsg:sendPendingMsgsDict as NSDictionary)
        
        var pendingChatArray = [NSDictionary]()
        pendingChatArray = sendPendingMsgsDict["businessMessages"] as! [NSDictionary]
        
        printToConsole(item: pendingChatArray)
        
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
            
            var isMsgRead = false
            
            if(senderIDStr == buisnessId){
                isMsgRead = true
            }
            
            _ = CoreDataWrapper.sharedInstance.saveUserChat(From:fromStr,Message:messageStr,MessageID:messageIDStr,MessageTimestamp:messageTimestampStr,ReceiverID:receiverIDStr,ReceiverName:receiverNameStr,ReceiverProfileImage:receiverProfileImageStr,SenderID:senderIDStr,SenderName:senderNameStr,SenderProfileImage:senderProfileImageStr,EntityName:"BusinessChatEntity",isRead: isMsgRead)
            fetchLocalMessage()
        }
    }
    
    @objc func userLoggedIn(){
        
        //**-- Emit Socket Init --**
        emitSocketInit()
    }
    
    @objc func broadcastMessage(sender: NSNotification){
        
        var broadcastMessageDict = sender.userInfo as! [String : Any]
        
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
        
        if(SenderIDStr == buisnessId){
            
            let chatMsg = CoreDataWrapper.sharedInstance.saveUserChat(From:FromStr,Message:MessageStr,MessageID:MessageIDStr,MessageTimestamp:MessageTimestamp,ReceiverID:ReceiverIDStr,ReceiverName:ReceiverNameStr,ReceiverProfileImage:ReceiverProfileImageStr,SenderID:SenderIDStr,SenderName:SenderNameStr,SenderProfileImage:SenderProfileImageStr,EntityName:"BusinessChatEntity",isRead: true)
            
            presenter?.presentBroadcastMessages(chatArr:chatMsg as! BusinessChatEntity)
            emitDeliveredMsg(broadcastMsg:broadcastMessageDict as NSDictionary)
        }
    }
    
    @objc func listenUserStatus(sender: NSNotification) {
        
        var userStartTypingDict = sender.userInfo as! [String : Any]
        
        let recvrId = userStartTypingDict["userId"] as! String
        
        if(recvrId == buisnessId){
            
            let userStatus = userStartTypingDict["status"] as? String
            presenter?.presentTypingStatus(typingStatusString:userStatus!)
        }
    }
    
    @objc func startTypingNotification(sender: NSNotification) {
        
        var userStartTypingDict = sender.userInfo as! [String : Any]
        
        let recvrId = userStartTypingDict["receiverId"] as! String
        let senderId = userStartTypingDict["senderId"] as! String
        
        
        if(recvrId == buisnessId || senderId == buisnessId){
            
            presenter?.presentTypingStatus(typingStatusString:localizedTextFor(key: BusinessChatSceneText.BusinessChatSceneTypingTextLabel.rawValue))

        }else{
            
            if(recvrId == buisnessId || senderId == buisnessId){
                
                  presenter?.presentTypingStatus(typingStatusString:localizedTextFor(key: BusinessChatSceneText.BusinessChatSceneOnlineTextLabel.rawValue))
                
            }
        }
    }
    
    
    @objc func stopTypingNotification(sender: NSNotification) {
        
        var userStartTypingDict = sender.userInfo as! [String : Any]
        
        let recvrId = userStartTypingDict["receiverId"] as! String
        let senderId = userStartTypingDict["senderId"] as! String
        
        
        if(recvrId == buisnessId || senderId == buisnessId){
            presenter?.presentTypingStatus(typingStatusString:localizedTextFor(key: BusinessChatSceneText.BusinessChatSceneOnlineTextLabel.rawValue))
        }
    }
    
    @objc func keyboardWillHide(sender: NSNotification) {
        presenter?.hideKeyboard()
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        
        if let keyboardFrame: NSValue = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue {
            
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            
             presenter?.showKeyboardManage(keyboardHeight:keyboardHeight)
        }
    }
    
    func removeObserveNotification(){
        NotificationCenter.default.removeObserver(self)
    }
}
