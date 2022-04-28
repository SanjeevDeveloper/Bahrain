
import UIKit

enum ClientReviews
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
            var name:String
            var date:String
            var discription:String
            var profileImg:String
            var rating:NSNumber
        }
       var tableArray: [tableCellData]
    }
  
}
