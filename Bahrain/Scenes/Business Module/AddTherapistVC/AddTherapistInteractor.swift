
import UIKit

protocol AddTherapistBusinessLogic
{
    func hitGetListServicesByBusinessIdApi(offset:Int)
    func hitAddBusinessTherapistApi(request: AddTherapist.SelectService.Request)
    func getHoursArray()
    func getTherapistData()
    func hitDisableTherapistApi(therapistId: String, isActive:Bool)
    func hitSaveTherapistChangesApi(request: AddTherapist.SelectService.Request, therapistId: String)
    func getscheduledArray()
    func HitListScheduleBreaks(offset:Int, therapistId: String)
    
}

protocol AddTherapistDataStore
{
    var hoursArray: [TherapistWorkingHours.ViewModel.tableCellData]? { get set }
    var screenName: String? { get set }
    var therapistObj: Therapist? { get set }
    var therapistData: TherapistList.ViewModel.tableCellData? { get set }
    var scheduledArray: [AddScheduledBreak.ViewModel.tableCellData]? { get set }
}

class AddTherapistInteractor: AddTherapistBusinessLogic, AddTherapistDataStore
{
    
    var presenter: AddTherapistPresentationLogic?
    var worker: AddTherapistWorker?
    var therapistObj: Therapist?
    var hoursArray: [TherapistWorkingHours.ViewModel.tableCellData]?
    var screenName: String?
    var therapistData: TherapistList.ViewModel.tableCellData?
    var scheduledArray: [AddScheduledBreak.ViewModel.tableCellData]?
    
    
    // MARK: Do something
    
    //  disable Api
    
    func hitDisableTherapistApi(therapistId: String, isActive:Bool) {
        worker = AddTherapistWorker()
        
        let param = [
            "isActive":isActive
            ] as [String : Any]
        
        worker?.hitDisableTherapistApi(id: therapistId, parameters: param, apiResponse: { (response) in
            
            if response.code == 200{
                
                self.presenter?.presentDisableApiResponse(response: response)
            }
            else if response.code == 404 {
                CommonFunctions.sharedInstance.showSessionExpireAlert()
            }
            else {
                CustomAlertController.sharedInstance.showErrorAlert(error: response.error!)
            }
            
        })
    }
    
    ///scheduled
    
    func HitListScheduleBreaks(offset: Int, therapistId: String) {
        worker = AddTherapistWorker()
        
            worker?.getListScheduleBreaks(offset: offset, therapistID: therapistId, apiResponse: { (response) in
                if response.code == 200 {
                    self.presenter?.presentListApiResponse(response: response)
                }
                else {
                    CustomAlertController.sharedInstance.showErrorAlert(error: response.error!)
                }
            })
        
    }
    
    
    
    // data from listTherapist Scree
    func getTherapistData() {
        if screenName == "editTherapist"{
            self.presenter?.presentThearpistDetail(response: therapistData)
        }
        
    }
    
    // data from Therapist working hour screen
    func getHoursArray() {
        if screenName == "therapistWorkingHours"{
            self.presenter?.presentHoursArray(response: hoursArray)
        }
    }
    
     // data from scheduled List screen
    
    func getscheduledArray() {
        if screenName == "ListScheduledBreak"{
          self.presenter?.presentScheduledArray(response: scheduledArray)
        }
    }
    
    
    func hitSaveTherapistChangesApi(request: AddTherapist.SelectService.Request, therapistId: String) {
        worker = AddTherapistWorker()
        
        if isRequestValid(request: request) {
            let therapistHoursArray = NSMutableArray()
            let selectedServiceArray = NSMutableArray()
            let scheduledBreakArray = NSMutableArray()
            
            
            if request.scheduledArray.count != 0 {
                
                for item in request.scheduledArray {
                    
                    let startTime = item.start
                    let dateFormatter = DateFormatter()
                    dateFormatter.timeZone = UaeTimeZone
                    
                    if item.fullday {
                        dateFormatter.dateFormat = dateFormats.format9
                    }
                    else {
                        if item.repeatInfo == "Never"{
                            dateFormatter.dateFormat = dateFormats.format5
                        }
                        else {
                            dateFormatter.dateFormat = dateFormats.format2
                        }
                    }
                    
                    let selectedDate = dateFormatter.date(from: startTime)
                    let selectedDateMilliseconds = selectedDate?.millisecondsSince1970
                    
                    let endTime = item.end
                    
                    let selectedEndDate = dateFormatter.date(from: endTime)
                    var selectedEndDateMilliseconds : Int64?
                    selectedEndDateMilliseconds = selectedEndDate?.millisecondsSince1970
                    
                    if item.fullday{
                        selectedEndDateMilliseconds = ((selectedEndDate?.millisecondsSince1970)!) + 85840000
                    }
                    
                    
                    let dict = [
                        "end": selectedEndDateMilliseconds!,
                        "fullday": item.fullday,
                        "repeat": item.repeatInfo,
                        "start": selectedDateMilliseconds!,
                        "title": item.title,
                        ] as [String : Any]
                    
                    scheduledBreakArray.add(dict)
                    
                    printToConsole(item: scheduledBreakArray)
                }
                
            }
            
            
            // Making raw hours array
            for item in request.hoursArray {
                let dict = [
                    "from": item.from,
                    "to": item.to,
                    "day": item.day,
                    "active": item.active,
                    "fromTimestamp": item.fromTimestamp,
                    "toTimestamp": item.toTimestamp
                    ] as [String : Any]
                therapistHoursArray.add(dict)
            }
            
            // Making raw services array
            for data in request.serviceArray {
                let businessServiceArray = NSMutableArray()
                
                for row in data.businessServices{
                    let rowDict = [
                        "serviceName": row.serviceName,
                        "businessServiceId": row.businessServiceId,
                        "serviceDuration": row.serviceDuration,
                        
                        ] as [String : Any]
                    businessServiceArray.add(rowDict)
                }
                
                let serviceDict = [
                    "businessCategoryId": data.header.businessCategoryId,
                    "businessServices": businessServiceArray
                    ] as [String : Any]
                selectedServiceArray.add(serviceDict)
            }
            
            printToConsole(item: selectedServiceArray)
            
            let workingHourArrayString = CommonFunctions.sharedInstance.json(from: therapistHoursArray)
            let serviceArrayString = CommonFunctions.sharedInstance.json(from: selectedServiceArray)
            
            let scheduledArrayString = CommonFunctions.sharedInstance.json(from: scheduledBreakArray)
            
            
            let param = [
                "name":request.name,
                "nameArabic":request.arabicName,
                "jobTitle":request.jobTitle,
                "jobTitleArabic":request.jobTitleArabic,
                "businessCategoryServices":serviceArrayString,
                "workingHours":workingHourArrayString,
                "businessId":getUserData(.businessId),
                "scheduleBreaks":scheduledArrayString
                ] as [String : Any]
            
            printToConsole(item: param)
            
            worker?.hitSaveTherapistChangesApi(id: therapistId, image: request.imageView, imageName: request.imageTitle, parameters: param, apiResponse: { (response) in
                if response.code == 200{
                    self.presenter?.presentAddTherapistResponse(response: response, isAdd: false)
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
    
    
    // Add Therapist Api
    func hitAddBusinessTherapistApi(request: AddTherapist.SelectService.Request) {
        worker = AddTherapistWorker()
        
        if isRequestValid(request: request) {
            let therapistHoursArray = NSMutableArray()
            let selectedServiceArray = NSMutableArray()
             let scheduledBreakArray = NSMutableArray()
            
            
            if request.scheduledArray.count != 0 {
                
                for item in request.scheduledArray {
                    
                    let startTime = item.start
                    let dateFormatter = DateFormatter()
                    dateFormatter.timeZone = UaeTimeZone
                    
                    if item.fullday {
                        dateFormatter.dateFormat = dateFormats.format9
                    }
                    else {
                        if item.repeatInfo == "Never"{
                            dateFormatter.dateFormat = dateFormats.format5
                        }
                        else {
                            dateFormatter.dateFormat = dateFormats.format2
                        }
                    }
                    
                    let selectedDate = dateFormatter.date(from: startTime)
                    let selectedDateMilliseconds = selectedDate?.millisecondsSince1970
                    
                    let endTime = item.end
                    
                    let selectedEndDate = dateFormatter.date(from: endTime)
                    
                    var selectedEndDateMilliseconds : Int64?
                    selectedEndDateMilliseconds = selectedEndDate?.millisecondsSince1970
                    
                    if item.fullday{
                        selectedEndDateMilliseconds = ((selectedEndDate?.millisecondsSince1970)!) + 85840000
                    }
                    
                    let dict = [
                        "end": selectedEndDateMilliseconds!,
                        "fullday": item.fullday,
                        "repeat": item.repeatInfo,
                        "start": selectedDateMilliseconds!,
                        "title": item.title,
                        ] as [String : Any]
                    
                    scheduledBreakArray.add(dict)
                    
                    printToConsole(item: scheduledBreakArray)
                }
                
            }
            
            // Making raw hours array
            for item in request.hoursArray {
                let dict = [
                    "from": item.from,
                    "to": item.to,
                    "day": item.day,
                    "active": item.active,
                    "fromTimestamp": item.fromTimestamp,
                    "toTimestamp": item.toTimestamp
                    ] as [String : Any]
                therapistHoursArray.add(dict)
            }
            
            // Making raw services array
            for data in request.serviceArray {
                let businessServiceArray = NSMutableArray()
                
                for row in data.businessServices{
                    let rowDict = [
                        "serviceName": row.serviceName,
                        "businessServiceId": row.businessServiceId,
                        "serviceDuration": row.serviceDuration,
                        
                        ] as [String : Any]
                    businessServiceArray.add(rowDict)
                }
                
            
                let serviceDict = [
                    "businessCategoryId": data.header.businessCategoryId,
                    "businessServices": businessServiceArray
                    ] as [String : Any]
                selectedServiceArray.add(serviceDict)
            }
            
            let workingHourArrayString = CommonFunctions.sharedInstance.json(from: therapistHoursArray)
            let serviceArrayString = CommonFunctions.sharedInstance.json(from: selectedServiceArray)
            
            let scheduledArrayString = CommonFunctions.sharedInstance.json(from: scheduledBreakArray)
        
            
            let param = [
                "name":request.name,
                "nameArabic":request.arabicName,
                "jobTitle":request.jobTitle,
                "jobTitleArabic":request.jobTitleArabic,
                "businessCategoryServices":serviceArrayString,
                "workingHours":workingHourArrayString,
                "businessId":getUserData(.businessId),
                "scheduleBreaks":scheduledArrayString
                ] as [String : Any]
            
            worker?.hitAddBusinessTherapistApi(image: request.imageView, imageName: request.imageTitle, parameters: param, apiResponse: { (response) in
                if response.code == 200{
                    self.presenter?.presentAddTherapistResponse(response: response, isAdd: true)
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
    
    
    
    func hitGetListServicesByBusinessIdApi(offset:Int)
    {
        worker = AddTherapistWorker()
        worker?.getListServicesByBusinessId(offset: offset, apiResponse: { (response) in
            
            if response.code == 200 {
                
                self.presenter?.presentServiceResponse(response: response, screenName: self.screenName, servicesNameArray:self.therapistData)
            }
            else if response.code == 404 {
                CommonFunctions.sharedInstance.showSessionExpireAlert()
            }
            else {
                CustomAlertController.sharedInstance.showErrorAlert(error: response.error!)
            }
            
        })
        
    }
    
    func isRequestValid(request: AddTherapist.SelectService.Request) -> Bool {
        var isValid = true
        let validator = Validator()
        if !validator.validateRequired(request.name, errorKey: localizedTextFor(key: AddTherapistSceneText.addTherapistSceneSelectNameError.rawValue))  {
            isValid = false
        }
        else if !validator.validateRequired(request.jobTitle, errorKey: localizedTextFor(key: AddTherapistSceneText.addTherapistSceneSelectJobTitleError.rawValue))  {
            isValid = false
        }
        else if request.serviceArray.count == 0 {
            CustomAlertController.sharedInstance.showErrorAlert(error: localizedTextFor(key: AddTherapistSceneText.addTherapistSceneSelectServiceError.rawValue))
            isValid = false
        }
        else if request.hoursArray.count == 0 {
            CustomAlertController.sharedInstance.showErrorAlert(error: localizedTextFor(key: AddTherapistSceneText.addTherapistSceneSelectHoursError.rawValue))
            isValid = false
        }
        return isValid
    }
}
