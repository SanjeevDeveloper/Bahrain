
import UIKit

protocol FilterPresentationLogic
{
  func presentGetServiceResponse(response: ApiResponse, serviceName:String?)
  func presentSelectedArea(ResponseText:String?)
    func presentOldData(response:NSDictionary, categoryArr: [Filter.ViewModel.tableCellData]?, paymentArr: [Filter.PaymentViewModel.tableCellData]?, fromScreen: String?,minimumValue:NSNumber,MaximunValue:NSNumber)
}

class FilterPresenter: FilterPresentationLogic
{
    
    
  weak var viewController: FilterDisplayLogic?
  
  // MARK: Do something
  
  func presentGetServiceResponse(response: ApiResponse, serviceName:String?)
  {
    var responseArray = [Filter.ViewModel.tableCellData]()
    var ViewModelObj:Filter.ViewModel
    
     let data = response.result as! NSArray
    
    for arrData in data {
        let dataDict = arrData as! NSDictionary
        var isSelected = false
        if serviceName != nil {
            if serviceName == (dataDict["name"] as! String) {
                isSelected = true
            }
        }
        let obj = Filter.ViewModel.tableCellData(name: dataDict["name"] as! String, id: dataDict["_id"] as! String, isSelected: isSelected)
        responseArray.append(obj)
    }
    ViewModelObj = Filter.ViewModel(servicesArray: responseArray)
    viewController?.displayResponse(viewModel: ViewModelObj)

  }
    
  func presentSelectedArea(ResponseText: String?) {
        viewController?.displaySelectedAreaText(ResponseMsg: ResponseText)
    }
    
    func presentOldData(response: NSDictionary, categoryArr: [Filter.ViewModel.tableCellData]?, paymentArr: [Filter.PaymentViewModel.tableCellData]?, fromScreen: String?,minimumValue:NSNumber,MaximunValue:NSNumber) {
        
        viewController?.displayData(response: response, categoryArr: categoryArr, paymentArr: paymentArr, fromScreen: fromScreen,minimumValue:minimumValue,MaximunValue:MaximunValue)
        
    }
}
