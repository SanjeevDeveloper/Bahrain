
import UIKit

enum rateReview
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
        struct tableCellData { 
            var name:String
            var date:String
            var discription:String
            var profileImg:String
            var rating:NSNumber
            var isSelected:Bool
            var CustomerRating:NSNumber
            var QualityRating:NSNumber
            var TimingRating:NSNumber
            var MoneyRating:NSNumber
        }
        
        var SalonName:String
        var SalonRating:NSNumber
        var qualityPercentage:NSNumber
        var moneyPercentage:NSNumber
        var servicesPercentage:NSNumber
        var timingPercentage:NSNumber
        var tableArray:[tableCellData]
    }
  
}
