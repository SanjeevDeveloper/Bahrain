
import UIKit

enum AddScheduledBreak
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
            var title:String
            var start:String
            var end:String
            var fullday:Bool
            var repeatInfo:String
        }
        var scheduledBreakArray:[tableCellData]
    }
    
}

