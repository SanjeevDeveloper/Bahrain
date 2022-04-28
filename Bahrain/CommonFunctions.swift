
import UIKit

class CommonFunctions: NSObject {
    
    static let sharedInstance = CommonFunctions()
    
    private override init() {}
    
    /**
     Call this function to generate random number of preferred length.
     */
    
    func generateRandomNumber(length:Int) -> String {
        var place:UInt32 = 1
        var finalNumber:UInt32 = 0
        for _ in 0..<length-1 {
            place *= 10
            let randomNumber = arc4random_uniform(10)
            finalNumber += randomNumber * place
        }
        return "2018"
        //return finalNumber.description
    }
    
    /**
     Call this function to update logged in user data in user default
     */
    
    func updateUserData(_ attribute:userAttributes, value:String) {
        // UnArchiving user attributes object
        if let userData:Data = userDefault.value(forKey: userDefualtKeys.UserObject.rawValue) as? Data {
            if let userDict:NSMutableDictionary = NSKeyedUnarchiver.unarchiveObject(with: userData) as? NSMutableDictionary {
                
                userDict[attribute.rawValue] = value
                
                // saving again to userDefault
                let resultData = NSKeyedArchiver.archivedData(withRootObject: userDict)
                userDefault.set(resultData, forKey: userDefualtKeys.UserObject.rawValue)
                
                // updating app instance unarchived user object
                appDelegateObj.unarchiveUserData()
            }
        }
    }
    
    /**
     Call this function to convert json to model
     */
    
    public static func convertJsonObjectToModel<T: Decodable>(_ object: [String: Any], modelType: T.Type) -> T? {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: object, options: .prettyPrinted)
            
            let reqJSONStr = String(data: jsonData, encoding: .utf8)
            let data = reqJSONStr?.data(using: .utf8)
            let jsonDecoder = JSONDecoder()
            do {
                let modelObj = try jsonDecoder.decode(modelType, from: data!)
                return modelObj
            }
            catch {
                printToConsole(item: "error \(error)")
            }
        }
        catch {
            printToConsole(item: "error \(error)")
        }
        return nil
    }
    
    func genderValue() -> Int {
        var value = 0
        if userDefault.bool(forKey: userDefualtKeys.userLoggedIn.rawValue) {
            value = getUserData(.gender).intValue()
        } else {
            value = userDefault.value(forKey: "gender") as! Int
        }
        return value
    }
    
    /**
     Call this function to open google map web link
     */
    
    func openGoogleMap(destinationLatitude:Double, destinationLongitude:Double) {
        let url = URL(string: "http://maps.google.com/?saddr=\(LocationWrapper.sharedInstance.latitude),\(LocationWrapper.sharedInstance.longitude)&daddr=\(destinationLatitude),\(destinationLongitude)&directionsmode=driving")
        printToConsole(item: "Direction url \(String(describing: url))")
        if (UIApplication.shared.canOpenURL(url!)) {
            UIApplication.shared.open(url!, options: [:], completionHandler: nil)
            
        }
        else {
            printToConsole(item: "Can't open google maps")
        }
    }
    
    /**
     Call this function to show log in alert to guest user
     */
    
    func showLoginAlert(referenceController:UIViewController) {
        let alertController = PMAlertController(textForegroundColor:UIColor.darkGray, viewBackgroundColor: UIColor.white, title: localizedTextFor(key: GeneralText.pleaseLogin.rawValue), description: "", image: nil, style: .alert)
        alertController.addAction(PMAlertAction(title: localizedTextFor(key: GeneralText.no.rawValue), style: .default, action: {
            alertController.dismiss(animated: true, completion: nil)
        }))
        
        alertController.addAction(PMAlertAction(title: localizedTextFor(key: GeneralText.yes.rawValue), style: .default, action: {
            alertController.dismiss(animated: true, completion: nil)
            
            // moving to login screen
            self.moveToLoginScreen()
        }))
        
        referenceController.present(alertController, animated: true, completion: nil)
    }
    
    /**
     Call this function to convert json to Dictionary Data
     */
    func convertJsonStringToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    /**
     Call this function to convert any object into json string
     */
    
    func json(from object:Any) -> String {
        guard let data = try? JSONSerialization.data(withJSONObject: object, options: []) else {
            return ""
        }
        return String(data: data, encoding: String.Encoding.utf8) ?? ""
    }
    
    
    /**
     Call this function to show log in alert to guest user
     */
    
    func showSessionExpireAlert() {
        
        var alertWindow:UIWindow?
        alertWindow = UIWindow(frame: UIScreen.main.bounds)
        alertWindow?.rootViewController = UIViewController()
        alertWindow?.windowLevel = (appDelegateObj.window?.windowLevel)! + 1
        alertWindow?.makeKeyAndVisible()
        
        let alertController = PMAlertController(textForegroundColor:UIColor.darkGray, viewBackgroundColor: UIColor.white, title: localizedTextFor(key:GeneralText.sessionexpired.rawValue), description: "", image: nil, style: .alert)
        
        
        alertController.addAction(PMAlertAction(title: localizedTextFor(key: GeneralText.ok.rawValue), style: .default, action: {
            alertController.dismiss(animated: true, completion: nil)
            
            
            alertWindow?.resignKey()
            alertWindow = nil
            appDelegateObj.window?.makeKeyAndVisible()
            
            
            // updating user log in status in user default
            userDefault.set(false, forKey: userDefualtKeys.userLoggedIn.rawValue)
            
            // updating user data in user default
            userDefault.removeObject(forKey: userDefualtKeys.UserObject.rawValue)
            
            // Clears app delegate user object dictioary
            appDelegateObj.userDataDictionary.removeAllObjects()
            
            
            // moving to login screen
            self.moveToLoginScreen()
        }))
        
        alertWindow?.rootViewController?.present(alertController, animated: true, completion: nil)
    }
    
    func moveToLoginScreen() {
        let initialNavigationController = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: ViewControllersIds.LoginViewControllerID)
        let navCtrl = OnBoardingModuleNavigationController(rootViewController: initialNavigationController)
        appDelegateObj.window?.rootViewController = navCtrl
        appDelegateObj.window?.makeKeyAndVisible()
    }
    
    func setNavigationTitleView(titleStr:String, onVC: UIViewController){
        let navView = UIView()
        // Create the label
        let navTitleLabel = UILabel()
        navTitleLabel.text = localizedTextFor(key: LoginSceneText.loginSceneTitle.rawValue)
        navTitleLabel.text = titleStr
        navTitleLabel.sizeToFit()
        navTitleLabel.textColor = UIColor.white
        navTitleLabel.center = navView.center
        navTitleLabel.textAlignment = NSTextAlignment.center
        
        // Create the image view
        let navImageView = UIImageView()
        navImageView.image = UIImage(named: "logo_icon")
        let imageAspect = navImageView.image!.size.width/navImageView.image!.size.height
        
        var xFrame =  CGFloat()
        if let languageIdentifier = UserDefaults.standard.value(forKey: userDefualtKeys.currentLanguage.rawValue) as? String {
            if languageIdentifier == Languages.Arabic {
                xFrame = navTitleLabel.frame.maxX + 5
            }
            else {
                xFrame = navTitleLabel.frame.origin.x-30
            }
        }
        else {
            xFrame = navTitleLabel.frame.origin.x-30
        }
        
        navImageView.frame = CGRect(x: xFrame, y: navTitleLabel.frame.origin.y, width: navTitleLabel.frame.size.height*imageAspect, height: navTitleLabel.frame.size.height)
        navImageView.contentMode = UIViewContentMode.scaleAspectFit
        
        // Add both the label and image view to the navView
        navView.addSubview(navTitleLabel)
        navView.addSubview(navImageView)
        onVC.navigationItem.titleView = navView
        
    }
    
    /**
     Call this function to get date in particular format
     */
    func formatDate(_ date: Date, format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = UaeTimeZone
        dateFormatter.dateFormat = format
        let selectedDate = dateFormatter.string(from: date)
        return selectedDate
    }
    
}
