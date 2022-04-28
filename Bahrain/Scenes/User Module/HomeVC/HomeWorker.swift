
import UIKit

class HomeWorker
{
     let currentLanguageIdentifier = "/" + (userDefault.value(forKey: userDefualtKeys.currentLanguage.rawValue) as! String)
    
    func getCategoriesList( apiResponse:@escaping(responseHandler)) {
        
        let url = ApiEndPoints.userModule.categories + currentLanguageIdentifier + "/\(CommonFunctions.sharedInstance.genderValue())"
        NetworkingWrapper.sharedInstance.connect(urlEndPoint: url, httpMethod: .get) { (response) in
            apiResponse(response)
        }
    }
    
    func getListFavorite(offset:Int, apiResponse:@escaping(responseHandler)) {
        
        let url = ApiEndPoints.userModule.listFavorite + "/" + getUserData(._id) + "/10" + "/\(offset)"
        NetworkingWrapper.sharedInstance.connect(urlEndPoint: url, httpMethod: .get, headers: ApiHeaders.sharedInstance.headerWithLang()) { (response) in
            apiResponse(response)
        }
    }
    
    func getServicesList(apiResponse:@escaping(responseHandler)) {
        
        let url = ApiEndPoints.Business.getServicesList + currentLanguageIdentifier
        
        NetworkingWrapper.sharedInstance.connect(urlEndPoint: url, httpMethod: .get, headers: nil) { (response) in
            apiResponse(response)
        }
    }
    
    func getChatMessageResponse(apiResponse:@escaping(responseHandler)) {
        
        let endPointStr = ApiEndPoints.message.getAllChats + "/" + getUserData(._id) + "/" + getUserData(.businessId)
        
        NetworkingWrapper.sharedInstance.connect(urlEndPoint:endPointStr, httpMethod: .get, headers:ApiHeaders.sharedInstance.headerWithAuth()) { (response) in
            apiResponse(response)
        }
    }
    
    func getBenefitPayResponse(apiResponse:@escaping(responseHandler)) {
        
        let endPointStr = ApiEndPoints.userModule.getBenefitPayDetail
        
        NetworkingWrapper.sharedInstance.connect(urlEndPoint:endPointStr, httpMethod: .get, headers:ApiHeaders.sharedInstance.headerWithAuth()) { (response) in
            apiResponse(response)
        }
    }
    
    func getCountUnreadNotification(apiResponse:@escaping(responseHandler)) {
        
        let endPointStr = ApiEndPoints.userModule.countUnreadNotification + "/" + getUserData(._id) +  "/user"
        
        NetworkingWrapper.sharedInstance.connect(urlEndPoint:endPointStr, httpMethod: .get, headers:ApiHeaders.sharedInstance.headerWithAuth()) { (response) in
            apiResponse(response)
        }
    }
    
    func cashoutConfirmationByUserApi(parameters:[String:Any],bookingId:String,notifyId:String, apiResponse:@escaping(responseHandler)) {
        let url = ApiEndPoints.userModule.cashoutConfirmationByUser + "/" + bookingId + "/" + notifyId
        NetworkingWrapper.sharedInstance.connect(urlEndPoint: url, httpMethod: .put, headers: ApiHeaders.sharedInstance.headerWithAuth(), parameters: parameters) { (response) in
            apiResponse(response)
        }
    }
    
    func arrivalConfirmationByUserApi(parameters:[String:Any],bookingId:String, apiResponse:@escaping(responseHandler)) {
        let url = ApiEndPoints.userModule.updateArrivalStatus + "/" + bookingId
        NetworkingWrapper.sharedInstance.connect(urlEndPoint: url, httpMethod: .put, headers: ApiHeaders.sharedInstance.headerWithAuth(), parameters: parameters) { (response) in
            apiResponse(response)
        }
    }
    
    
}
