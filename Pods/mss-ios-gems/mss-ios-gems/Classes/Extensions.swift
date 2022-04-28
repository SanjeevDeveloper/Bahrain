/**
 This class contains various useful extension of UIKit objects
 */
import UIKit

public extension UITextField {
    
    /**
     This extension always return the trimmed text from the text field.
     
     ### Usage Example: ###
     ````
     textfieldInstance.trimmedText()
     ````
     */
    
    func text_Trimmed() -> String {
        if let actualText = self.text {
            return actualText.trimmingCharacters(in: .whitespaces)
        }
        else {
            return ""
        }
    }
    
    /**
     This extension adds done button on UITextfield keyboards where there is no default button (eg. number pad, phone pad, custom pickers etc.).
     */
    
    @IBInspectable var doneAccessory: Bool{
        get{
            return self.doneAccessory
        }
        set (hasDone) {
            if hasDone{
                addDoneButtonOnKeyboard()
            }
        }
    }
    
    func addDoneButtonOnKeyboard()
    {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: MSSLocalizedKeys.sharedInstance.localizedTextFor(key: MSSLocalizedKeys.GeneralText.done.rawValue), style: .done, target: self, action: #selector(self.doneButtonAction))
        
        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        self.inputAccessoryView = doneToolbar
    }
    
    @objc func doneButtonAction()
    {
        self.resignFirstResponder()
    }
}

public extension UIViewController {
    
    /**
     This extension hides the text written with the back button of the naviagtion bar.
     */
    
    func hideBackButtonTitle() {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
    }
}

public extension UIButton {
    
    /**
     Call this function to set background color of uibutton for any particular state
     */
    
    func setBackgroundColor(color: UIColor, forState: UIControl.State) {
        
        UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
        UIGraphicsGetCurrentContext()!.setFillColor(color.cgColor)
        UIGraphicsGetCurrentContext()!.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
        let colorImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        self.setBackgroundImage(colorImage, for: forState)
    }
}

public extension String {
    
    /**
     This extension converts the string into boolean.
     */
    
    func boolValue() -> Bool {
        let nsString = self as NSString
        return nsString.boolValue
    }
    
    /**
     This extension converts the string into Integer.
     */
    
    func intValue() -> Int {
        let nsString = self as NSString
        return nsString.integerValue
    }
}

public extension UIView {
    
    /**
     Call this function to add shadow to only bottom part of view
     */
    
    @IBInspectable var bottomShadowColor: UIColor{
        get{
            let color = layer.shadowColor ?? UIColor.clear.cgColor
            return UIColor(cgColor: color)
        }
        set {
            addBottomShadow(color: bottomShadowColor)
        }
    }
    
    func addBottomShadow(color:UIColor) {
        let shadowColor = color.cgColor
        self.layer.shadowColor = shadowColor
        self.layer.shadowOpacity = 0.4
        self.layer.shadowRadius = 3
        self.layer.shadowOffset = CGSize(width: 0, height: 3)
    }
}

public extension UIScrollView {
    
    /**
     This extension manages the keyboard. This will work correctly only if the constraints are placed properly in storyboard.
     ### Usage Example: ###
     ````
     scrollViewInstance.manageKeyboard()
     ````
     */
    
    func manageKeyboard() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(notification:)), name:UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(notification:)), name:UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification:NSNotification){
        var userInfo = notification.userInfo!
        let keyboardFrame:CGRect = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
        var contentInset:UIEdgeInsets = self.contentInset
        contentInset.bottom = keyboardFrame.size.height
        self.contentInset = contentInset
    }
    
    @objc func keyboardWillHide(notification:NSNotification){
        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        self.contentInset = contentInset
    }
}

public extension UITextView {
    
    /**
     This extension always return the trimmed text from the text view.
     
     ### Usage Example: ###
     ````
     textfieldInstance.trimmedText()
     ````
     */
    
    func text_Trimmed() -> String {
        if let actualText = self.text {
            return actualText.trimmingCharacters(in: .whitespaces)
        }
        else {
            return ""
        }
    }
    
    /**
     This extension adds done button on UITextview keyboards where there is no default button (eg. number pad, phone pad, custom pickers etc.).
     */
    
    @IBInspectable var doneAccessory: Bool{
        get{
            return self.doneAccessory
        }
        set (hasDone) {
            if hasDone{
                addDoneButtonOnKeyboard()
            }
        }
    }
    
    func addDoneButtonOnKeyboard()
    {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: MSSLocalizedKeys.sharedInstance.localizedTextFor(key: MSSLocalizedKeys.GeneralText.done.rawValue), style: .done, target: self, action: #selector(self.doneButtonAction))
        
        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        self.inputAccessoryView = doneToolbar
    }
    
    @objc func doneButtonAction() {
        self.resignFirstResponder()
    }
}

public extension Date {
    
    /**
     Call this function to convert date into milliseconds
     */
    
    var millisecondsSince1970:Int64 {
        return Int64((self.timeIntervalSince1970 * 1000.0).rounded())
    }
    
    /**
     Call this function to convert milliseconds into date
     */
    
    init(milliseconds:Int64) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds / 1000))
    }
}

public extension UIToolbar {
    
    func toolbarPicker(selector : Selector) -> UIToolbar {
        
        let toolBar = UIToolbar()
        
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.black
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: MSSLocalizedKeys.sharedInstance.localizedTextFor(key:MSSLocalizedKeys.GeneralText.done.rawValue), style: UIBarButtonItem.Style.plain, target: self, action: selector)
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        
        toolBar.setItems([ spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        return toolBar
    }
}

public extension UITabBarController {
    
    /**
     Call this function to hide or show tab bar with animation
     */
    
    func setTabBarVisible(visible:Bool) {
        setTabBarVisible(visible: visible, duration: 0, animated: false)
    }
    
    /**
     Call this function to hide or show tab bar with custom animation and duration
     */
    
    func setTabBarVisible(visible:Bool, duration: TimeInterval, animated:Bool) {
        if (tabBarIsVisible() == visible) { return }
        let frame = self.tabBar.frame
        let height = frame.size.height
        let offsetY = (visible ? -height : height)
        
        // animation
        UIView.animate(withDuration: duration, animations: {
            self.tabBar.frame.offsetBy(dx:0, dy:offsetY)
            let width = self.view.frame.width
            let height = self.view.frame.height + offsetY
            self.view.frame = CGRect(x:0, y:0, width: width, height: height)
            self.view.setNeedsDisplay()
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    func tabBarIsVisible() ->Bool {
        return self.tabBar.frame.origin.y < UIScreen.main.bounds.height
    }
}

/**
 Call this function to append two dictionaries
 */

public extension Dictionary {
    mutating func add(other:Dictionary) {
        for (key,value) in other {
            self.updateValue(value, forKey:key)
        }
    }
}


