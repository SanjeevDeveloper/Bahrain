

import UIKit

protocol LoginPresentationLogic
{
    func presentResponse(response: ApiResponse)
    func presentLoginResponse(response: ApiResponse)
    func presentLoginSuccessResponse(response: ApiResponse)
    func presentChangePasswordResponse(response: ApiResponse)
}

class LoginPresenter: LoginPresentationLogic
{
    
    
    weak var viewController: LoginDisplayLogic?
    
    func presentLoginResponse(response: ApiResponse)
    {
        
        let viewModel = Login.ViewModel(error: response.error)
        viewController?.displayLoginResponse(viewModel: viewModel)
    }
    
    func presentLoginSuccessResponse(response: ApiResponse) {
        let resultDict = response.result as! NSDictionary
        let isFirstTimeLogin = resultDict["firstTimeLogin"] as! Bool
        
        // check business is approved or not
        let isApproved = resultDict["isApproved"] as! Bool
        userDefault.set(isApproved, forKey: userDefualtKeys.businessApproved.rawValue)
        
        //Registered Date
        let createdAt = resultDict["createdAt"] as! Int64
        let createdDate = Date(largeMilliseconds: createdAt)
        let dateFormatterC = DateFormatter()
        dateFormatterC.timeZone = UaeTimeZone
        dateFormatterC.dateFormat = dateFormats.format10
        let createDate = dateFormatterC.string(from: createdDate)
        
        userDefault.set(createDate, forKey: userDefualtKeys.registeredDate.rawValue)
        
        
        viewController?.displayLoginSuccessResponse(isFirstTimeLogin: isFirstTimeLogin)
    }
    
    func presentResponse(response: ApiResponse)
    {
      var ViewModelObj:ProfileSetting.ViewModel
      
      if response.error != nil {
          ViewModelObj = ProfileSetting.ViewModel(dict: nil, errorString: response.error)
      }
      else {
          
          let dataDict = response.result as! NSDictionary
          ViewModelObj = ProfileSetting.ViewModel(dict: dataDict, errorString: nil)
      }
      viewController?.displayResponse(viewModel: ViewModelObj)
    }
    
    func presentChangePasswordResponse(response: ApiResponse) {
        var ViewModelObj:ProfileSetting.ChangePasswordModel
        
        if response.error != nil {
            ViewModelObj = ProfileSetting.ChangePasswordModel(message: nil, errormessage: response.error!)
        }
        else {
            let resultDict = response.result as! NSDictionary
            
            if let loginData = resultDict["loginData"] as? NSDictionary {
                let resultData = NSKeyedArchiver.archivedData(withRootObject: loginData.mutableCopy())
                userDefault.set(resultData, forKey: userDefualtKeys.UserObject.rawValue)
                appDelegateObj.unarchiveUserData()
            }
            
            ViewModelObj = ProfileSetting.ChangePasswordModel(message: resultDict["message"] as? String, errormessage: nil)
        }
        
        viewController?.displayChangePasswordResponse(viewModel: ViewModelObj)
    }
}
