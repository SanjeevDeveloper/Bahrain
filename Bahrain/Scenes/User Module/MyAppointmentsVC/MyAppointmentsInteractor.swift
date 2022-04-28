
import UIKit

protocol MyAppointmentsBusinessLogic
{
    func hitGetListUserUpcomingAppointmentsApi(offset:Int)
    func hitGetListUserPastAppointmentsApi(offset:Int)
    func hitCancelAppoinmentApi(request: MyAppointments.Request)
}

protocol MyAppointmentsDataStore
{
  //var name: String { get set }
}

class MyAppointmentsInteractor: MyAppointmentsBusinessLogic, MyAppointmentsDataStore
{
    
  var presenter: MyAppointmentsPresentationLogic?
  var worker: MyAppointmentsWorker?
  //var name: String = ""
  
  // MARK: Do something
  
  func hitGetListUserUpcomingAppointmentsApi(offset:Int)
  {
    worker = MyAppointmentsWorker()
    
    worker?.getListUserUpcomingAppointments(offset: offset, apiResponse: { (response) in
         if response.code == 200 {
            self.presenter?.presentPastResponse(response: response, isPast: false)
        }
         else if response.code == 404 {
            CommonFunctions.sharedInstance.showSessionExpireAlert()
        
        }
         else {
            CustomAlertController.sharedInstance.showErrorAlert(error: response.error!)
        }
        
    })
   
  }
    func hitGetListUserPastAppointmentsApi(offset:Int)
    {
        worker = MyAppointmentsWorker()
        
        worker?.getListUserPastAppointments(offset: offset, apiResponse: { (response) in
            if response.code == 200 {
                  self.presenter?.presentPastResponse(response: response, isPast: true)
            }
            else if response.code == 404 {
                CommonFunctions.sharedInstance.showSessionExpireAlert()
              
            }
            else {
                CustomAlertController.sharedInstance.showErrorAlert(error: response.error!)
            }
            
        })
    }
  
    func hitCancelAppoinmentApi(request: MyAppointments.Request) {
        worker = MyAppointmentsWorker()
        
        worker?.cancelAppoinmentApi(id: request.appointmentId, apiResponse: { (response) in
            
            if response.code == 200{
                self.presenter?.presentCancelResponse(response: response, index: request.indexPath)
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
