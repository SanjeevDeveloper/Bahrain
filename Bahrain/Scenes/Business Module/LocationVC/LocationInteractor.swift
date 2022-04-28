
import UIKit

protocol LocationBusinessLogic
{
    func showSelectedArea()
    func getBusinessInfo()
    func updateLocation(request:Location.Request)
}

protocol LocationDataStore
{
    var saloonData:BasicInformation.Request? { get set }
    var selectedArea: String? { get set }
    var selectedBlock: String? { get set }
}

class LocationInteractor: LocationBusinessLogic, LocationDataStore
{
    var presenter: LocationPresentationLogic?
    var worker: LocationWorker?
    var saloonData:BasicInformation.Request?
    var selectedArea: String?
    var selectedBlock: String?
    
    func showSelectedArea() {
        presenter?.presentSelectedArea(ResponseText: selectedArea)
    }
    
    func getBusinessInfo() {
        worker = LocationWorker()
        worker?.getBusinessById(apiResponse: { (response) in
            if response.code == 200 {
                self.presenter?.gotBusinessInfo(info: response.result as! NSDictionary)
            }
            else if response.code == 404 {
                CommonFunctions.sharedInstance.showSessionExpireAlert()
            }
            else {
                CustomAlertController.sharedInstance.showErrorAlert(error: response.error!)
            }
        })
    }
    
    func updateLocation(request:Location.Request) {
        if isRequestValid(request: request) {
            var param:[String:Any]
            if appDelegateObj.isPageControlActive {
                param = [
                    "address": request.block,
                    "step": "2",
                    "specialLocation":request.specialLocation,
                    "address2": request.address1Street,
                    "avenue": request.avenue,
                    "userId": getUserData(._id),
                    "website": appDelegateObj.saloonStep1Data!.website,
                    "saloonName": appDelegateObj.saloonStep1Data!.saloonName,
                    "phoneNumber":appDelegateObj.saloonStep1Data!.phoneNumber,
                    "buildingFloor": request.buildingFloor,
                    "area": request.area,
                    "instaAccount": appDelegateObj.saloonStep1Data!.instagramAccount,
                    "about": appDelegateObj.saloonStep1Data!.about,
                    "crNumberText":request.crNumber
                ]
            }
            else {
                param = [
                    "address": request.block,
                    "step": "2",
                    "specialLocation":request.specialLocation,
                    "address2": request.address1Street,
                    "avenue": request.avenue,
                    "userId": getUserData(._id),
                    "saloonName": getUserData(.saloonName),
                    "buildingFloor": request.buildingFloor,
                    "area": request.area,
                    "crNumberText":request.crNumber
                ]
            }
            
            worker = LocationWorker()
           
            
            
            worker?.updateLocation(pdf: request.crDocument ?? nil, image: request.crImage ?? nil ,parameters: param, apiResponse: { (response) in
                if response.code == 200 {
                   
                   if appDelegateObj.isPageControlActive { CommonFunctions.sharedInstance.updateUserData(.saloonName, value: appDelegateObj.saloonStep1Data!.saloonName)
                    }
                    self.presenter?.locationUpdated()
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
    
    func isRequestValid(request: Location.Request) -> Bool {
        var isValid = true
        let validator = Validator()
        if !validator.validateRequired(request.area, errorKey: LocationSceneText.locationSceneEmptyArea.rawValue)  {
            isValid = false
        }
        else if !validator.validateRequired(request.block, errorKey: LocationSceneText.locationSceneEmptyBlockAddress.rawValue)  {
            isValid = false
        }
        else if !validator.validateNil(request.address1Street, errorKey: LocationSceneText.locationSceneEmptyStreetAddress.rawValue)  {
            isValid = false
        }
//        else if !validator.validateRequired(request.crNumber, errorKey: localizedTextFor(key: LocationSceneText.crNumberEmptyError.rawValue)) {
//            isValid = false
//        }
//        else if request.crImage == nil && (request.crDocument?.absoluteString.isEmpty)! {
//            CustomAlertController.sharedInstance.showErrorAlert(error: localizedTextFor(key: LocationSceneText.uploadCrError.rawValue))
//            isValid = false
//        }
        return isValid
    }
}
