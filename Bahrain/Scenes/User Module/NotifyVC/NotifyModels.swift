

import UIKit

enum Notify
{
  // MARK: Use cases
    struct Request
    {
    }
    struct Response
    {
    }
    struct ViewModel
    {
        struct tableCellData{
            var isRead:Bool
            var message:String
            var name:String
            var notificationId:String
            var notificationTime:String
            var type:String
            var body:String
            var isRated: Bool
        }
        
//        struct bodyStruct {
//            var type:String
//            var receiverUserType:String
//            var messageTimestamp:NSNumber
//            var messageId:String
//            var from:String
//            var receiverId:String
//            var profileImage:String
//            var senderName:String
//            var senderId:String
//            var message:String
//        }
        
         var tableArray: [tableCellData]
    }
  
}
