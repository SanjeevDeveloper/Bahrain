///**
// This is a wrapper which uses Twilio rest api to send sms.
// */
//
//import UIKit
//
//class TwilioWrapper: NSObject {
//    
//    static let sharedInstance = TwilioWrapper()
//
//    private override init() {}
//    
//    func sendOtp(otp:String, toNumber:String, countryCode:String) {
//        let toNumber = "%2B\(countryCode.dropFirst())\(toNumber)"
//        let message = localizedTextFor(key: TwilioWrapperText.userMessage.rawValue) + otp
//         printToConsole(item: otp)
//        // Build the request
//        let request = NSMutableURLRequest(url: NSURL(string:"https://\(Configurator.twilioSID):\(Configurator.twilioSecret)@api.twilio.com/2010-04-01/Accounts/\(Configurator.twilioSID)/SMS/Messages")! as URL)
//        request.httpMethod = "POST"
//        request.httpBody = "From=\(Configurator.fromNumber)&To=\(toNumber)&Body=\(message)".data(using: String.Encoding.utf8)
//        
//        // Build the completion block and send the request
//        URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) in
//            if let data = data, let responseDetails = NSString(data: data, encoding: String.Encoding.utf8.rawValue) {
//                // Success
//                printToConsole(item: "Response: \(responseDetails.description)")
//            } else {
//                // Failure
//                printToConsole(item: "Error: \(String(describing: error))")
//            }
//        }).resume()
//    }
//    
//}
