
import UIKit

class AddAddressWorker {
  func addAddressApi(parameters: [String: Any], apiResponse:@escaping(responseHandler)) {
    let url = ApiEndPoints.userModule.address
    NetworkingWrapper.sharedInstance.connect(urlEndPoint: url, httpMethod: .post, headers: ApiHeaders.sharedInstance.headerWithAuth(), parameters: parameters) { (response) in
      apiResponse(response)
    }
  }
  
  func updateAddressApi(id:String, parameters: [String: Any], apiResponse: @escaping(responseHandler)) {
    let url = ApiEndPoints.userModule.address + "/" + id
    NetworkingWrapper.sharedInstance.connect(urlEndPoint: url, httpMethod: .put, headers: ApiHeaders.sharedInstance.headerWithAuth(), parameters: parameters) { (response) in
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
