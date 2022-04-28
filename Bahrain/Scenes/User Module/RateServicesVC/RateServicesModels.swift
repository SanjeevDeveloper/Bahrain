
import UIKit

enum RateServices
{
  // MARK: Use cases
    struct Request
    {
        var qualityRating: Double
        var moneyRating: Double
        var serviceRating: Double
        var timingRating: Double
        var reviewText: String
        var ratingArray:[RatingData]
    }
    struct Response
    {
    }
    struct ViewModel
    {
        struct tableCellData{
            var serviceName:String
            var therapistId:String
            var therapistName:String
        }
         var tableArray: [tableCellData]
    }
  
}
