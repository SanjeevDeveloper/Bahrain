
import UIKit

class BookingSummaryWorker
{
    func confirmBooking(parameters:[String:Any],  apiResponse:@escaping(responseHandler)) {
        
        let urlEndpoint = ApiEndPoints.userModule.bookingService
        NetworkingWrapper.sharedInstance.connect(urlEndPoint: urlEndpoint, httpMethod: .post, headers: ApiHeaders.sharedInstance.headerWithAuth(), parameters: parameters) { (response) in
            apiResponse(response)
        }
    }
    
    func deleteBooking(bookingId:String,apiResponse:@escaping(responseHandler)) {
        let url = ApiEndPoints.userModule.deleteBooking + "/" + bookingId
        
        NetworkingWrapper.sharedInstance.connect(urlEndPoint: url, httpMethod: .delete, headers: ApiHeaders.sharedInstance.headerWithAuth()) { (response) in
            apiResponse(response)
        }
    }
    
    func getPromoCodeInfo(parameters:[String:Any], apiResponse:@escaping(responseHandler)) {
        let url = ApiEndPoints.userModule.getPromoCodeInfo
        NetworkingWrapper.sharedInstance.connect(urlEndPoint: url, httpMethod: .post, headers: ApiHeaders.sharedInstance.headerWithAuth(), parameters: parameters) { (response) in
            apiResponse(response)
        }
    }
    
    func getAddressListApi(apiResponse:@escaping(responseHandler)) {
        let url = ApiEndPoints.userModule.addressList + "/" + getUserData(._id)
        NetworkingWrapper.sharedInstance.connect(urlEndPoint: url, httpMethod: .get, headers: ApiHeaders.sharedInstance.headerWithAuth()) { (response) in
            apiResponse(response)
        }
    }
    
}
