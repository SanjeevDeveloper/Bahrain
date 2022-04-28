
import UIKit

enum SpecialOffersList
{
  // MARK: Use cases
    struct Request
    {
        var offerId:String
        var indexPath:Int
    }
    struct Response
    {
    }
    struct ViewModel
    {
        struct tableCellData{
            var offerImage:String
            var offerId:String
            var offerName:String
            var serviceName:String
            var serviceType:String
            var expiryDate:String
            var offerSalonPrice:NSNumber
            var offerHomePrice:NSNumber
            var totalSalonPrice:NSNumber
            var totalHomePrice:NSNumber
            
        }
        
       var offerListArray:[tableCellData]
    }
}
