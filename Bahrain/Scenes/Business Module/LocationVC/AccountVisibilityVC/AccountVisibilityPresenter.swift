
import UIKit

protocol AccountVisibilityPresentationLogic
{
  func presentVisibilityResponse(response: ApiResponse)
}

class AccountVisibilityPresenter: AccountVisibilityPresentationLogic
{
  weak var viewController: AccountVisibilityDisplayLogic?
  
  // MARK: Do something
  
  func presentVisibilityResponse(response: ApiResponse)
  {
     let apiResponseDict = response.result as! NSDictionary
    
     let obj = AccountVisibility.ViewModel(visibility: apiResponseDict["visibility"] as! Bool)
    
    viewController?.displayVisibilityResponse(viewModel: obj)
    
  }
}
