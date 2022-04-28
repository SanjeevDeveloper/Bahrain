
import UIKit

protocol BookingPresentationLogic
{
    func presentResponse(response: ApiResponse)
    func presentData(saloonName: String, serviceArray: [SalonDetail.ViewModel.service], isHome: Bool?,offerId: String?, totalPrice:String, selectedSingleserviceArray: [[String: String]])
    func presentAdvanceBookingDays(response: ApiResponse)
}

class BookingPresenter: BookingPresentationLogic
{
    
    weak var viewController: BookingDisplayLogic?
    
    // MARK: Do something
    
    func presentData(saloonName: String, serviceArray: [SalonDetail.ViewModel.service], isHome: Bool?,offerId: String?, totalPrice:String, selectedSingleserviceArray: [[String: String]]) {
        printToConsole(item: serviceArray)
        
        var servicesName = String()
        var servicesIdsArray = [String]()
        var calulatedTotalPrice:Float =  0
        
        if let isHomeBool = isHome {
            // coming from salon detail
            
            if isHomeBool {
                for service in serviceArray {
                    let string = NSString(string: service.homePrice)
                    let homeprice = string.floatValue
                    
                    let salonPrice:Float =  0
                    calulatedTotalPrice = calulatedTotalPrice + homeprice + salonPrice
                    
                    let name = service.name
                    
                    if servicesName.isEmptyString() {
                        servicesName.append(name)
                    }
                    else {
                        servicesName.append(", \(name)")
                    }
                    
                    let serviceId = service.id
                    servicesIdsArray.append(serviceId)
                    
                }
            }
            else {
                for service in serviceArray {
                    let homeprice :Float =  0
                    let string = NSString(string: service.salonPrice)
                    let salonPrice = string.floatValue
                    
                    calulatedTotalPrice = calulatedTotalPrice + homeprice + salonPrice
                    
                    let name = service.name
                    
                    if servicesName.isEmptyString() {
                        servicesName.append(name)
                    }
                    else {
                        servicesName.append(", \(name)")
                    }
                    
                    let serviceId = service.id
                    servicesIdsArray.append(serviceId)
                }
            }
            
        }
        else {
            // coming from order detail (rebooking flow) && Offer list screen
            for service in serviceArray {
                
                let stringHome = NSString(string: service.homePrice)
                let stringSalon = NSString(string: service.salonPrice)
                
                let homeprice = stringHome.floatValue
                let salonPrice = stringSalon.floatValue
                
                calulatedTotalPrice = calulatedTotalPrice + homeprice + salonPrice
                
                let name = service.name
                
                if servicesName.isEmptyString() {
                    servicesName.append(name)
                }
                else {
                    servicesName.append(", \(name)")
                }
                
                let serviceId = service.id
                servicesIdsArray.append(serviceId)
            }
        }
        
        viewController?.displaySelectedData(saloonName: saloonName, serviceName: servicesName, totalPrice: calulatedTotalPrice as NSNumber, servicesIdsArray: servicesIdsArray,offerId:offerId, totalSalonPrice: totalPrice)
    }
    
    func presentAdvanceBookingDays(response: ApiResponse) {
        if let apiResponseDict = response.result as? NSDictionary {
            let futureBookingDays = apiResponseDict["futureBookingDays"] as? Int ?? 90
            viewController?.AdvanceBookingDays(days: futureBookingDays)
        }
    }
    
    func presentResponse(response: ApiResponse)
    {
        var viewModelArray = [Booking.ViewModel.tableCellData]()
        var ViewModelObj:Booking.ViewModel
        
        let apiResponseArray = response.result as! NSArray
        
        printToConsole(item: apiResponseArray)
        
        for obj in apiResponseArray {
            
            var calulatedTotalTime = 0
           
            let dataDict = obj as! NSDictionary
            
            // Service Array
            //        let serviceDataArray = dataDict["therapistArr"] as! NSArray
            
            var servicesIds = [String]()
            //        for serviceObj in serviceDataArray {
            //           let serviceDict = serviceObj as! NSDictionary
            
            let serviceId = dataDict["serviceId"] as! String
            servicesIds.append(serviceId)
            
            
            
            //Total Time
            let time = dataDict["serviceDuration"] as! String
            
            var totalHourMin = 0
            var totalMin = 0
            var Min = 0
            if time.contains("hours") {
                
                printToConsole(item: time)
                let hourString = String(time.prefix(2))
                let accurateHourString = hourString.trimmingCharacters(in: .whitespaces)
                let hourMin = accurateHourString.intValue()
                totalHourMin = hourMin * 60
                
                if time.contains("mins") {
                    let subStr = time[time.index(time.startIndex, offsetBy: 8)...time.index(time.startIndex, offsetBy: 10)]
                    let accurateMin = subStr.trimmingCharacters(in: .whitespaces)
                    Min = accurateMin.intValue()
                }
                
                
            }
            else {
                let minString = String(time.prefix(2))
                let accurateMinString = minString.trimmingCharacters(in: .whitespaces)
                totalMin = accurateMinString.intValue()
                // printToConsole(item: minString)
            }
            
            calulatedTotalTime = calulatedTotalTime + totalHourMin + Min + totalMin
            printToConsole(item: calulatedTotalTime)
            //        }
            
            
            let serviceDataArray = dataDict["therapistArr"] as! NSArray
            
            for serviceObj in serviceDataArray {
                
                let serviceDict = serviceObj as! NSDictionary
                var collectionArray = [Booking.ViewModel.collectionCellData]()
                var isSameServiceId = true
                
                //var serviceName = String()
                let serviceName = serviceDict["therapistServiceName"] as! String
//                if serviceName.isEmptyString() {
//                    serviceName.append(name)
//                }
//                else {
//                    serviceName.append(", \(name)")
//                }
                
                
                // Therapist Array
                let therapistTimeArray = serviceDict["therapistTimeSlots"] as! NSArray
                for itemTimeSlot in therapistTimeArray {
                    let timeSlotDict = itemTimeSlot as! NSDictionary
                    let formattedTime = timeSlotDict["formatTime"] as! String
                    let beforTime = dataDict["bookingBefore"] as! NSNumber
                    let beforTimeInt = beforTime.intValue
                    var startTimeStampDate = timeSlotDict["timestampDate"] as! NSNumber
                    var startTimeStampDateInt = startTimeStampDate.intValue
                    startTimeStampDateInt += beforTimeInt
                    startTimeStampDate = NSNumber(value: startTimeStampDateInt)
                    let endTimeStampDate = addMinutesToTimeStamp(originalTimeStamp: Int64(truncating: startTimeStampDate), minutes: calulatedTotalTime)
                    
                    let minusTimeStampDate = addMinutesToTimeStamp(originalTimeStamp: Int64(truncating: startTimeStampDate), minutes: -calulatedTotalTime)
                    
                    let currentDate = Date()
                    
                    let collectionObj = Booking.ViewModel.collectionCellData(
                        formatTime: formattedTime,
                        startTimeStampDate: Int64(truncating: startTimeStampDate),
                        endTimeStampDate: endTimeStampDate, minusTimeStampDate: minusTimeStampDate,
                        isSelected: false, isDisabled: false
                    )
                    
                    if (startTimeStampDate.int64Value > currentDate.millisecondsSince1970) {
                        
                        collectionArray.append(collectionObj)
                        
                    }
                    
                }
                
                // for upper label hide and show
                let therapistServiceID = serviceDict["therapistServiceId"] as! String
                
                printToConsole(item: therapistServiceID)
                if viewModelArray.count != 0 {
                    
                    let id = viewModelArray.last?.therapistServiceId
                    if therapistServiceID != id {
                        isSameServiceId = true
                    }
                    else {
                        isSameServiceId = false
                    }
                }
                //
                
                if collectionArray.count != 0 {
                
                    let obj = Booking.ViewModel.tableCellData(
                        serviceName: serviceName,
                        theraPistName: serviceDict["therapistName"] as! String,
                        serviceDuration: calulatedTotalTime,
                        servicesIds: servicesIds,
                        therapistId:  serviceDict["therapistId"] as! String, therapistImage: serviceDict["therapistImage"] as! String, therapistServiceId: serviceDict["therapistServiceId"] as! String,
                        therapistTimeSlots: collectionArray, isSameSerice: isSameServiceId
                    )
                    viewModelArray.append(obj)
                    
                }
            
                
            }
            
            
        }
        
        printToConsole(item: viewModelArray)
        ViewModelObj = Booking.ViewModel(tableArray: viewModelArray)
        viewController?.displayResponse(viewModel: ViewModelObj)
        
    }
    
    func addMinutesToTimeStamp(originalTimeStamp:Int64, minutes:Int) -> Int64 {
        
        let startDate = Date.init(largeMilliseconds: originalTimeStamp)
        let calendar = getCalendar()
        let endDate = calendar.date(byAdding: .minute, value: minutes, to: startDate)
        let finalMilliseconds = endDate?.millisecondsSince1970
        return finalMilliseconds!
    }
}
