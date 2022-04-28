
import UIKit

enum MyAppointments
{
    // MARK: Use cases
    
    struct Request
    {
        var appointmentId:String
        var indexPath:Int
    }
    struct Response
    {
    }
    struct ViewModel
    {
        struct tableCellData{
            var date:String
            var time:String
            var name:String
            var appointmentId:String
            var categories:String
            var paymentMode:String
            var totalAmount:NSNumber
            var isCancelled:Bool
            var categoriesArr:NSArray
            var profileImage:String
            var paymentType:String
            var businessId:String
            var createdAt:Int64
            var paidAmt:NSNumber
            var remainingAmt:NSNumber
          var serviceStatus:String
        }
        var tableArray: [tableCellData]
        var errorString:String?
        
        
        
    }
    
}

