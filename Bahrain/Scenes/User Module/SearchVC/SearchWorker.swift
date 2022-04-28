
import UIKit

class SearchWorker
{
    func getListBusiness(offset:Int, filterText:String, parameters:[String:Any], apiResponse:@escaping(responseHandler)) {
        
        let url = ApiEndPoints.userModule.listBusiness
        NetworkingWrapper.sharedInstance.connect(urlEndPoint: url, httpMethod: .post, headers: ApiHeaders.sharedInstance.headerWithLang(), parameters:  parameters) { (response) in
            apiResponse(response)
        }
    }
    
    
    func searchSalonFilterApi(offset:Int, filterText:String, parameters:[String:Any], apiResponse:@escaping(responseHandler)) {
        var url = ApiEndPoints.userModule.searchSalonFilter + "/500" + "/0/\(CommonFunctions.sharedInstance.genderValue())"
        
        if !(filterText.isEmptyString()) {
            url.append("/\(filterText)")
        }
        NetworkingWrapper.sharedInstance.connect(urlEndPoint: url, httpMethod: .post, headers: ApiHeaders.sharedInstance.headerWithAuth(), parameters:  parameters) { (response) in
            apiResponse(response)
        }
    }
  
}
