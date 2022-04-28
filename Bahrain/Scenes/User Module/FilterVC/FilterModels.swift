
import UIKit

enum Filter
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
            var name:String
            var id:String
            var isSelected:Bool
        }
        
        var servicesArray:[tableCellData]
    }
    
    struct PaymentViewModel
    {
        struct tableCellData{
            var name:String
            var isSelected:Bool
        }
        
        var paymentArray:[tableCellData]
    }
  
}
