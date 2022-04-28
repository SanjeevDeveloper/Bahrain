
import UIKit

enum AddSalonService
{
    // MARK: Use cases
    struct Request
    {
        var maincategoryId:String
        var serviceType:String
        var categoryId:String
        var serviceName:String
        var arabicName:String
        var homePrice:String
        var salonPrice:String
        var serviceDuration:String
        var serviceDurationNumber:Int
        var serviceDescription:String
        var arabicDescription:String
        var addOnArray:[addOn]
        
        
        
        //        struct addOn {
        //            var addonServiceType:String
        //            var addOnName:String
        //            var addOnSaloonPrice:String
        //            var addOnhomePrice:String
        //            var addOnDuration:String
        //        }
        
    }
    struct Response
    {
    }
    struct ViewModel
    {
        struct pickerData{
            var serviceName:String
            var categoryId:String
        }
        
        var pickerArray: [pickerData]
        var errorString:String?
    }
    
    struct MainCategoryViewModel
    {
        struct mainCategoryData{
            var categoryName:String
            var categoryId:String
        }
        var mainCategoryArray: [mainCategoryData]
    }
}

struct addOn {
    var addonServiceType:String
    var addOnName:String
    var addOnSaloonPrice:String
    var addOnhomePrice:String
    var addOnDuration:String
}
