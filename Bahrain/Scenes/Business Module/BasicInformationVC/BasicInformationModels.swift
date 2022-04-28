
import UIKit

enum BasicInformation
{
    struct Request
    {
        var saloonName:String
        var arabicName:String
        var website:String
        var instagramAccount:String
        var phoneNumber:String
        var about:String
        var arabicAbout:String
        var profileImage:UIImage?
        var coverImage:UIImage?
    }
    struct imageRequest
    {
        var image:UIImage
        var imageName:String
    }
    struct Response
    {
    }
    struct ViewModel
    {
        var saloonName:String
        var arabicName:String
        var website:String
        var instagramAccount:String
        var phoneNumber:String
        var about:String
        var arabicAbout:String
        var profileImageUrl:String
        var coverImageUrl:String
    }
}

struct PhotoType {
    static let profileImage = "profileImage"
    static let coverPhoto = "coverPhoto"
}
