
import UIKit

class AddTherapistWorker
{
    func getListServicesByBusinessId(offset:Int, apiResponse:@escaping(responseHandler)) {
        
        let url = ApiEndPoints.Business.listServicesByBusinessId + "/" + getUserData(.businessId) + "/business" + "/100" + "/\(offset)"
        NetworkingWrapper.sharedInstance.connect(urlEndPoint: url, httpMethod: .get, headers: ApiHeaders.sharedInstance.headerWithAuth()) { (response) in
            apiResponse(response)
            
        }
    }
    
    func getListScheduleBreaks(offset:Int, therapistID:String,  apiResponse:@escaping(responseHandler)) {
        
        let url = ApiEndPoints.Business.listScheduleBreaks + "/" + therapistID
        NetworkingWrapper.sharedInstance.connect(urlEndPoint: url, httpMethod: .get, headers: ApiHeaders.sharedInstance.headerWithAuth()) { (response) in
            apiResponse(response)
            
        }
    }
    
    func hitAddBusinessTherapistApi(image:UIImage?, imageName:String?, parameters:[String:Any], apiResponse:@escaping(responseHandler)) {
        
        let url = ApiEndPoints.Business.addBusinessTherapist
        
        if image == nil{
      NetworkingWrapper.sharedInstance.connectWithMultiPart(urlEndPoint:url, httpMethod: .post, headers:ApiHeaders.sharedInstance.headerWithAuth(), parameters:parameters) { (response) in
                apiResponse(response)
                
            }
        }
        else {
    NetworkingWrapper.sharedInstance.connectWithMultiPart(urlEndPoint:url, httpMethod: .post, parameters:parameters, headers:ApiHeaders.sharedInstance.headerWithAuth(), images:[image!], imageName:imageName) { (response) in
                apiResponse(response)
                
            }
        }
    }
    
    func hitDisableTherapistApi(id:String, parameters:[String:Any], apiResponse:@escaping(responseHandler)) {
        
        let url = ApiEndPoints.Business.editTherapistInfo + "/" + id
        
        NetworkingWrapper.sharedInstance.connect(urlEndPoint: url, httpMethod: .put, headers: ApiHeaders.sharedInstance.headerWithAuth(), parameters: parameters) { (response) in
            apiResponse(response)
        }
    }
    
    func hitSaveTherapistChangesApi(id:String, image:UIImage?, imageName:String?, parameters:[String:Any], apiResponse:@escaping(responseHandler)) {
        
        let url = ApiEndPoints.Business.editTherapistInfo + "/" + id
        
        if image == nil{
            NetworkingWrapper.sharedInstance.connectWithMultiPart(urlEndPoint:url, httpMethod: .put, headers:ApiHeaders.sharedInstance.headerWithAuth(), parameters:parameters) { (response) in
                apiResponse(response)
                
            }
        }
        else {
            NetworkingWrapper.sharedInstance.connectWithMultiPart(urlEndPoint:url, httpMethod: .put, parameters:parameters, headers:ApiHeaders.sharedInstance.headerWithAuth(), images:[image!], imageName:imageName) { (response) in
                apiResponse(response)
                
            }
        }
    }
    
    
}


