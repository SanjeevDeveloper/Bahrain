
import UIKit

enum Home
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
        struct Category {
            var categoryName: String
            var categoryId: String
            var categoryImageUrl: String
           
        }
        var categoriesArray: [Category]
        var errorString:String?
    }
    
    struct FavouriteApiViewModel
    {
        struct CellData
        {
            var salonImage:String
            var favImage: UIImage?
            var saloonId:String
        }
        
        var tableArray: [CellData]
        var errorString:String?
    }
    
    struct services {
        var name:String
        var imageName:String
        var id:String
    }
}
