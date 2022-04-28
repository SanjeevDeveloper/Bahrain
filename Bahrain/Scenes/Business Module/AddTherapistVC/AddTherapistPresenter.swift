
import UIKit

protocol AddTherapistPresentationLogic
{
    func presentServiceResponse(response: ApiResponse, screenName:String?, servicesNameArray:TherapistList.ViewModel.tableCellData?)
    func presentHoursArray(response: [TherapistWorkingHours.ViewModel.tableCellData]?)
    func presentAddTherapistResponse(response: ApiResponse, isAdd: Bool)
    func presentThearpistDetail(response: TherapistList.ViewModel.tableCellData?)
    func presentDisableApiResponse(response: ApiResponse)
    func presentScheduledArray(response: [AddScheduledBreak.ViewModel.tableCellData]?)
    func presentListApiResponse(response: ApiResponse)
}

class AddTherapistPresenter: AddTherapistPresentationLogic
{
    
    
    weak var viewController: AddTherapistDisplayLogic?
    
    // MARK: Do something
    
    
    func presentListApiResponse(response: ApiResponse) {
        
        
        var viewModelArray = [AddScheduledBreak.ViewModel.tableCellData]()
        var ViewModelObj:AddScheduledBreak.ViewModel
        
        let apiResponseArray = response.result as! NSArray
        printToConsole(item: apiResponseArray)
        
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
                dateFormatter.dateFormat = dateFormats.format2
            }
            let time = dateFormatter.string(from: date)
            
            
            let endTimeData = dataDict["end"] as! Int
            let ed = endTimeData
            let Enddate = Date(milliseconds: ed)
            let endTime = dateFormatter.string(from: Enddate)
            
            
            let rowObj = AddScheduledBreak.ViewModel.tableCellData(title: dataDict["title"] as! String, start: time , end: endTime, fullday: dataDict["fullday"] as! Bool, repeatInfo: dataDict["repeat"] as? String ?? "")
            
            viewModelArray.append(rowObj)
            
        }
        ViewModelObj = AddScheduledBreak.ViewModel(scheduledBreakArray: viewModelArray)
        viewController?.displayApiResponse(viewModel: ViewModelObj)
    }
    
    
    
    
    func presentDisableApiResponse(response: ApiResponse) {
        
        let apiResponseDict = response.result as! NSDictionary
        let isActive = apiResponseDict["isActive"] as! Bool
        viewController?.displayDisableResponse(isActive: isActive)
    }
    
    
    func presentThearpistDetail(response: TherapistList.ViewModel.tableCellData?) {
        
        //    var listServiceArray = [AddTherapist.SelectService.EditViewModel.serviceRowData]()
        var workingHoursArray = [TherapistWorkingHours.ViewModel.tableCellData]()
        var ViewModelObj:TherapistWorkingHours.ViewModel
        for item in (response?.workingHourArr)! {
            
            let dict = item as! NSDictionary
            
            let obj = TherapistWorkingHours.ViewModel.tableCellData(from:  dict["from"] as! String, to: dict["to"] as! String, day: dict["day"] as! String, active: dict["active"] as! String, fromTimestamp: dict["fromTimestamp"] as! Int64, toTimestamp: dict["toTimestamp"] as! Int64)
            
            workingHoursArray.append(obj)
            
        }
        //    for data in (response?.serviceArray)! {
        //        let dict = data as! NSDictionary
        //        let rowArr = dict["businessServices"] as! NSArray
        //
        //        for item in rowArr {
        //            let dict = item as! NSDictionary
        //
        //            let obj = AddTherapist.SelectService.EditViewModel.serviceRowData(serviceName: dict["serviceName"] as! String)
        //
        //           listServiceArray.append(obj)
        //        }
        //
        ViewModelObj = TherapistWorkingHours.ViewModel(tableArray: workingHoursArray, errorString: nil)
        
        viewController?.displayTherapistDetailResponse(viewModel: ViewModelObj)
        //
        //    }
    }
    
    func presentAddTherapistResponse(response: ApiResponse, isAdd: Bool) {
        viewController?.displayAddTherapistResponse(isAdd: isAdd)
    }
    
    func presentHoursArray(response: [TherapistWorkingHours.ViewModel.tableCellData]?) {
        viewController?.displayHoursArray(response: response)
    }
    
    func presentScheduledArray(response: [AddScheduledBreak.ViewModel.tableCellData]?) {
        viewController?.displayScheduledArray(response: response)
    }
    
    
    
    func presentServiceResponse(response: ApiResponse, screenName:String?, servicesNameArray:TherapistList.ViewModel.tableCellData?)
    {
        
        var viewModelArray = [AddTherapist.SelectService.ViewModel.tableCellData]()
        var ViewModelObj:AddTherapist.SelectService.ViewModel
        var therapistImage = ""
        var therapistName = ""
        var therapistArabicName = ""
        var jobTitle = ""
        var jobTitleArabic = ""
        var comingFrom = false
        var therapistId = ""
        var isActive = Bool()
        
        let apiResponseArray = response.result as! NSArray
        var cellDataObj:AddTherapist.SelectService.ViewModel.tableCellData
        
        for (index, obj) in apiResponseArray.enumerated() {
            let dataDict = obj as! NSDictionary
            
            let headerDataDict = dataDict["serviceCategoryId"] as! NSDictionary
            let categoryName = headerDataDict["categoryName"] as! String
            let categoryId = headerDataDict["_id"] as! String
            
            let sectionObj = AddTherapist.SelectService.ViewModel.tableSectionData(areaHeaderTitle: categoryName, businessCategoryId: categoryId)
            
            
            
            let name = dataDict["serviceName"] as! String
            let serviceId = dataDict["_id"] as! String
            var isSelected = false
            
            
            if screenName == "editTherapist" {
                comingFrom = true
                
                if servicesNameArray?.therapistProfileImage != "" {
                    therapistImage = Configurator().imageBaseUrl +  (servicesNameArray?.therapistProfileImage)!
                }
                else {
                    therapistImage = ""
                }
                
                therapistName = (servicesNameArray?.therapistName)!
                therapistArabicName = servicesNameArray?.therapistArabicName ?? ""
                jobTitle = servicesNameArray?.jobTitle ?? ""
                jobTitleArabic = servicesNameArray?.jobTitleArabic ?? ""
                therapistId = (servicesNameArray?.therapistId)!
                isActive = (servicesNameArray?.isActive)!
                
                
                for sname in (servicesNameArray?.serviceArray)!{
                    
                    let dict = sname as! NSDictionary
                    let rowArr = dict["businessServices"] as! NSArray
                    
                    for item in rowArr {
                        let dict = item as! NSDictionary
                        let businessServiceId = dict["businessServiceId"] as! String
                        if businessServiceId == serviceId {
                            isSelected = true
                        }
                    }
                }
            }
            else {
                isSelected = false
            }
            
            let rowObject = AddTherapist.SelectService.ViewModel.tableRowData(serviceName: name, businessServiceId: dataDict["_id"] as! String, serviceDuration: dataDict["serviceDuration"] as! String, isSelected: isSelected)
            var rowObjectArray = [AddTherapist.SelectService.ViewModel.tableRowData]()
            rowObjectArray.append(rowObject)
            
            if index == 0 {
                cellDataObj = AddTherapist.SelectService.ViewModel.tableCellData(header: sectionObj, businessServices: rowObjectArray)
                viewModelArray.append(cellDataObj)
            }
            else {
                var isObjFound = false
                for (index, dataObj) in viewModelArray.enumerated() {
                    if dataObj.header.areaHeaderTitle == categoryName{
                        viewModelArray[index].businessServices.append(rowObject)
                        isObjFound = true
                    }
                }
                if !isObjFound {
                    cellDataObj = AddTherapist.SelectService.ViewModel.tableCellData(header: sectionObj, businessServices: rowObjectArray)
                    viewModelArray.append(cellDataObj)
                }
            }
        }
        
        
        ViewModelObj = AddTherapist.SelectService.ViewModel(tableArray: viewModelArray, therapistProfileImage: therapistImage, therapistName: therapistName, arabicTherapistName: therapistArabicName, jobTilte: jobTitle, jobTilteArabic: jobTitleArabic, therapistId: therapistId, isActive: isActive)
        viewController?.displayServiceResponse(comingFromEdit: comingFrom, viewModel: ViewModelObj)
    }
    
}
