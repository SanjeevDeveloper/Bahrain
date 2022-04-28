
import UIKit

public class ConfigureGems {
    
    public static let sharedInstance = ConfigureGems()

    public var consolePrintingEnabled: Bool = true {
        didSet {
            ConfigureGems.sharedInstance.consolePrintingEnabled = consolePrintingEnabled
        }
    }
}
