
import UIKit

protocol SearchPresentationLogic
{
  func presentResponse(isFilter:Bool, response: ApiResponse)
  func presentSelectedArea(_ area: String)
}

class SearchPresenter: SearchPresentationLogic
{
   
    
  weak var viewController: SearchDisplayLogic?
  
  // MARK: Do something
  
  func presentResponse(isFilter:Bool, response: ApiResponse)
  {
    var DataArray = [Search.ViewModel.tableCellData]()
    var ViewModelObj:Search.ViewModel
    
    
    if response.error != nil {
        ViewModelObj = Search.ViewModel(tableArray: DataArray, maximumPrice: 0, minimumPrice: 0, errorString: response.error)
    }
    else {
        
        let responseDic = response.result as! NSDictionary
        let minPrice = responseDic["minPrice"] as? NSNumber
        let maxPrice = responseDic["maxPrice"] as? NSNumber
       
        let data = responseDic["businessData"] as! NSArray
        for arrData in data {
            
         let dataDict = arrData as! NSDictionary
            
            let obj = Search.ViewModel.tableCellData(image: dataDict["profileImage"] as! String, title: dataDict["saloonName"] as! String, subTitle: dataDict["area"] as! String, saloonId: dataDict["_id"] as! String)
            
           DataArray.append(obj)
        }
        ViewModelObj = Search.ViewModel(tableArray: DataArray, maximumPrice: maxPrice!, minimumPrice: minPrice!, errorString: response.error)
    }
    
    if isFilter {
        viewController?.displayFilterResponse(viewModel: ViewModelObj)
    }else {
        viewController?.displayResponse(viewModel: ViewModelObj)
    }
    
    }
  
  func presentSelectedArea(_ area: String) {
    viewController?.presentSelectedArea(area)
  }
  
}
