
import UIKit

protocol SpecialOffersListBusinessLogic
{
    func hitGetListBusinessOffersAPI(offset:Int)
    func hitDeleteOfferApi(request: SpecialOffersList.Request)
}

protocol SpecialOffersListDataStore
{
    var offersArray: NSArray! { get set }
}

class SpecialOffersListInteractor: SpecialOffersListBusinessLogic, SpecialOffersListDataStore
{
    
    
    var presenter: SpecialOffersListPresentationLogic?
    var worker: SpecialOffersListWorker?
    var offersArray: NSArray! 
    
    // MARK: Do something
    
    func hitGetListBusinessOffersAPI(offset:Int)
    {
        worker = SpecialOffersListWorker()
        worker?.getListBusinessOffers(offset: offset, apiResponse: { (response) in
            if response.code == 200 {
                let resultArray = response.result as! NSArray
                self.offersArray = resultArray
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
    
    func hitDeleteOfferApi(request: SpecialOffersList.Request) {
        worker = SpecialOffersListWorker()
        worker?.deleteOfferApi(id: request.offerId, apiResponse: { (response) in
            if response.code == 200 {
                self.presenter?.presentDeleteOfferResponse(response: response, index: request.indexPath)
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
