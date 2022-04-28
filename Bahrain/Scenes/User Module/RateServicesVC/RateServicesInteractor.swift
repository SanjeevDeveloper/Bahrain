

import UIKit

protocol RateServicesBusinessLogic
{
  func hitAddReviewApi(request: RateServices.Request)
  func getArrayData()
}

protocol RateServicesDataStore
{
  var salonId:String? { get set }
  var dataArray :[RateServices.ViewModel.tableCellData]? { get set }
  var notificationId:String? { get set }
}

class RateServicesInteractor: RateServicesBusinessLogic, RateServicesDataStore
{
   
  var presenter: RateServicesPresentationLogic?
  var worker: RateServicesWorker?
  var salonId:String?
  var dataArray: [RateServices.ViewModel.tableCellData]?
var notificationId:String?
  
  // MARK: Do something
    
    
    func getArrayData() {
        self.presenter?.presentArrayData(dataArray: dataArray)
    }
    
  
    func hitAddReviewApi(request: RateServices.Request) {
        
        worker = RateServicesWorker()
        
        
        let ratingArr = NSMutableArray()
        
        for item in request.ratingArray {
            
            let dict = [
                "therapistId": item.id,
                "rating": item.rating,
                ] as [String : Any]
            
            ratingArr.add(dict)
            
        }
        
        
        
            let param = [
                "userId":getUserData(._id),
                "businessId":salonId,
                "quality":request.qualityRating,
                "valueOfMoney":request.moneyRating,
                "customerService":request.serviceRating,
                "timing":request.timingRating,
                "review":request.reviewText,
                "therapistRating":ratingArr,
                "notificationId": notificationId ?? ""
                ] as [String : Any]
        
            printToConsole(item: param)
            worker?.hitAddReviewApi(parameters: param, apiResponse: { (response) in
                
                if response.code == 200 {
                    let resultObj = response.result as! NSDictionary
                    let msg = resultObj["msg"] as! String
                    CustomAlertController.sharedInstance.showAlert(subTitle: msg, type: .success)
                    self.presenter?.presentAddReviewResponse()
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
//if request.rating.description == "0.0" {
//
//    CustomAlertController.sharedInstance.showErrorAlert(error: localizedTextFor(key: SalonDetailSceneText.SalonDetailSceneEmptyRatingText.rawValue))
//
//}

