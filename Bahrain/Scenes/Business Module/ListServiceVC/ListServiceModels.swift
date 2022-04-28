
import UIKit

enum ListService
{
  // MARK: Use cases
  
    struct Request
    {
         var serviceId:String
         var indexPath:Int
    }
    struct Response
    {
    }
    struct ViewModel
    {
//        struct tableCellData{
//            var header:tableSectionData
//            var row:[tableRowData]
//        }
        
//        struct tableSectionData{
//            var serviceHeaderTitle:String
//        }
        
        struct tableRowData{
            var serviceMainName:String
            var serviceMainId:String
            var serviceName:String
            var arabicServiceName:String
            var salonPrice:NSNumber
            var homePrice:NSNumber
            var serviceType:String
            var serviceDuration:String
            var serviceDurationNumber:NSNumber
            var serviceId:String
            var categoryName:String
            var categoryId:String
            var serviceDescription:String?
            var arabicServiceDescription:String?
            var addOnData:[addOn]

        }
        
//        struct addOnData {
//            var addOnServiceName:String?
//            var addOnServiceType:String?
//            var addOnSalonPrice:Int?
//            var addOnHomePrice:Int?
//            var addOnDuration:String?
//        }
        
        var serviceListArray:[tableRowData]
        
    }
  
}
