
import UIKit

protocol SalonDetailBusinessLogic
{
    func getSpecialOffers()
    func hitAddRemoveFavoriteApi()
    func getBusinessByIdApi()
    func hitAddReviewApi(request: SalonDetail.Request)
    func prepareForBooking(salonName:String, selectedServicesArray: [SalonDetail.ViewModel.service], isHome: Bool) 
}

protocol SalonDetailDataStore
{
    var aboutResultDict:NSDictionary? { get set }
    var saloonId:String? { get set }
    var saloonName:String? { get set }
    var profileImage:String? { get set }
    var isHome: Bool? { get set }
    var selectedServicesArray: [SalonDetail.ViewModel.service]! { get set }
}

class SalonDetailInteractor: SalonDetailBusinessLogic, SalonDetailDataStore
{
    
    var presenter: SalonDetailPresentationLogic?
    var worker: SalonDetailWorker?
    var aboutResultDict: NSDictionary?
    var saloonId:String?
    var saloonName:String?
    var profileImage:String?
    var isHome: Bool?
    var selectedServicesArray: [SalonDetail.ViewModel.service]!
    
    // MARK: Do something
    
    func hitAddRemoveFavoriteApi()
    {
        worker = SalonDetailWorker()
        
        let param = [
            "userId":getUserData(._id),
            "businessId":saloonId!
        ]
        worker?.hitAddRemoveFavoriteApi(parameters: param, apiResponse: { (response) in
            
            self.presenter?.presentFavAddRemoveResponse(response: response)
        })
        
    }
    
    func getBusinessByIdApi() {
        worker = SalonDetailWorker()
        
        worker?.getBusinessById(saloonId: saloonId!,apiResponse: { (response) in
            
            if response.code == 200 {
                let resultDict = response.result as! NSDictionary
                
                
                self.saloonName = resultDict["saloonName"] as? String
                self.profileImage = resultDict["profileImage"] as? String
                
                self.aboutResultDict = resultDict
                
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
    
    func hitAddReviewApi(request: SalonDetail.Request) {
        
        worker = SalonDetailWorker()
        
        if request.rating.description == "0.0" {
            
            CustomAlertController.sharedInstance.showErrorAlert(error: localizedTextFor(key: SalonDetailSceneText.SalonDetailSceneEmptyRatingText.rawValue))
            
        }
        else{
            let param = [
                "businessId":saloonId!,
                "rating":request.rating,
                "review":request.reviewText,
                "userId":getUserData(._id)
                
            ]
            printToConsole(item: param)
            worker?.hitAddReviewApi(parameters: param, apiResponse: { (response) in
                
                if response.code == 200 {
                    self.presenter?.presentAddReviewResponse()
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
    
    func prepareForBooking(salonName:String, selectedServicesArray: [SalonDetail.ViewModel.service], isHome: Bool) {
        self.selectedServicesArray = selectedServicesArray
        self.saloonName = salonName
        self.isHome = isHome
        presenter?.preparedForBooking()
    }
    
    func getSpecialOffers() {
        worker = SalonDetailWorker()
        worker?.getSpecialOffer(businessID: saloonId!, apiResponse: { (response) in
            if response.code == 200 {
                self.presenter?.presentOfferListResponse(response: response)
            } else if response.code == 404 {
                CommonFunctions.sharedInstance.showSessionExpireAlert()
            } else {
                CustomAlertController.sharedInstance.showErrorAlert(error: response.error!)
            }
        })
    }
}

