
import UIKit

class OrderDetailWorker
{
    func cancelAppoinmentApi(id:String, apiResponse:@escaping(responseHandler)) {
        let url = ApiEndPoints.userModule.cancelAppoinment + "/" + id + "/user"
        
        NetworkingWrapper.sharedInstance.connect(urlEndPoint: url, httpMethod: .put, headers: ApiHeaders.sharedInstance.headerWithAuth()) { (response) in
            apiResponse(response)
        }
    }
  
  func orderDetailApi(bookingId: String, apiResponse:@escaping(responseHandler)) {
    let url = ApiEndPoints.userModule.orderDetail + "/" + bookingId + "/user"
    NetworkingWrapper.sharedInstance.connect(urlEndPoint: url, httpMethod: .get, headers: ApiHeaders.sharedInstance.headerWithAuth()) { (response) in
      apiResponse(response)
    }
  }
}
