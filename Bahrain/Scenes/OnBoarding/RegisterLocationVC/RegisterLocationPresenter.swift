
import UIKit

protocol RegisterLocationPresentationLogic
{
    func presentRegistrationResponse(response: ApiResponse)
    func presentUpdateImageResponse(response: ApiResponse)
}

class RegisterLocationPresenter: RegisterLocationPresentationLogic
{
  weak var viewController: RegisterLocationDisplayLogic?
    
    func presentUpdateImageResponse(response: ApiResponse)
    {
        var ViewModelObj:RegisterLocation.ViewModel.ResponseError
        
        if response.error != nil {
            ViewModelObj = RegisterLocation.ViewModel.ResponseError(dict: nil, errorString: response.error)
        }
        else {
            
            let dataDict = response.result as! NSDictionary
            ViewModelObj = RegisterLocation.ViewModel.ResponseError(dict: dataDict, errorString: nil)
        }
        viewController?.displayUpdateImageResponse(viewModel: ViewModelObj)
    }
  
    func presentRegistrationResponse(response: ApiResponse) {
        let viewModel = RegisterLocation.ViewModel(error: response.error)
        viewController?.displayRegistrationResponse(viewModel: viewModel)
    }
}
