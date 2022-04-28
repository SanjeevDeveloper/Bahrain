//
//  MssBundle.swift
//  MssGems
//
//  Created by Kashish Verma on 4/11/18.
//

class MssBundle {
    
   class func getMssGemsBundle() -> Bundle {
        let podBundle = Bundle(for: MssBundle.self)
        if let bundleURL = podBundle.url(forResource: "MssGems", withExtension: "bundle") {
            if let frameworkBundle = Bundle.init(url: bundleURL) {
                if  let path = frameworkBundle.path(forResource: "LocalizedBundle", ofType: "bundle") {
                    if let localizedBundle = Bundle(path: path) {
                        
                        let defaults = UserDefaults.standard
                        let langIdArray = defaults.value(forKey: "AppleLanguages") as! Array<String>
                        let lanIdCompleteString = langIdArray[0]
                        let langId = lanIdCompleteString.prefix(2)
                        
                        
                        if let langBundlePath = localizedBundle.path(forResource: langId.description, ofType: "lproj") {
                            
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
                    }
                    else {
                        print("Could not load the Mss localized bundle")
                    }
                }
                else {
                    print("Could not create a path the Mss localized bundle")
                }
            }
            else {
                print("Could not load the Mss framework")
            }
        }
        else {
            print("Could not create a path to the Mss framework")
        }
        return  Bundle.main
    }
}
