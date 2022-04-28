

import UIKit

enum Login
{
    struct Request
    {
        var countryCode: String
        var mobileNumber:String
        var password:String
    }
    struct ViewModel
    {
        var error:String?
    }
}
