
import UIKit

class SalonDetailWorker
{
    
    func hitAddRemoveFavoriteApi(parameters:[String:String], apiResponse:@escaping(responseHandler)) {
        NetworkingWrapper.sharedInstance.connect(urlEndPoint: ApiEndPoints.userModule.addRemoveFavorite, httpMethod: .post, headers: ApiHeaders.sharedInstance.headerWithAuth(), parameters: parameters) { (response) in
            apiResponse(response)
        }
    }
    
    func getBusinessById(saloonId:String, apiResponse:@escaping(responseHandler)) {
        let url = ApiEndPoints.userModule.getBusinessById + "/" + saloonId + "/" + getUserData(._id)
        NetworkingWrapper.sharedInstance.connect(urlEndPoint: url, httpMethod: .get, headers: ApiHeaders.sharedInstance.headerWithLang()) { (response) in
            apiResponse(response)
            
        }
    }
    
    func hitAddReviewApi(parameters:[String:String], apiResponse:@escaping(responseHandler)) {
        NetworkingWrapper.sharedInstance.connect(urlEndPoint: ApiEndPoints.userModule.addReview, httpMethod: .post, headers: ApiHeaders.sharedInstance.headerWithAuth(), parameters: parameters) { (response) in
            apiResponse(response)
        }
    }
    
    func getSpecialOffer(businessID: String, apiResponse:@escaping(responseHandler)) {
        let url = ApiEndPoints.userModule.getSpecialOfferOfBusiness + "/" + businessID
        NetworkingWrapper.sharedInstance.connect(urlEndPoint: url, httpMethod: .get, headers: ApiHeaders.sharedInstance.headerWithLang()) { (response) in
            apiResponse(response)
        }
    }
}
