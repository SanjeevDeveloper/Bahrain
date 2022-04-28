
import UIKit

protocol OpeningHoursBusinessLogic
{
  func hitListBusinessWorkingHoursApi()
  func getBusinessByIdApi()
}

protocol OpeningHoursDataStore
{
   var buisnessId:String? { get set }
}

class OpeningHoursInteractor: OpeningHoursBusinessLogic, OpeningHoursDataStore
{
  var presenter: OpeningHoursPresentationLogic?
  var worker: OpeningHoursWorker?
  var buisnessId: String?
 
  
  // MARK: Do something
  
  func hitListBusinessWorkingHoursApi()
  {
    worker = OpeningHoursWorker()
    worker?.getListBusinessWorkingHours(saloonBusinessId: buisnessId!, apiResponse: { (response) in
        if response.code == 200 {
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
    
    func getBusinessByIdApi() {
    worker = OpeningHoursWorker()
        worker?.getBusinessById(saloonId: buisnessId!, apiResponse: { (response) in
           
            if response.code == 200 {
                self.presenter?.presentGetBusinessResponse(response: response)
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
