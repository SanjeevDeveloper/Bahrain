
import UIKit

protocol SelectBlockBusinessLogic {
    func getBlockList()
    func showScreenName()
}

protocol SelectBlockDataStore {
    var screenName: String? { get set }
}

class SelectBlockInteractor: SelectBlockBusinessLogic, SelectBlockDataStore {
    var presenter: SelectBlockPresentationLogic?
    var worker: SelectBlockWorker?
    var screenName: String?
    // MARK: Do something
    func getBlockList() {
        worker = SelectBlockWorker()
        
        worker?.getBlockList(apiResponse: { (response) in
            if response.code == 200 {
                self.presenter?.presentResponse(response: response)
                
            } else  if response.code == 404 {
                CommonFunctions.sharedInstance.showSessionExpireAlert()
            }
            else {
                CustomAlertController.sharedInstance.showErrorAlert(error: response.error!)
            }
        })
    }
    
    func showScreenName() {
        presenter?.presentScreenName(screenNameText: screenName)
    }
}
