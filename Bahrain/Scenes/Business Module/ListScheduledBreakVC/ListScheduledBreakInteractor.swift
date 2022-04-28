

import UIKit

protocol ListScheduledBreakBusinessLogic
{
    func HitListScheduleBreaks(offset:Int)
    func getArrayData()
    func hitEditTherapistApi(request: [AddScheduledBreak.ViewModel.tableCellData])
    func getScheduledArray()
    func deleteScheduleObj()
}

protocol ListScheduledBreakDataStore
{
    var therapistID: String? { get set }
    var scheduledBreakArray: AddScheduledBreak.ViewModel.tableCellData?{ get set }
    var screenName: String? { get set }
    var scheduledArray: [AddScheduledBreak.ViewModel.tableCellData]? { get set }
}

class ListScheduledBreakInteractor: ListScheduledBreakBusinessLogic, ListScheduledBreakDataStore
{
    
    
    
    var presenter: ListScheduledBreakPresentationLogic?
    var worker: ListScheduledBreakWorker?
    var therapistID: String?
    var scheduledBreakArray: AddScheduledBreak.ViewModel.tableCellData?
    var screenName: String?
    var scheduledArray: [AddScheduledBreak.ViewModel.tableCellData]?
    
    // MARK: Do something
    
    func HitListScheduleBreaks(offset:Int)
    {
        
        if therapistID != "" {
            
            worker = ListScheduledBreakWorker()
            worker?.getListScheduleBreaks(offset: offset, therapistID: therapistID!, apiResponse: { (response) in
                printToConsole(item: response)
                
                if response.code == 200 {
                    self.presenter?.presentListApiResponse(response: response)
                }
                else if response.code == 404 {
                    CommonFunctions.sharedInstance.showSessionExpireAlert()
                }
                else {
                    CustomAlertController.sharedInstance.showErrorAlert(error: response.error!)
                }
                
            })
        }
    }
    
    
    func getScheduledArray()
    {
        presenter?.presentScheduleArray(scheduledArray: scheduledArray)
    }
    
    func getArrayData() {
        if screenName == "addBraek" {
            presenter?.presentArrayData(response: scheduledBreakArray!)
        }
    }
    
    func deleteScheduleObj() {
        screenName = ""
    }
    
    
    func hitEditTherapistApi(request: [AddScheduledBreak.ViewModel.tableCellData]) {
        worker = ListScheduledBreakWorker()
        
        let dataArray = NSMutableArray()
        
        
        
        for item in request {
            
            let startTime = item.start
            let dateFormatter = DateFormatter()
            dateFormatter.timeZone = UaeTimeZone
            dateFormatter.dateFormat = dateFormats.format8
            let selectedDate = dateFormatter.date(from: startTime)
            let selectedDateMilliseconds = selectedDate?.millisecondsSince1970
            
            let endTime = item.end
            
            var selectedEndDateMilliseconds: String
            
            if endTime != "Full Day" {
                let dateFormatter = DateFormatter()
                dateFormatter.timeZone = UaeTimeZone
                dateFormatter.dateFormat = dateFormats.format8
                let selectedDate = dateFormatter.date(from: endTime)
                selectedEndDateMilliseconds = ((selectedDate?.millisecondsSince1970)!.description)
            }
            else {
                selectedEndDateMilliseconds = "Full Day"
            }
            
            let dict = [
                "end": selectedEndDateMilliseconds,
                "fullday": item.fullday,
                "repeat": item.repeatInfo,
                "start": selectedDateMilliseconds?.description,
                "title": item.title,
                ] as [String : Any]
            
            dataArray.add(dict)
        }
        
        
        let param = [
            "scheduleBreakId": dataArray
            ] as [String : Any]
        
        worker?.hitEditTherapistApi(id: therapistID!, parameters: param, apiResponse: { (response) in
            printToConsole(item: response)
        })
    }
}
