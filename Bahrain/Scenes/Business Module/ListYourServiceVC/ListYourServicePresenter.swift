
import UIKit

protocol ListYourServicePresentationLogic
{
  func presentListResponse(response: ListYourService.Response)
  func businessCreated()
  func presentSelectedListResponse(response: ApiResponse)
  func presentServiceUpdatedResponse()
}

class ListYourServicePresenter: ListYourServicePresentationLogic
{
    
  weak var viewController: ListYourServiceDisplayLogic?
  
    func presentListResponse(response: ListYourService.Response) {
        
        var viewModelArray = [ListYourService.ViewModel.service]()
        
        for obj in response.servicesArray {
            let dict = obj as! NSDictionary
            let name = dict["name"] as! String
            let keyName = dict["keyName"] as! String
            let imageName = dict["serviceIcon"] as! String
            let id = dict["_id"] as! String
            let bgImageName = dict["serviceBgImage"] as? String ?? ""
            let serviceModelObj = ListYourService.ViewModel.service(keyName: keyName, name: name, imageName: imageName, id: id, bgImageName: bgImageName, isSelected: false)
            viewModelArray.append(serviceModelObj)
        }
        viewController?.presentServicesResponse(viewModelArray: viewModelArray)
    }
    
    func presentSelectedListResponse(response: ApiResponse) {
        var viewModelArray = [ListYourService.selectedService.service]()
        
        let selectedArray = response.result as! NSArray
        
        for obj in selectedArray {
            let dict = obj as! NSDictionary
            let name = dict["serviceName"] as! String
            let keyName = dict["keyName"] as! String
            let id = dict["serviceId"] as! String
            
             let serviceModelObj = ListYourService.selectedService.service(keyName: keyName, name: name, id: id)
             viewModelArray.append(serviceModelObj)
        }
        
         viewController?.presentSelectedResponse(viewModelArray: viewModelArray)
        
    }
    
    func businessCreated() {
        viewController?.businessCreated()
    }
    
    func presentServiceUpdatedResponse() {
        viewController?.displayServiceUpdatedResponse()
    }
  
}
