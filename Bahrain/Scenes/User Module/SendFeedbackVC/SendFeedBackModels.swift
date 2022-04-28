
import UIKit

enum SendFeedBack
{
  // MARK: Use cases
  
    struct Request
    {
        var feedBackText:String
    }
    struct Response
    {
    }
    struct ViewModel
    {
        var message:String?
        var error:String?
    }
  
}
