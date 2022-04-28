

import UIKit

protocol BookingSettingPresentationLogic
{
  func presentResponse(response: ApiResponse)
  func presentUpdateResponse(response: ApiResponse)
}

class BookingSettingPresenter: BookingSettingPresentationLogic
{
  weak var viewController: BookingSettingDisplayLogic?
  
  // MARK: Do something
    
  func presentUpdateResponse(response: ApiResponse) {
    viewController?.displayUpdatedResponse()
        
    }
  
  func presentResponse(response: ApiResponse)
  {
    let resultDict = response.result as! NSDictionary
    
    let time = resultDict["timeStamp"] as! Int
    let note = resultDict["note"] as! String
    
    viewController?.displayResponse(Time: time, Note: note)
    
  }
}
