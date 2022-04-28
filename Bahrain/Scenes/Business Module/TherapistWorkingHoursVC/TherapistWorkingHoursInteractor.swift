
import UIKit



protocol TherapistWorkingHoursBusinessLogic
{
    func hitListBusinessWorkingHoursApi()
}

protocol TherapistWorkingHoursDataStore
{
    var workingHourArray: [TherapistWorkingHours.ViewModel.tableCellData]?{ get set }
    var businessWorkingResponse : NSArray? { get set }
}

class TherapistWorkingHoursInteractor: TherapistWorkingHoursBusinessLogic, TherapistWorkingHoursDataStore
{
    var presenter: TherapistWorkingHoursPresentationLogic?
    var worker: TherapistWorkingHoursWorker?
    var workingHourArray: [TherapistWorkingHours.ViewModel.tableCellData]?
    var businessWorkingResponse : NSArray?
    
    
    // MARK: Do something
    
    func hitListBusinessWorkingHoursApi()
    {
        worker = TherapistWorkingHoursWorker()
        
            worker?.getListBusinessWorkingHours(apiResponse: { (response) in
                if response.code == 404 {
                    CommonFunctions.sharedInstance.showSessionExpireAlert()
                }
                else {
                    self.businessWorkingResponse = response.result as! NSArray
                    if self.workingHourArray?.count == 0 {
                    self.presenter?.presentResponse(response: response)
                    }else{
                        self.presenter?.presentHoursResponse(response: self.workingHourArray!, workingResponse:self.businessWorkingResponse!)
                    }
                }
                
            })
    }
}
