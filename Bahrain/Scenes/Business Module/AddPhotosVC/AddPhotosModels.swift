

import UIKit

enum AddPhotos
{
  // MARK: Use cases
  
    struct Request
    {
        var imageReq =  [AddPhotos.ViewModel.tableCellData]()
        
    }
    struct Response
    {
    }
    struct ViewModel
    {
        struct tableCellData{
            var imageUrl:String?
            var image:UIImage?
        }
        
        var tableArray: [tableCellData]
        var errorString:String?
    }
  
}
