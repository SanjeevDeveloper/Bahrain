
import UIKit

protocol BusinessTodayPresentationLogic
{
  func presentResponse(response: ApiResponse)
}

class BusinessTodayPresenter: BusinessTodayPresentationLogic
{
  weak var viewController: BusinessTodayDisplayLogic?
  
  // MARK: Do something
  
  func presentResponse(response: ApiResponse)
  {
     var viewModelArray = [BusinessToday.ViewModel.tableCellData]()
     var ViewModelObj:BusinessToday.ViewModel
    
    if response.error != nil {
         ViewModelObj = BusinessToday.ViewModel(tableArray: viewModelArray, errorString: response.error)
    }
    else {
        let apiResponseArray = response.result as! NSArray
        printToConsole(item: apiResponseArray)
        for arrData in apiResponseArray {
            let responseDict = arrData as! NSDictionary
          //Client Name
            let bookingDataDict =  responseDict["bookingData"] as! NSDictionary
            let clientInfoDict = bookingDataDict["clientId"] as! NSDictionary
            
            
           //Booking Date
            
            
          let bookingDate = (bookingDataDict["bookingDate"] as! NSNumber).intValue

          let date = Date(milliseconds: bookingDate)
          let dateFormatter = DateFormatter()
            dateFormatter.timeZone = UaeTimeZone
          let locale = Locale(identifier: "ro_RO")
          dateFormatter.locale = locale
          dateFormatter.dateFormat = dateFormats.format2
          let day = dateFormatter.string(from: date)
            
          dateFormatter.dateFormat = dateFormats.format4
          let forDetailday = dateFormatter.string(from: date)
            
            printToConsole(item: day)
            
    
          let timeStr = String(day.prefix(5))
          let amStr = String(day.suffix(2))
            
          //therapist name
            let servicesArray = bookingDataDict["services"] as! NSArray
            
            var therapistId = String()
            var therapistName = String()
            var serviceName = String()
            var calulatedTotalTime = 0
            
            for serviceData in servicesArray {
              let serviceDict = serviceData as! NSDictionary
               
                let tid = serviceDict["therapistId"] as! String
                let therpname = serviceDict["therapistName"] as! String
//                serviceDuration = serviceDict["serviceDuration"] as! String
                let name = serviceDict["serviceName"] as! String
                
                
                if therapistName.isEmptyString() {
                    therapistName.append(therpname)
                    therapistId.append(tid)
                }
                else {
                    
                    if therapistId != tid {
                        therapistName.append(", \(therpname)")
                    }
                    
                }
                
                if serviceName.isEmptyString() {
                    serviceName.append(name)
                }
                else {
                    serviceName.append(", \(name)")
                }
                
                //Total Time
                let time = serviceDict["serviceDuration"] as! String
                
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
                    
                }
                
                calulatedTotalTime = calulatedTotalTime + totalHourMin + Min + totalMin
                printToConsole(item: calulatedTotalTime)
            }
            
            let obj = BusinessToday.ViewModel.tableCellData(date: forDetailday, time: day, serviceName: serviceName, therapistName: therapistName, clientName: clientInfoDict["name"] as! String, appointmentTime: timeStr, am: amStr , durationTime: calulatedTotalTime, isCancelled: bookingDataDict["isCancelled"] as! Bool, totalAmount: bookingDataDict["totalAmount"] as! NSNumber, specialInstructions: bookingDataDict["specialInstructions"] as! String , appointmentId: bookingDataDict["_id"] as! String, categoriesArr: servicesArray, profileImage: clientInfoDict["profileImage"] as! String, paymentType: bookingDataDict["paymentType"] as! String, paymentMode: bookingDataDict["paymentStatus"] as! String, clientId: clientInfoDict["_id"] as! String, createdAt: bookingDataDict["createdAt"] as? Int64 ?? 0)
            
            viewModelArray.append(obj)
            
        }
        ViewModelObj = BusinessToday.ViewModel(tableArray: viewModelArray, errorString: response.error)
        
    }
     viewController?.displayResponse(viewModel: ViewModelObj)
  }
}
