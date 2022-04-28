
import UIKit

protocol OrderDetailPresentationLogic
{
    func presentData(response: MyAppointments.ViewModel.tableCellData, tableScreen: Bool)
    func presentCancelResponse(response: ApiResponse)
    func presentOrderDetailResponse(response: ApiResponse)
    func presentBookingData(response: MyAppointments.ViewModel.tableCellData)
}

class OrderDetailPresenter: OrderDetailPresentationLogic
{
    
    
    
    weak var viewController: OrderDetailDisplayLogic?
    
    // MARK: Do something
    
    
    func presentBookingData(response: MyAppointments.ViewModel.tableCellData) {
        printToConsole(item: response)
        
        var bookingArray = [SalonDetail.ViewModel.service]()
        
        for item in response.categoriesArr {
            
            let apiResponseDict = item as! NSDictionary
            
            printToConsole(item: apiResponseDict)
            
            let salonPrice = apiResponseDict["servicePrice"] as! NSNumber
            let homePrice = 0
            
            let obj = SalonDetail.ViewModel.service(name: apiResponseDict["serviceName"] as! String, duration: apiResponseDict["serviceDuration"] as! String, salonPrice: salonPrice.description, homePrice: homePrice.description, type: "", id: apiResponseDict["_id"] as! String, isSelected: false, about: "", salonOfferPrice: "0", homeOfferPrice: "0", isOfferAvailable: false, isSOfferAvailable: false)
            
            bookingArray.append(obj)
        }
        
        viewController?.displayBookingData(bookingArray: bookingArray, salonName: response.name, businessID: response.businessId)
    }
    
    
    
    func presentCancelResponse(response: ApiResponse) {
        let apiResponseDict = response.result as! NSDictionary
        let msg = apiResponseDict["msg"] as? String ?? ""
        viewController?.displayCancelAppointmentResponse(msg: msg)
    }
    
    func presentOrderDetailResponse(response: ApiResponse) {
        
        if let responseDict = response.result as? [String: Any] {
            var services = [OrderDetail.ViewModel.tableRowData]()
            let createdAt = responseDict["orderDate"] as? Int64 ?? 0
            let bookingCreatedDate = Date(largeMilliseconds: createdAt)
            let dateFormatterC = DateFormatter()
            dateFormatterC.timeZone = UaeTimeZone
            dateFormatterC.dateFormat = dateFormats.format10
            let bookingCreatDate = dateFormatterC.string(from: bookingCreatedDate)
            let orderDateText = localizedTextFor(key: OrderDetailSceneText.OrderDateText.rawValue)
            let sectionData = OrderDetail.ViewModel.tableSectionData(headerTitle: orderDateText, time: bookingCreatDate, orderId: responseDict["orderId"] as? String ?? "")
            if let servicesList = responseDict["services"] as? [[String: Any]] {
                for service in servicesList {
                    let bookingDate = Date(largeMilliseconds: service["startTime"] as? Int64 ?? 0)
                    let dateFormatter = DateFormatter()
                    dateFormatter.timeZone = UaeTimeZone
                    dateFormatter.dateFormat = dateFormats.format10
                    let servicesObj = OrderDetail.ViewModel.tableRowData(name: service["serviceName"] as? String ?? "", therapistName: service["therapistName"] as? String ?? "", time: service["serviceDuration"] as? String ?? "", price: service["servicePrice"] as? NSNumber ?? 0, therapistId: service["therapistId"] as? String ?? "", bookingDate: dateFormatter.string(from: bookingDate), paidAmount: service["paidAmount"] as? NSNumber ?? 0, discountAvailed: service["discountAvailed"] as? NSNumber ?? 0)
                    services.append(servicesObj)
                }
                
                let statusText = responseDict["status"] as? String ?? ""
                var isCanceled = false
                var isCompleted = false
                var isPending = false
                if statusText == "cancelled" {
                    isCanceled = true
                    isCompleted = false
                    isPending = false
                } else if statusText == "completed" {
                    isCompleted = true
                    isCanceled = false
                    isPending = false
                } else if statusText == "pending"{
                    isCompleted = false
                    isCanceled = false
                    isPending = true
                }else {
                    isCompleted = false
                    isCanceled = false
                    isPending = false
                }
                
                let cellObj = OrderDetail.ViewModel.tableCellData.init(header: sectionData, row: services)
                
                let paidAmt = responseDict["paidAmount"] as? NSNumber ?? 0
                let paidAmtStr = paidAmt.doubleValue.description
                
                let remainingAmt = responseDict["remainingAmount"] as? NSNumber ?? 0
                let remainingAmtStr = remainingAmt.doubleValue.description
                
                //Cancelled Date
                let cancelAt = responseDict["cancelledDate"] as? Int64 ?? 0
                let bookingCancelDate = Date(largeMilliseconds: cancelAt)
                let dateFormatterCancel = DateFormatter()
                dateFormatterCancel.timeZone = UaeTimeZone
                dateFormatterCancel.dateFormat = dateFormats.format10
                let cancelledDate = dateFormatterCancel.string(from: bookingCancelDate)
                
                var paymentMethod = ""
                if let methodsArray = responseDict["usedPaymentMethods"] as? [String] {
                    for item in methodsArray {
                        if paymentMethod != ""{
                            paymentMethod.append(", ")
                        }
                        paymentMethod.append(item)
                    }
                }
                
                let transactionDetailsArr = responseDict["transactionDetails"] as! NSArray
                
                let walletPaidAmount: NSNumber = 0
                let CardPaidAmount: NSNumber = 0
                let paidAtSalonAmount: NSNumber = 0
                
                let walletTransId = ""
                let CardTransId = ""
                let paidTransId = ""
                
                let cardTypeName = ""
                let otherPaymentTypeName = ""
                
                
                var txnList = [TransactionList]()
                
                for item in transactionDetailsArr {
                    let dataDict = item as! NSDictionary
                    
                    let paymentMethodName = (dataDict["paymentMethod"] as? String ?? "").uppercased()
                    var txnId = dataDict["transactionId"] as? String ?? ""
                    let paidAmount = dataDict["paidAmount"] as? NSNumber ?? 0
                    let paidAmountString = String(format: "%.3f", paidAmount.floatValue)
                    
                    if txnId == "" {
                        txnId = "NA"
                    }
                    
                    let txn = TransactionList(paymentMethod: paymentMethodName, id: txnId, paidAmount: paidAmountString)
                    txnList.append(txn)
                }
                
                let promoCode = responseDict["couponCode"] as? String ?? ""
                let discountAvailAmount = responseDict["discountAvailed"] as? NSNumber ?? 0
                let discountAvail = String(format: "%.3f", discountAvailAmount.floatValue)  + " " + localizedTextFor(key: GeneralText.bhd.rawValue)
                
                
                var addressObject: AddressList.ViewModel?
                let homeAddress = responseDict["homeAddress"] as? String ?? ""
                
                if homeAddress != "" {
                    let otherAddress = responseDict["otherAddress"] as? String ?? ""
                    let flatNumber = responseDict["flatNumber"] as? String ?? ""
                    let houseNumber = responseDict["houseNumber"] as? String ?? ""
                    let title = responseDict["title"] as? String ?? ""
                    let latitude = responseDict["latitude"] as? String ?? ""
                    let longitude = responseDict["longitude"] as? String ?? ""
                    let phoneNumber = responseDict["phoneNumber"] as? String ?? ""
                    let countryCode = responseDict["countryCode"] as? String ?? ""
                    
                    addressObject = AddressList.ViewModel(
                        address: homeAddress,
                        addressID: "",
                        title: title,
                        phoneNumber: phoneNumber,
                        countryCode: countryCode,
                        latitude: latitude,
                        longitude: longitude,
                        isDefault: true,
                        road: otherAddress,
                        flatNumber: flatNumber,
                        houseNumber: houseNumber,
                        block: responseDict["blockNumber"] as? String ?? ""
                    )
                }
                
                let offerId = responseDict["businessServiceOfferId"] as? String ?? ""
                
                let viewModelObj = OrderDetail.ViewModel.init(
                    salonName: responseDict["salonName"] as? String ?? "",
                    salonPhoneNumber: responseDict["salonPhoneNumber"] as? String ?? "",
                    paymentStatus: responseDict["paymentStatus"] as? String ?? "",
                    totalAmount: responseDict["totalAmount"] as? NSNumber ?? 0,
                    profileImage: responseDict["salonProfileImage"] as? String ?? "",
                    isCancel: isCanceled,
                    paymentType: paymentMethod,
                    appointmentId: responseDict["bookingId"] as? String ?? "",
                    ClientId: responseDict["businessId"] as? String ?? "",
                    specialInstructions: responseDict["specialInstructions"] as? String ?? "",
                    paidAmount: paidAmtStr,
                    remainingAmount: remainingAmtStr,
                    cancelledDate: cancelledDate,
                    cancelledBy: responseDict["cancelledBy"] as? String ?? "",
                    walletPaidAmount: walletPaidAmount,
                    CardPaidAmount: CardPaidAmount,
                    paidAtSalonAmount: paidAtSalonAmount,
                    paidAtSalon: otherPaymentTypeName,
                    cardType: cardTypeName,
                    walletTransactionId: walletTransId,
                    CardTransactionId: CardTransId,
                    paidTransactionId: paidTransId,
                    arrivalStatus: responseDict["arrivalStatus"] as? String ?? "", couponCode: responseDict["couponCode"] as? String ?? ""
                )
                
                viewController?.displayOrderData(viewModel: viewModelObj, viewModelTable: cellObj, isCompleted: isCompleted,ispending:isPending, serviceStatus: statusText, txnList: txnList, promoCode: promoCode, discountAvail: discountAvail, address: addressObject, totalAfterDiscountValue: responseDict["finalDiscountedAmount"] as? NSNumber ?? 0, isMaxDiscountLimitExceed: responseDict["isMaxDiscountLimitExceed"] as? Bool ?? false, offerId: offerId )
            }
        }
    }
    
    
    func presentData(response: MyAppointments.ViewModel.tableCellData, tableScreen: Bool)
    {
        
        
        //    printToConsole(item: tableScreen)
        //
        //
        //    var ViewModelTableObj:OrderDetail.ViewModel.tableCellData
        //    var ViewModelObj:OrderDetail.ViewModel
        //
        //
        //    let createdAt = response.createdAt
        //    let bookingCreatedDate = Date(largeMilliseconds: createdAt)
        //    let dateFormatterC = DateFormatter()
        //    dateFormatterC.dateFormat = dateFormats.format5
        //    let bookingCreatDate = dateFormatterC.string(from: bookingCreatedDate)
        //
        //    let sectionObj = OrderDetail.ViewModel.tableSectionData(headerTitle: "ORDER", time:bookingCreatDate, orderId: "")
        //    var rowArray = [OrderDetail.ViewModel.tableRowData]()
        //    var calulatedTotalTime = 0
        //
        //    for item in response.categoriesArr{
        //
        //      let apiResponseDict = item as! NSDictionary
        //      calulatedTotalTime = 0
        //      printToConsole(item: apiResponseDict)
        //
        //      //Total Time
        //      let time = apiResponseDict["serviceDuration"] as! String
        //      var totalHourMin = 0
        //      var totalMin = 0
        //      var Min = 0
        //      if time.contains("hours") {
        //
        //        printToConsole(item: time)
        //        let hourString = String(time.prefix(2))
        //        let accurateHourString = hourString.trimmingCharacters(in: .whitespaces)
        //        let hourMin = accurateHourString.intValue()
        //        totalHourMin = hourMin * 60
        //
        //        if time.contains("mins") {
        //          let subStr = time[time.index(time.startIndex, offsetBy: 8)...time.index(time.startIndex, offsetBy: 10)]
        //          let accurateMin = subStr.trimmingCharacters(in: .whitespaces)
        //          Min = accurateMin.intValue()
        //        }
        //
        //
        //      }
        //      else {
        //        let minString = String(time.prefix(2))
        //        let accurateMinString = minString.trimmingCharacters(in: .whitespaces)
        //        totalMin = accurateMinString.intValue()
        //        // printToConsole(item: minString)
        //      }
        //
        //      let startTime = apiResponseDict["startTime"] as? Int64 ?? 0
        //      let date = Date(largeMilliseconds: startTime)
        //      let dateFormatter = DateFormatter()
        //      dateFormatter.dateFormat = dateFormats.format5
        //      let bookingDate = dateFormatter.string(from: date)
        //
        //
        //
        //      calulatedTotalTime = calulatedTotalTime + totalHourMin + Min + totalMin
        //
        //      let rowObj = OrderDetail.ViewModel.tableRowData(
        //        name: apiResponseDict["serviceName"] as? String ?? "",
        //        therapistName: apiResponseDict["therapistName"] as? String ?? "",
        //        time: calulatedTotalTime.description,
        //        price: apiResponseDict["servicePrice"] as! NSNumber, therapistId: apiResponseDict["therapistId"] as? String ?? "", bookingDate: bookingDate)
        //      rowArray.append(rowObj)
        //
        //    }
        //
        //    printToConsole(item: rowArray)
        //
        //    ViewModelTableObj = OrderDetail.ViewModel.tableCellData(header: sectionObj, row: rowArray)
        //
        //    ViewModelObj = OrderDetail.ViewModel(salonName: response.name, paymentStatus: response.paymentMode, totalAmount: response.totalAmount, profileImage: response.profileImage, isCancel: response.isCancelled, paymentType: response.paymentType, appointmentId: response.appointmentId, ClientId: "", specialInstructions: "", paidAmount: response.paidAmt.description, remainingAmount: response.remainingAmt.description, cancelledDate: "", cancelledBy: "", walletPaidAmount: 0, CardPaidAmount: 0, paidAtSalonAmount: 0, paidAtSalon: "")
        //
        //
        //    viewController?.displayOrderData(viewModel: ViewModelObj, viewModelTable: ViewModelTableObj, tableView: tableScreen)
    }
}


//let rowObj = OrderDetail.ViewModel.tableRowData(
//    name: apiResponseDict["serviceName"] as? String ?? "",
//    therapistName: apiResponseDict["therapistName"] as? String ?? "",
//    time: calulatedTotalTime.description,
//    price: apiResponseDict["servicePrice"] as! Int, therapistId: apiResponseDict["therapistId"] as! String, businessId: response.businessId, saloonName: response.name, serviceId: apiResponseDict["_id"] as! String
//)
