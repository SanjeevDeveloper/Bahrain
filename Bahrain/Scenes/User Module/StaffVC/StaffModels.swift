
import UIKit

enum Staff
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
            var image:String
            var name:String
            var jobTitle:String
            var therapistRating:Double
            var servicesArray:[tableServiceCellData]
        }
        struct tableServiceCellData{
            var category:String
            var subCategory:String
        }
        
        var tableArray: [tableCellData]
        var errorString:String?
    }
  
}
