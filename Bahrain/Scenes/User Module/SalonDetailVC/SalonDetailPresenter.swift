
import UIKit

protocol SalonDetailPresentationLogic
{
    func presentResponse(response: ApiResponse)
    func presentFavAddRemoveResponse(response: ApiResponse)
    func presentAddReviewResponse()
    func preparedForBooking()
    func presentOfferListResponse(response: ApiResponse)
}

class SalonDetailPresenter: SalonDetailPresentationLogic
{
    weak var viewController: SalonDetailDisplayLogic?
    
    // MARK: Do something
    
    func presentFavAddRemoveResponse(response: ApiResponse)
    {
        viewController?.displayFavAddRemoveResponse(viewModel: response)
    }
    
    func presentResponse(response: ApiResponse) {
        
        let resultDict = response.result as! NSDictionary
        
        let galleryImagesArray = resultDict["gallery"] as! NSArray
        
        let latitudeString = resultDict["latitude"] as? String ?? "0"
        let longitudeString = resultDict["longitude"] as? String ?? "0"
        
        let latitude = (latitudeString as NSString).doubleValue
        let longitude = (longitudeString as NSString).doubleValue
        
        var categoriesArray = [String]()
        
        
        
        var servicesArray = [[SalonDetail.ViewModel.service]]()
        if let servicesCategoryIdArray = resultDict["serviceCategoryId"] as? NSArray {
            for obj in servicesCategoryIdArray {
                if let serviceCategoryIdDict = obj as? NSDictionary {
                    
                    ////////////////
                    if let categoryIdDict = serviceCategoryIdDict["categoryId"] as? NSDictionary {
                        let categoryName = categoryIdDict["categoryName"] as? String ?? ""
                        categoriesArray.append(categoryName)
                        /////////////////
                        
                        var serviceArray = [SalonDetail.ViewModel.service]()
                        if let businessServiceIdArray = serviceCategoryIdDict["businessServiceId"] as? NSArray {
                            for obj in businessServiceIdArray {
                                if let businessServiceIdDict = obj as? NSDictionary {
                                    
                                    var serviceName = ""
                                    
                                    if isCurrentLanguageArabic() {
                                        if let arabicName = businessServiceIdDict["serviceNameArabic"] as? String  {
                                            if arabicName == "" {
                                                serviceName = "-"
                                            } else {
                                                serviceName = arabicName
                                            }
                                        }
                                    } else {
                                        if let englishName = businessServiceIdDict["serviceName"] as? String  {
                                            if englishName == "" {
                                                serviceName = "-"
                                            } else {
                                                serviceName = englishName
                                            }
                                        }
                                    }
                                    
                                    let serviceDuration = businessServiceIdDict["serviceDuration"] as? String ?? ""
                                    let serviceType = businessServiceIdDict["serviceType"] as! String
                                    let salonPrice = String(format: "%.3f",(businessServiceIdDict["salonPrice"] as? NSNumber ?? 0).floatValue)
                                    let homePrice = String(format: "%.3f",(businessServiceIdDict["homePrice"] as? NSNumber ?? 0).floatValue)
                                    let salonOfferPrice = String(format: "%.3f",(businessServiceIdDict["salonOfferPrice"] as? NSNumber ?? 0).floatValue)
                                    let homeOfferPrice = String(format: "%.3f",(businessServiceIdDict["homeOfferPrice"] as? NSNumber ?? 0).floatValue)
                                    let id = businessServiceIdDict["_id"] as? String ?? ""
                                    let serviceDescription = businessServiceIdDict["serviceDescription"] as? String ?? ""
                                    var offerAvailable = false
                                    if ((businessServiceIdDict["salonOfferPrice"] as? NSNumber) ?? 0).floatValue > 0.0 {
                                        offerAvailable = true
                                    } else {
                                        offerAvailable = false
                                    }
                                    
                                    
                                    var hOfferAvailable = false
                                    if ((businessServiceIdDict["homeOfferPrice"] as? NSNumber) ?? 0).floatValue > 0.0 {
                                        hOfferAvailable = true
                                    } else {
                                        hOfferAvailable = false
                                    }
                                    
                                    
                                    let serviceObj = SalonDetail.ViewModel.service(
                                        name: serviceName,
                                        duration:serviceDuration,
                                        salonPrice: salonPrice.description + " " +  localizedTextFor(key: GeneralText.bhd.rawValue),
                                        homePrice: homePrice.description + " " + localizedTextFor(key: GeneralText.bhd.rawValue),
                                        type: serviceType,
                                        id: id,
                                        isSelected: false, about: serviceDescription, salonOfferPrice: salonOfferPrice.description + " " +  localizedTextFor(key: GeneralText.bhd.rawValue), homeOfferPrice: homeOfferPrice.description + " " + localizedTextFor(key: GeneralText.bhd.rawValue), isOfferAvailable: hOfferAvailable, isSOfferAvailable: offerAvailable)
                                    
                                    serviceArray.append(serviceObj)
                                }
                            }
                            servicesArray.append(serviceArray)
                        }
                    }
                }
            }
        }
        let ViewModelObj = SalonDetail.ViewModel(galleryImages: galleryImagesArray as! [String], avgRating: resultDict["avgRating"] as? Double ?? 0.0, review: resultDict["totalReviews"] as? Int, isFavorite: resultDict["isFavorite"] as? Int ?? 0, salonName: resultDict["saloonName"] as! String, profileImage: resultDict["profileImage"] as! String,  serviceType: resultDict["serviceType"] as! String, latitude: latitude, longitude: longitude, categoriesArray: categoriesArray, servicesArray: servicesArray)
        
        viewController?.displaybusinessIdResponse(viewModel: ViewModelObj)
    }
    
    func presentAddReviewResponse() {
        viewController?.displayAddReviewResponse()
    }
    
    func preparedForBooking() {
        viewController?.preparedForBooking()
    }
    
    func presentOfferListResponse(response: ApiResponse) {
        var salonOffers = [SalonDetail.SpecialOfferDetail]()
        if let packagesArray = response.result as? [[String: Any]] {
            //if let packagesArray = resp["packages"] as? [[String: Any]] {
            
            for packageObj in packagesArray {
                if var salonListObj = CommonFunctions.convertJsonObjectToModel(packageObj, modelType: SalonDetail.SpecialOfferDetail.self) {
                    if var serviceList = salonListObj.businessServicesId {
                        for (index, _) in serviceList.enumerated() {
                            serviceList[index].isServiceAdded = false
                        }
                        salonListObj.businessServicesId = serviceList
                    }
                    salonOffers.append(salonListObj)
                }
            }
            viewController?.displaySpecialOffersList(specialOffers: salonOffers)
            //}
        }
    }
}
