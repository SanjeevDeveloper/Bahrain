
import UIKit

enum Wallet
{
  // MARK: Use cases
  
  struct Request {
  }
  struct Response {
  }
  struct ViewModel {
    
    var totalAmount: NSNumber
    var refundDetailsArray: [refundDetails]
    
    struct refundDetails {
      var salonName: String
      var totalWalletAmount: NSNumber
      var walletDetailsArray: [walletDetail]
      
      struct walletDetail{
        var orderId: String
        var bookingId: String
        var walletId: String
        var walletAmount: NSNumber
        var validTill: Int64
      }
    }
  }
}
