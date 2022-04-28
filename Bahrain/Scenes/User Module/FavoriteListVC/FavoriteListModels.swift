
import UIKit

enum FavoriteList
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
        struct UIModel {
            var title:String?
            var type:screenType
        }
        
        enum screenType {
            case category
            case service
            case favorite
        }
    }
    
    struct ApiViewModel
    {
        struct tableCellData
        {
            var coverImage:String
            var name:String
            var salonPlace:String
            var salonImage:String
            var price:NSNumber
            var serviceType:String
            var paymentLabel:String
            var rating:Double
            var saloonId:String
            var latitude:Double?
            var longitude:Double?
            var website:String
            var cash:Bool
        }
        
        var tableArray: [tableCellData]
        var maximumPrice:NSNumber
        var minimumPrice:NSNumber
        var errorString:String?
    }
  
}
