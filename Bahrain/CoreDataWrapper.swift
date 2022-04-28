

import UIKit
import CoreData

class CoreDataWrapper: NSObject {
    
    static let sharedInstance = CoreDataWrapper()
    
    
    func saveUserChat(From:String,Message:String,MessageID:String,MessageTimestamp:NSNumber,ReceiverID:String,ReceiverName:String,ReceiverProfileImage:String,SenderID:String,SenderName:String,SenderProfileImage:String,EntityName:String,isRead:Bool) -> NSManagedObject{
        
        //**-- Save data in core database --**
        
        
        let appDelegate =
            UIApplication.shared.delegate as! AppDelegate
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        let entity =
            NSEntityDescription.entity(forEntityName:EntityName,
                                       in: managedContext)!
        var chatMsg: NSManagedObject!
        if let message = getMessage(messageId: MessageID) {
            chatMsg = message
            let isReadVal = message.isRead
            if !isReadVal{
                chatMsg.setValue(isRead, forKeyPath: "isRead")
            }
        } else {
            chatMsg = NSManagedObject(entity: entity,
                                      insertInto: managedContext)
            chatMsg.setValue(isRead, forKeyPath: "isRead")
        }
        

        
        chatMsg.setValue(From, forKeyPath: "from")
        chatMsg.setValue(Message, forKeyPath: "message")
        chatMsg.setValue(MessageID, forKeyPath: "messageID")
        chatMsg.setValue(MessageTimestamp, forKeyPath: "messageTimeStamp")
        chatMsg.setValue(ReceiverID, forKeyPath: "receiverId")
        chatMsg.setValue(ReceiverName, forKeyPath: "receiverName")
        chatMsg.setValue(ReceiverProfileImage, forKeyPath: "receiverProfileImage")
        chatMsg.setValue(SenderID, forKeyPath: "senderID")
        chatMsg.setValue(SenderName, forKeyPath: "senderName")
        chatMsg.setValue(SenderProfileImage, forKeyPath: "senderProfileImage")
        
        
        do {
            try managedContext.save()
            
            
        } catch let error as NSError {
            printToConsole(item: "Could not save. \(error), \(error.userInfo)")
        }
        return chatMsg
    }
    
    func getMessage(messageId: String) -> MessageEntity?{
        var msg: MessageEntity?
        let appDelegate =
            UIApplication.shared.delegate as! AppDelegate
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "MessageEntity")
        fetchRequest.predicate = NSPredicate(format: "messageID == %@", messageId)
        
        do {
            if let messages = try managedContext.fetch(fetchRequest) as? [MessageEntity] {
                if messages.count > 0 {
                    msg = messages.first
                }
            }
        } catch let error as NSError {
            printToConsole(item: "Could not fetch. \(error), \(error.userInfo)")
        }
        return msg
    }
    
    func fetchMessages() -> [MessageEntity]{
        
        var fetchMsgArr = [MessageEntity]()
        
        let appDelegate =
            UIApplication.shared.delegate as! AppDelegate
        
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "MessageEntity")
        fetchRequest.returnsObjectsAsFaults = false
        
        let sort = NSSortDescriptor(key: "messageTimeStamp", ascending: false)
        fetchRequest.sortDescriptors = [sort]
        
        do {
            fetchMsgArr = try managedContext.fetch(fetchRequest) as! [MessageEntity]
            
        } catch let error as NSError {
            printToConsole(item: "Could not fetch. \(error), \(error.userInfo)")
        }
        return fetchMsgArr
    }
    
    func fetchBusinessMessages() -> [BusinessChatEntity]{
        
        var fetchMsgArr = [BusinessChatEntity]()
        
        let appDelegate =
            UIApplication.shared.delegate as! AppDelegate
        
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "BusinessChatEntity")
        fetchRequest.returnsObjectsAsFaults = false
        
        let sort = NSSortDescriptor(key: "messageTimeStamp", ascending: false)
        fetchRequest.sortDescriptors = [sort]
        
        do {
            fetchMsgArr = try managedContext.fetch(fetchRequest) as! [BusinessChatEntity]
            
        } catch let error as NSError {
            printToConsole(item: "Could not fetch. \(error), \(error.userInfo)")
        }
        return fetchMsgArr
    }
    
    func dropAllData()  {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let context = delegate.persistentContainer.viewContext
        
        let deleteBusinessFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "BusinessChatEntity")
        let deleteBusinessRequest = NSBatchDeleteRequest(fetchRequest: deleteBusinessFetch)
        
        let deleteMessageFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "MessageEntity")
        let deleteMessageRequest = NSBatchDeleteRequest(fetchRequest: deleteMessageFetch)
        
        do {
            try context.execute(deleteBusinessRequest)
            try context.execute(deleteMessageRequest)
            try context.save()
        } catch {
            printToConsole(item: "There was an error")
        }
    }
    
    func updateDatabaseCount(RecieveId:String,SenderId:String) {
      
        let request = NSFetchRequest<NSFetchRequestResult>(entityName:"MessageEntity")
        let predicate = NSPredicate(format: "receiverId == %@ AND senderID == %@",SenderId,RecieveId)
      
        request.predicate = predicate
        
        
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        do{
            let test = try managedContext.fetch(request)
            
            for obj in test{
                
                (obj as! MessageEntity).isRead = true
                
                do{
                    try managedContext.save()
                }
                catch
                {
                    printToConsole(item: error)
                }
            }
        }
        catch let error as NSError {
            printToConsole(item: "Could not fetch \(error), \(error.userInfo)")
        }
    }
    
    
    func updateBusinessDatabaseCount(RecieveId:String,SenderId:String) {
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName:"BusinessChatEntity")
        let predicate = NSPredicate(format: "receiverId == %@ AND senderID == %@",SenderId,RecieveId)
        
        request.predicate = predicate
        
        
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        do{
            let test = try managedContext.fetch(request)
          
            for obj in test{
                
                (obj as! BusinessChatEntity).isRead = true
                
                do{
                    try managedContext.save()
                }
                catch
                {
                    printToConsole(item: error)
                }
            }
        }
        catch let error as NSError {
            printToConsole(item: "Could not fetch \(error), \(error.userInfo)")
        }
    }
}

