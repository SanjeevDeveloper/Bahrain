

import UIKit
import SocketIO

class SocketIOManager: NSObject {
    static let sharedInstance = SocketIOManager()

    lazy var manager:SocketManager = {
        
        return SocketManager(socketURL: URL(string:Configurator().socketBaseURL)!)
    }()
    
    var socket: SocketIOClient?
    
    
    override init() {
        super.init()
         socket = manager.defaultSocket
        
        socket?.on(SocketEndPoints.SocketListen.socketStartTyping) {data, ack in

            let dictVal = data[0] as! [String: AnyObject]
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: SocketEndPoints.SocketNotification.socketNotificationSocketStartTyping), object: nil,userInfo: dictVal)
        }

        socket?.on(SocketEndPoints.SocketListen.socketStopTyping) {data, ack in

            let dictVal = data[0] as! [String: AnyObject]
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: SocketEndPoints.SocketNotification.socketNotificationSocketStopTyping), object: nil,userInfo: dictVal)
        }
        
        socket?.on(SocketEndPoints.SocketListen.socketBroadcastMessage) {data, ack in
        
            let dictVal = data[0] as! [String: AnyObject]
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: SocketEndPoints.SocketNotification.socketNotificationSocketBroadcastMessage), object: data[0] as! [String: AnyObject],userInfo: dictVal)
        }
        
        socket?.on(SocketEndPoints.SocketListen.socketListenUserStatus) {data, ack in
            
            let dictVal = data[0] as! [String: AnyObject]
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: SocketEndPoints.SocketNotification.socketNotificationSocketListenUserStatus), object: nil,userInfo: dictVal)
        }
        
        socket?.on(SocketEndPoints.SocketListen.socketOnLineUser) {data, ack in
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: SocketEndPoints.SocketNotification.socketNotificationSocketOnLineUser), object: data[0] as! [String: AnyObject])
        }
        
        socket?.on(SocketEndPoints.SocketListen.socketsendPendingMessages) {data, ack in
            
             let dictVal = data[0] as! [String: AnyObject]
             NotificationCenter.default.post(name: NSNotification.Name(rawValue:SocketEndPoints.SocketNotification.socketNotificationSocketSendPendingMessages), object: nil,userInfo: dictVal)
        }
        
        socket?.on(SocketEndPoints.SocketListen.setUnreadMsgNotifications) {data, ack in
            
            let dictVal = data[0] as! [String: AnyObject]
            NotificationCenter.default.post(name: NSNotification.Name(rawValue:SocketEndPoints.SocketNotification.socketUnreadNotificationsName), object: nil,userInfo: dictVal)
        }
    }
    
    func establishConnection() {
        socket?.connect()
    }
    
    func closeConnection() {
        socket?.disconnect()
    }
   
    func emitMethod(Key: String?, params: Any?){
        socket?.emit(Key!, with: (params as? [Any])!)
    }

}
