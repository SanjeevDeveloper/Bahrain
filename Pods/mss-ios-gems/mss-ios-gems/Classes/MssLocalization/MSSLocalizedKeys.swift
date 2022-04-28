
import UIKit

public class MSSLocalizedKeys {
    
    public static let sharedInstance = MSSLocalizedKeys()
    
    /**
     Call this function for showing localized text from string file using the key.
     */
    
    func localizedTextFor(key:String) -> String {
        return NSLocalizedString(key, tableName: "MSSLocalizable", bundle: MssBundle.getMssGemsBundle(), value: "", comment: "")
    }    
    
    /**
     keys to find text from localized string file
     */
    
    // Custom Image Picker Wrapper
    
    enum CustomImagePickerText:String {
        case openCamera = "openCamera"
        case openGallery = "openGallery"
    }
    
    // General
    
    enum GeneralText:String {
        case no = "no"
        case yes = "yes"
        case cancel = "cancel"
        case cameraPermission = "cameraPermission"
        case permissionHeading = "permissionHeading"
        case ok = "ok"
        case done = "done"
        case retry = "retry"
        case noInternetFound = "noInternetFound"
    }
    
}
