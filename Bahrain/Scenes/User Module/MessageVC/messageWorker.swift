

import UIKit

class messageWorker
{
  func doSomeWork()
  {
  }
    
    func getChatMessageResponse(apiResponse:@escaping(responseHandler)) {
       
        let endPointStr = ApiEndPoints.message.getAllChats + "/" + getUserData(._id) + "/" + getUserData(.businessId)
        NetworkingWrapper.sharedInstance.connect(urlEndPoint:endPointStr, httpMethod: .get, headers:ApiHeaders.sharedInstance.headerWithAuth()) { (response) in
            apiResponse(response)
            printToConsole(item: response)
        }
    }
}
