/**
 This class generates custom headers to send in api's
 */
import UIKit

class ApiHeaders: NSObject {
    
    static let sharedInstance = ApiHeaders()
    
    func headerWithAuth() -> [String:String] {
        let currentLanguageIdentifier = (userDefault.value(forKey: userDefualtKeys.currentLanguage.rawValue) as! String)
        print("CURRENT LANGUAGE >>>>>>>>>>>>", currentLanguageIdentifier)
        let headerWithAuth = [
            "authorization": getUserData(.accessToken),
            "language": currentLanguageIdentifier
        ]
        return headerWithAuth
    }
    
    func headerWithAuthAndUserId() -> [String:String] {
        let currentLanguageIdentifier = (userDefault.value(forKey: userDefualtKeys.currentLanguage.rawValue) as! String)
        print("CURRENT LANGUAGE >>>>>>>>>>>>", currentLanguageIdentifier)
        let headerWithAuthAndUserId = [
            "authorization": getUserData(.accessToken),
            "userId": getUserData(._id),
            "language": currentLanguageIdentifier
        ]
        
        return headerWithAuthAndUserId
    }
    
    func headerWithLang() -> [String:String] {
        let currentLanguageIdentifier = (userDefault.value(forKey: userDefualtKeys.currentLanguage.rawValue) as! String)
        print("CURRENT LANGUAGE >>>>>>>>>>>>", currentLanguageIdentifier)
        let headerWithLang = [
            "language": currentLanguageIdentifier
        ]
        
        return headerWithLang
    }
    
    
    
}
