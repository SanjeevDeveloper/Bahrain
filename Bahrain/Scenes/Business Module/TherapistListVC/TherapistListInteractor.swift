
import UIKit

protocol TherapistListBusinessLogic
{
    func HitListTherapistByBusinessId(offset:Int)
    func hitApiAgain()
    func HitcheckTherapistAssigned()
}

protocol TherapistListDataStore
{
    var screenName: String? { get set }
    var therapistsArray: [Therapist] { get set }
}

class TherapistListInteractor: TherapistListBusinessLogic, TherapistListDataStore
{
    var presenter: TherapistListPresentationLogic?
    var worker: TherapistListWorker?
    var therapistsArray = [Therapist]()
    var screenName: String?
    
    // MARK: Do something
    
    //    func fetchUpdatedTherapist() {
    //        presenter?.presentUpdatedTherapists(therapistsArray: self.therapistsArray)
    //    }
    
    
    func hitApiAgain() {
        if appDelegateObj.isPageControlActive {
            self.presenter?.presentApiHitResponse()
        }
        else {
            if screenName == "addTherapistScreen"{
                self.presenter?.presentApiHitResponse()
            }
        }
    }
    
    func HitListTherapistByBusinessId(offset:Int)
    {
        worker = TherapistListWorker()
        
        worker?.getListTherapistByBusinessId(offset: offset, apiResponse: { (response) in
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
    
    func HitcheckTherapistAssigned() {
        worker = TherapistListWorker()
        
        worker?.getcheckTherapistAssigned(apiResponse: { (response) in
            if response.code == 200 {
                self.presenter?.presentApiHitcheckTherapistAssignedResponse()
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
