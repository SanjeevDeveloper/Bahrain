
import UIKit
import MapKit

protocol ProfileSettingBusinessLogic
{
    func hitEditUserProfileApi(request: ProfileSetting.Request)
    func hitUpdateProfileImageApi(request: ProfileSetting.ImageRequest)
    func hitChangePasswordApi(request: ProfileSetting.ChangePasswordRequest)
    
    func showSelectedArea()
    func clearArea()
}

protocol ProfileSettingDataStore
{
    var selectedArea: String? { get set }
    var coordinate: CLLocationCoordinate2D? { get set }
    var pinAddress: String? { get set }
    var selectedBlock: String? { get set }
}

class ProfileSettingInteractor: ProfileSettingBusinessLogic, ProfileSettingDataStore
{
    
    var pinAddress: String?
    var coordinate: CLLocationCoordinate2D?
    var selectedBlock: String?
    var presenter: ProfileSettingPresentationLogic?
    var worker: ProfileSettingWorker?
    var selectedArea: String?
    
    // MARK: Do something
    
    func hitEditUserProfileApi(request: ProfileSetting.Request)
    {
        
        if isRequestValid(request: request) {
            
            worker = ProfileSettingWorker()
            
            let birthDateString = request.birthday
            let dateFormatter = DateFormatter()
            dateFormatter.timeZone = UaeTimeZone
            dateFormatter.dateFormat = dateFormats.format1
            let birthDate = dateFormatter.date(from: birthDateString)
            let birthDateMilliseconds = birthDate?.millisecondsSince1970
            let birthMillisecondsString = birthDateMilliseconds?.description ?? ""
            
            var param: [String: Any] = [
                "name":request.name,
                "area":request.area,
                "birthday":birthMillisecondsString,
                "language":request.language,
                "latitude":request.latitude,
                "longitude":request.longitude,
                "notification":request.notification,
                "address":request.address,
                "address2":request.address2,
                "block": request.block,
                "road": request.road,
                "houseNumber": request.houseNo,
                "flatNumber": request.flatno,
                "gender": request.gender
                ]
            
            if request.email != "" {
                param["email"] = request.email
            }
            
            printToConsole(item: param)
            
            worker?.hitEditUserProfileApi(parameters: param , apiResponse: { (response) in
                if response.code == 200 {
                    self.presenter?.presentResponse(response: response)
                }
                else if response.code == 404{
                    CommonFunctions.sharedInstance.showSessionExpireAlert()
                }
                else {
                    CustomAlertController.sharedInstance.showErrorAlert(error: response.error!)
                }
                
            })
        }
    }
    
    func hitUpdateProfileImageApi(request: ProfileSetting.ImageRequest) {
        worker = ProfileSettingWorker()
        worker?.hitUpdateProfileImageApi(image: request.imageView, imageName: request.imageTitle, apiResponse: { (response) in
            
            if response.code == 200 {
                self.presenter?.presentUpdateImageResponse(response: response)
            }
            else if response.code == 404{
                CommonFunctions.sharedInstance.showSessionExpireAlert()
            }
            else {
                CustomAlertController.sharedInstance.showErrorAlert(error: response.error!)
            }
            
        })
    }
    
    func hitChangePasswordApi(request: ProfileSetting.ChangePasswordRequest)
    {
        
        if isChangePasswordRequestValid(request: request) {
            
            worker = ProfileSettingWorker()
            
            let parameter = [
                "userId":getUserData(._id),
                "currentPassword":request.currentPassword,
                "newPassword":request.newPassword,
                "verifyPassword":request.verifyPassword,
                "email": "",
                "isTemporary": false
                
                ] as [String : Any]
            worker?.hitChangePasswordApi(parameters: parameter , apiResponse: { (response) in
                if response.code == 200 {
                    self.presenter?.presentChangePasswordResponse(response: response)
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
    
    
    func showSelectedArea() {
        if selectedArea != nil { presenter?.presentSelectedArea(ResponseText: selectedArea)
        }
    }
    
    func isRequestValid(request: ProfileSetting.Request) -> Bool {
        var isValid = true
        let validator = Validator()
        if !validator.validateRequired(request.name, errorKey: ValidationsText.emptyName.rawValue)  {
            isValid = false
        }
        else if (request.email != "") {
            if !validator.validateEmail(request.email, errorKey:ValidationsText.invalidEmail.rawValue)  {
                isValid = false
            }
        }
        
        return isValid
    }
    
    func isChangePasswordRequestValid(request: ProfileSetting.ChangePasswordRequest) -> Bool {
        var isValid = true
        let validator = Validator()
        if !validator.validateRequired(request.currentPassword, errorKey: ValidationsText.emptyPassword.rawValue)  {
            isValid = false
        }
        else if !validator.validateRequired(request.newPassword, errorKey: ValidationsText.emptyNewPassword.rawValue)  {
            isValid = false
        }
        else if !validator.validateMinCharactersCount(request.newPassword, minCount: 8, minCountErrorKey: ValidationsText.passwordLength.rawValue)  {
            isValid = false
        }
        else if !validator.validateRequired(request.verifyPassword, errorKey: ValidationsText.emptyConfirmPassword.rawValue)  {
            isValid = false
        }
        else if !validator.validateEquality(request.newPassword, secondItem: request.verifyPassword, errorKey: ValidationsText.confirmPasswordMatch.rawValue){
            isValid = false
        }
        
        return isValid
    }
    
    func clearArea() {
        self.selectedArea = nil
    }
    
}
