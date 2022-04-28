
import UIKit

enum Booking
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
            var serviceName:String
            var theraPistName:String
            var serviceDuration:Int
            var servicesIds:[String]
            var therapistId:String
            var therapistImage: String
            var therapistServiceId:String
            var therapistTimeSlots:[collectionCellData]
            var isSameSerice:Bool
        }
        
        struct collectionCellData {
            var formatTime:String
            var startTimeStampDate:Int64
            var endTimeStampDate:Int64
            var minusTimeStampDate:Int64
            var isSelected:Bool
            var isDisabled:Bool
        }
        
        var tableArray: [tableCellData]
        
    }
    
    struct selectedTherapistModel {
        var businessServiceId:[String]
        var isServiceCancel:Bool
        var therapistImage: String
        var therapistId:String
        var therapistName:String
        var therapistServiceId:String
        var therapistSlots:NSDictionary
        var collectionTag:Int
    }
    
    struct NewBookingModel {
        var headerServiceName: String
        var serviceDuration: Int
        var therapists: [NewTherapistModel]
    }
    
    struct NewTherapistModel {
        var serviceName:String
        var theraPistName: String
        var serviceDuration: Int
        var servicesIds: [String]
        var therapistId: String
        var therapistImage: String
        var therapistServiceId: String
        var timeSlots: [ViewModel.collectionCellData]
        var isTherapistSelected: Bool
    }
}
