
import UIKit

protocol WorkingHoursBusinessLogic
{
    func hitListBusinessWorkingHoursApi()
    func hitUpdateBusinessApi(request: WorkingHours.Request)
}

protocol WorkingHoursDataStore
{
    //var name: String { get set }
}

class WorkingHoursInteractor: WorkingHoursBusinessLogic, WorkingHoursDataStore
{
    
    var presenter: WorkingHoursPresentationLogic?
    var worker: WorkingHoursWorker?
    
    // MARK: Do something
    
    func hitListBusinessWorkingHoursApi()
    {
        worker = WorkingHoursWorker()
        
        worker?.getListBusinessWorkingHours(apiResponse: { (response) in
            if  response.code == 200 {
                self.presenter?.presentResponse(response: response)
            }
            else if response.code == 404 {
                CommonFunctions.sharedInstance.showSessionExpireAlert()
            }
            else{
                CustomAlertController.sharedInstance.showErrorAlert(error: response.error!)
            }
            
        })
    }
    
    func hitUpdateBusinessApi(request: WorkingHours.Request) {
        worker = WorkingHoursWorker()
        
        printToConsole(item: request.hoursArray)
        
        let dataArray = NSMutableArray()
        
        var isValid = false
        
        for item in request.hoursArray {
            
            if item.active == "true"{
                isValid = true
            }
            
            let dict = [
                "active": item.active,
                "day": item.day,
                "from": item.from,
                "fromTimestamp": item.fromTimestamp,
                "to": item.to,
                "toTimestamp": item.toTimestamp,
                
                ] as [String : Any]
            
            dataArray.add(dict)
        }
        
        if isValid {
            
            let param = [
                "userId":getUserData(._id),
                "step": "6",
                "businessWorkingHours":dataArray,
                ] as [String : Any]
            
            worker?.hitUpdateBusinessApi(parameters: param, apiResponse: { (response) in
                
                if  response.code == 200 {
                    self.presenter?.workingHoursUpdated()
                }
                else if response.code == 404 {
                    CommonFunctions.sharedInstance.showSessionExpireAlert()
                }
                else{
                    CustomAlertController.sharedInstance.showErrorAlert(error: response.error!)
                }
                
            })
        }
        else {
            CustomAlertController.sharedInstance.showErrorAlert(error: localizedTextFor(key: WorkingHourSceneText.workingHoursError.rawValue))
        }
    }
}
