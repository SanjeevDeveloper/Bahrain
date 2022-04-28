
import UIKit

enum SpecialNewOffers
{
  // MARK: Use cases
  
    struct Request
    {
        var expiryDate: Int64
        var activeExpiryDate:Bool
        var offerSalonPrice:NSNumber
        var totalSalonPrice:NSNumber
        var servicesIdsArray:[String]
        
    }
    struct Response
    {
    }
    struct ViewModel
    {
//        struct tableCellData{
//            var title:String
//            var date:String
//            var time:String
//        }
        var selectedServicesArray: [SalonDetail.ViewModel.service]
        var offerObj: AnyObject?
        var offerName: String?
        var offerImage: UIImage?
        var TotalPrice: NSNumber
    }

}
