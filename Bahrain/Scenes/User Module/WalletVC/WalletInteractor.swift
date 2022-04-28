
import UIKit

protocol WalletBusinessLogic
{
  func getUserWalletApi()
}

protocol WalletDataStore
{
  //var name: String { get set }
}

class WalletInteractor: WalletBusinessLogic, WalletDataStore
{
  var presenter: WalletPresentationLogic?
  var worker: WalletWorker?
  //var name: String = ""
  
  // MARK: Do something
  
  func getUserWalletApi()
  {
    worker = WalletWorker()
    worker?.getUserWalletApi(apiResponse: { (response) in
        if response.code == 200{
            self.presenter?.presentUserWalletResponse(response: response)
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
