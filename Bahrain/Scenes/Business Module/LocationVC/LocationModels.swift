
import UIKit

enum Location
{
    struct Request {
        var area:String
        var block:String
        var address1Block:String
        var address1Street:String
        var avenue:String
        var buildingFloor:String
        var specialLocation:String
        var crNumber: String
        var crImage: UIImage?
        var crDocument: URL?
    }
    struct ViewModel
    {
        var area:String
        var address1Block:String
        var address1Street:String
        var avenue:String
        var buildingFloor:String
        var specialLocation:String
        var crNumberText:String
        var crDocument:String
    }
}
