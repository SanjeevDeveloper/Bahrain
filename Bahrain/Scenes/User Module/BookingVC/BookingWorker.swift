
import UIKit

class BookingWorker
{
    func hitTherapistTimeSlotApi(parameters:[String:Any], apiResponse:@escaping(responseHandler)) {
        NetworkingWrapper.sharedInstance.connect(urlEndPoint: ApiEndPoints.userModule.listTherapistTimeSlots, httpMethod: .post, headers: ApiHeaders.sharedInstance.headerWithAuth(), parameters: parameters) { (response) in
            apiResponse(response)
        }
    }
    
    func getAdvanceBookingDays(apiResponse:@escaping(responseHandler)) {
        let url = ApiEndPoints.userModule.getAdvanceBookingDays
        NetworkingWrapper.sharedInstance.connect(urlEndPoint: url, httpMethod: .get, headers: ApiHeaders.sharedInstance.headerWithAuth()) { (response) in
            apiResponse(response)
        }
    }
}
