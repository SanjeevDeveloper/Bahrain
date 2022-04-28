
import UIKit

protocol CancelAppointmentBusinessLogic
{
    func hitGetBookingCancelReasonsApi()
    func hitCancelAppoinmentApi(reason:String)
    
}

protocol CancelAppointmentDataStore
{
  var appoinmentId: String! { get set }
}

class CancelAppointmentInteractor: CancelAppointmentBusinessLogic, CancelAppointmentDataStore
{
   
    
  var presenter: CancelAppointmentPresentationLogic?
  var worker: CancelAppointmentWorker?
  var appoinmentId: String!
  
  // MARK: Do something
  
  func hitGetBookingCancelReasonsApi()
  {
    worker = CancelAppointmentWorker()
    worker?.getBookingCancelReasonsApi(apiResponse: { (response) in
        if response.code == 200{
            self.presenter?.presentCancelReasonsResponse(response: response)
        }
        else if response.code == 404 {
            CommonFunctions.sharedInstance.showSessionExpireAlert()
        }
        else {
            CustomAlertController.sharedInstance.showErrorAlert(error: response.error!)
        }
    })

  }
    
    func hitCancelAppoinmentApi(reason:String) {
        worker = CancelAppointmentWorker()
        
        let param = [
            "cancelReason":reason
            ]
        
        worker?.cancelAppoinmentApi(id: appoinmentId, parameters: param, apiResponse: { (response) in
            if response.code == 200{
            self.presenter?.presentCancelResponse(response: response)
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
