

import UIKit

protocol ListScheduledBreakPresentationLogic
{
    func presentArrayData(response: AddScheduledBreak.ViewModel.tableCellData)
    func presentListApiResponse(response: ApiResponse)
    func presentScheduleArray(scheduledArray: [AddScheduledBreak.ViewModel.tableCellData]?)
}

class ListScheduledBreakPresenter: ListScheduledBreakPresentationLogic
{
    
    weak var viewController: ListScheduledBreakDisplayLogic?
    
    // MARK: Do something
    
    func presentListApiResponse(response: ApiResponse) {
        
        var viewModelArray = [AddScheduledBreak.ViewModel.tableCellData]()
        var ViewModelObj:AddScheduledBreak.ViewModel
        
        let apiResponseArray = response.result as! NSArray
        
        for item in apiResponseArray {
            
            let dataDict = item as! NSDictionary
            
            let fullDay = dataDict["fullday"] as! Bool
            
            let startDate = dataDict["start"] as! Int
            let sd = startDate
            let date = Date(milliseconds: sd)
            let dateFormatter = DateFormatter()
            dateFormatter.timeZone = UaeTimeZone
            
            if fullDay {
                dateFormatter.dateFormat = dateFormats.format9
            }
            else {
                if dataDict["repeat"] as! String == "Never"{
                    dateFormatter.dateFormat = dateFormats.format5
                }
                else {
                    dateFormatter.dateFormat = dateFormats.format2
                }
            }
            let time = dateFormatter.string(from: date)
            
            
            let endTimeData = dataDict["end"] as! Int
            let ed = endTimeData
            let Enddate = Date(milliseconds: ed)
            let endTime = dateFormatter.string(from: Enddate)
            
            
            let rowObj = AddScheduledBreak.ViewModel.tableCellData(title: dataDict["title"] as! String, start: time , end: endTime, fullday: dataDict["fullday"] as! Bool, repeatInfo: dataDict["repeat"] as! String)
            
            viewModelArray.append(rowObj)
            
        }
        
        ViewModelObj = AddScheduledBreak.ViewModel(scheduledBreakArray: viewModelArray)
        viewController?.displayApiResponse(viewModel: ViewModelObj)
        
    }
    
    func presentScheduleArray(scheduledArray: [AddScheduledBreak.ViewModel.tableCellData]?) {
        viewController?.displayScheduleArray(scheduledArray: scheduledArray)
    }
    
    
    
    func presentArrayData(response: AddScheduledBreak.ViewModel.tableCellData)
    {
        var viewModelArray = [AddScheduledBreak.ViewModel.tableCellData]()
        
        let startDate = response.start.intValue()
        let date = Date(milliseconds: startDate)
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = UaeTimeZone
        
        if response.fullday{
            dateFormatter.dateFormat = dateFormats.format9
        }
        else {
            if response.repeatInfo == "Never"{
                dateFormatter.dateFormat = dateFormats.format5
            }
            else {
                dateFormatter.dateFormat = dateFormats.format2
            }
        }
        
        let time = dateFormatter.string(from: date)
        
        let eDate = response.end.intValue()
        let EndDate = Date(milliseconds: eDate)
        let endTime = dateFormatter.string(from: EndDate)
        
        let rowObj = AddScheduledBreak.ViewModel.tableCellData(title: response.title, start: time, end: endTime, fullday: response.fullday, repeatInfo: response.repeatInfo)
        
        viewModelArray.append(rowObj)
        
        //    ViewModelObj = AddScheduledBreak.ViewModel(scheduledBreakArray: viewModelArray)
        
        viewController?.displayArrayData(viewModelTable: viewModelArray)
    }
}






