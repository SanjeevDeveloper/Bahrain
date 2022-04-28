
import UIKit

protocol BookingBusinessLogic
{
    func listTherapistTimeSlots(timeStamp:Int64) 
    func getData()
    func getAdvanceBookingDays()
}

protocol BookingDataStore
{
    var businessId: String! { get set }
    var saloonName:String? { get set }
    var isHome: Bool? { get set }
    var selectedServicesArray: [SalonDetail.ViewModel.service]! { get set }
    var offerId: String? { get set }
    var totalPrice: String? { get set }
    var selectedSingleserviceArray: [[String: String]]? { get set }
}

class BookingInteractor: BookingBusinessLogic, BookingDataStore
{
    
    var presenter: BookingPresentationLogic?
    var worker: BookingWorker?
    var businessId: String!
    var saloonName:String?
    var isHome: Bool?
    var selectedSingleserviceArray: [[String : String]]?
    var selectedServicesArray: [SalonDetail.ViewModel.service]!
    var offerId: String?
    var totalPrice: String?
    
    func getData() {
        
        var arr = [[String: String]]()
        
        if selectedSingleserviceArray != nil {
            arr = selectedSingleserviceArray!
        }
        
        if offerId != nil || arr.count > 0 {
            self.presenter?.presentData(saloonName: saloonName!, serviceArray: selectedServicesArray, isHome: self.isHome,offerId: offerId!, totalPrice: totalPrice ?? "", selectedSingleserviceArray: arr)
        }
        else {
            self.presenter?.presentData(saloonName: saloonName!, serviceArray: selectedServicesArray, isHome: self.isHome,offerId: nil, totalPrice: totalPrice ?? "", selectedSingleserviceArray: arr)
        }
    }
    
    func getAdvanceBookingDays() {
        worker = BookingWorker()
        worker?.getAdvanceBookingDays(apiResponse: { (response) in
            self.presenter?.presentAdvanceBookingDays(response: response)
        })
    }
    
    func listTherapistTimeSlots(timeStamp:Int64) {
        
        var calulatedTotalPrice:Float =  0
        var servicesIdsArray = [String]()
        
        var arr = [[String: String]]()
        
        if selectedSingleserviceArray != nil {
            arr = selectedSingleserviceArray!
        }
        
        if let isHomeBool = self.isHome {
            // coming from salon detail
            
            
            if offerId != nil || arr.count > 0 {
                for service in self.selectedServicesArray {
                    
                    printToConsole(item: service.homePrice.intValue())
                    printToConsole(item: service.salonPrice.intValue())
                    
                    let homeString = NSString(string: service.homePrice)
                    let homeprice = homeString.floatValue
                    let salonString = NSString(string: service.salonPrice)
                    let salonPrice = salonString.floatValue
                    if arr.count > 0 {
                        if service.type == "home" {
                            calulatedTotalPrice = calulatedTotalPrice + homeprice
                        } else {
                            calulatedTotalPrice = calulatedTotalPrice + salonPrice
                        }
                    } else {
                        calulatedTotalPrice = calulatedTotalPrice + homeprice + salonPrice
                    }
                    
                    
                    servicesIdsArray.append(service.id)
                }
            }
            else {
                if isHomeBool {
                    for service in self.selectedServicesArray {
                        let string = NSString(string: service.homePrice)
                        let homeOffer = NSString(string: service.homeOfferPrice)
                        
                        let homeprice = string.floatValue
                        let homeOfferprice = homeOffer.floatValue
                        let salonPrice:Float =  0
                        
                        if homeOfferprice > 0.0 {
                            calulatedTotalPrice = calulatedTotalPrice + homeOfferprice + salonPrice
                        } else {
                            calulatedTotalPrice = calulatedTotalPrice + homeprice + salonPrice
                        }
                        
                        servicesIdsArray.append(service.id)
                    }
                }
                else {
                    for service in self.selectedServicesArray {
                        let homeprice:Float =  0
                        let string = NSString(string: service.salonPrice)
                        let salonOffer = NSString(string: service.salonOfferPrice)
                        let salonPrice = string.floatValue
                        let salonOfferprice = salonOffer.floatValue
                        
                        if salonOfferprice > 0.0 {
                            calulatedTotalPrice = calulatedTotalPrice + homeprice + salonOfferprice
                        } else {
                            calulatedTotalPrice = calulatedTotalPrice + homeprice + salonPrice
                        }
                        
                        calulatedTotalPrice = calulatedTotalPrice + homeprice + salonPrice
                        
                        servicesIdsArray.append(service.id)
                    }
                }
            }
        }
        else {
            // coming from order detail (rebooking flow)
            for service in self.selectedServicesArray {
                
                printToConsole(item: service.homePrice.intValue())
                printToConsole(item: service.salonPrice.intValue())
                
                let homeString = NSString(string: service.homePrice)
                let homeprice = homeString.floatValue
                let homeOffer = NSString(string: service.homeOfferPrice)
                let homeOfferprice = homeOffer.floatValue
                let salonOffer = NSString(string: service.salonOfferPrice)
                let salonString = NSString(string: service.salonPrice)
                let salonPrice = salonString.floatValue
                let salonOfferprice = salonOffer.floatValue
                
                
                if salonOfferprice > 0.0 && homeOfferprice > 0.0{
                    calulatedTotalPrice = calulatedTotalPrice + salonOfferprice + homeOfferprice
                } else if salonOfferprice > 0.0 {
                    calulatedTotalPrice = calulatedTotalPrice + homeprice + salonOfferprice
                } else if homeOfferprice > 0.0 {
                    calulatedTotalPrice = calulatedTotalPrice + homeOfferprice + salonPrice
                } else {
                    calulatedTotalPrice = calulatedTotalPrice + homeprice + salonPrice
                }
                
                servicesIdsArray.append(service.id)
            }
        }
        
        printToConsole(item: calulatedTotalPrice)
        
        let param = [
            "bookingTimestamp": timeStamp,
            "businessId": self.businessId ?? "",
            "businessServicesId": servicesIdsArray,
            "totalPrice": calulatedTotalPrice
            ] as [String : Any]
        
        printToConsole(item: param)
        
        worker = BookingWorker()
        worker?.hitTherapistTimeSlotApi(parameters: param, apiResponse: { (response) in
            if response.code == 200{
                self.presenter?.presentResponse(response: response)
            }
            else if response.code == 404 {
                CommonFunctions.sharedInstance.showSessionExpireAlert()
            }
            else {
                CustomAlertController.sharedInstance.showErrorAlert(error: response.error!)
            }
            
        })
    }
}
