
import UIKit

enum SelectArea
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
            var header:tableSectionData
            var row:[tableRowData]
        }
        
        struct tableSectionData{
            var areaHeaderTitle:String
        }
        
        struct tableRowData{
            var areaListTitle:String
            
        }
    }
  
}
