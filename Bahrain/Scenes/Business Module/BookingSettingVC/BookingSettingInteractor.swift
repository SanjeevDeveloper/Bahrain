
import UIKit

protocol BookingSettingBusinessLogic
{
    func hitGetBusinessById()
    func hitUpdateBusinessApi(request: BookingSetting.Request)
}

protocol BookingSettingDataStore
{
    //var name: String { get set }
}

class BookingSettingInteractor: BookingSettingBusinessLogic, BookingSettingDataStore
{
    var presenter: BookingSettingPresentationLogic?
    var worker: BookingSettingWorker?
    //var name: String = ""
    
    // MARK: Do something
    
    func hitGetBusinessById()
    {
        worker = BookingSettingWorker()
        
        worker?.getBusinessById(apiResponse: { (response) in
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
    
    func hitUpdateBusinessApi(request: BookingSetting.Request) {
        
        if isRequestValid(request: request) {
            worker = BookingSettingWorker()
            
            let param = [
                "note": request.note,
                "userId": getUserData(._id),
                "timeStamp": request.time
                ] as [String : Any]
            
            worker?.hitUpdateBusinessApi(parameters: param, apiResponse: { (response) in
                if response.code == 200 {
                    self.presenter?.presentUpdateResponse(response: response)
                    
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
    
    func isRequestValid(request: BookingSetting.Request) -> Bool {
        var isValid = true
        let validator = Validator()
        if !validator.validateRequired(request.time, errorKey: "Enter Time")  {
            isValid = false
        }
        else if !validator.validateRequired(request.note, errorKey: "Enter Note")  {
            isValid = false
        }
        return isValid
    }
    
}
