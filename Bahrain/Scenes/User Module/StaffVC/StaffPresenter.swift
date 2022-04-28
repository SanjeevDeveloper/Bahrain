
import UIKit

protocol StaffPresentationLogic
{
  func presentResponse(response: ApiResponse)
}

class StaffPresenter: StaffPresentationLogic
{
  weak var viewController: StaffDisplayLogic?
  
  // MARK: Do something
  
  func presentResponse(response: ApiResponse)
  {
    
    var responseArray = [Staff.ViewModel.tableCellData]()
    
     var ViewModelObj:Staff.ViewModel
    
    
    if response.error != nil {
        ViewModelObj = Staff.ViewModel(tableArray: responseArray, errorString: response.error)
    }
    else {
    
        let data = response.result as! NSArray
        
        for arrData in data {
           
            let dataDict = arrData as! NSDictionary
            
            printToConsole(item: dataDict)
            
            let businessCategoriesArray = dataDict["businessCategoryServices"] as! NSArray
            
            var responseServiceArray = [Staff.ViewModel.tableServiceCellData]()
        
             for businessCategoriesArrData in businessCategoriesArray {
                
                var categoryName = String()
                var serviceName = String()
                
                printToConsole(item: categoryName)
                
                let businessCategoriesDict = businessCategoriesArrData as! NSDictionary
                
                categoryName = businessCategoriesDict["businessCategoryName"] as! String
                
                let businessServiceArray = businessCategoriesDict["businessServices"] as! NSArray
                
                for businessServiceArrData in businessServiceArray{
                    
                    let businessServiceDict = businessServiceArrData as! NSDictionary
                    
                    let obj = businessServiceDict["serviceName"] as! String
                    if serviceName.isEmptyString() {
                        serviceName.append(obj)
                    }                                              
                    else {
                    serviceName.append(", \(obj)")
                    }
                }
                
               let serviceObj = Staff.ViewModel.tableServiceCellData.init(category: categoryName, subCategory: serviceName)
                
               responseServiceArray.append(serviceObj)
            }
            printToConsole(item: responseServiceArray)
            
            let obj = Staff.ViewModel.tableCellData(image: dataDict["therapistProfileImage"] as! String, name: dataDict["name"] as! String, jobTitle: dataDict["jobTitle"] as? String ?? "", therapistRating: dataDict["therapistAverageRating"] as! Double, servicesArray: responseServiceArray)
            
            responseArray.append(obj)
            
        }
        ViewModelObj = Staff.ViewModel(tableArray: responseArray, errorString: nil)
      }
    
       viewController?.displayResponse(viewModel: ViewModelObj)
    }
  }

