

import Foundation
import CoreData


extension BusinessChatEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BusinessChatEntity> {
        return NSFetchRequest<BusinessChatEntity>(entityName: "BusinessChatEntity")
    }

    @NSManaged public var from: String?
    @NSManaged public var message: String?
    @NSManaged public var messageID: String?
    @NSManaged public var messageTimeStamp: Double
    @NSManaged public var receiverId: String?
    @NSManaged public var receiverName: String?
    @NSManaged public var receiverProfileImage: String?
    @NSManaged public var senderID: String?
    @NSManaged public var senderName: String?
    @NSManaged public var senderProfileImage: String?
    @NSManaged public var isRead: Bool

}
