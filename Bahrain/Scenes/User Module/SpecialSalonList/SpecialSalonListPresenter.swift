
import UIKit

protocol SpecialSalonListPresentationLogic {
    func presentResponse(response: ApiResponse)
}

class SpecialSalonListPresenter: SpecialSalonListPresentationLogic
{
    weak var viewController: SpecialSalonListDisplayLogic?
    
    func presentResponse(response: ApiResponse) {
        if let response = response.result as? [String: Any] {
            if let salonListObj = CommonFunctions.convertJsonObjectToModel(response, modelType: SpecialSalonList.ViewModel.self) {
                viewController?.displayResponse(viewModel: salonListObj)
            }
        }
    }
}
