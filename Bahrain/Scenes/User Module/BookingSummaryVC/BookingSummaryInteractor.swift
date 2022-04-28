
import UIKit

protocol BookingSummaryBusinessLogic
{
    func updateUI()
    func confirmBooking()
    func showSelectedAddress()
    func getSelectedServicesData()
    func deleteBooking()
    func getPromoCodeInfo(code: String)
    func updatePromoCodeDict(dict: [String: Any])
    func getPromoCodeDict()
    func deleteAddress()
    func deletePromoCode()
    func getAddressList()
    func passBookingToAddress()
}

protocol BookingSummaryDataStore
{
    var businessId: String! { get set }
    var bookingData: [Booking.selectedTherapistModel]! { get set }
    var saloonName:String? { get set }
    var bookingDate:String? { get set }
    var specialInstructions: String? { get set }
    var selectedServicesArray: [SalonDetail.ViewModel.service]! { get set }
    var isHome: Bool? { get set }
    var offerId: String? { get set }
    var OfferPrice: String? { get set }
    var totalAmount:NSNumber? { get set }
    var slotBlockedTill:NSNumber? { get set }
    var promoCodeDict: [String: Any]? { get set }
    var selectedAddress: AddressList.ViewModel? { get set }
    var bookingId: String? { get set }
    var calendarTimeStamp: Int64?{ get set }
    var selectedSingleServiceArr: [[String: String]]? { get set }
}

class BookingSummaryInteractor: BookingSummaryBusinessLogic, BookingSummaryDataStore
{
    
    var presenter: BookingSummaryPresentationLogic?
    var worker: BookingSummaryWorker?
    var businessId: String!
    var saloonName:String?
    var bookingDate:String?
    var specialInstructions: String?
    var selectedServicesArray: [SalonDetail.ViewModel.service]!
    var bookingData: [Booking.selectedTherapistModel]!
    var totalAmount:NSNumber?
    var isHome: Bool?
    var offerId: String?
    var OfferPrice: String?
    var selectedSingleServiceArr: [[String : String]]?
    
    var bookingId: String?
    var slotBlockedTill: NSNumber?
    var promoCodeDict: [String: Any]?
    
    var selectedAddress: AddressList.ViewModel?
    var calendarTimeStamp: Int64?
    
    var serviceTotalPrice = ""
    
    func deleteAddress() {
        selectedAddress = nil
        presenter?.deleteAddress()
    }
    
    func getAddressList() {
        worker = BookingSummaryWorker()
        worker?.getAddressListApi(apiResponse: { (response) in
            self.presenter?.presentAddressListResponse(response: response)
        })
    }
    
    func deletePromoCode() {
        promoCodeDict = nil
    }
    
    func showSelectedAddress() {
        if self.selectedAddress != nil {
            presenter?.presentSelectedAddress(address: self.selectedAddress!)
        }
    }
    
    func updatePromoCodeDict(dict: [String: Any]) {
        promoCodeDict = dict
    }
    
    func getPromoCodeDict() {
        if let dict = promoCodeDict {
            presenter?.promoCodeInfo(info: dict)
        }
    }
    
    func getSelectedServicesData() {
        
        var arr = [[String: String]]()
        
        if selectedSingleServiceArr != nil {
            arr = selectedSingleServiceArr!
        }
        
        presenter?.getSelectedServicesData(bookingData: bookingData, servicesArray: selectedServicesArray, salonName: saloonName!, bookingdate: bookingDate!, isHome: isHome ?? nil, offerId: offerId, selectedSingleservice: arr)
    }
    
    
    func updateUI() {
        
        var calulatedTotalPrice:Float =  0
        var servicesNamesArray = [String]()
        
        //if let isHomeBool = isHome {
        
        var arr = [[String: String]]()
        var offerAvailable = false
        var actualAmount:Float =  0
        var isOffer = false
        if selectedSingleServiceArr != nil {
            arr = selectedSingleServiceArr!
        }
        
        
        if offerId != nil && isHome! || arr.count > 0 && isHome!{
            isOffer = true
            totalAmount = 0
            actualAmount = 0
            for service in self.selectedServicesArray {
                let stringHome = NSString(string: service.homePrice)
                let homeprice = stringHome.floatValue
                calulatedTotalPrice = calulatedTotalPrice + homeprice
                servicesNamesArray.append(service.name)
            }
            
            let cost = NSNumber(value: OfferPrice?.doubleValue() ?? 0.0)
            totalAmount = cost
            actualAmount = Float(truncating: cost)
        } else if offerId != nil && !isHome!  || arr.count > 0 && !isHome!{
            totalAmount = 0
            isOffer = true
            actualAmount = 0
            for service in self.selectedServicesArray {
                let stringSalon = NSString(string: service.salonPrice)
                let salonPrice = stringSalon.floatValue
                calulatedTotalPrice = calulatedTotalPrice + salonPrice
                servicesNamesArray.append(service.name)
            }
            let cost = NSNumber(value: OfferPrice?.doubleValue() ?? 0.0)
            totalAmount = cost
            actualAmount = Float(truncating: cost)
        }
        else {
            isOffer = false
            if isHome ?? false {
                totalAmount = 0
                for service in self.selectedServicesArray {
                    let homeString = NSString(string: service.homePrice)
                    let homeprice = homeString.floatValue
                    let homeOffer = NSString(string: service.homeOfferPrice)
                    let homeOfferprice = homeOffer.floatValue
                    
                    actualAmount = actualAmount + homeprice
                    
                    if homeOfferprice > 0.0 {
                        offerAvailable = true
                        calulatedTotalPrice = calulatedTotalPrice + homeOfferprice
                    } else {
                        calulatedTotalPrice = calulatedTotalPrice + homeprice
                    }
                    servicesNamesArray.append(service.name)
                }
            }
            else {
                totalAmount = 0
                for service in self.selectedServicesArray {
                    let salonOffer = NSString(string: service.salonOfferPrice)
                    let salonString = NSString(string: service.salonPrice)
                    let salonPrice = salonString.floatValue
                    let salonOfferprice = salonOffer.floatValue
                    
                    actualAmount = actualAmount + salonPrice
                    
                    if salonOfferprice > 0.0 {
                        offerAvailable = true
                        calulatedTotalPrice = calulatedTotalPrice + salonOfferprice
                    } else {
                        calulatedTotalPrice = calulatedTotalPrice + salonPrice
                    }
                    servicesNamesArray.append(service.name)
                }
            }
            
            if actualAmount > calulatedTotalPrice {
                totalAmount = calulatedTotalPrice as NSNumber
                OfferPrice = "\(calulatedTotalPrice)"
            } else {
                totalAmount = calulatedTotalPrice as NSNumber
            }
        }
        
        // }
        
        
        var leastTimeStamp:Int64?
        var leastTimeString:String?
        for obj in bookingData {
            let timeStamp = obj.therapistSlots["start"] as! Int64
            let timeString = obj.therapistSlots["formatString"] as! String
            if leastTimeStamp == nil {
                leastTimeStamp = timeStamp
                leastTimeString = timeString
            }
            else {
                if timeStamp < leastTimeStamp! {
                    leastTimeStamp = timeStamp
                    leastTimeString = timeString
                }
            }
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = UaeTimeZone
        dateFormatter.dateFormat = dateFormats.format3
        printToConsole(item: self.bookingDate!)
        let date = dateFormatter.date(from: self.bookingDate!)
        dateFormatter.dateFormat = dateFormats.format3
        let formattedBookingDate = dateFormatter.string(from: date!)
        presenter?.updateUI(totalPrice: (offerAvailable == true) ? actualAmount.description : calulatedTotalPrice.description, saloonName:self.saloonName!, bookingDate:formattedBookingDate, servicesNames:servicesNamesArray, bookingLeastTime: leastTimeString!, totalPriceStr: (offerAvailable == true) ? calulatedTotalPrice.description : totalAmount?.description ?? "0.000", payablePrice: ((offerId != nil || arr.count > 0 || offerAvailable) ? OfferPrice ?? "" : totalAmount?.description ?? "0.000"), isOffer: isOffer)
    }
    
    func confirmBooking() {
        
        var arr = [[String: String]]()
        
        if selectedSingleServiceArr != nil {
            arr = selectedSingleServiceArr!
        }
        
        var rawBookingDataObj = [NSDictionary]()
        for obj in bookingData {
            let dict:NSDictionary = [
                "businessServiceId": obj.businessServiceId,
                "isServiceCancel": obj.isServiceCancel,
                "therapistId": obj.therapistId,
                "therapistSlots": obj.therapistSlots
            ]
            rawBookingDataObj.append(dict)
        }
        
        var type = ""
        if let isHomeBool = isHome {
            if isHomeBool {
                type = "home"
            }
            else {
                type = "salon"
            }
        }
        
        var param = [
            "bookingData": rawBookingDataObj,
            "businessId": businessId,
            "clientId": getUserData(._id),
            "createdBy": "user",
            "paymentPlace": type,
            "paymentType": "cash",
            "specialInstructions": specialInstructions!,
            "discountAmount": promoCodeDict?["discountAvailed"] as? String ?? "",
            "priceAfterDiscount": promoCodeDict?["priceAfterDiscount"] as? String ?? "",
            "promoCodeId": promoCodeDict?["promoCodeId"] as? String ?? "",
            "couponCode": promoCodeDict?["couponCode"] as? String ?? "",
            "bookingId": self.bookingId ?? ""
            ] as [String : Any]
        
        if offerId != nil || arr.count > 0{
            param["totalAmount"] = self.OfferPrice
            if offerId != "" {
                param["businessServiceOfferId"] = offerId
            } else {
                param["specialSingleServices"] = selectedSingleServiceArr
            }
        } else {
            if promoCodeDict?["couponCode"] as? String ?? "" == "" {
            }
            param["totalAmount"] = totalAmount!.description
        }
        
        printToConsole(item: param)
        
        worker = BookingSummaryWorker()
        worker?.confirmBooking(parameters: param, apiResponse: { (response) in
            if response.code == 200 {
                let apiResponseDict = response.result as! NSDictionary
                let id = apiResponseDict["bookingId"] as! String
                if let slotBlockedTill = apiResponseDict["slotBlockedTill"] as? NSNumber {
                    self.slotBlockedTill = slotBlockedTill
                }
                self.bookingId = id
                
                self.presenter?.bookingConfirmed(response: response)
            }
            else if response.code == 404 {
                CommonFunctions.sharedInstance.showSessionExpireAlert()
            }
            else {
                CustomAlertController.sharedInstance.showErrorAlert(error: response.error!)
            }
        })
    }
    
    func passBookingToAddress() {
        
        var rawBookingDataObj = [NSDictionary]()
        for obj in bookingData {
            let dict:NSDictionary = [
                "businessServiceId": obj.businessServiceId,
                "isServiceCancel": obj.isServiceCancel,
                "therapistId": obj.therapistId,
                "therapistSlots": obj.therapistSlots
            ]
            rawBookingDataObj.append(dict)
        }
        
        var type = ""
        if let isHomeBool = isHome {
            if isHomeBool {
                type = "home"
            }
            else {
                type = "salon"
            }
        }
        
        var param = [
            "bookingData": rawBookingDataObj,
            "businessId": businessId,
            "clientId": getUserData(._id),
            "createdBy": "user",
            "paymentPlace": type,
            "paymentType": "cash",
            "specialInstructions": specialInstructions!,
            "discountAmount": promoCodeDict?["discountAvailed"] as? String ?? "",
            "priceAfterDiscount": promoCodeDict?["priceAfterDiscount"] as? String ?? "",
            "promoCodeId": promoCodeDict?["promoCodeId"] as? String ?? "",
            "couponCode": promoCodeDict?["couponCode"] as? String ?? "",
            "bookingId": self.bookingId ?? ""
            ] as [String : Any]
        
        var arr = [[String: String]]()
        
        if selectedSingleServiceArr != nil {
            arr = selectedSingleServiceArr!
        }
        
        if selectedAddress != nil {
            param.updateValue(selectedAddress!.address, forKey: "homeAddress")
            param.updateValue(selectedAddress!.road, forKey: "otherAddress")
            param.updateValue(selectedAddress!.houseNumber, forKey: "houseNumber")
            param.updateValue(selectedAddress!.flatNumber, forKey: "flatNumber")
            param.updateValue(selectedAddress!.title, forKey: "title")
            param.updateValue(selectedAddress!.phoneNumber, forKey: "phoneNumber")
            param.updateValue(selectedAddress!.countryCode, forKey: "countryCode")
            param.updateValue(selectedAddress!.latitude, forKey: "latitude")
            param.updateValue(selectedAddress!.longitude, forKey: "longitude")
            param.updateValue(selectedAddress!.block, forKey: "blockNumber")
        }
        
        if offerId != nil || arr.count > 0{
            param["totalAmount"] = self.OfferPrice
            if offerId != "" {
                param["businessServiceOfferId"] = offerId
            } else {
                param["specialSingleServices"] = selectedSingleServiceArr
            }
        } else {
            if promoCodeDict?["couponCode"] as? String ?? "" == "" {
            }
            param["totalAmount"] = totalAmount!.description
        }
        
        presenter?.presentBookingForAddress(response: param)
    }
    
    func getPromoCodeInfo(code: String) {
        worker = BookingSummaryWorker()
        
        var rawBookingDataObj = [[String: Any]]()
        for obj in selectedServicesArray {
            
            var price = ""
            if let isHomeBool = isHome {
                if isHomeBool {
                    price = obj.homePrice
                }
                else {
                    price = obj.salonPrice
                }
            }
            
            price = price.replacingOccurrences(of: "BHD", with: "")
            price = price.replacingOccurrences(of: "د.ب", with: "")
            
            let dict = [
                "businessServiceId": obj.id,
                "serviceAmount": price,
                "serviceName": obj.name
            ]
            rawBookingDataObj.append(dict)
        }
        
        var type = ""
        if let isHomeBool = isHome {
            type = isHomeBool ? "home": "salon"
        }
        
        let param = [
            "services": rawBookingDataObj,
            "serviceType": type,
            "businessId": businessId ?? "",
            "userId": getUserData(._id),
            "couponCode": code,
            "totalAmount": totalAmount!.description,
            "bookingDate": calendarTimeStamp ?? 0
            ] as [String : Any]
        worker?.getPromoCodeInfo(parameters: param, apiResponse: { (response) in
            if response.code == 200 {
                let apiResponseDict = response.result as? [String: Any] ?? [:]
                self.presenter?.promoCodeInfo(info: apiResponseDict)
            }
            else if response.code == 404 {
                CommonFunctions.sharedInstance.showSessionExpireAlert()
            }
            else {
                self.promoCodeDict = nil
                self.presenter?.clearPromoCodeInfo()
                CustomAlertController.sharedInstance.showErrorAlert(error: response.error!)
            }
        })
    }
    
    func deleteBooking(){
        if bookingId != nil {
            worker = BookingSummaryWorker()
            worker?.deleteBooking(bookingId: bookingId!, apiResponse: { (response) in
                if response.code == 200 {
                }
                else if response.code == 404 {
                }
                else {
                }
                
            })
        }
    }
}
