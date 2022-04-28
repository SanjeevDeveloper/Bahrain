

import UIKit

protocol ViewProfilePresentationLogic
{
    func presentResponse(response: ApiResponse)
}

class ViewProfilePresenter: ViewProfilePresentationLogic
{
  weak var viewController: ViewProfileDisplayLogic?
  
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
                                    let serviceName = businessServiceIdDict["serviceName"] as? String ?? ""
                                    let serviceDuration = businessServiceIdDict["serviceDuration"] as? String ?? ""
                                    let serviceType = businessServiceIdDict["serviceType"] as! String
                                    let bhdText = localizedTextFor(key: GeneralText.bhd.rawValue)
                                    let salonPrice = (businessServiceIdDict["salonPrice"] as? NSNumber ?? 0).description + " " + bhdText
                                    
                                    let homePrice = (businessServiceIdDict["homePrice"] as? NSNumber ?? 0).description + " " + bhdText
                                    
                                    let salonOfferPrice = String(format: "%.3f",(businessServiceIdDict["salonPrice"] as? NSNumber ?? 0).floatValue)
                                    let homeOfferPrice = String(format: "%.3f",(businessServiceIdDict["homePrice"] as? NSNumber ?? 0).floatValue)
                                    
                                    let id = businessServiceIdDict["_id"] as? String ?? ""
                                    
                                    let serviceObj = SalonDetail.ViewModel.service(
                                        name: serviceName,
                                        duration:serviceDuration,
                                        salonPrice: salonPrice,
                                        homePrice: homePrice,
                                        type: serviceType,
                                        id: id,
                                        isSelected: false, about: "", salonOfferPrice: salonOfferPrice.description + " " + bhdText, homeOfferPrice: homeOfferPrice.description + " " + bhdText, isOfferAvailable: false, isSOfferAvailable: false)
                                    
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
  
  
}
