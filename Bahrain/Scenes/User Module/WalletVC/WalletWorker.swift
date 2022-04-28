

import UIKit

class WalletWorker
{
    func getUserWalletApi(apiResponse:@escaping(responseHandler)) {
        let url = ApiEndPoints.userModule.getUserWallet + "/" + getUserData(._id)
        NetworkingWrapper.sharedInstance.connect(urlEndPoint: url, httpMethod: .get, headers: ApiHeaders.sharedInstance.headerWithAuth()) { (response) in
            apiResponse(response)
        }
    }
}
