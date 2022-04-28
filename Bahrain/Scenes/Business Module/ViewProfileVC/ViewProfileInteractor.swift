

import UIKit

protocol ViewProfileBusinessLogic
{
  func getBusinessByIdApi()
}

protocol ViewProfileDataStore
{
   var aboutResultDict:NSDictionary? { get set }
}

class ViewProfileInteractor: ViewProfileBusinessLogic, ViewProfileDataStore
{
  var presenter: ViewProfilePresentationLogic?
  var worker: ViewProfileWorker?
  var aboutResultDict:NSDictionary?
  
    func getBusinessByIdApi() {
        worker = ViewProfileWorker()
        
        worker?.getBusinessById(apiResponse: { (response) in
            
            if response.code == 200 {
                let resultDict = response.result as! NSDictionary
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
}
