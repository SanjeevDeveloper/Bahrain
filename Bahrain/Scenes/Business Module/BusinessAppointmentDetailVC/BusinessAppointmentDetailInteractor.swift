
import UIKit

protocol BusinessAppointmentDetailBusinessLogic
{
    func showData()
    func hitAddToSpamApi(ClientId: String)
    
}

protocol BusinessAppointmentDetailDataStore
{
    var orderDetailArray: BusinessToday.ViewModel.tableCellData? { get set }
    
}

class BusinessAppointmentDetailInteractor: BusinessAppointmentDetailBusinessLogic, BusinessAppointmentDetailDataStore
{
    
    var presenter: BusinessAppointmentDetailPresentationLogic?
    var worker: BusinessAppointmentDetailWorker?
    var orderDetailArray: BusinessToday.ViewModel.tableCellData?
    
    func showData() {
        self.presenter?.presentData(response: orderDetailArray!)
    }
    
    func hitAddToSpamApi(ClientId: String) {
        worker = BusinessAppointmentDetailWorker()
        
        let param = [
            "userId":ClientId,
            "businessId":getUserData(.businessId)
        ]
        
        worker?.hitReportUserApi(parameters: param, apiResponse: { (response) in
            printToConsole(item: response)
            if response.code == 200 {
                CustomAlertController.sharedInstance.showAlert(subTitle: localizedTextFor(key: BusinessAppointmentDetailSceneText.BusinessAppointmentDetailSceneReportApiSuccessText.rawValue), type: .success)
            }
            else {
                CustomAlertController.sharedInstance.showErrorAlert(error: response.error!)
            }
            
        })
    }
}


