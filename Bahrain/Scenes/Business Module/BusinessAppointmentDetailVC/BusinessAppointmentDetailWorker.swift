
import UIKit

class BusinessAppointmentDetailWorker
{
    func hitReportUserApi(parameters:[String:String], apiResponse:@escaping(responseHandler)) {
        NetworkingWrapper.sharedInstance.connect(urlEndPoint: ApiEndPoints.Business.addToSpam, httpMethod: .post, headers: ApiHeaders.sharedInstance.headerWithAuth(), parameters: parameters) { (response) in
            apiResponse(response)
        }
    }
}
