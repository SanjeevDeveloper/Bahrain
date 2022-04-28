
import UIKit

protocol TherapistWorkingHoursPresentationLogic
{
    func presentResponse(response: ApiResponse)
    func presentHoursResponse(response: [TherapistWorkingHours.ViewModel.tableCellData], workingResponse: NSArray)
}

class TherapistWorkingHoursPresenter: TherapistWorkingHoursPresentationLogic
{
    
    
    
    weak var viewController: TherapistWorkingHoursDisplayLogic?
    
    // MARK: Do something
    
    func presentHoursResponse(response: [TherapistWorkingHours.ViewModel.tableCellData],workingResponse: NSArray) {
        printToConsole(item: response)
        printToConsole(item: workingResponse)
        
        var ViewModelObj:TherapistWorkingHours.ViewModel
        
        var newBusinessArr = [TherapistWorkingHours.ViewModel.tableCellData]()
        var businessworkingHourArray = [TherapistWorkingHours.ViewModel.tableCellData]()
        
        for obj in workingResponse{
            let dataDict = obj as! NSDictionary
            let active = dataDict["active"] as! String
//            let fromtTimestam = dataDict["fromTimestamp"] as! Int64
//            let totTimestam = dataDict["toTimestamp"] as! Int64
            if active != "false" {
                let tableObj = TherapistWorkingHours.ViewModel.tableCellData(from:dataDict["from"] as! String ,to:dataDict["to"] as! String, day: dataDict["day"] as! String, active: dataDict["active"] as! String, fromTimestamp: dataDict["fromTimestamp"] as! Int64, toTimestamp: dataDict["toTimestamp"] as! Int64)
                newBusinessArr.append(tableObj)
                businessworkingHourArray.append(tableObj)
            }
        }
        printToConsole(item: newBusinessArr.count)
        for (index, objNew) in newBusinessArr.enumerated() {
            var isContainTherapistDay = false
            let day = objNew.day
            for obj in response {
                let fromtTimestam = obj.fromTimestamp
                let totTimestam = obj.toTimestamp
                let resday = obj.day
                
                if day == resday {
                     isContainTherapistDay = true
                    let finalobj = TherapistWorkingHours.ViewModel.tableCellData(from:obj.from, to: obj.to, day: obj.day, active: obj.active, fromTimestamp: obj.fromTimestamp, toTimestamp: obj.toTimestamp)
                    newBusinessArr.remove(at: index)
                    newBusinessArr.insert(finalobj, at: index)
                    printToConsole(item: finalobj.day)
                }
            }
            
            if !isContainTherapistDay {
                newBusinessArr[index].active = "false"
            }
        }
        printToConsole(item: newBusinessArr)
        ViewModelObj = TherapistWorkingHours.ViewModel(tableArray: newBusinessArr, errorString: nil)
        viewController?.displayResponse(viewModel: ViewModelObj, businessworkingHourArray: businessworkingHourArray)
    }
    
    func presentResponse(response: ApiResponse)
    {
        var viewModelArray = [TherapistWorkingHours.ViewModel.tableCellData]()
        var ViewModelObj:TherapistWorkingHours.ViewModel
        
        if response.error != nil {
            ViewModelObj = TherapistWorkingHours.ViewModel(tableArray: viewModelArray, errorString: response.error)
        }
        else {
            let apiResponseArray = response.result as! NSArray
            for obj in apiResponseArray {
                let dataDict = obj as! NSDictionary
                
                let active = dataDict["active"] as! String
                
                let fromtTimestam = dataDict["fromTimestamp"] as! Int64
                let totTimestam = dataDict["toTimestamp"] as! Int64
                
                if active != "false" {
                    let tableObj = TherapistWorkingHours.ViewModel.tableCellData(from: dataDict["from"] as! String ,to:dataDict["to"] as! String, day: dataDict["day"] as! String, active: dataDict["active"] as! String, fromTimestamp: dataDict["fromTimestamp"] as! Int64, toTimestamp: dataDict["toTimestamp"] as! Int64)
                    
                    viewModelArray.append(tableObj)
                }
            }
            ViewModelObj = TherapistWorkingHours.ViewModel(tableArray: viewModelArray, errorString: nil)
        }
        viewController?.displayResponse(viewModel: ViewModelObj, businessworkingHourArray:viewModelArray)
    }
}
