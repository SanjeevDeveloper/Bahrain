
import UIKit

protocol ListServiceBusinessLogic
{
    func hitGetListServicesByBusinessIdApi(offset:Int)
    func hitDeleteBusinessServiceApi(request:ListService.Request)
    func hitApiAgain()
}

protocol ListServiceDataStore
{
    var fromAddServiceScreen: String? { get set }
}

class ListServiceInteractor: ListServiceBusinessLogic, ListServiceDataStore
{
    
    var presenter: ListServicePresentationLogic?
    var worker: ListServiceWorker?
    var fromAddServiceScreen: String?
    
    // MARK: Do something
    
    func hitApiAgain() {
        if appDelegateObj.isPageControlActive {
            self.presenter?.presentApiHitResponse()
        }
        else {
            if fromAddServiceScreen == "fromAddServiceScreen"{
                self.presenter?.presentApiHitResponse()
            }
        }
    }
    
    
    func hitGetListServicesByBusinessIdApi(offset:Int)
    {
        worker = ListServiceWorker()
        worker?.getListServicesByBusinessId(offset: offset, apiResponse: { (response) in
            
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
    
    func hitDeleteBusinessServiceApi(request: ListService.Request) {
        worker = ListServiceWorker()
        
        worker?.deleteBusinessServiceApi(id: request.serviceId, apiResponse: { (response) in
            
            if response.code == 200 {
                let dataDict = response.result as! NSDictionary
                self.presenter?.presentDeleteResponse(message: dataDict["msg"] as! String, index: request.indexPath)
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
