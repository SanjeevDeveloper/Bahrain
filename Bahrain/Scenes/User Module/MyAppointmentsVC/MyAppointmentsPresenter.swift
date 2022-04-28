
import UIKit

protocol MyAppointmentsPresentationLogic
{
    func presentPastResponse(response: ApiResponse, isPast: Bool)
    func presentCancelResponse(response: ApiResponse, index:Int)
}

class MyAppointmentsPresenter: MyAppointmentsPresentationLogic
{
    
    weak var viewController: MyAppointmentsDisplayLogic?
    
    // MARK: Do something
    // cancel Appointment
    func presentCancelResponse(response: ApiResponse, index:Int) {
        let apiResponseDict = response.result as! NSDictionary
        let msg = apiResponseDict["msg"] as? String ?? ""
        viewController?.displayCancelAppointmentResponse(msg: msg, index: index)
    }
    
    //
    func presentPastResponse(response: ApiResponse, isPast: Bool)
    {
        var viewModelArray = [MyAppointments.ViewModel.tableCellData]()
        var ViewModelObj:MyAppointments.ViewModel
        if response.error != nil {
            ViewModelObj = MyAppointments.ViewModel(tableArray: viewModelArray, errorString: response.error)
        }
        else {
            
            // result Array
            let apiResponseArray = response.result as! NSArray
            printToConsole(item: apiResponseArray)
            for obj in apiResponseArray {
                var serviceName = String()
                let dataDict = obj as! NSDictionary
                let bookingDataDict = dataDict["bookingData"] as! NSDictionary
                let businessDataDict = bookingDataDict["businessId"] as! NSDictionary
                
                // Service Array
                let serviceDataArray = bookingDataDict["services"] as! NSArray
                for serviceObj in serviceDataArray {
                    let serviceDict = serviceObj as! NSDictionary
                    let name = serviceDict["serviceName"] as! String
                    
                    if serviceName.isEmptyString() {
                        serviceName.append(name)
                    }
                    else {
                        serviceName.append(", \(name)")
                    }
                    
                }
                
                // Booking date
                let bookingDate = bookingDataDict["bookingDate"] as! Int
                
                printToConsole(item: bookingDate)
                let date = Date(milliseconds: bookingDate)
                let dateFormatter = DateFormatter()
                dateFormatter.timeZone = UaeTimeZone
                dateFormatter.dateFormat = dateFormats.format2
                let time = dateFormatter.string(from: date)
                  printToConsole(item: time)
                
                dateFormatter.dateFormat = dateFormats.format4
                let day = dateFormatter.string(from: date)
                 printToConsole(item: date)
                
//                servicesName is removed using order id instead
                
                let obj = MyAppointments.ViewModel.tableCellData(
                    date: day,
                    time: time,
                    name: businessDataDict["saloonName"] as! String,
                    appointmentId: bookingDataDict["_id"] as! String,
                    categories: bookingDataDict["orderId"] as? String ?? "",
                    paymentMode: bookingDataDict["paymentStatus"] as! String,
                    totalAmount: bookingDataDict["totalAmount"] as! NSNumber,
                    isCancelled: bookingDataDict["isCancelled"] as! Bool,
                    categoriesArr: serviceDataArray,
                    profileImage: businessDataDict["profileImage"] as! String,
                    paymentType: bookingDataDict["paymentType"] as! String,
                    businessId: businessDataDict["_id"] as! String,
                    createdAt: bookingDataDict["bookingCreatedAt"] as? Int64 ?? 0,
                    paidAmt: bookingDataDict["paidAmount"] as! NSNumber,
                    remainingAmt: bookingDataDict["remainingAmount"] as! NSNumber,
                    serviceStatus: bookingDataDict["status"] as! String
                )
                
                viewModelArray.append(obj)
            }
            ViewModelObj = MyAppointments.ViewModel(tableArray: viewModelArray, errorString: nil)
        }
        viewController?.displayResponse(viewModel: ViewModelObj, isPast: isPast)
    }
}
