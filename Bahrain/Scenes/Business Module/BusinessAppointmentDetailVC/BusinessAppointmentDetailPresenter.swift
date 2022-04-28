
import UIKit

protocol BusinessAppointmentDetailPresentationLogic
{
    func presentData(response: BusinessToday.ViewModel.tableCellData)
}

class BusinessAppointmentDetailPresenter: BusinessAppointmentDetailPresentationLogic
{
    
    weak var viewController: BusinessAppointmentDetailDisplayLogic?
    
    // MARK: Do something
    
    func presentData(response: BusinessToday.ViewModel.tableCellData) {
        var ViewModelTableObj:OrderDetail.ViewModel.tableCellData
        var ViewModelObj:OrderDetail.ViewModel
        
        
        printToConsole(item: response.createdAt)
        
        let createdAt = response.createdAt
        let bookingCreatedDate = Date(largeMilliseconds: createdAt)
        let dateFormatterC = DateFormatter()
        dateFormatterC.timeZone = UaeTimeZone
        dateFormatterC.dateFormat = dateFormats.format5
        let bookingCreatDate = dateFormatterC.string(from: bookingCreatedDate)
        
        let sectionObj = OrderDetail.ViewModel.tableSectionData(headerTitle: "ORDER", time: bookingCreatDate, orderId: "")
        var rowArray = [OrderDetail.ViewModel.tableRowData]()
        var calulatedTotalTime = 0
        printToConsole(item: response.categoriesArr)
        
        for item in response.categoriesArr{
            let apiResponseDict = item as! NSDictionary
            calulatedTotalTime = 0
            
            //Total Time
            let time = apiResponseDict["serviceDuration"] as! String
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
            
            let startTime = apiResponseDict["startTime"] as? Int64 ?? 0
            let date = Date(largeMilliseconds: startTime)
            let dateFormatter = DateFormatter()
            dateFormatterC.timeZone = UaeTimeZone
            dateFormatter.dateFormat = dateFormats.format5
            let bookingDate = dateFormatter.string(from: date)
            
            
            let rowObj = OrderDetail.ViewModel.tableRowData(
                name: apiResponseDict["serviceName"] as? String ?? "",
                therapistName: apiResponseDict["therapistName"] as? String ?? "",
                time: calulatedTotalTime.description,
                price: apiResponseDict["servicePrice"] as! NSNumber, therapistId: apiResponseDict["therapistId"] as! String, bookingDate: bookingDate, paidAmount: 0, discountAvailed: 0)
            rowArray.append(rowObj)
            
        }
        
        ViewModelTableObj = OrderDetail.ViewModel.tableCellData(header: sectionObj, row: rowArray)
        
        ViewModelObj = OrderDetail.ViewModel(salonName: response.clientName, salonPhoneNumber: "", paymentStatus: response.paymentMode, totalAmount: response.totalAmount, profileImage: response.profileImage, isCancel: response.isCancelled, paymentType: response.paymentType, appointmentId: response.appointmentId, ClientId: response.clientId, specialInstructions: response.specialInstructions, paidAmount: "", remainingAmount: "", cancelledDate: "", cancelledBy: "", walletPaidAmount: 0, CardPaidAmount: 0, paidAtSalonAmount: 0, paidAtSalon: "", cardType: "", walletTransactionId: "", CardTransactionId: "", paidTransactionId: "", arrivalStatus: "", couponCode: "")
        
        viewController?.displayOrderData(viewModel: ViewModelObj, viewModelTable: ViewModelTableObj)
    }
    
    
}
