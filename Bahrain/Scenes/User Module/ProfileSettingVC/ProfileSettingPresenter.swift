
import UIKit

protocol ProfileSettingPresentationLogic
{
  func presentResponse(response: ApiResponse)
  func presentUpdateImageResponse(response: ApiResponse)
  func presentChangePasswordResponse(response: ApiResponse)
  func presentSelectedArea(ResponseText:String?)
    
}

class ProfileSettingPresenter: ProfileSettingPresentationLogic
{
    
  weak var viewController: ProfileSettingDisplayLogic?
  
  // MARK: Do something
  
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
            
            ViewModelObj = ProfileSetting.ChangePasswordModel(message: resultDict["message"] as? String, errormessage: nil)
        }
        
        viewController?.displayChangePasswordResponse(viewModel: ViewModelObj)
    }
    
    
    
    
    
    func presentUpdateImageResponse(response: ApiResponse)
    {
        var ViewModelObj:ProfileSetting.ViewModel
        
        if response.error != nil {
            ViewModelObj = ProfileSetting.ViewModel(dict: nil, errorString: response.error)
        }
        else {
            
            let dataDict = response.result as! NSDictionary
            ViewModelObj = ProfileSetting.ViewModel(dict: dataDict, errorString: nil)
        }
        viewController?.displayUpdateImageResponse(viewModel: ViewModelObj)
    }
    
  func presentSelectedArea(ResponseText: String?) {
        viewController?.displaySelectedAreaText(ResponseMsg: ResponseText)
    }
}
