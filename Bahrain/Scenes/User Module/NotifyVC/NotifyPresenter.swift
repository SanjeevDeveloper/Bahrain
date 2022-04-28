
import UIKit

protocol NotifyPresentationLogic
{
    func presentResponse(response: ApiResponse)
    func presentClearResponse()
    func presentReadResponse()
}

class NotifyPresenter: NotifyPresentationLogic
{
    
    weak var viewController: NotifyDisplayLogic?
    
    // MARK: Do something
    
    func presentResponse(response: ApiResponse)
    {
        var viewModelArray = [Notify.ViewModel.tableCellData]()
        var ViewModelObj:Notify.ViewModel
        
        let apiResponseArray = response.result as! NSArray
        for item in apiResponseArray {
            let dataDict = item as! NSDictionary
            
            let createdDate = dataDict["notificationTime"] as! Int64
            let date = Date(milliseconds: Int(createdDate))
            let dateFormatter = DateFormatter()
            dateFormatter.timeZone = UaeTimeZone
            dateFormatter.dateFormat = dateFormats.format6
            let day = dateFormatter.string(from: date)
            
            let timeAgo:String = timeStamp.sharedInstance.timeAgoSinceDate(date, currentDate: Date(), numericDates: true)
            
            let obj = Notify.ViewModel.tableCellData(isRead: dataDict["isRead"] as! Bool, message: dataDict["message"] as! String, name: dataDict["userName"] as! String, notificationId: dataDict["notificationId"] as! String, notificationTime: timeAgo, type: dataDict["type"] as! String, body: dataDict["body"] as! String, isRated: dataDict["isRated"] as? Bool ?? false)
            
            viewModelArray.append(obj)
        }
        ViewModelObj = Notify.ViewModel(tableArray: viewModelArray)
        viewController?.displayResponse(viewModel: ViewModelObj)
    }
    
    func presentClearResponse() {
        viewController?.displayClearAllResponse()
    }
    func presentReadResponse() {
        viewController?.displayReadResponse()
    }
}
