
import UIKit

enum OpeningHours
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
            var day:String
            var timeFrom:String
            var timeTo:String
            var active:String
        }
        
        var tableArray: [tableCellData]
        var errorString:String?
    }
  
}
