
import UIKit

enum RegisterLocation
{
  // MARK: Use cases
  
  
    struct Request
    {
         var imageView:UIImage
    }
    struct Response
    {
    }
    struct ViewModel
    {
        var error:String?
        struct ResponseError {
            var dict:NSDictionary?
            var errorString:String?
        }

    }
}
