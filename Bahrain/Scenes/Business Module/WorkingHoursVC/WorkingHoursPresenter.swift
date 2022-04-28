


import UIKit

protocol WorkingHoursPresentationLogic
{
    func presentResponse(response: ApiResponse)
    func workingHoursUpdated()
}

class WorkingHoursPresenter: WorkingHoursPresentationLogic
{
    weak var viewController: WorkingHoursDisplayLogic?
    
    // MARK: Do something
    
    func presentResponse(response: ApiResponse)
    {
        var viewModelArray = [WorkingHours.ViewModel.tableCellData]()
        var ViewModelObj:WorkingHours.ViewModel
        
        if response.error != nil {
            ViewModelObj = WorkingHours.ViewModel(tableArray: viewModelArray, errorString: response.error)
        }
        else {
            let apiResponseArray = response.result as! NSArray
            
            for obj in apiResponseArray {
                let dataDict = obj as! NSDictionary
                var fromTimestamp = dataDict["fromTimestamp"] as? Int64 ?? 0
                var toTimestamp = dataDict["toTimestamp"] as? Int64 ?? 0
                
                if fromTimestamp == 0 {
                    fromTimestamp = 12600000
                }
                
                if toTimestamp == 0 {
                    toTimestamp = 45000000
                }
                
                let date = Date(largeMilliseconds: fromTimestamp)
                let dateFormatter = DateFormatter()
                dateFormatter.timeZone = UaeTimeZone
                dateFormatter.dateFormat = dateFormats.format2
                let fromTime = dateFormatter.string(from: date)
                
                //
                let toDate = Date(largeMilliseconds: toTimestamp)
                let toTime = dateFormatter.string(from: toDate)
                
                let tableObj = WorkingHours.ViewModel.tableCellData(from: fromTime, to: toTime, day: dataDict["day"] as! String, active: dataDict["active"] as! String, fromTimestamp: fromTimestamp, toTimestamp: toTimestamp, oldStartTime: fromTimestamp, oldCloseTime: toTimestamp)
                
                viewModelArray.append(tableObj)
            }
            ViewModelObj = WorkingHours.ViewModel(tableArray: viewModelArray, errorString: nil)
        }
        viewController?.displayResponse(viewModel: ViewModelObj)
    }
    
    func workingHoursUpdated() {
        viewController?.workingHoursUpdated()
    }
}
