/**
 This is a text validator class which contains validation functions for most used cases like email validation, required validation etc.
 */

import UIKit

public class Validator {
    
    public init() {}
    
    /**
     Call this function to validate email
     */
    
    public func validateEmail(_ email:String) -> Bool  {
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        if !(emailPredicate.evaluate(with: email)) {
            return false
        }
        return true
    }
    
    /**
     Call this function to validate password with custom Regex string
     */
    
    public func validatePassword(_ password:String, regexString: String) -> Bool  {
        let passwordPredicate = NSPredicate(format:"SELF MATCHES %@", regexString)
        if !(passwordPredicate.evaluate(with: password)) {
            return false
        }
        return true
    }
    
    /**
     Call this function to validate equality
     */
    
    public func validateEquality(_ firstItem:String, secondItem:String) -> Bool {
        if secondItem != firstItem {
            return false
        }
        return true
    }
    
    /**
     Call this function to validate required fields
     */
    
    public func validateRequired(_ text:String) -> Bool {
        if text.trimmingCharacters(in: .whitespaces) == "" {
            return false
        }
        return true
    }
    
    /**
     Call this function to validate null fields
     */
    
    public func validateNil(_ item:Any?) -> Bool {
        if item == nil {
            return false
        }
        return true
    }
    
    /**
     Call this function to validate string minimum characters count
     */
    
    public func validateMinCharactersCount(_ text:String, minCount:Int?) -> Bool {
        return validateCharactersCount(text, minCount: minCount, maxCount: nil)
    }
    
    /**
     Call this function to validate string maximum characters count
     */
    
    public func validateMaxCharactersCount(_ text:String, maxCount:Int?) -> Bool {
        return validateCharactersCount(text, minCount: nil, maxCount: maxCount)
    }
    
    /**
     Call this function to validate string minimum and maximum characters count
     */
    
    public func validateCharactersCount(_ text:String, minCount:Int?, maxCount:Int?) -> Bool {
        if minCount != nil {
            if text.count < minCount! {
                return false
            }
        }
        if maxCount != nil {
            if text.count > maxCount! {
                return false
            }
        }
        return true
    }
}
