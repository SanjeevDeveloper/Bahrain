
import UIKit

enum message
{
  // MARK: Use cases
  
  enum Something
  {
    struct Request
    {
    }
    struct Response
    {
        var allChatArr:NSArray
    }
    struct ViewModel
    {
        struct showMessage {
            var _id:String
            var message:String
            var messageTimestamp: NSNumber
            var name: String
            var profileImage: String
            var count: String
        }
    }
  }
}
