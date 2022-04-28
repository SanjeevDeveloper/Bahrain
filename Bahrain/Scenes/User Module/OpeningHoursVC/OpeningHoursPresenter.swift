
import UIKit

protocol OpeningHoursPresentationLogic
{
    func presentResponse(response: ApiResponse)
    func presentGetBusinessResponse(response: ApiResponse)
    
}

class OpeningHoursPresenter: OpeningHoursPresentationLogic
{
    
    
    weak var viewController: OpeningHoursDisplayLogic?
    
    // MARK: Do something
    
    
    func presentGetBusinessResponse(response: ApiResponse) {
        var viewModelArray = [OpeningHours.ViewModel.tableCellData]()
        var ViewModelObj:OpeningHours.ViewModel
        
        if response.error != nil {
            ViewModelObj = OpeningHours.ViewModel(tableArray: viewModelArray, errorString: response.error)
        }
        else {
            let resultDict = response.result as! NSDictionary
            let workingHourArray = resultDict["businessWorkingHours"] as! NSArray
            
            for obj in workingHourArray {
                let dataDict = obj as! NSDictionary
                let active = dataDict["active"] as! String
                
                if active == "true" {
                    if let fromTimestamp = dataDict["fromTimestamp"] as? NSNumber {
                        if let toTimestamp = dataDict["toTimestamp"] as? NSNumber {
                            
                            let fromDate = Date(largeMilliseconds: fromTimestamp.int64Value)
                            let toDate = Date(largeMilliseconds: toTimestamp.int64Value)
                            
                            let dateFormatter = DateFormatter()
                            dateFormatter.dateFormat = dateFormats.format2
                            dateFormatter.timeZone = UaeTimeZone
                            
                            let fromTime = dateFormatter.string(from: fromDate)
                            let toTime = dateFormatter.string(from: toDate)
                            
                            let tableObj = OpeningHours.ViewModel.tableCellData(
                                day: dataDict["day"] as! String,
                                timeFrom: fromTime,
                                timeTo: toTime,
                                active: dataDict["active"] as! String
                            )
                            
                            viewModelArray.append(tableObj)
                        }
                    }
                }
            }
            ViewModelObj = OpeningHours.ViewModel(tableArray: viewModelArray, errorString: nil)
        }
        viewController?.displayResponse(viewModel: ViewModelObj)
        
    }
    
    func presentResponse(response: ApiResponse)
    {
        var viewModelArray = [OpeningHours.ViewModel.tableCellData]()
        var ViewModelObj:OpeningHours.ViewModel
        
        if response.error != nil {
            ViewModelObj = OpeningHours.ViewModel(tableArray: viewModelArray, errorString: response.error)
        }
        else {
            let apiResponseArray = response.result as! NSArray
            let datadict = apiResponseArray[0] as! NSDictionary
            let workingHourArray = datadict["businessWorkingHours"] as! NSArray
            
            for obj in workingHourArray {
                let dataDict = obj as! NSDictionary
                
                let tableObj = OpeningHours.ViewModel.tableCellData(day: dataDict["day"] as! String, timeFrom: dataDict["from"] as! String, timeTo: dataDict["to"] as! String, active: dataDict["active"] as! String)
                
                viewModelArray.append(tableObj)
                
            }
            ViewModelObj = OpeningHours.ViewModel(tableArray: viewModelArray, errorString: nil)
        }
        viewController?.displayResponse(viewModel: ViewModelObj)
        
    }
}
