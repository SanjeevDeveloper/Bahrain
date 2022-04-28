
import UIKit

protocol AccountVisibilityBusinessLogic
{
    func hitGetBusinessByIdApi()
    func hitUpdateBusinessApi(visibility: Bool)
    func hitDeleteBusinessAccountApi()
}

protocol AccountVisibilityDataStore
{
    //var name: String { get set }
}

class AccountVisibilityInteractor: AccountVisibilityBusinessLogic, AccountVisibilityDataStore
{
    
    
    var presenter: AccountVisibilityPresentationLogic?
    var worker: AccountVisibilityWorker?
    //var name: String = ""
    
    // MARK: Do something
    
    func hitDeleteBusinessAccountApi() {
        worker = AccountVisibilityWorker()
        
        worker?.hitDeleteBusinessAccountApi(apiResponse: { (response) in
            if response.code == 200{
                let apiResponseDict = response.result as! NSDictionary
                let msg = apiResponseDict["msg"] as? String ?? ""
                CustomAlertController.sharedInstance.showAlert(subTitle: msg, type: .success)
                self.presenter?.presentDeleteAccountResponse(response: response)
            }
            else if response.code == 404 {
                CommonFunctions.sharedInstance.showSessionExpireAlert()
            }
            else {
                CustomAlertController.sharedInstance.showErrorAlert(error: response.error!)
            }
        })
    }
    
    
    
    func hitGetBusinessByIdApi()
    {
        worker = AccountVisibilityWorker()
        
        worker?.getBusinessById(apiResponse: { (response) in
            
            if response.code == 200{
                
                self.presenter?.presentVisibilityResponse(response: response)
                
            }
            else if response.code == 404 {
                CommonFunctions.sharedInstance.showSessionExpireAlert()
            }
            else {
                CustomAlertController.sharedInstance.showErrorAlert(error: response.error!)
            }
            
        })
        
    }
    
    func hitUpdateBusinessApi(visibility: Bool) {
        worker = AccountVisibilityWorker()
        
        let param = [
            "userId": getUserData(._id),
            "step": "2",
            "visibility": visibility,
            
            ] as [String : Any]
        
        worker?.hitUpdateBusinessApi(parameters: param, apiResponse: { (response) in
            
            if response.code == 200{
                
                if visibility{
                    CustomAlertController.sharedInstance.showAlert(subTitle: localizedTextFor(key: AccountVisibilitySceneText.accountVisibilitySceneTurnedOnMessage.rawValue), type: .success)
                }
                else {
                    CustomAlertController.sharedInstance.showAlert(subTitle: localizedTextFor(key: AccountVisibilitySceneText.accountVisibilitySceneTurnedOffMessage.rawValue), type: .success)
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
    
}
