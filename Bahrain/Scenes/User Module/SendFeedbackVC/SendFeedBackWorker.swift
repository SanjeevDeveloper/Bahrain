
import UIKit

class SendFeedBackWorker
{
    
    func hitSendFeedBackApi(parameters:[String:String], apiResponse:@escaping(responseHandler)) {
        NetworkingWrapper.sharedInstance.connect(urlEndPoint: ApiEndPoints.userModule.sendFeedback, httpMethod: .post, headers: ApiHeaders.sharedInstance.headerWithAuth(), parameters: parameters) { (response) in
            apiResponse(response)
        }
    }
}
