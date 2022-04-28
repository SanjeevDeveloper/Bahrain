

import UIKit

protocol LoginBusinessLogic
{
    func hitLoginApi(request: Login.Request)
    func hitEditUserProfileApi()
    func hitChangePasswordApi(request: ProfileSetting.ChangePasswordRequest, email: String)
}

protocol LoginDataStore
{
}

class LoginInteractor: LoginBusinessLogic, LoginDataStore
{
    var presenter: LoginPresentationLogic?
    var worker: LoginWorker?
    
    func hitLoginApi(request: Login.Request)
    {
        if isRequestValid(request: request) {
            worker = LoginWorker()
            let param = [
                "password":request.password,
                "countryCode": request.countryCode,
                "phoneNumber":request.mobileNumber,
                "deviceType" : "ios",
                "language":UserDefaults.standard.value(forKey: userDefualtKeys.currentLanguage.rawValue) as! String,
                "deviceId" : userDefault.value(forKey: userDefualtKeys.firebaseToken.rawValue) as? String ?? ""
            ]
            print(param)
            printToConsole(item: param)
            worker?.hitLoginApi(parameters: param, apiResponse: { (response) in
                if response.code == 200 {
                    // saving complete user object
                    printToConsole(item: response.result)
                    let resultDict = response.result as! NSDictionary
                    let resultData = NSKeyedArchiver.archivedData(withRootObject: resultDict.mutableCopy())
                    userDefault.set(resultData, forKey: userDefualtKeys.UserObject.rawValue)
                    appDelegateObj.unarchiveUserData()
                    self.presenter?.presentLoginSuccessResponse(response: response)
                    
                    // saving isbusinessDelete Bool value
                    
                    let data = resultDict["isBusinessDelete"] as? Bool
                    
                    userDefault.set(data, forKey: userDefualtKeys.isBusinessDelete.rawValue)
                    
                    // for password functionality its changed
//                    // updating user log in status
//                    userDefault.set(true, forKey: userDefualtKeys.userLoggedIn.rawValue)
                    
                  
                    
                }
                self.presenter?.presentLoginResponse(response: response)
            })
        }
    }
    
    func hitEditUserProfileApi() {
               worker = LoginWorker()
               let param: [String: Any] = ["gender": userDefault.value(forKey: "gender")]
               printToConsole(item: param)
               worker?.hitEditUserProfileApi(parameters: param , apiResponse: { (response) in
                   if response.code == 200 {
                       self.presenter?.presentResponse(response: response)
                   } else if response.code == 404{
                       CommonFunctions.sharedInstance.showSessionExpireAlert()
                   } else {
                       CustomAlertController.sharedInstance.showErrorAlert(error: response.error!)
                   }
               })
       }
    
    func hitChangePasswordApi(request: ProfileSetting.ChangePasswordRequest, email: String)
    {
        
        if isChangePasswordRequestValid(request: request, email: email) {
            
            worker = LoginWorker()
            
            let parameter = [
                "userId":getUserData(._id),
                "currentPassword":request.currentPassword,
                "newPassword":request.newPassword,
                "verifyPassword":request.verifyPassword,
                "email": email,
                "isTemporary": true
                ] as [String : Any]
            worker?.hitChangePasswordApi(parameters: parameter , apiResponse: { (response) in
                if response.code == 404 {
                    CommonFunctions.sharedInstance.showSessionExpireAlert()
                }
                else {
                    self.presenter?.presentChangePasswordResponse(response: response)
                }
                
            })
        }
    }
    
    
    
    func isRequestValid(request: Login.Request) -> Bool {
        var isValid = true
        let validator = Validator()
        if !validator.validateRequired(request.mobileNumber, errorKey: ValidationsText.emptyPhoneNumber.rawValue)  {
            isValid = false
        }
        else if !validator.validateRequired(request.password, errorKey: ValidationsText.emptyPassword.rawValue)  {
            isValid = false
        }
//        else if !validator.validateMinCharactersCount(request.password, minCount: 8, minCountErrorKey: ValidationsText.passwordLength.rawValue)  {
//            isValid = false
//        }
//        else if !validator.validateMinCharactersCount(request.mobileNumber, minCount: 7,  minCountErrorKey: ValidationsText.phoneNumberMinLength.rawValue)  {
//            isValid = false
//        }
        return isValid
    }
    
    func isChangePasswordRequestValid(request: ProfileSetting.ChangePasswordRequest, email: String) -> Bool {
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
        } else if !validator.validateRequired(email, errorKey: ValidationsText.emptyEmail.rawValue)  {
            isValid = false
        }
        
        return isValid
    }
}
