
import UIKit

class FavoriteListWorker
{
    func getListBusinessByCategoryId(parameters:[String:Any], categoryId : String, apiResponse:@escaping(responseHandler)) {
        
        let url = ApiEndPoints.userModule.listBusinessByCategoryId + "/" + categoryId + "/\(CommonFunctions.sharedInstance.genderValue())"
        NetworkingWrapper.sharedInstance.connect(urlEndPoint: url, httpMethod: .put, headers: ApiHeaders.sharedInstance.headerWithLang(), parameters: parameters) { (response) in
            apiResponse(response)
        }
    }
    
    func getListBusinessByServiceName(parameters:[String:Any], serviceName : String, apiResponse:@escaping(responseHandler)) {
        
        let url = ApiEndPoints.userModule.ListBusinessByServiceName + "/" + serviceName
        NetworkingWrapper.sharedInstance.connect(urlEndPoint: url, httpMethod: .put, headers: ApiHeaders.sharedInstance.headerWithLang(), parameters: parameters) { (response) in
            apiResponse(response)
        }
    }
    
    func getListFavorite(parameters:[String:Any], apiResponse:@escaping(responseHandler)) {
        
        let url = ApiEndPoints.userModule.listFavorite + "/" + getUserData(._id)
        NetworkingWrapper.sharedInstance.connect(urlEndPoint: url, httpMethod: .put, headers: ApiHeaders.sharedInstance.headerWithAuth(), parameters: parameters) { (response) in
            apiResponse(response)
        }
    }
    
    func hitAdvanceFilterBusinessApi(offset:Int, filterText:String, parameters:[String:Any], apiResponse:@escaping(responseHandler)) {
        
//        var url = ApiEndPoints.userModule.advanceFilterBusiness + "/10" + "/\(offset)"
        var url = ApiEndPoints.userModule.advanceFilterBusiness + "/600" + "/\(0)/\(CommonFunctions.sharedInstance.genderValue())"

        if !(filterText.isEmptyString()) {
            url.append("/\(filterText)")
        }
        NetworkingWrapper.sharedInstance.connect(urlEndPoint: url, httpMethod: .post, headers: ApiHeaders.sharedInstance.headerWithAuth(), parameters:  parameters) { (response) in
            apiResponse(response)
        }
    }
    
    func hitFilterFavoriteBusinessApi(offset:Int, parameters:[String:Any], apiResponse:@escaping(responseHandler)) {
        
//        let url = ApiEndPoints.userModule.filterFavoriteBusiness + "/" + getUserData(._id) + "/10" + "/\(offset)"
        
        let url = ApiEndPoints.userModule.filterFavoriteBusiness + "/" + getUserData(._id) + "/600" + "/\(0)"
        
        NetworkingWrapper.sharedInstance.connect(urlEndPoint: url, httpMethod: .post, headers: ApiHeaders.sharedInstance.headerWithAuth(), parameters:  parameters) { (response) in
            apiResponse(response)
        }
    }
    
    func hitBusinessByCategoryIdFilterApi(offset:Int, categoryId : String, parameters:[String:Any], apiResponse:@escaping(responseHandler)) {
        
        let url = ApiEndPoints.userModule.businessByCategoryIdFilter + "/600" + "/\(0))"
        
        NetworkingWrapper.sharedInstance.connect(urlEndPoint: url, httpMethod: .post, headers: ApiHeaders.sharedInstance.headerWithAuth(), parameters:  parameters) { (response) in
            apiResponse(response)
        }
    }
    
}


