
import UIKit

enum ClientList
{
    struct Request
    {
    }
    struct Response
    {
    }
    struct ViewModel
    {
        struct tableCellData {
            var id:String
            var ClientId:String
            var firstName:String
            var lastName:String
            var phoneNumber:String
            var countryCode:String
            var profileImage:String?
            var isDelete:Bool
            var isActive:Bool
        }
        
        var clientListArray:[tableCellData]
    }
}


struct client {
    var firstName:String
    var lastName:String
    var phoneNumber:String
    var countryCode:String
    var profileImage:UIImage?
    var profileImageUrlString:String?
}
