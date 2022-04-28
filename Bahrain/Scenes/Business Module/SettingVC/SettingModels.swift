
import UIKit

enum Setting
{
  
    struct Request
    {
    }
    struct Response
    {
    }
    struct ViewModel
    {
        struct row {
            var title:String
        }
        struct header {
            var title:String
            var image:UIImage
            var rows:[row]
        }
    }
}
