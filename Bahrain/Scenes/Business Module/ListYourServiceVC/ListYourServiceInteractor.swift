
import UIKit

protocol ListYourServiceBusinessLogic
{
    func getServicesList()
    func registerBusiness(selectedIndexPaths:[IndexPath])
    func getBusinessSelectedServices()
    func hitUpdateBusinessApi(selectedIndexPaths:[IndexPath])
}

protocol ListYourServiceDataStore
{
    var servicesArray: NSArray? { get set }
}

class ListYourServiceInteractor: ListYourServiceBusinessLogic, ListYourServiceDataStore
{
    
    var presenter: ListYourServicePresentationLogic?
    var worker: ListYourServiceWorker?
    
    var servicesArray: NSArray?
    
    // MARK: Do something
    
    func getServicesList() {
        worker = ListYourServiceWorker()
        worker?.getServicesList(apiResponse: { (response) in
            if response.code == 200 {
                self.servicesArray = response.result as? NSArray
                let presenterResponse = ListYourService.Response(servicesArray: self.servicesArray!)
                self.presenter?.presentListResponse(response: presenterResponse)
            }
            else if response.code == 404 {
                CommonFunctions.sharedInstance.showSessionExpireAlert()
            }
            else {
                CustomAlertController.sharedInstance.showErrorAlert(error: response.error!)
            }
            
        })
    }
    
    func registerBusiness(selectedIndexPaths:[IndexPath]) {
        
        if servicesArray != nil {
            let selectedServicesArray = NSMutableArray()
            for (index, element) in servicesArray!.enumerated() {
                let currentIndexPath = IndexPath(row: 0, section: index)
                if  selectedIndexPaths.contains(currentIndexPath) {
                    let dict = element as! NSDictionary
                    let newDict:NSDictionary = [
                        "keyName": dict["keyName"] as! String,
                        "serviceId": dict["_id"] as! String,
                        "serviceName": dict["name"] as! String
                    ]
                    
                    selectedServicesArray.add(newDict)
                }
            }
            
            let param = [
                "services": selectedServicesArray,
                "step": "1",
                "userId": getUserData(._id)
                ] as [String : Any] 
            
            worker?.registerBusiness(parameters: param, apiResponse: { (response) in
                if response.code == 200 {
                    let resultDict = response.result as! NSDictionary
                    let businessId = resultDict["_id"] as! String
                    CommonFunctions.sharedInstance.updateUserData(.businessId, value: businessId)
                    self.presenter?.businessCreated()
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
    
    
    func hitUpdateBusinessApi(selectedIndexPaths: [IndexPath]) {
        worker = ListYourServiceWorker()
        if servicesArray != nil {
            let selectedServicesArray = NSMutableArray()
            for (index, element) in servicesArray!.enumerated() {
                let currentIndexPath = IndexPath(row: 0, section: index)
                if  selectedIndexPaths.contains(currentIndexPath) {
                    let dict = element as! NSDictionary
                    let newDict:NSDictionary = [
                        "keyName": dict["keyName"] as! String,
                        "serviceId": dict["_id"] as! String,
                        "serviceName": dict["name"] as! String
                    ]
                    
                    selectedServicesArray.add(newDict)
                }
            }
            
            let param = [
                "services": selectedServicesArray
                ] as [String : Any]
            
            worker?.hitUpdateBusinessApi(parameters: param, apiResponse: { (response) in
                if response.code == 200 {
                    
                    self.presenter?.presentServiceUpdatedResponse()
                    
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
    
    func getBusinessSelectedServices() {
        worker = ListYourServiceWorker()
        worker?.getBusinessSelectedServices(apiResponse: { (response) in
            if response.code == 200 {
                self.presenter?.presentSelectedListResponse(response: response)
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
