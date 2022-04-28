

import UIKit

class BusinessMessageWorker
{
  func doSomeWork()
  {
  }
    
    func getBusinessChatMessageResponse(apiResponse:@escaping(responseHandler)) {
        
        let endPointStr = ApiEndPoints.message.getAllChats + "/" + getUserData(._id) + "/" + getUserData(.businessId)
        
        NetworkingWrapper.sharedInstance.connect(urlEndPoint:endPointStr, httpMethod: .get, headers:ApiHeaders.sharedInstance.headerWithAuth()) { (response) in
            apiResponse(response)
        }
    }
}
