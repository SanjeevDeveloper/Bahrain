
import UIKit

protocol BasicInformationBusinessLogic
{
    func updateBusinessImage(request:BasicInformation.imageRequest)
    
    func updateSaloonName(request:BasicInformation.Request)
    
    func getBusinessInfo()
}

protocol BasicInformationDataStore
{
    var saloonData:BasicInformation.Request? { get set }
}

class BasicInformationInteractor: BasicInformationBusinessLogic, BasicInformationDataStore
{
    var presenter: BasicInformationPresentationLogic?
    var worker: BasicInformationWorker?
    var saloonData:BasicInformation.Request?
    
    func updateSaloonName(request:BasicInformation.Request) {
        
        if isRequestValid(request: request) {
            if appDelegateObj.isPageControlActive {
                appDelegateObj.saloonStep1Data = request
                presenter?.requestValidated()
            }
            else {
                let param = [
                    "step":"2",
                    "userId":getUserData(._id),
                    "saloonName":request.saloonName,
                    "website":request.website,
                    "instaAccount":request.instagramAccount,
                    "phoneNumber":request.phoneNumber,
                    "about":request.about
                ]
                worker = BasicInformationWorker()
                worker?.updateBasicInfo(parameters: param, apiResponse: { (response) in
                    
                    if response.code == 200 {
                        CommonFunctions.sharedInstance.updateUserData(.saloonName, value: request.saloonName)
                        self.presenter?.infoUpdated()
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
    }
    
    func updateBusinessImage(request:BasicInformation.imageRequest) {
        
        worker = BasicInformationWorker()
        worker?.updateBusinessImage(image: request.image, imageName: request.imageName, apiResponse: { (response) in
            if response.code == 200 {
                self.presenter?.imageUploaded(imageData:request)
                let resultObj = response.result as! NSDictionary
                self.updateSalonImageInUserDefault(resultDict: resultObj)
            }
            else if response.code == 404 {
                CommonFunctions.sharedInstance.showSessionExpireAlert()
            }
            else {
                CustomAlertController.sharedInstance.showErrorAlert(error: response.error!)
            }
        })
    }
    
    func getBusinessInfo() {
        worker = BasicInformationWorker()
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
    
    func updateSalonImageInUserDefault(resultDict:NSDictionary) {
        let profileImageUrl = resultDict[PhotoType.profileImage] as? String ?? ""
        let coverImageUrl = resultDict[PhotoType.coverPhoto] as? String ?? ""
        
        userDefault.set(profileImageUrl, forKey: userDefualtKeys.saloonProfileImage.rawValue)
        
        userDefault.set(coverImageUrl, forKey: userDefualtKeys.saloonCoverImage.rawValue)
    }
    
    func isRequestValid(request: BasicInformation.Request) -> Bool {
        var isValid = true
        let validator = Validator()
        if !validator.validateRequired(request.saloonName, errorKey: BasicInformationSceneText.basicInformationSceneEmptySaloonName.rawValue)  {
            isValid = false
        }
        else if !validator.validateRequired(request.phoneNumber, errorKey: ValidationsText.emptyPhoneNumber.rawValue)  {
            isValid = false
        }
        else if !validator.validateMinCharactersCount(request.phoneNumber, minCount: 7,  minCountErrorKey: ValidationsText.phoneNumberMinLength.rawValue)  {
            isValid = false
        }
        else if !validator.validateNil(request.profileImage, errorKey: BasicInformationSceneText.basicInformationSceneEmptySaloonImage.rawValue)  {
            isValid = false
        }
        else if !validator.validateNil(request.coverImage, errorKey: BasicInformationSceneText.basicInformationSceneEmptySaloonCoverImage.rawValue)  {
            isValid = false
        }
        return isValid
    }
    
}
