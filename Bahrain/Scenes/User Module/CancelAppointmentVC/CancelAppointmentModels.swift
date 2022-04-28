
import UIKit

enum CancelAppointment
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
            var isSelected:Bool
            var reason:String
        }
        
        var tableArray: [tableCellData]
    }
    
}
