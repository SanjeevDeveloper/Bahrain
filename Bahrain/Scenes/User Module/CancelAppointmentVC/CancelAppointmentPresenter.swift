
import UIKit

protocol CancelAppointmentPresentationLogic
{
  func presentCancelReasonsResponse(response: ApiResponse)
  func presentCancelResponse(response: ApiResponse)
}

class CancelAppointmentPresenter: CancelAppointmentPresentationLogic
{
   
  weak var viewController: CancelAppointmentDisplayLogic?
  
  // MARK: Do something
  
  func presentCancelReasonsResponse(response: ApiResponse)
  {
    var viewModelArray = [CancelAppointment.ViewModel.tableCellData]()
    var ViewModelObj:CancelAppointment.ViewModel
    
    let responseArray = response.result as! NSArray
    for item in responseArray {
        
      let obj = CancelAppointment.ViewModel.tableCellData(isSelected: false, reason: item as! String)
        viewModelArray.append(obj)
    }
    
     ViewModelObj = CancelAppointment.ViewModel(tableArray: viewModelArray)

    viewController?.displayCancelReasonsResponse(viewModel: ViewModelObj)
  }
    
    func presentCancelResponse(response: ApiResponse) {
        let apiResponseDict = response.result as! NSDictionary
        let msg = apiResponseDict["msg"] as? String ?? ""
        viewController?.displayCancelAppointmentResponse(msg: msg)
    }
    
}
