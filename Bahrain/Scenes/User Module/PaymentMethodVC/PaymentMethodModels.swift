

import UIKit

enum PaymentMethod
{
  // MARK: Use cases

    struct Request
    {
        var paymentType:String
        var isWalletUsed:Bool
        var paidAmount:Float
        var remainingAmount:Float
        var walletPaidAmount:Float
        var cardPaidAmount:Float
    }
    struct Response
    {
    }
    struct ViewModel
    {
        var totalAmount:NSNumber // total service amount
        var fullAmountToBePaid:NSNumber // full case
        var partialAmountToBePaid:NSNumber //advance payment
        var paymenttype:String
        var walletAmount:NSNumber
        var paymentMethods:[CardDetails]
        
        struct CardDetails{
            var cardName:String
            var cardType:String
        }
    }
    
   
    
  
}
