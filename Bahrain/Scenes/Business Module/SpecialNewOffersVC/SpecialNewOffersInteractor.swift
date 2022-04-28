
import UIKit

protocol SpecialNewOffersBusinessLogic
{
    func getData()
    func hitCreateOfferApi(request: SpecialNewOffers.Request)
    func hitEditOfferApi(request: SpecialNewOffers.Request, offerId: String)
}

protocol SpecialNewOffersDataStore
{
    var selectedServicesArray: [SalonDetail.ViewModel.service]! { get set }
    var offerObj: AnyObject? { get set }
    var offerName: String? { get set }
    var offerImage: UIImage? { get set }
    var isHome: Bool? { get set }
}

class SpecialNewOffersInteractor: SpecialNewOffersBusinessLogic, SpecialNewOffersDataStore
{
    
    var presenter: SpecialNewOffersPresentationLogic?
    var worker: SpecialNewOffersWorker?
    var selectedServicesArray: [SalonDetail.ViewModel.service]!
    var offerObj: AnyObject?
    var offerName: String?
    var offerImage: UIImage?
    var isHome: Bool? 
    
    // MARK: Do something
    
    func hitCreateOfferApi(request: SpecialNewOffers.Request) {
        worker = SpecialNewOffersWorker()
        
        //        var servicesIdsArray = [String]()
        var serviceType = ""
        for service in self.selectedServicesArray {
            serviceType = service.type
            //            servicesIdsArray.append(service.id)
        
        }
        
        var param = [String : Any]()
        
        if serviceType == "salon"{
            param = [
                "expiryDate": request.expiryDate,
                "businessServicesId": request.servicesIdsArray,
                "userId": getUserData(._id),
                "offerName": offerName!,
                "businessId": getUserData(.businessId),
                "activeExpiryDate": request.expiryDate,
                "offerSalonPrice": request.offerSalonPrice,
                "totalSalonPrice": request.totalSalonPrice,
                "serviceType": serviceType
                
            ] 
            
        }
        else {
            param = [
                "expiryDate": request.expiryDate,
                "businessServicesId": request.servicesIdsArray,
                "userId": getUserData(._id),
                "offerName": offerName!,
                "businessId": getUserData(.businessId),
                "activeExpiryDate": request.expiryDate,
                "offerHomePrice": request.offerSalonPrice,
                "totalHomePrice": request.totalSalonPrice,
                "serviceType": "home"
                
            ]
            
        }
        
        worker?.hitCreateOfferApi(image: offerImage,parameters: param, apiResponse: { (response) in
            if response.code == 200 {
                self.presenter?.presentCreateOfferResponse()
            }
            else if response.code == 404 {
                CommonFunctions.sharedInstance.showSessionExpireAlert()
            }
            else {
                CustomAlertController.sharedInstance.showErrorAlert(error: response.error!)
            }
        })
    }
    
    
    func hitEditOfferApi(request: SpecialNewOffers.Request, offerId: String) {
        worker = SpecialNewOffersWorker()
        
        //        var servicesIdsArray = [String]()
        var serviceType = ""
        for service in self.selectedServicesArray {
            serviceType = service.type
            //            servicesIdsArray.append(service.id)
        }
        
        var param = [String : Any]()
        
        if serviceType == "salon"{
            param = [
                "expiryDate": request.expiryDate,
                "businessServicesId": request.servicesIdsArray,
                "userId": getUserData(._id),
                "offerName": offerName!,
                "businessId": getUserData(.businessId),
                "activeExpiryDate": request.expiryDate,
                "offerSalonPrice": request.offerSalonPrice,
                "totalSalonPrice": request.totalSalonPrice,
                "serviceType": serviceType
                
            ]
            
        }
        else {
            param = [
                "expiryDate": request.expiryDate,
                "businessServicesId": request.servicesIdsArray,
                "userId": getUserData(._id),
                "offerName": offerName!,
                "businessId": getUserData(.businessId),
                "activeExpiryDate": request.expiryDate,
                "offerHomePrice": request.offerSalonPrice,
                "totalHomePrice": request.totalSalonPrice,
                "serviceType": "home"
                
            ]
            
        }
        
        worker?.hitEditOfferApi(image:offerImage,parameters: param, offerId: offerId, apiResponse: { (response) in
            if response.code == 200 {
                self.presenter?.presentCreateOfferResponse()
            }
            else if response.code == 404 {
                CommonFunctions.sharedInstance.showSessionExpireAlert()
            }
            else {
                CustomAlertController.sharedInstance.showErrorAlert(error: response.error!)
            }
        })
        
    }
    
    
    func getData()
    {
        let response = SpecialNewOffers.ViewModel(selectedServicesArray: selectedServicesArray, offerObj: offerObj, offerName: offerName, offerImage: offerImage, TotalPrice: 0)
        printToConsole(item: response)
        presenter?.presentOfferData(response: response, isHome: self.isHome)
    }
    
    
}
