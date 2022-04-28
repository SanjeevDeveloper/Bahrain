
import UIKit

enum SpecialOfferUser {
    struct Request
    {
    }
    struct Response
    {
    }
    struct ViewModel
    {
        struct tableCellData{
            var coverImage: String
            var salonImage: String
            var totalPrice: NSNumber
            var offerPrice: NSNumber
            var salonName: String
            var offerName: String
            var serviceType: String
            var serviceName: String
            var expiryDate: String
            
        }
        
        var tableArray: [tableCellData]
        var maximumPrice:NSNumber
        var minimumPrice:NSNumber
        var errorString:String?
    }
}
