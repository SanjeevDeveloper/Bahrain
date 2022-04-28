/**
 This file contains functions having global scope.
 */

import UIKit
    
    /**
     Call this function to print anything on console.
     */
    
    public func printToConsole(_ item: Any) {
        if ConfigureGems.sharedInstance.consolePrintingEnabled {
            print(item)
        }
    }

