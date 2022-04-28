
import UIKit

protocol StaffBusinessLogic
{
    func hitlistTherapistByBusinessIdApi(offset:Int)
}

protocol StaffDataStore
{
    var saloonId:String? { get set }
}

class StaffInteractor: StaffBusinessLogic, StaffDataStore
{
    
    var presenter: StaffPresentationLogic?
    var worker: StaffWorker?
    var saloonId:String?
    
    func hitlistTherapistByBusinessIdApi(offset:Int) {
        worker = StaffWorker()
        worker?.getListTherapistByBusinessId(offset:offset, saloonId:self.saloonId!, apiResponse: { (response) in
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
