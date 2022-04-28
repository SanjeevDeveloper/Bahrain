
import UIKit

protocol SendFeedBackPresentationLogic
{
    func presentResponse(response: ApiResponse)
}

class SendFeedBackPresenter: SendFeedBackPresentationLogic
{
  weak var viewController: SendFeedBackDisplayLogic?
  
  // MARK: Do something
  
  func presentResponse(response: ApiResponse)
  {
    var ViewModelObj:SendFeedBack.ViewModel
    
    if response.error != nil {
        ViewModelObj = SendFeedBack.ViewModel(message: nil, error: response.error)
    }
    else {
        let dataDict = response.result as! NSDictionary
        ViewModelObj = SendFeedBack.ViewModel(message: dataDict["msg"] as? String, error: nil)
    }
    
    viewController?.displaySendFeedBackResponse(viewModel: ViewModelObj)
  }
}
