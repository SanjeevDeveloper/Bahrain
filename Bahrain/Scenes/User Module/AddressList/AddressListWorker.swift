
import UIKit

class AddressListWorker {
    
    func getAddressListApi(apiResponse:@escaping(responseHandler)) {
        let url = ApiEndPoints.userModule.addressList + "/" + getUserData(._id)
        NetworkingWrapper.sharedInstance.connect(urlEndPoint: url, httpMethod: .get, headers: ApiHeaders.sharedInstance.headerWithAuth()) { (response) in
            apiResponse(response)
        }
    }
    
    func deleteAddressApi(id:String, apiResponse:@escaping(responseHandler)) {
        let url = ApiEndPoints.userModule.address + "/" + id
        NetworkingWrapper.sharedInstance.connect(urlEndPoint: url, httpMethod: .delete, headers: ApiHeaders.sharedInstance.headerWithAuth()) { (response) in
            apiResponse(response)
        }
    }
    
    func setDefaultAddressApi(id:String, apiResponse:@escaping(responseHandler)) {
        let url = ApiEndPoints.userModule.defaultAddress + "/" + id
        NetworkingWrapper.sharedInstance.connect(urlEndPoint: url, httpMethod: .put, headers: ApiHeaders.sharedInstance.headerWithAuth(), parameters: ["userId": getUserData(._id)]) { (response) in
            apiResponse(response)
        }
    }
    
    func confirmBooking(parameters:[String:Any],  apiResponse:@escaping(responseHandler)) {
        
        let urlEndpoint = ApiEndPoints.userModule.bookingService
        NetworkingWrapper.sharedInstance.connect(urlEndPoint: urlEndpoint, httpMethod: .post, headers: ApiHeaders.sharedInstance.headerWithAuth(), parameters: parameters) { (response) in
            apiResponse(response)
        }
    }
}
