//
//  OtpWrapper.swift
//  iBeauty
//
//  Created by Nitesh Chauhan on 5/10/18.
//  Copyright © 2018 Kashish Verma. All rights reserved.
//

import UIKit
import Firebase

class OtpWrapper  {
    
    typealias verificationIdHandler = (( _ response: String?) -> ())
 
    func sendOtp(toNumber:String, response:@escaping(verificationIdHandler)) {
        PhoneAuthProvider.provider().verifyPhoneNumber(toNumber, uiDelegate: nil) { (verificationID, error) in
            
            if let error = error {
                  print(error)
                response(nil)
            }
            else {
                response(verificationID)
            }
            
        }
    }
    typealias completionHandler = (( _ response: Bool) -> ())
    func verifyOtp(verificationId:String, otp:String, response:@escaping(completionHandler))  {
        let credential = PhoneAuthProvider.provider().credential(
            withVerificationID: verificationId,
            verificationCode: otp)
        
        Auth.auth().signIn(with: credential) { (user, error) in
            if let error = error {
                print(error)
                response(false)
            }
            else {
                print("success")
                response(true)
            }
        }
    }
    
}
