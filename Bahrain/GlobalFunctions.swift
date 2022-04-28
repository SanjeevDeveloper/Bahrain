
import Foundation

/**
 Call this function to print anything on console.
 */

func printToConsole(item: Any) {
    if Configurator.consolePrintingEnabled.boolValue() {
        print(item)
    }
}


/**
 Call this function for showing localized text instead of default nslocalized constructor in every class.
 */

func localizedTextFor(key:String) -> String {
    return NSLocalizedString(key, tableName: nil, bundle: getCurrentBundle(), value: "", comment: "")
}


func getCurrentBundle() -> Bundle {
    
    let defaults = UserDefaults.standard
    let langIdArray = defaults.value(forKey: "AppleLanguages") as! Array<String>
    let lanIdCompleteString = langIdArray[0]
    let langId = lanIdCompleteString.prefix(2)
    
    
    if let langBundlePath = Bundle.main.path(forResource: langId.description, ofType: "lproj") {
        
        if let langBundle = Bundle(path: langBundlePath) {
            return langBundle
        }
        else {
            print("Could not load the Mss localized bundle language folder")
        }
    }
    else {
        print("Could not create a path the Mss localized bundle language folder")
    }
    return  Bundle.main
}

/**
 Call this function to get any attribute related to logged in user.
 */


func getUserData(_ attribute:userAttributes) -> String {
    if attribute == .birthday {
        let birthdateMilliseconds =  appDelegateObj.userDataDictionary.value(forKey: attribute.rawValue) as? NSNumber ?? 0
        printToConsole(item: attribute.rawValue)
        printToConsole(item: birthdateMilliseconds.description)
        return birthdateMilliseconds.description
    }
    else if attribute == .notification {
        let notification =  appDelegateObj.userDataDictionary.value(forKey: attribute.rawValue) as? Int ?? 0
        return notification.description
    } else if attribute == .gender {
        if let gender =  appDelegateObj.userDataDictionary.value(forKey: attribute.rawValue) as? String {
            return gender
        } else {
            return ""
        }
    }
    else if attribute == .isApproved {
        let notification =  appDelegateObj.userDataDictionary.value(forKey: attribute.rawValue) as? Int ?? 0
        return notification.description
    }
    else {
        return appDelegateObj.userDataDictionary.value(forKey: attribute.rawValue) as? String ?? ""
    }
}


/**
 Call this function to check if any user is logged in
 */

func isUserLoggedIn() -> Bool {
    return userDefault.bool(forKey: userDefualtKeys.userLoggedIn.rawValue)
}

func getCalendar() -> Calendar {
    var calendar = Calendar.current
    calendar.timeZone = UaeTimeZone!
    return calendar
}

func isCurrentLanguageArabic() -> Bool {
    let languageIdentifier = UserDefaults.standard.value(forKey: userDefualtKeys.currentLanguage.rawValue) as! String
    return languageIdentifier == Languages.Arabic
}

func getDateFormatter() -> DateFormatter {
    let dateFormatter = DateFormatter()
    dateFormatter.timeZone = UaeTimeZone
    return dateFormatter
}

func getDatePicker() -> UIDatePicker {
    let datePickerView = UIDatePicker()
    datePickerView.locale = Locale(identifier: "en_US")
    if isCurrentLanguageArabic() {
        for views in datePickerView.subviews {
            views.semanticContentAttribute = .forceLeftToRight
        }
    }
    datePickerView.timeZone = UaeTimeZone
    return datePickerView
}


/**
 Call this function to check if business is approved
 */

func isBusinessApproved() -> Bool {
    return userDefault.bool(forKey: userDefualtKeys.businessApproved.rawValue)
}
