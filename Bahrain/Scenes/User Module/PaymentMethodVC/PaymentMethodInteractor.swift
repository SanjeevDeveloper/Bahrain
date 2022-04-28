

import UIKit
import BenefitInAppSDK
protocol PaymentMethodBusinessLogic
{
    func hitCheckBusinessPaymentTypeApi()
    func hitVerifyCardApi(request: PaymentMethod.Request)
    func openGatewayUrl(result: String, isPaymentPartial: Bool, isMpgs: Bool, isWalletUsed: Bool, walletPaidAmount: Double, cardPaidAmount: Double, advanceAmount: Double, remainingAmount: Double, transactionId: String)
    func getTimeoutSeconds()
    func getBookingDate()
    func sendBenefitPayDetail(result: String, isPaymentPartial: Bool, isMpgs: Bool, isWalletUsed: Bool, walletPaidAmount: Double, cardPaidAmount: Double, advanceAmount: Double, remainingAmount: Double, transactionId: String, paymentDetail:BPDLPaymentCallBackItem, merchantId:String)
}

protocol PaymentMethodDataStore
{
    var businessId: String! { get set }
    var bookingData: [Booking.selectedTherapistModel]! { get set }
    var specialInstructions: String? { get set }
    var isHome: Bool? { get set }
    var offerId: String? { get set }
    var totalAmount:NSNumber? { get set }
    var bookingId: String! { get set }
    var bookingDate: String! { get set }
    var slotBlockedTill: NSNumber? { get set }
    
}

class PaymentMethodInteractor: PaymentMethodBusinessLogic, PaymentMethodDataStore
{
    var bookingDate: String!
    var presenter: PaymentMethodPresentationLogic?
    var worker: PaymentMethodWorker?
    var businessId: String!
    var bookingData: [Booking.selectedTherapistModel]!
    var specialInstructions: String?
    var isHome: Bool?
    var offerId: String?
    var totalAmount:NSNumber?
    var bookingId: String!
    var slotBlockedTill:NSNumber?
    
    // MARK: Do something
    
    func getBookingDate() {
        presenter?.presentBookingDate(bookingDate: bookingDate)
    }
    
    func openGatewayUrl(result: String, isPaymentPartial: Bool, isMpgs: Bool, isWalletUsed: Bool, walletPaidAmount: Double, cardPaidAmount: Double, advanceAmount: Double, remainingAmount: Double, transactionId: String) {
        guard let bookingId = bookingId else {return}
        guard let totalAmount = totalAmount else { return }
        
        let type = isMpgs ? "credit card": "debit card"
        var paymentMethod = [String]()
        paymentMethod.append(type)
        
        
        let systemVersion = UIDevice.current.systemVersion
        let info = Bundle.main.infoDictionary ?? [:]
        let currentVersion = info["CFBundleShortVersionString"] as? String ?? ""
        let customerAgent = "iOS " + systemVersion + ", " + "BS " + currentVersion
        
        let paymentType = isPaymentPartial ? "partial": "full"
        
        let param = [
            "extraParams" : [ "paymentMethod":paymentMethod,
                              "paymentType":paymentType,
                              "isWalletUsed":isWalletUsed,
                              "walletPaidAmount":String(format: "%.3f", walletPaidAmount),
                              "cardPaidAmount":String(format: "%.3f", cardPaidAmount),
                              "totalAmount":String(format: "%.3f", totalAmount),
                              "paidAmount":String(format: "%.3f", advanceAmount),
                              "bookingId": bookingId,
                              "remainingAmount":String(format: "%.3f", remainingAmount),
                              "paymentStatus": "",
                              "transactionId": transactionId],
            
            "amount": String(format: "%.3f", cardPaidAmount),
            "type": type,
            "bookingId": bookingId,
            "deviceType":"ios",
            "customerAgent": customerAgent,
            "customerNote":""
            ] as [String : Any]
        
        worker = PaymentMethodWorker()
        worker?.openGatewayUrl(parameters: param, apiResponse: { (response) in
            if response.code == 200{
                self.presenter?.presentGatewayResponse(response: response)
            }
            else if response.code == 404 {
                CommonFunctions.sharedInstance.showSessionExpireAlert()
            }
            else {
                CustomAlertController.sharedInstance.showErrorAlert(error: response.error!)
            }
        })
    }
    
    func sendBenefitPayDetail(result: String, isPaymentPartial: Bool, isMpgs: Bool, isWalletUsed: Bool, walletPaidAmount: Double, cardPaidAmount: Double, advanceAmount: Double, remainingAmount: Double, transactionId: String, paymentDetail:BPDLPaymentCallBackItem, merchantId:String) {
        guard let bookingId = bookingId else {return}
        guard let totalAmount = totalAmount else { return }
        
        var paymentMethod = [String]()
        if isWalletUsed{
            paymentMethod.append("wallet")
        }
        paymentMethod.append("benefit pay")
        
        let systemVersion = UIDevice.current.systemVersion
        let info = Bundle.main.infoDictionary ?? [:]
        let currentVersion = info["CFBundleShortVersionString"] as? String ?? ""
        let customerAgent = "iOS " + systemVersion + ", " + "BS " + currentVersion
        
        let paymentType = isPaymentPartial ? "partial": "full"
        var paymentStatus = "fully paid"
        
        if remainingAmount > 0 {
            paymentStatus = "partially paid"
        }
        let param = [
            "transaction" : [
                "amount": paymentDetail.amount ?? "",
                "cardNumber": paymentDetail.cardNumber ?? "",
                "currency": paymentDetail.currency ?? "",
                "merchant": paymentDetail.merchantName ?? "",
                "merchantId": merchantId,
                "referenceNumber": paymentDetail.referenceId ?? "",
                "terminalId": "", ],
            
            "amount": String(format: "%.3f", cardPaidAmount),
            "booking_id": bookingId,
            "cardPaidAmount":String(format: "%.3f", cardPaidAmount),
            "isWalletUsed":isWalletUsed,
            "paidAmount":String(format: "%.3f", advanceAmount),
            "paymentMethod":paymentMethod,
            "paymentStatus": paymentStatus,
            "paymentType":paymentType,
            "remainingAmount":String(format: "%.3f", remainingAmount),
            "status": paymentDetail.status.rawValue == 1 ? "success" : "failed",
            "totalAmount":"\(totalAmount)",
            "walletPaidAmount":String(format: "%.3f", walletPaidAmount),
            
            
            
            
        ] as [String : Any]
        print(param);
        
        printToConsole(item: param)
        worker = PaymentMethodWorker()
        
        worker?.hitVerifyBenefitApi(parameters: param, apiResponse: { (response) in
            if response.code == 200{
                printToConsole(item: response)
                let result:Dictionary<String,Any> = response.result as! Dictionary<String, Any>
                if response.status as! Bool {
                    if let msg = result["msg"] as? String {
                        CustomAlertController.sharedInstance.showAlertWith(subTitle: msg, theme: .success) {
                            self.presenter?.presentUserBookingResponse()
                        }
                    }
                }else{
                    if let msg = result["msg"] as? String {
                        CustomAlertController.sharedInstance.showErrorAlert(error: msg)
                    }
                }
                
            }
            else if response.code == 404 {
                CommonFunctions.sharedInstance.showSessionExpireAlert()
            }
            else {
                CustomAlertController.sharedInstance.showErrorAlert(error: response.error!)
            }
        })
        /*"type": type,
         
         "deviceType":"ios",
         "customerAgent": customerAgent,
         "customerNote":""*/
    }
    
    func getTimeoutSeconds() {
        if let slotBlockedTill = slotBlockedTill {
            let date = Date(largeMilliseconds: Int64(truncating: slotBlockedTill))
            let elapsed = date.timeIntervalSince(Date())
            presenter?.timeoutSeconds(seconds: elapsed)
        }
    }
    
    func hitCheckBusinessPaymentTypeApi() {
        worker = PaymentMethodWorker()
        
        let parameters = [
            "businessId": businessId ?? "",
            "userId":getUserData(._id),
            "totalAmount": totalAmount ?? 0
            ] as [String : Any]
        
        worker?.hitCheckBusinessPaymentTypeApi(parameters: parameters, apiResponse: { (response) in
            if response.code == 200{
                self.presenter?.presentResponse(response: response, totalAmount: self.totalAmount ?? 0)
            }
            else if response.code == 404 {
                CommonFunctions.sharedInstance.showSessionExpireAlert()
            }
            else {
                CustomAlertController.sharedInstance.showErrorAlert(error: response.error!)
            }
        })
    }
    
    func hitVerifyCardApi(request: PaymentMethod.Request) {
        let totalCharge = totalAmount?.doubleValue
        let remainingAmount = request.remainingAmount
        var paymentStatus = "fully paid"
        
        if remainingAmount > 0 {
            paymentStatus = "partially paid"
        }
        let parameters = [
            "paymentMethod":[],
            "paymentStatus":paymentStatus,
            "paymentType":request.paymentType,
            "totalAmount":totalCharge?.description ?? "",
            "paidAmount":request.paidAmount,
            "remainingAmount":request.remainingAmount,
            "bookingId": bookingId,
            "isWalletUsed":request.isWalletUsed,
            "walletPaidAmount":request.walletPaidAmount,
            "cardPaidAmount":request.cardPaidAmount,
            "transactionId": ""
            ] as [String : Any]
        
        printToConsole(item: parameters)
        worker = PaymentMethodWorker()
        
        worker?.hitVerifyCardApi(parameters: parameters, apiResponse: { (response) in
            if response.code == 200{
                printToConsole(item: response)
                self.presenter?.presentUserBookingResponse()
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
