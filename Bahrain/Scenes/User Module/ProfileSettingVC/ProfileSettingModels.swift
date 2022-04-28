
import UIKit

enum ProfileSetting
{
  // MARK: Use cases
    struct Request
    {
        var name:String
        var area:String
        var birthday:String
        var language:String
        var latitude:String
        var longitude:String
        var notification:String
        var address:String
        var address2:String
        var email:String
        var block: String
        var road: String
        var houseNo: String
        var flatno: String
        var gender: Int
    }
    struct Response
    {
    }
    struct ViewModel
    {
        var dict:NSDictionary?
        var errorString:String?
    }
    
    struct ImageRequest
    {
        var imageView:UIImage
        var imageTitle:String
        
    }
    
    struct ChangePasswordRequest
    {
        var currentPassword:String
        var newPassword:String
        var verifyPassword:String
        
    }
    
    struct ChangePasswordModel
    {
        var message:String?
        var errormessage:String?
    }
}
