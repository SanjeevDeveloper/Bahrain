
import UIKit

class SpecialSalonListWorker {
    
    func getSalonsWithSpecialOffers(offset: Int, apiResponse: @escaping(responseHandler)) {
        let url = ApiEndPoints.userModule.getSalonsWithSpecialOffers + "/100" + "/\(offset) /\(CommonFunctions.sharedInstance.genderValue())"
        NetworkingWrapper.sharedInstance.connect(urlEndPoint: url, httpMethod: .get, headers: ApiHeaders.sharedInstance.headerWithAuth()) { (response) in
            apiResponse(response)
        }
    }
}
