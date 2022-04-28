
import UIKit

protocol rateReviewBusinessLogic
{
 func hitGetUserListReviews(offset:Int)
 func getScreenName()
}

protocol rateReviewDataStore
{
 var salonId:String? { get set }
 var dataArray :[RateServices.ViewModel.tableCellData]? { get set }
    var notificationId:String? {get set}
    var isRated:Bool? {get set}
}

class rateReviewInteractor: rateReviewBusinessLogic, rateReviewDataStore
{
    
  var presenter: rateReviewPresentationLogic?  
  var worker: rateReviewWorker?
  var salonId:String?
  var screenName:String?
  var dataArray: [RateServices.ViewModel.tableCellData]?
    
    var notificationId:String?
    var isRated:Bool?

    
    func getScreenName() {
        self.presenter?.presentScreenName(isRated: isRated ?? false)
    }
    
    func hitGetUserListReviews(offset:Int){
        worker = rateReviewWorker()
        
        worker?.getUserListReviews(salonId: salonId, offset: offset, apiResponse: { (response) in
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
