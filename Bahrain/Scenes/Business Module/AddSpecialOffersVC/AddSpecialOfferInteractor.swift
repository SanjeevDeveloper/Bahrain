
import UIKit

protocol AddSpecialOfferBusinessLogic
{
    func getBusinessByIdApi()
    func prepareOffer(offerName:String, selectedServicesArray: [SalonDetail.ViewModel.service], offerImage:UIImage?, isHome: Bool)
}

protocol AddSpecialOfferDataStore
{
    var selectedServicesArray: [SalonDetail.ViewModel.service]! { get set }
    var offerObj: AnyObject? { get set }
    var offerName: String? { get set }
    var offerImage: UIImage? { get set }
    var isHome: Bool? { get set }
}

class AddSpecialOfferInteractor: AddSpecialOfferBusinessLogic, AddSpecialOfferDataStore
{
    var presenter: AddSpecialOfferPresentationLogic?
    var worker: AddSpecialOfferWorker?
    var selectedServicesArray: [SalonDetail.ViewModel.service]!
    var offerObj: AnyObject?
    var offerName: String?
    var offerImage: UIImage?
    var isHome: Bool?
    
    var isEdit = false
    
    func getBusinessByIdApi() {
        worker = AddSpecialOfferWorker()
        
        worker?.getBusinessById(saloonId: getUserData(.businessId),apiResponse: { (response) in
            
            if response.code == 200 {
                if let dict = self.offerObj as? NSDictionary {
                    self.isEdit = true
                    self.presenter?.presentResponse(response: response, isComingFromEdit: true, previousDict: dict)
                }
                else {
                    self.presenter?.presentResponse(response: response, isComingFromEdit: false, previousDict: nil)
                }
                
            }
            else if response.code == 404 {
                CommonFunctions.sharedInstance.showSessionExpireAlert()
            }
            else {
                CustomAlertController.sharedInstance.showErrorAlert(error: response.error!)
            }
        })
    }
    
    func prepareOffer(offerName:String, selectedServicesArray: [SalonDetail.ViewModel.service], offerImage:UIImage?, isHome: Bool) {
        if isRequestValid(offerName: offerName, offerImage: offerImage, selectedServicesArray: selectedServicesArray) {
            self.offerName = offerName
            self.selectedServicesArray = selectedServicesArray
            self.offerImage = offerImage
            self.isHome = isHome
            presenter?.offerPrepared()
        }
    }
    
    func isRequestValid(offerName: String,offerImage: UIImage?, selectedServicesArray:[SalonDetail.ViewModel.service]) -> Bool {
        var isValid = true
        let validator = Validator()
        if !validator.validateRequired(offerName, errorKey:  AddSpecialOfferSceneText.AddSpecialOfferSceneOfferNameValidationText.rawValue)  {
            isValid = false
        }
        else if offerImage == nil && !isEdit {
                CustomAlertController.sharedInstance.showErrorAlert(error: localizedTextFor(key: AddSpecialOfferSceneText.AddOfferEmptyImage.rawValue))
                isValid = false
           
        }
        else if selectedServicesArray.count == 0  {
            CustomAlertController.sharedInstance.showErrorAlert(error: localizedTextFor(key: AddSpecialOfferSceneText.AddSpecialOfferSceneOfferServiceValidationText.rawValue))
            isValid = false
        }
        return isValid
    }
    
}
