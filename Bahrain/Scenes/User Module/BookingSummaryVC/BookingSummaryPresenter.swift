
import UIKit

protocol BookingSummaryPresentationLogic
{
    func updateUI(totalPrice:String, saloonName:String, bookingDate:String, servicesNames:[String], bookingLeastTime:String, totalPriceStr:String, payablePrice: String, isOffer: Bool)
    func bookingConfirmed(response:ApiResponse)
    func getSelectedServicesData(bookingData: [Booking.selectedTherapistModel], servicesArray:[SalonDetail.ViewModel.service], salonName:String, bookingdate:String,isHome:Bool?, offerId:String?, selectedSingleservice: [[String: String]])
    func promoCodeInfo(info: [String: Any])
    func clearPromoCodeInfo()
    func presentSelectedAddress(address: AddressList.ViewModel)
    func deleteAddress()
    func presentAddressListResponse(response: ApiResponse)
    
    func presentBookingForAddress(response: [String : Any])
}

class BookingSummaryPresenter: BookingSummaryPresentationLogic
{
    
    weak var viewController: BookingSummaryDisplayLogic?
    
    // MARK:
    
    func presentSelectedAddress(address: AddressList.ViewModel) {
        viewController?.displaySelectedAddress(address: address)
    }
    
    func presentBookingForAddress(response: [String : Any]) {
        viewController?.presentBookingForAddress(address: response)
    }
    
    func presentAddressListResponse(response: ApiResponse) {
        var addressList = [AddressList.ViewModel]()
        if response.code == 200 {
            if let list = response.result as? [[String: Any]] {
                for listObj in list {
                    let addressObject = AddressList.ViewModel(
                        address: listObj["homeAddress"] as? String ?? "",
                        addressID: listObj["_id"] as? String ?? "",
                        title: listObj["title"] as? String ?? "",
                        phoneNumber: listObj["phoneNumber"] as? String ?? "",
                        countryCode: listObj["countryCode"] as? String ?? "",
                        latitude: listObj["latitude"] as? String ?? "",
                        longitude: listObj["longitude"] as? String ?? "",
                        isDefault: listObj["isDefault"] as! Bool,
                        road: listObj["otherAddress"] as? String ?? "",
                        flatNumber: listObj["flatNumber"] as? String ?? "",
                        houseNumber: listObj["houseNumber"] as? String ?? "",
                        block: listObj["blockNumber"] as? String ?? ""
                    )
                    addressList.append(addressObject)
                }
                viewController?.displayAddressList(viewModel: addressList)
            }
        } else if response.code == 404 {
            CommonFunctions.sharedInstance.showSessionExpireAlert()
        } else {
            CustomAlertController.sharedInstance.showErrorAlert(error: "Unable to fetch address")
        }
    }
    
    func deleteAddress() {
        viewController?.deleteAddress()
    }
    
    func getSelectedServicesData(bookingData: [Booking.selectedTherapistModel], servicesArray: [SalonDetail.ViewModel.service], salonName:String, bookingdate:String,isHome:Bool?, offerId:String?, selectedSingleservice: [[String: String]]) {
        
        printToConsole(item: bookingData)
        printToConsole(item: servicesArray)
        
        var viewModelArray = [BookingSummary.SelectedService.tableCellData]()
        
        for (_,item) in servicesArray.enumerated() {
            
            let serviceId = item.id
            var price = ""
            var offerPrice = ""
            
            
            if let isHomeBool = isHome {
                
                if offerId != nil && isHomeBool || selectedSingleservice.count > 0  && isHomeBool {
                    price = item.homePrice
                    if item.isOfferAvailable {
                        offerPrice = item.homeOfferPrice
                    } else {
                        offerPrice = ""
                    }
                } else if offerId != nil && !isHomeBool || selectedSingleservice.count > 0  && !isHomeBool {
                    price = item.salonPrice
                    if item.isOfferAvailable {
                        offerPrice = item.salonOfferPrice
                    } else {
                        offerPrice = ""
                    }
                } else {
                    if isHomeBool {
                        price = item.homePrice
                        if item.isOfferAvailable {
                            offerPrice = item.homeOfferPrice
                        } else {
                            offerPrice = ""
                        }
                    }
                    else {
                        price = item.salonPrice
                        if item.isSOfferAvailable {
                            offerPrice = item.salonOfferPrice
                        } else {
                            offerPrice = ""
                        }
                    }
                }
            }
            
            for obj in bookingData {
                
                let therapistServiceId = obj.therapistServiceId
                let slotObj = obj.therapistSlots
                let seconds = slotObj["start"] as! Int64
                let date = Date(largeMilliseconds: seconds)
                let dateFormatter = DateFormatter()
                dateFormatter.timeZone = UaeTimeZone
                dateFormatter.dateFormat = dateFormats.format10
                let formattedBookingDate = dateFormatter.string(from: date)
                
                printToConsole(item: formattedBookingDate)
                
                if therapistServiceId == item.id {
                    
                    let obj = BookingSummary.SelectedService.tableCellData(serviceName: item.name, therapistName: obj.therapistName, bookingDate: formattedBookingDate, salonName: salonName, price: price, offerPrice: offerPrice, discountAmount: "", payabaleAmount: "", id: serviceId, isdiscountLimitExceed: false, description: item.about)
                    
                    viewModelArray.append(obj)
                }
            }
        }
        
        printToConsole(item: viewModelArray)
        
        var type = ""
        if let isHomeBool = isHome {
            if isHomeBool {
                type = "home"
            } else {
                type = "salon"
            }
        }
        viewController?.displaySelectedServicesData(servicesArray: viewModelArray, type: type)
    }
    
    func updateUI(totalPrice:String, saloonName:String, bookingDate:String, servicesNames:[String], bookingLeastTime:String, totalPriceStr:String, payablePrice: String, isOffer: Bool)
    {
        let roundedTotalPrice = String(format: "%.3f", totalPrice.floatValue())
        var bookingPrice = ""
        if isCurrentLanguageArabic() {
            let priceTextArabic = ltrMark + roundedTotalPrice + " " + localizedTextFor(key: GeneralText.bhd.rawValue)
            bookingPrice = localizedTextFor(key: BookingSummarySceneText.bookingSummarySceneTotalPriceText.rawValue) + " - " + priceTextArabic
        } else {
            bookingPrice = localizedTextFor(key: BookingSummarySceneText.bookingSummarySceneTotalPriceText.rawValue) + " - " + roundedTotalPrice + " " + localizedTextFor(key: GeneralText.bhd.rawValue)
        }
        
        
        var discountPrice = ""
        
        if totalPriceStr != "" {
            let price =  totalPriceStr.floatValue() - totalPrice.floatValue()
            discountPrice = String(format: "%.3f",price.description.floatValue())
            
        }
        
        
        let viewModel = BookingSummary.ViewModel(totalPrice: roundedTotalPrice, saloonName: saloonName, bookingDate: bookingDate, servicesNames: servicesNames, bookingLeastTime: bookingLeastTime, totalSalonPrice: discountPrice)
        viewController?.updateUI(viewModel: viewModel, totalPrice: roundedTotalPrice.floatValue(), payablePrice: totalPriceStr, isOffer: isOffer)
    }
    
    func bookingConfirmed(response:ApiResponse) {
        let apiResponseDict = response.result as! NSDictionary
        let bookingId = apiResponseDict["bookingId"] as! String
        viewController?.bookingConfirmed(bookingId: bookingId)
    }
    
    func promoCodeInfo(info: [String: Any]) {
        viewController?.promoCodeInfo(info: info)
    }
    
    func clearPromoCodeInfo() {
        viewController?.clearPromoCodeInfo()
    }
}
