

import UIKit

enum BusinessBooking
{
    // MARK: Use cases
    
    enum ListService
    {
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
                var salonPrice:NSNumber
                var homePrice:NSNumber
                var salonType:String
                var isSelected:Bool
            }
            var tableArray: [tableCellData]
            
        }
    }
    
    enum Booking
    {
        struct Request
        {
            var timeStamp:Int64
            var serviceId:[String]
            var totalPrice:NSNumber
            
        }
        struct Response
        {
        }
        struct ViewModel
        {
            struct tableCellData {
                var serviceName:String
                var theraPistName:String
                var theraPistImage:String
                var serviceDuration:Int
                var servicesIds:[String]
                var therapistId:String
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
    }
    
    enum ConfirmBooking
    {
        struct Request
        {
            struct BookingData {
                var businessServiceId:[String]
                var isServiceCancel:Bool
                var therapistId:String
                var therapistSlots:NSDictionary
            }
             var bookingArray:[BookingData]
             var ClientId:String
             var paymentPlace:String
             var paymentType:String
             var totalAmount:NSNumber
            
        }
        struct Response
        {
        }
        struct ViewModel
        {
            struct timeArrayData {
                var startTimeStamp:Int64
                var endTimeStamp:Int64
                var minusTimeStamp:Int64
                var therapistId:String
                var therapistServiceId:String
               }
        }
    }
    
    
}
