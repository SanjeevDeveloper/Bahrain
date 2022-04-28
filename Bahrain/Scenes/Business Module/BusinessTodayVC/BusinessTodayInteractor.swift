
import UIKit

protocol BusinessTodayBusinessLogic
{
    func hitListBusinessAppointmentsApi(offset:Int, fromDate: String, toDate: String)
}

protocol BusinessTodayDataStore
{
  //var name: String { get set }
}

class BusinessTodayInteractor: BusinessTodayBusinessLogic, BusinessTodayDataStore
{
  var presenter: BusinessTodayPresentationLogic?
  var worker: BusinessTodayWorker?
  //var name: String = ""
  
  // MARK: Do something
  
  func hitListBusinessAppointmentsApi(offset:Int, fromDate: String, toDate: String)
  {
    worker = BusinessTodayWorker()
    
    worker?.getListBusinessAppointments(offset: offset, fromDate: fromDate, toDate: toDate, apiResponse: { (response) in
        if response.code == 404 {
            CommonFunctions.sharedInstance.showSessionExpireAlert()
        }
        else {
            self.presenter?.presentResponse(response: response)
            printToConsole(item: response)
        }
        
    })
    
  }
}
