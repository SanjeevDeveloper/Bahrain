

import Foundation

class SocketEndPoints: NSObject {
    
    struct SocketListen {
        static let socketInit = "init"
        static let socketStartTyping = "startTyping"
        static let socketStopTyping = "stopTyping"
        static let socketBroadcastMessage = "broadcastMessage"
        static let socketOffLineUser = "offLineUser"
        static let socketListenUserStatus = "listenUserStatus"
        static let socketOnLineUser = "onLineUser"
        static let socketsendPendingMessages = "sendPendingMessages"
        static let setUnreadMsgNotifications = "unreadNotifications"
        
    }
    
    struct SocketEmit{
        static let socketEmitInit = "init"
        static let socketEmitGetPendingMessages = "getPendingMessages"
        static let socketEmitOffLineUser = "offLineUser"
        static let socketEmitMessageDelivered = "messageDelivered"
        static let socketEmitListnenMessage = "listnenMessage"
        static let socketEmitGetUserStatus = "getUserStatus"
        static let socketEmitStartTyping = "startTyping"
        static let socketEmitStopTyping = "stopTyping"
        static let getUnreadMsgNotifications = "countUnreadMsgNotifications"
        static let socketEmitOnLineUser = "initOnlineUser"
    }
    
    struct SocketNotification{
        static let socketNotificationAppDidBecomeActive = "appDidBecomeActive"
        static let socketNotificationSocketBroadcastMessage = "socketBroadcastMessage"
        static let socketNotificationSocketListenUserStatus = "socketListenUserStatus"
        static let socketNotificationSocketOnLineUser = "socketOnLineUser"
        static let socketNotificationSocketStartTyping = "socketStartTyping"
        static let socketNotificationSocketStopTyping = "socketStopTyping"
        static let socketNotificationSocketSendPendingMessages = "socketSendPendingMessages"
        static let socketUnreadNotificationsName = "socketUnreadNotificationsName"
        
    }
    
}
