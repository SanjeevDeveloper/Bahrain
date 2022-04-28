
import UIKit

enum AddTherapist
{
  // MARK: Use cases
  
  enum SelectService
  {
    struct Request
    {
        var serviceArray: [AddTherapist.SelectService.ViewModel.tableCellData]
        var hoursArray: [TherapistWorkingHours.ViewModel.tableCellData]
        var name:String
        var arabicName:String
        var jobTitle:String
        var jobTitleArabic:String
        var imageView:UIImage?
        var imageTitle:String?
        var scheduledArray: [AddScheduledBreak.ViewModel.tableCellData]
        
    }
    struct Response
    {
    }
    struct ViewModel
    {
        struct tableCellData{
            var header:tableSectionData
            var businessServices:[tableRowData]
        }
        
        struct tableSectionData{
            var areaHeaderTitle:String
            var businessCategoryId:String
        }
        
        struct tableRowData{
            var serviceName:String
            var businessServiceId:String
            var serviceDuration:String
            var isSelected:Bool
        }
        var tableArray: [tableCellData]
        var therapistProfileImage:String?
        var therapistName:String?
        var arabicTherapistName:String?
        var jobTilte:String?
        var jobTilteArabic:String?
        var therapistId:String?
        var isActive:Bool
        
        
    }
    struct EditViewModel
    {
        
       var tableArray: [workingCellData]
        
        struct workingCellData {
            var from:String
            var to:String
            var day:String
            var active:String
            var fromTimestamp:Int64
            var toTimestamp:Int64
        }
    }
  }
}
