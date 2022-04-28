
import UIKit

protocol ClientReviewsBusinessLogic
{
  func hitGetListReviewsByBusinessId(offset:Int)
}

protocol ClientReviewsDataStore
{
  //var name: String { get set }
}

class ClientReviewsInteractor: ClientReviewsBusinessLogic, ClientReviewsDataStore
{
  var presenter: ClientReviewsPresentationLogic?
  var worker: ClientReviewsWorker?
  //var name: String = ""
  
  // MARK: Do something
  
  func hitGetListReviewsByBusinessId(offset:Int)
  {
    worker = ClientReviewsWorker()
   
    worker?.getListReviewsByBusinessId(offset: offset, apiResponse: { (response) in
        
        if response.code == 200 {
            self.presenter?.presentResponse(response: response)
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
