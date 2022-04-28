
import UIKit

class StaffWorker
{
    func getListTherapistByBusinessId(offset:Int, saloonId:String, apiResponse:@escaping(responseHandler)) {

        let url = ApiEndPoints.userModule.listTherapistByBusinessId + "/" + saloonId + "/business/300" + "/\(0)"
        
        NetworkingWrapper.sharedInstance.connect(urlEndPoint: url, httpMethod: .get, headers: ApiHeaders.sharedInstance.headerWithAuth()) { (response) in
            apiResponse(response)
            
        }
    }
}
