
import UIKit

enum TherapistList
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
            var therapistName:String
            var therapistArabicName:String
            var jobTitle:String
            var jobTitleArabic:String
            var workingHourArr:NSArray
            var serviceArray:NSArray
            var therapistProfileImage:String?
            var therapistId:String
            var isActive:Bool
        }
        var serviceListArray:[tableCellData]
    }
    
}

struct Therapist {
    var name:String
    var service:String
    var workingHour:String
}
