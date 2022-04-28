
import UIKit

enum Search
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
            var title:String
            var subTitle:String
            var saloonId:String
        }
        var tableArray: [tableCellData]
        var maximumPrice:NSNumber
        var minimumPrice:NSNumber
        var errorString:String?
    }
 
}
