
import UIKit

protocol AddSalonServicePresentationLogic
{
    func presentResponse(response: ApiResponse)
    func presentAddOnValidResponse(response: addOn)
    func presentOldData(response: ListService.ViewModel.tableRowData?, editService: String?)
    func presentServiceResponse(response: ApiResponse)
    func presentMainServiceResponse(response: ApiResponse)
}

class AddSalonServicePresenter: AddSalonServicePresentationLogic
{
    func presentServiceResponse(response: ApiResponse) {
         viewController?.displayServiceResponse()
    }
    
    weak var viewController: AddSalonServiceDisplayLogic?
    
    // MARK: Do something
    
    func presentOldData(response: ListService.ViewModel.tableRowData?, editService: String?) {
        viewController?.displayOldData(response: response, editService: editService)
    }
    
    func presentMainServiceResponse(response: ApiResponse) {
        var viewModelArray = [AddSalonService.MainCategoryViewModel.mainCategoryData]()
        var ViewModelObj:AddSalonService.MainCategoryViewModel
        let responseArray = response.result as! NSArray
        
        for arrElement in responseArray {
            let arrDict = arrElement as! NSDictionary
            
            let obj = AddSalonService.MainCategoryViewModel.mainCategoryData(categoryName: arrDict["name"] as! String, categoryId: arrDict["_id"] as! String)
            
            viewModelArray.append(obj)
        }
        
        ViewModelObj = AddSalonService.MainCategoryViewModel(mainCategoryArray: viewModelArray)
        viewController?.displayMainCategoryResponse(viewModel: ViewModelObj)
    }
    
    func presentResponse(response: ApiResponse)
    {
        
        var viewModelArray = [AddSalonService.ViewModel.pickerData]()
        var ViewModelObj:AddSalonService.ViewModel
        
        if response.error != nil {
            ViewModelObj = AddSalonService.ViewModel(pickerArray: viewModelArray, errorString: response.error)
        }
        else {
            
            let responseArray = response.result as! NSArray
            
            for arrElement in responseArray {
                let arrDict = arrElement as! NSDictionary
                
                let obj = AddSalonService.ViewModel.pickerData(serviceName: arrDict["categoryName"] as! String, categoryId: arrDict["_id"] as! String)
                
                viewModelArray.append(obj)
            }
            ViewModelObj = AddSalonService.ViewModel(pickerArray: viewModelArray, errorString: nil)
            
        }
        viewController?.displayResponse(viewModel: ViewModelObj)
    }
    
    func presentAddOnValidResponse(response: addOn) {
        
        viewController?.displayAddOnValidResponse(response: response)
        
    }
}
