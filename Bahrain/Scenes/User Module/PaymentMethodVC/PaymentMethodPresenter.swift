

import UIKit

protocol PaymentMethodPresentationLogic
{
    func presentBookingDate(bookingDate: String)
    func presentResponse(response: ApiResponse, totalAmount: NSNumber)
    func presentGatewayResponse(response: ApiResponse)
    func presentUserBookingResponse()
    func presentVerifyCardResponse(response: ApiResponse)
    func timeoutSeconds(seconds: TimeInterval)
}

class PaymentMethodPresenter: PaymentMethodPresentationLogic
{
    
    
    weak var viewController: PaymentMethodDisplayLogic?
    
    // MARK: Do something
    
    func presentGatewayResponse(response: ApiResponse) {
        if let resultDict = response.result as? [String: Any] {
            if let redirectUrl = resultDict["redirectUrl"] as? String {
                viewController?.redirectUrl(redirectUrl)
            }
        }
    }
    
    func presentBookingDate(bookingDate: String) {
        viewController?.displayBookingDate(bookingDate: bookingDate)
    }
    
    func presentResponse(response: ApiResponse, totalAmount: NSNumber)
    {
        
        var dataArray = [PaymentMethod.ViewModel.CardDetails]()
        
        let dataDict = response.result as! NSDictionary
        let responseArray = dataDict["paymentMethods"] as! [[String: String]]
        for item in responseArray {
            let cardDetailObj = PaymentMethod.ViewModel.CardDetails(cardName: item["name"] ?? "", cardType: item["type"] ?? "")
            dataArray.append(cardDetailObj)
        }
        
        
        let viewModelObj = PaymentMethod.ViewModel(totalAmount: totalAmount, fullAmountToBePaid: dataDict["fullAmountToBePaid"] as! NSNumber, partialAmountToBePaid: dataDict["partialAmountToBePaid"] as! NSNumber, paymenttype: dataDict["paymentType"] as! String, walletAmount: dataDict["userWalletAmount"] as! NSNumber, paymentMethods: dataArray)
        
        viewController?.displayResponse(viewModel: viewModelObj)
        
    }
    
    func presentUserBookingResponse() {
        viewController?.displayUserBookingResponse()
    }
    
    func presentVerifyCardResponse(response: ApiResponse)
    {
        if let result = response.result as? [String: Any] {
            viewController?.displayVerifyCardResponse(result)
        }
    }
    
    func timeoutSeconds(seconds: TimeInterval) {
        viewController?.timeoutSeconds(seconds: seconds)
    }
    
    
}
