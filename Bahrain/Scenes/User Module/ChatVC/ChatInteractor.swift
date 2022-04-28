
import UIKit
import CoreData

protocol ChatBusinessLogic
{
     func doSomething(request: Chat.Something.Request)
     func emitSendMessage(message:String,randomId:String,stampTime:Int64)
     func emitTyping()
     func stopTyping()
     func SocketInit()
     func emitUserOfflineSocket()
     func fetchMessage()
     func emitPendingMessageSocket()
     func emitDeliveredMsg(broadcastMsg:NSDictionary)
     func observeNotification()
     func removeObserveNotification()
    func emitUserOnlineSocket()
}


protocol ChatDataStore
{
     var buisnessId:String? { get set }
     var salonName:String? { get set }
     var salonImage:String? { get set }
     var isFromMessage:Bool? { get set }
}

class ChatInteractor: ChatBusinessLogic, ChatDataStore
{
     var buisnessId: String?
     var salonImage: String?
     var salonName: String?
     var isFromMessage:Bool?

     var presenter: ChatPresentationLogic?
     var worker: ChatWorker?
  
  // MARK: Do something
  
  func doSomething(request: Chat.Something.Request)
  {
    worker = ChatWorker()
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
    
    printToConsole(item: salonName)

    self.emitgetUserStatus()
    self.fetchMessage()
  }
    
    func emitSendMessage(message:String,randomId:String,stampTime:Int64){
        
        //*-- Listen Messages from socket --*
        
        var listnenMessageArr = [Any]()
        var listnenMessageDict =
            ["senderId": getUserData(._id),
             "receiverId":buisnessId as Any,
             "message":message,
             "messageId":randomId,
             "from":"user",
             "messageTimestamp":stampTime as Any
        ]
        
        if salonName == "admin" {
            listnenMessageDict["receiverUserType"] = "user"
        } else if salonName == "Admin" {
            listnenMessageDict["receiverUserType"] = "user"
        } else {
            listnenMessageDict["receiverUserType"] = "business"
        }
        
        listnenMessageArr = [listnenMessageDict]
 SocketIOManager.sharedInstance.emitMethod(Key:SocketEndPoints.SocketEmit.socketEmitListnenMessage, params: listnenMessageArr)
     printToConsole(item: listnenMessageArr)
    }
    
    func emitgetUserStatus()  {
        
        //*-- Get user status socket --*
        
        var listnenMessageArr = [Any]()
        let listnenMessageDict = ["senderId": getUserData(._id),"receiverId":buisnessId as Any]
        listnenMessageArr = [listnenMessageDict]
        SocketIOManager.sharedInstance.emitMethod(Key:SocketEndPoints.SocketEmit.socketEmitGetUserStatus, params: listnenMessageArr)
        
    }
    
    func emitPendingMessageSocket(){
        //**-- Pending Messages socket --**
        
        var getPendingMessagesArr = [Any]()
        let getPendingMessagesDict = ["receiverUserId":getUserData(._id),"receiverBusinessId":getUserData(.businessId),"type":"user"]
        getPendingMessagesArr = [getPendingMessagesDict]
        SocketIOManager.sharedInstance.emitMethod(Key:SocketEndPoints.SocketEmit.socketEmitGetPendingMessages, params: getPendingMessagesArr)
        
    }
    
    func emitDeliveredMsg(broadcastMsg:NSDictionary)  {
        
        //*-- Emit delivered messages --*
        
        var listnenMessageArr = [Any]()
        listnenMessageArr.append(broadcastMsg)
        SocketIOManager.sharedInstance.emitMethod(Key:SocketEndPoints.SocketEmit.socketEmitMessageDelivered, params: listnenMessageArr)
        
    }
    
    func emitTyping(){
        
        //*-- Listen emitTyping from socket --*
        
        var listnenMessageArr = [Any]()
        let listnenMessageDict = ["senderId": getUserData(._id),"receiverId":buisnessId as Any]
        listnenMessageArr = [listnenMessageDict]
        SocketIOManager.sharedInstance.emitMethod(Key:SocketEndPoints.SocketEmit.socketEmitStartTyping, params: listnenMessageArr)
    }
    
    func stopTyping(){
        
        //*-- Listen emitTyping from socket --*
        
        var listnenMessageArr = [Any]()
        let listnenMessageDict = ["senderId": getUserData(._id),"receiverId":buisnessId as Any]
        listnenMessageArr = [listnenMessageDict]
        SocketIOManager.sharedInstance.emitMethod(Key:SocketEndPoints.SocketEmit.socketEmitStopTyping, params: listnenMessageArr)
    }
    
    func SocketInit(){
        //*-- Socket Initialize --*
        var initChatArr = [Any]()
        let initDict = ["userId":getUserData(._id)]
        initChatArr = [initDict]
        SocketIOManager.sharedInstance.emitMethod(Key:SocketEndPoints.SocketEmit.socketEmitInit, params: initChatArr)
    }
    
   func emitUserOfflineSocket(){
        //*-- Emit user offline --*
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
    
    func fetchMessage() {
        
        CoreDataWrapper.sharedInstance.updateDatabaseCount(RecieveId: buisnessId!,SenderId:getUserData(._id))
        
        var fetchMsgArr : [MessageEntity]
        fetchMsgArr = CoreDataWrapper.sharedInstance.fetchMessages()
        self.manageMessageResponse(chatArr: fetchMsgArr )
    }
    
    func manageMessageResponse(chatArr:[MessageEntity]){

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
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:NSNotification.Name.UIKeyboardWillShow,object: nil)
        
        NotificationCenter.default.addObserver(self,selector: #selector(keyboardWillHide),name:NSNotification.Name.UIKeyboardWillHide,object: nil)
    }
    
    @objc func sendPendingMsgsNotification(sender: NSNotification) {
        
        let sendPendingMsgsDict = sender.userInfo as! [String : AnyObject]
        
         printToConsole(item: sendPendingMsgsDict)
        
        var pendingChatArray  = [NSDictionary]()
        
        pendingChatArray = sendPendingMsgsDict["userMessages"] as! [NSDictionary]
        
        printToConsole(item: pendingChatArray)
        
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
            
            var isMsgRead = false
            
            if(senderIDStr == buisnessId){
                isMsgRead = true
            }
            
            _ = CoreDataWrapper.sharedInstance.saveUserChat(From:fromStr,Message:messageStr,MessageID:messageIDStr,MessageTimestamp:messageTimestampStr,ReceiverID:receiverIDStr,ReceiverName:receiverNameStr,ReceiverProfileImage:receiverProfileImageStr,SenderID:senderIDStr,SenderName:senderNameStr,SenderProfileImage:senderProfileImageStr,EntityName:"MessageEntity",isRead: isMsgRead)
            fetchMessage()
            
           emitDeliveredMsg(broadcastMsg:sendPendingMsgsDict as NSDictionary)
        }
    }
    
    @objc func userLoggedIn(){
        //*-- Socket Initialize --*
        SocketInit()
    }
    
    @objc func broadcastMessage(sender: NSNotification){
        
        var broadcastMessageDict = sender.userInfo as! [String : Any]
   
        print(broadcastMessageDict)
        
        //**-- Save data in core database --**
        let FromStr = broadcastMessageDict["from"] as! String
        let MessageStr = broadcastMessageDict["message"] as! String
        let MessageIDStr = broadcastMessageDict["messageId"] as! String
        let MessageTimestampStr = broadcastMessageDict["messageTimestamp"] as! NSNumber
        let ReceiverIDStr = broadcastMessageDict["receiverId"] as! String
        let ReceiverNameStr = getUserData(.name)
        let ReceiverProfileImageStr = getUserData(.profileImage)
        let SenderIDStr = broadcastMessageDict["senderId"] as! String
        let SenderNameStr = broadcastMessageDict["senderName"] as! String
        let SenderProfileImageStr = broadcastMessageDict["profileImage"] as! String
        
        if(SenderIDStr == buisnessId){
            
            let ChatMsg = CoreDataWrapper.sharedInstance.saveUserChat(From:FromStr,Message:MessageStr,MessageID:MessageIDStr,MessageTimestamp:MessageTimestampStr,ReceiverID:ReceiverIDStr,ReceiverName:ReceiverNameStr,ReceiverProfileImage:ReceiverProfileImageStr,SenderID:SenderIDStr,SenderName:SenderNameStr,SenderProfileImage:SenderProfileImageStr,EntityName:"MessageEntity",isRead:true)
            
            presenter?.presentBroadcastMessages(chatArr:ChatMsg as! MessageEntity)
         
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
            
            presenter?.presentTypingStatus(typingStatusString:localizedTextFor(key: ChatSceneText.ChatSceneTypingTextLabel.rawValue))
            
        }else{
            if(senderId == buisnessId || recvrId == buisnessId){
                
                presenter?.presentTypingStatus(typingStatusString:localizedTextFor(key: ChatSceneText.ChatSceneOnlineTextLabel.rawValue))
                
            }
        }
    }
    
    @objc func stopTypingNotification(sender: NSNotification) {
        
        var userStartTypingDict = sender.userInfo as! [String : Any]
        
        let recvrId = userStartTypingDict["receiverId"] as! String
        let senderId = userStartTypingDict["senderId"] as! String
        
        
        if(recvrId == buisnessId || senderId == buisnessId){
            
             presenter?.presentTypingStatus(typingStatusString:localizedTextFor(key: ChatSceneText.ChatSceneOnlineTextLabel.rawValue))
        }
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        
        if let keyboardFrame: NSValue = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue {
            
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            
            presenter?.showKeyboardManage(keyboardHeight:keyboardHeight)
        }
    }
    
    @objc func keyboardWillHide(sender: NSNotification) {
        presenter?.hideKeyboard()
    }
    
    func removeObserveNotification(){
         NotificationCenter.default.removeObserver(self)
    }
}
