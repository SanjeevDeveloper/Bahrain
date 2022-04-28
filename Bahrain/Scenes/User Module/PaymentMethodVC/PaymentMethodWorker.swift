

import UIKit

class PaymentMethodWorker
{
    func hitCheckBusinessPaymentTypeApi(parameters:[String:Any], apiResponse:@escaping(responseHandler)) {
        NetworkingWrapper.sharedInstance.connect(urlEndPoint: ApiEndPoints.userModule.checkBusinessPaymentType, httpMethod: .post, headers: ApiHeaders.sharedInstance.headerWithAuth(), parameters: parameters) { (response) in
            apiResponse(response)
        }
    }
    
    func hitVerifyCardApi(parameters:[String:Any], apiResponse:@escaping(responseHandler)) {
        NetworkingWrapper.sharedInstance.connect(urlEndPoint: ApiEndPoints.userModule.userBookingPayment, httpMethod: .post, headers: ApiHeaders.sharedInstance.headerWithAuth(), parameters: parameters) { (response) in
            apiResponse(response)
        }
    }
    
    func hitVerifyBenefitApi(parameters:[String:Any], apiResponse:@escaping(responseHandler)) {
        NetworkingWrapper.sharedInstance.connect(urlEndPoint: ApiEndPoints.userModule.gatewayCallbackBenefitPay, httpMethod: .post, headers: ApiHeaders.sharedInstance.headerWithAuth(), parameters: parameters) { (response) in
            apiResponse(response)
        }
    }
  
  func openGatewayUrl(parameters:[String:Any], apiResponse:@escaping(responseHandler)) {
    NetworkingWrapper.sharedInstance.connect(urlEndPoint: ApiEndPoints.userModule.openGatewayUrl, httpMethod: .post, headers: ApiHeaders.sharedInstance.headerWithAuth(), parameters: parameters) { (response) in
      apiResponse(response)
    }
  }
    
}
