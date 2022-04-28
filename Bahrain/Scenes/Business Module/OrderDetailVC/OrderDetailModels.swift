
import UIKit

enum OrderDetail
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
            var header:tableSectionData
            var row:[tableRowData]
        }
        
        struct tableSectionData{
            var headerTitle:String
            var time:String
            var orderId:String
        }
        
        struct tableRowData{
            var name:String
            var therapistName:String
            var time:String
            var price:NSNumber
            var therapistId:String
            var bookingDate:String
            var paidAmount: NSNumber
            var discountAvailed: NSNumber
        }
        
        var salonName:String
        var salonPhoneNumber: String
        var paymentStatus:String
        var totalAmount:NSNumber
        var profileImage:String
        var isCancel:Bool
        var paymentType:String
        var appointmentId:String
        var ClientId:String
        var specialInstructions:String
        var paidAmount:String
        var remainingAmount:String
        var cancelledDate:String
        var cancelledBy:String
        var walletPaidAmount:NSNumber
        var CardPaidAmount:NSNumber
        var paidAtSalonAmount:NSNumber
        var paidAtSalon:String
        var cardType:String
        var walletTransactionId:String
        var CardTransactionId:String
        var paidTransactionId:String
        var arrivalStatus:String
        var couponCode: String
    }
}

struct TransactionList {
  var paymentMethod: String
  var id: String
  var paidAmount: String
}
