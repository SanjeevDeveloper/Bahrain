
import UIKit

protocol SpecialOfferUserPresentationLogic
{
    func presentResponse(isFilter:Bool, isClearFilter:Bool, response: ApiResponse)
    func presentBookNowResponse(responseObj: NSDictionary)
    
}

class SpecialOfferUserPresenter: SpecialOfferUserPresentationLogic
{
    weak var viewController: SpecialOfferUserDisplayLogic?
    // MARK: Do something
    
    func presentBookNowResponse(responseObj: NSDictionary) {
        
        // var servicesArray = [[SalonDetail.ViewModel.service]]()
        var serviceArray = [SalonDetail.ViewModel.service]()
        var id = String()
        var salonName = String()
        
        
        printToConsole(item: responseObj)
        
        let offerid = responseObj["_id"] as! String
        let businessIdDict = responseObj["businessId"] as! NSDictionary
        id = businessIdDict["_id"] as! String
        salonName = businessIdDict["saloonName"] as! String
        let businessServiceIdArray = responseObj["businessServicesId"] as! NSArray
        
        printToConsole(item: businessServiceIdArray)
        
        
        var offerPrice : NSNumber
        var totalPrice : NSNumber
        var totalSalonPrice = ""
        if responseObj["serviceType"] as! String == "salon" {
            offerPrice = responseObj["offerSalonPrice"] as! NSNumber
            totalPrice = responseObj["totalSalonPrice"] as! NSNumber
        }
        else {
            offerPrice = responseObj["offerHomePrice"] as! NSNumber
            totalPrice = responseObj["totalHomePrice"] as! NSNumber
        }
        
        
        for (index, obj) in businessServiceIdArray.enumerated() {
            if let businessServiceIdDict = obj as? NSDictionary {
                let serviceName = businessServiceIdDict["serviceName"] as? String ?? ""
                let serviceDuration = ""
                let serviceType = responseObj["serviceType"] as! String
                // To Add Offer Price
                //  let priceToAdd = offerPrice/businessServiceIdArray.count
                
                
                //home Price is used to display all service Price
                var homePrice = ""
                
                if serviceType == "salon" {
                    let price = businessServiceIdDict["salonPrice"] as! NSNumber
                    homePrice = price.description
                }
                else {
                    let price = businessServiceIdDict["homePrice"] as! NSNumber
                    homePrice = price.description
                }
                
                
     //Salon Price is used to display Offer Price
                var salonPrice = ""
                
                if index == 0 {
                    salonPrice = offerPrice.floatValue.description
                    totalSalonPrice = totalPrice.floatValue.description
                }
                
                let id = businessServiceIdDict["_id"] as? String ?? ""
                
                let serviceObj = SalonDetail.ViewModel.service(
                    name: serviceName,
                    duration:serviceDuration,
                    salonPrice: salonPrice,
                    homePrice: homePrice,
                    type: serviceType,
                    id: id,
                    isSelected: false, about: "", salonOfferPrice: "0", homeOfferPrice: "0", isOfferAvailable: false, isSOfferAvailable: false)
                
                serviceArray.append(serviceObj)
            }
        }
        viewController?.displayBookNowResponse(servicesArray: serviceArray, businessId: id, saloonName: salonName,offerId:offerid, totalPrice: totalSalonPrice)
        
    }
    
    func presentResponse(isFilter:Bool, isClearFilter:Bool, response: ApiResponse)
    {
        var DataArray = [SpecialOfferUser.ViewModel.tableCellData]()
        var ViewModelObj:SpecialOfferUser.ViewModel
        
        if response.error != nil {
            ViewModelObj = SpecialOfferUser.ViewModel(tableArray: DataArray, maximumPrice: 0, minimumPrice: 0, errorString: response.error)
        }
        else {
            
            let response = response.result as! NSDictionary
            let minPrice = response["minPrice"] as? NSNumber ?? 0
            let maxPrice = response["maxPrice"] as? NSNumber ?? 0
            
            let data = response["businessData"] as! NSArray
            for arrData in data {
                var serviceName = String()
                
                if let dataDict = arrData as? NSDictionary {
                    if let businessIdDict = dataDict["businessId"] as? NSDictionary {
                        
                        if let businessServiceArray = dataDict["businessServicesId"] as? NSArray {
                            
                            if businessServiceArray.count != 0 {
                                
                                printToConsole(item: businessServiceArray)
                                
                                for businessServiceArrData in businessServiceArray{
                                    
                                    let businessServiceDict = businessServiceArrData as! NSDictionary
                                    
                                    
                                    let obj = businessServiceDict["serviceName"] as! String
                                    if serviceName.isEmptyString() {
                                        serviceName.append(obj)
                                    }
                                    else {
                                        serviceName.append(", \(obj)")
                                    }
                                }
                                
                                var offerPrice : NSNumber
                                var totalPrice : NSNumber
                             
                                
                                if dataDict["serviceType"] as! String == "salon" {
                                    offerPrice = dataDict["offerSalonPrice"] as! NSNumber
                                    totalPrice = dataDict["totalSalonPrice"] as! NSNumber
                                    
                                }
                                else {
                                    offerPrice = dataDict["offerHomePrice"] as! NSNumber
                                    totalPrice = dataDict["totalHomePrice"] as! NSNumber
                                 
                                }
                                
                                var expiryDateString = ""
                                if let expireDateMilliseconds = dataDict["expiryDate"] as? NSNumber {
                                    let expiryDate = Date(largeMilliseconds: expireDateMilliseconds.int64Value)
                                    let dateFormatter = getDateFormatter()
                                    dateFormatter.dateFormat = dateFormats.format11
                                    expiryDateString = dateFormatter.string(from: expiryDate)
                                }
                                
                                let obj = SpecialOfferUser.ViewModel.tableCellData(
                                    coverImage: dataDict["offerImage"] as? String ?? "",
                                    salonImage: businessIdDict["profileImage"] as? String ?? "",
                                    totalPrice: totalPrice,
                                    offerPrice: offerPrice,
                                    salonName: businessIdDict["saloonName"] as? String ?? "",
                                    offerName: dataDict["offerName"] as? String ?? "",
                                    serviceType: dataDict["serviceType"] as? String ?? "",
                                    serviceName: serviceName,
                                    expiryDate: expiryDateString
                                )
                                
                                DataArray.append(obj)
                                
                            }
                        }
                    }
                }
            }
            ViewModelObj = SpecialOfferUser.ViewModel(tableArray: DataArray, maximumPrice: maxPrice, minimumPrice: minPrice, errorString: nil)
            
        }
        if isFilter {
            viewController?.displayFilterResponse(viewModel: ViewModelObj)
        }else {
            viewController?.displayResponse(viewModel: ViewModelObj, isClearFilter: isClearFilter)
        }
        
    }
    
}
