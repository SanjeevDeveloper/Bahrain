

import UIKit

class AddSalonServiceWorker
{
    
   let currentLanguageIdentifier = "/" + (userDefault.value(forKey: userDefualtKeys.currentLanguage.rawValue) as! String) + "/"
    
    func getCategoriesList(categoryId:String, apiResponse:@escaping(responseHandler)) {
        
        let url = ApiEndPoints.userModule.categories + currentLanguageIdentifier + categoryId
        
        NetworkingWrapper.sharedInstance.connect(urlEndPoint: url, httpMethod: .get) { (response) in
            apiResponse(response)
        }
    }
    
    
    func getServicesList(apiResponse:@escaping(responseHandler)) {
        
        let url = ApiEndPoints.Business.getServicesList + currentLanguageIdentifier
        
        NetworkingWrapper.sharedInstance.connect(urlEndPoint: url, httpMethod: .get, headers:ApiHeaders.sharedInstance.headerWithAuth()) { (response) in
            apiResponse(response)
        }
    }
    
    func hitAddBusinessServiceApi(parameters:[String:Any], apiResponse:@escaping(responseHandler)) {
        NetworkingWrapper.sharedInstance.connect(urlEndPoint: ApiEndPoints.Business.addBusinessService, httpMethod: .post, headers: ApiHeaders.sharedInstance.headerWithAuth(), parameters: parameters) { (response) in
            apiResponse(response)
        }
    }
    
    
    
    func editBusinessServiceApi(id:String, parameters:[String:Any], apiResponse:@escaping(responseHandler)) {
      
        let url = ApiEndPoints.Business.editBusinessService + "/" + id
        
        NetworkingWrapper.sharedInstance.connect(urlEndPoint: url, httpMethod: .put, headers: ApiHeaders.sharedInstance.headerWithAuth(), parameters: parameters) { (response) in
            apiResponse(response)
        }
    }
    
    
}
