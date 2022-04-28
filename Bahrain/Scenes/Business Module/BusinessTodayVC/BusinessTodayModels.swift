
import UIKit

enum BusinessToday
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
            var date:String
            var time:String
            var serviceName:String
            var therapistName:String
            var clientName:String
            var appointmentTime:String
            var am:String
            var durationTime:Int
            var isCancelled:Bool
            var totalAmount:NSNumber
            var specialInstructions:String
            var appointmentId:String
            var categoriesArr:NSArray
            var profileImage:String
            var paymentType:String
            var paymentMode:String
            var clientId:String
            var createdAt:Int64
            
        }
        
//        var salonName:String
//        var paymentStatus:String
//        var totalAmount:Int
//        var profileImage:String
//        var isCancel:Bool
//        var paymentType:String
//        var appointmentId:String
        
        
        var tableArray: [tableCellData]
        var errorString:String?
    }
}
