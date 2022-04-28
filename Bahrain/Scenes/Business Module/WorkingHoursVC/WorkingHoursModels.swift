
import UIKit

enum WorkingHours
{
  // MARK: Use cases

    struct Request
    {
        var hoursArray: [WorkingHours.ViewModel.tableCellData]
    }
    struct Response
    {
    }
    struct ViewModel
    {
        struct tableCellData{
            var from:String
            var to:String
            var day:String
            var active:String
            var fromTimestamp:Int64
            var toTimestamp:Int64
            var oldStartTime:Int64
            var oldCloseTime:Int64
        }
        
        var tableArray: [tableCellData]
        var errorString:String?
    }
  
}
