
import UIKit

protocol SpecialSalonListBusinessLogic {
    func getSalonsWithSpecialOffers(offset: Int)
}

protocol SpecialSalonListDataStore {
}

class SpecialSalonListInteractor: SpecialSalonListBusinessLogic, SpecialSalonListDataStore
{
    var presenter: SpecialSalonListPresentationLogic?
    var worker: SpecialSalonListWorker?
    
    
    func getSalonsWithSpecialOffers(offset: Int) {
        worker = SpecialSalonListWorker()
        worker?.getSalonsWithSpecialOffers(offset: offset, apiResponse: { (response) in
            if response.code == 200{
                self.presenter?.presentResponse(response: response)
            } else if response.code == 404 {
                CommonFunctions.sharedInstance.showSessionExpireAlert()
            } else {
                CustomAlertController.sharedInstance.showErrorAlert(error: response.error!)
            }
        })
    }
}
