
import UIKit

protocol CardDetailBusinessLogic
{
    func hitVerifyCardApi(request: CardDetail.Request)
    func getData()
}

protocol CardDetailDataStore
{
    var businessId: String! { get set }
    var bookingData: [Booking.selectedTherapistModel]! { get set }
    var specialInstructions: String? { get set }
    var isHome: Bool? { get set }
    var offerId: String? { get set }
    var totalAmount:NSNumber? { get set }
    var advanceAmount:Double? { get set }
    var remainingAmount:Double? { get set }
    var isTypeMpgs:Bool? { get set }
    var bookingId: String! { get set }
    var isPaymentPartial:Bool? { get set }
    var isWalletUsed:Bool? { get set }
    var walletPaidAmount:Double? { get set }
    var cardPaidAmount:Double? { get set }
    var paymentMethodName:String? { get set }
}

class CardDetailInteractor: CardDetailBusinessLogic, CardDetailDataStore
{

    var presenter: CardDetailPresentationLogic?
    var worker: CardDetailWorker?
    var businessId: String!
    var bookingData: [Booking.selectedTherapistModel]!
    var specialInstructions: String?
    var isHome: Bool?
    var offerId: String?
    var totalAmount: NSNumber?
    var advanceAmount: Double?
    var remainingAmount: Double?
    var isTypeMpgs:Bool?
    var bookingId: String!
    var isPaymentPartial:Bool?
    var isWalletUsed:Bool?
    var walletPaidAmount: Double?
    var cardPaidAmount: Double?
    var paymentMethodName: String?
    
    
    // MARK: Do something
    
    func getData() {
        presenter?.presentData(paymentMethodName: paymentMethodName!, amount: cardPaidAmount!)
    }
    
    func hitVerifyCardApi(request: CardDetail.Request)
    {
        
        if isRequestValid(request: request) {
            
            worker = CardDetailWorker()
            
            var paymentMethod = [String]()
            if isTypeMpgs!{
                paymentMethod.append("credit card")
            }
            else {
                paymentMethod.append("debit card")
            }
            
            var paymentType = ""
            if isPaymentPartial!{
                paymentType = "partial"
            }
            else {
                paymentType = "full"
            }
            
//            if isWalletUsed != nil{
//                if isWalletUsed!{
////                    paymentMethod.append("")
//                }
//            }
          
          let parameters = [
            "paymentMethod":paymentMethod,
            "paymentType":paymentType,
            "isWalletUsed":isWalletUsed,
            "walletPaidAmount":walletPaidAmount,
            "cardPaidAmount":cardPaidAmount,
            "cardNumber":request.cardNumber.intValue(),
            "expiryMonth":request.expiryMonth.intValue(),
            "expiryYear":request.expiryYear.intValue(),
            "cvv":request.cvv.intValue(),
            "totalAmount":totalAmount,
            "paidAmount":advanceAmount,
            "remainingAmount":remainingAmount,
            "bookingId": bookingId
            ] as [String : Any]
          
//            let parameters = [
//                "paymentMethod":paymentMethod,
//                "paymentType":paymentType,
//                "isWalletUsed":isWalletUsed,
//                "walletPaidAmount":walletPaidAmount,
//                "cardPaidAmount":cardPaidAmount,
//                "totalAmount":totalAmount,
//                "paidAmount":advanceAmount,
//                "remainingAmount":remainingAmount,
//                "bookingId": bookingId
//                ] as [String : Any]
          
            printToConsole(item: parameters)
            
            worker?.hitVerifyCardApi(parameters: parameters, apiResponse: { (response) in
                if response.code == 200{
                    printToConsole(item: response)
                    self.presenter?.presentVerifyCardResponse(response: response)
                }
                else if response.code == 404 {
                    CommonFunctions.sharedInstance.showSessionExpireAlert()
                }
                else {
                    CustomAlertController.sharedInstance.showErrorAlert(error: response.error!)
                }
            })
            
        }
    }
    
    func isRequestValid(request: CardDetail.Request) -> Bool {
        var isValid = true
        let validator = Validator()
        if !validator.validateRequired(request.cardNumber, errorKey: CardDetailSceneText.CardDetailNumberValidationText.rawValue)  {
            isValid = false
        }
        else if !validator.validateRequired(request.expiryMonth, errorKey: CardDetailSceneText.CardDetailMonthValidationText.rawValue)  {
            isValid = false
        }
        else if !validator.validateRequired(request.expiryYear, errorKey: CardDetailSceneText.CardDetailYearValidationText.rawValue)  {
            isValid = false
        }
        else if !validator.validateRequired(request.cvv, errorKey: CardDetailSceneText.CardDetailCvvValidationText.rawValue)  {
            isValid = false
        }
        
        return isValid
    }
}

