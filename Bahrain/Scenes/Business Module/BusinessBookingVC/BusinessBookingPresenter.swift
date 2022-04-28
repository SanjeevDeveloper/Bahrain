

import UIKit

protocol BusinessBookingPresentationLogic
{
    func presentServiceResponse(response: ApiResponse)
    func presentResponse(response: ApiResponse)
    func presentClientData(response: ClientList.ViewModel.tableCellData?)
    func bookingConfirmed()
}

class BusinessBookingPresenter: BusinessBookingPresentationLogic
{
    
    weak var viewController: BusinessBookingDisplayLogic?
    
    // MARK: Do something
    
    func bookingConfirmed() {
        viewController?.bookingConfirmed()
    }
    
    func presentClientData(response: ClientList.ViewModel.tableCellData?) {
        viewController?.displayClientData(response: response)
    }
    
    func presentServiceResponse(response: ApiResponse)
    {
        var viewModelArray = [BusinessBooking.ListService.ViewModel.tableCellData]()
        var ViewModelObj:BusinessBooking.ListService.ViewModel
        let apiResponseArray = response.result as! NSArray
        printToConsole(item: apiResponseArray)
        var cellDataObj:BusinessBooking.ListService.ViewModel.tableCellData
        
        for (index, obj) in apiResponseArray.enumerated() {
            let dataDict = obj as! NSDictionary
            
            let headerDataDict = dataDict["serviceCategoryId"] as! NSDictionary
            let categoryName = headerDataDict["categoryName"] as! String
            let categoryId = headerDataDict["_id"] as! String
            
            let sectionObj = BusinessBooking.ListService.ViewModel.tableSectionData(areaHeaderTitle: categoryName, businessCategoryId: categoryId)
            
            let name = dataDict["serviceName"] as! String
            //        let serviceId = dataDict["_id"] as! String
            let isSelected = false
            
            let rowObject = BusinessBooking.ListService.ViewModel.tableRowData(
                serviceName: name,
                businessServiceId: dataDict["_id"] as! String,
                serviceDuration: dataDict["serviceDuration"] as! String,
                salonPrice: dataDict["salonPrice"] as! NSNumber,
                homePrice: dataDict["homePrice"] as! NSNumber,
                salonType: dataDict["serviceType"] as! String,
                isSelected: isSelected
            )
            var rowObjectArray = [BusinessBooking.ListService.ViewModel.tableRowData]()
            rowObjectArray.append(rowObject)
            if index == 0 {
                cellDataObj = BusinessBooking.ListService.ViewModel.tableCellData(header: sectionObj, businessServices: rowObjectArray)
                viewModelArray.append(cellDataObj)
            }
            else {
                var isObjFound = false
                for (index, dataObj) in viewModelArray.enumerated() {
                    if dataObj.header.areaHeaderTitle == categoryName{
                        viewModelArray[index].businessServices.append(rowObject)
                        isObjFound = true
                    }
                }
                if !isObjFound {
                    cellDataObj = BusinessBooking.ListService.ViewModel.tableCellData(header: sectionObj, businessServices: rowObjectArray)
                    viewModelArray.append(cellDataObj)
                }
            }
        }
        
        printToConsole(item: viewModelArray)
    //    MARK:-  To hide salon or home pick button
        var isSalon = false
        var isHome  = false
        for item in viewModelArray {
            for obj in item.businessServices{
                if obj.salonType == "both"{
                    isSalon = true
                    isHome = true
                    break;
                }
                else if obj.salonType == "home"{
                    isHome = true
                }
                else {
                    isSalon = true
                }
            }
        }
        //
        

        
        ViewModelObj = BusinessBooking.ListService.ViewModel(tableArray: viewModelArray)
        viewController?.displayServiceResponse(viewModel: ViewModelObj, ishome: isHome, isSalon: isSalon)
        
    }
    //
    
    func presentResponse(response: ApiResponse) {
        var viewModelArray = [BusinessBooking.Booking.ViewModel.tableCellData]()
        
        var ViewModelObj:BusinessBooking.Booking.ViewModel
        
        let apiResponseArray = response.result as! NSArray
        printToConsole(item: apiResponseArray)
        
        for obj in apiResponseArray {
            
            
            var calulatedTotalTime = 0
            var serviceName = String()
            let dataDict = obj as! NSDictionary
            
            //            let serviceDataArray = dataDict["therapistServices"] as! NSArray
            
            var servicesIds = [String]()
            //            for serviceObj in serviceDataArray {
            //                let serviceDict = serviceObj as! NSDictionary
            let name = dataDict["serviceName"] as! String
            let serviceId = dataDict["serviceId"] as! String
            servicesIds.append(serviceId)
            
            if serviceName.isEmptyString() {
                serviceName.append(name)
            }
            else {
                serviceName.append(", \(name)")
            }
            
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
                //printToConsole(item: minString)
            }
            
            calulatedTotalTime = calulatedTotalTime + totalHourMin + Min + totalMin
            //printToConsole(item: calulatedTotalTime)
            //            }
            
            let serviceDataArray = dataDict["therapistArr"] as! NSArray
            
            for serviceObj in serviceDataArray {
                var collectionArray = [BusinessBooking.Booking.ViewModel.collectionCellData]()
                var isSameServiceId = false
                
                let serviceDict = serviceObj as! NSDictionary
                
                
                // Therapist Array
                let therapistTimeArray = serviceDict["therapistTimeSlots"] as! NSArray
                
                for itemTimeSlot in therapistTimeArray {
                    let timeSlotDict = itemTimeSlot as! NSDictionary
                    let dateFormatter = DateFormatter()
                    dateFormatter.timeZone = UaeTimeZone
                    dateFormatter.dateFormat = dateFormats.format5
                    let formattedTime = timeSlotDict["formatTime"] as! String
                    //let startTimeStampDate = timeSlotDict["timestampDate"] as! NSNumber
                    let beforTime = dataDict["bookingBefore"] as! NSNumber
                    let beforTimeInt = beforTime.intValue
                    var startTimeStampDate = timeSlotDict["timestampDate"] as! NSNumber
                    var startTimeStampDateInt = startTimeStampDate.intValue
                    startTimeStampDateInt += beforTimeInt
                    startTimeStampDate = NSNumber(value: startTimeStampDateInt)
                    
                   // printToConsole(item: startTimeStampDate)
                    
                    let endTimeStampDate = addMinutesToTimeStamp(originalTimeStamp: Int64(truncating: startTimeStampDate), minutes: calulatedTotalTime)
                    
                    
                    let minusTimeStampDate = addMinutesToTimeStamp(originalTimeStamp: Int64(truncating: startTimeStampDate), minutes: -calulatedTotalTime)
                    
                    let currentDate = Date()
                    
                    let collectionObj = BusinessBooking.Booking.ViewModel.collectionCellData(
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
                        if therapistServiceID != id{
                            isSameServiceId = true
                        }
                }
                //
                
                let obj = BusinessBooking.Booking.ViewModel.tableCellData(
                    serviceName: serviceName,
                    theraPistName: serviceDict["therapistName"] as! String, theraPistImage: serviceDict["therapistImage"] as! String,
                    serviceDuration: calulatedTotalTime,
                    servicesIds: servicesIds,
                    therapistId:  serviceDict["therapistId"] as! String, therapistServiceId: serviceDict["therapistServiceId"] as! String,
                    therapistTimeSlots: collectionArray, isSameSerice: isSameServiceId
                )
            
                viewModelArray.append(obj)
                
            }
            
            
        }
        ViewModelObj = BusinessBooking.Booking.ViewModel(tableArray: viewModelArray)
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
