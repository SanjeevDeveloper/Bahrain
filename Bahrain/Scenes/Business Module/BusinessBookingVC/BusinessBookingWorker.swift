

import UIKit

class BusinessBookingWorker
{
    func getListServicesByBusinessId(apiResponse:@escaping(responseHandler)) {
        
        let url = ApiEndPoints.Business.listServicesByBusinessId + "/" + getUserData(.businessId) + "/business" + "/100" + "/0"
        NetworkingWrapper.sharedInstance.connect(urlEndPoint: url, httpMethod: .get, headers: ApiHeaders.sharedInstance.headerWithAuth()) { (response) in
            apiResponse(response)
            
        }
    }
    
    func hitTherapistTimeSlotApi(parameters:[String:Any], apiResponse:@escaping(responseHandler)) {
        NetworkingWrapper.sharedInstance.connect(urlEndPoint: ApiEndPoints.userModule.listTherapistTimeSlots, httpMethod: .post, headers: ApiHeaders.sharedInstance.headerWithAuth(), parameters: parameters) { (response) in
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
