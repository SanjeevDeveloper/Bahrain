
import UIKit

protocol ListServicePresentationLogic
{
    func presentResponse(response: ApiResponse)
    func presentDeleteResponse(message:String, index:Int)
    func presentApiHitResponse()
    
}

class ListServicePresenter: ListServicePresentationLogic
{
    
    weak var viewController: ListServiceDisplayLogic?
    
    // MARK: Do something
    
    func presentApiHitResponse() {
        viewController?.displayHitApiResponse()
    }
    
    func presentResponse(response: ApiResponse)
    {
        var viewModelArray = [ListService.ViewModel.tableRowData]()
       
        var ViewModelObj:ListService.ViewModel
        
        let apiResponseArray = response.result as! NSArray
        // let datadict = apiResponseArray[0] as! NSDictionary
        
        for obj in apiResponseArray {
             var addOnModelArray = [addOn]()
            
            let datadict = obj as! NSDictionary
            //        let secObj = ListService.ViewModel.tableSectionData(serviceHeaderTitle: datadict["serviceName"] as! String)
            
            
            let addOnResponseArray = datadict["addOn"] as! NSArray
            for addOnObj in addOnResponseArray{
                
                let addOnDict = addOnObj as! NSDictionary
                printToConsole(item: addOnDict)
                
                var serviceType =  String()

                
                if addOnDict["serviceType"] as? String == "home" {
                    serviceType = addOnDict["addOnSaloonPrice"] as! String
                }else{
                    serviceType = addOnDict["addOnHomePrice"] as! String
                }
                    let addObj = addOn(
                        addonServiceType: addOnDict["addonServiceType"] as? String ?? "",
                        addOnName: addOnDict["addOnName"] as! String,
                        addOnSaloonPrice: serviceType,
                        addOnhomePrice: addOnDict["addOnHomePrice"] as? String ?? "",
                        addOnDuration: addOnDict["addOnDuration"] as! String
                    )
                    
                    addOnModelArray.append(addObj)
             //   }
            }
            
            let categoryDict = datadict["serviceCategoryId"] as! NSDictionary
            
            let rowObj = ListService.ViewModel.tableRowData(
                serviceMainName: datadict["serviceMainName"] as! String, serviceMainId: datadict["serviceMainId"] as! String, serviceName: datadict["serviceName"] as! String, arabicServiceName: datadict["serviceNameArabic"] as! String,
                salonPrice: datadict["salonPrice"] as? NSNumber ?? 0,
                homePrice: datadict["homePrice"] as? NSNumber ?? 0,
                serviceType: datadict["serviceType"] as! String,
                serviceDuration: datadict["serviceDuration"] as! String, serviceDurationNumber: datadict["serviceDurationNumber"] as! NSNumber,
                serviceId: datadict["_id"] as! String,
                categoryName: categoryDict["categoryName"] as! String,
                categoryId: categoryDict["_id"] as! String,
                serviceDescription: datadict["serviceDescription"] as? String, arabicServiceDescription: datadict["serviceDescriptionArabic"] as? String,
                addOnData: addOnModelArray
            )
            
            viewModelArray.append(rowObj)
            
        }
        ViewModelObj = ListService.ViewModel(serviceListArray: viewModelArray)
        
        viewController?.displayResponse(viewModel: ViewModelObj)
        
    }
    
    func presentDeleteResponse(message: String, index: Int) {
        
        viewController?.displayDeleteResponse(message: message, index: index)
    }
}
