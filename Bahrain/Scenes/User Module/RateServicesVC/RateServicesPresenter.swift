
import UIKit

protocol RateServicesPresentationLogic
{
  func presentAddReviewResponse()
  func presentArrayData(dataArray:[RateServices.ViewModel.tableCellData]?)
}

class RateServicesPresenter: RateServicesPresentationLogic
{
    
  weak var viewController: RateServicesDisplayLogic?
    
    func presentArrayData(dataArray: [RateServices.ViewModel.tableCellData]?) {
        viewController?.displayArrayData(dataArray: dataArray)
    }
  
    func presentAddReviewResponse() {
        viewController?.displayAddReviewResponse()
    }
  

}
