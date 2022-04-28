
import UIKit

enum BookingSummary
{
    struct Request
    {
    }
    struct Response
    {
    }
    struct ViewModel
    {
        var totalPrice:String
        var saloonName:String
        var bookingDate:String
        var servicesNames:[String]
        var bookingLeastTime:String
        var totalSalonPrice:String // totalprice in case of offer
    }
    
    struct SelectedService {
        
        struct tableCellData {
            var serviceName:String
            var therapistName: String
            var bookingDate:String
            var salonName:String
            var price:String
            var offerPrice:String
            var discountAmount:String
            var payabaleAmount:String
            var id: String
            var isdiscountLimitExceed: Bool
            var description: String
        }
        
        var servicesArray:[tableCellData]
    }
}
