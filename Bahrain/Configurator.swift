/**
 This class contains configurable parameters for the project
 */
import Foundation

class Configurator: NSObject {
    
    
    ///////////   Base URL  /////////////////
    
    //    static let baseURL = "http://www.mastersoftwaretechnologies.com:9035/api/v1/"
    //    static let imageBaseUrl = "http://www.mastersoftwaretechnologies.com:9035/uploads/"
    //    static let socketBaseURL = "http://www.mastersoftwaretechnologies.com:9035/api/"
    
    // client build url
     var baseURL = NetworkingWrapper.sharedInstance.selectedServerURL().baseURL
     var imageBaseUrl = NetworkingWrapper.sharedInstance.selectedServerURL().imageURL
     var socketBaseURL = NetworkingWrapper.sharedInstance.selectedServerURL().socketURL
        
    // Local
    
    /*static let baseURL = "http://mastersoftwaretechnologies.com:8097/api/v2/"
     static let imageBaseUrl = "http://mastersoftwaretechnologies.com:8097/uploads/"
     static let socketBaseURL = "http://mastersoftwaretechnologies.com:8097/api/v2/"*/
    
    
    // Live Server url
//        static let baseURL = "https://webservices.bahrainsalons.com:9052/api/v2/"
//        static let imageBaseUrl = "https://webservices.bahrainsalons.com:9052/uploads/"
//        static let socketBaseURL = "https://webservices.bahrainsalons.com:9052/api/v2/"
    
    
    ///////////   Google Maps  /////////////////
    
    static let gmMapKey = "AIzaSyBHJ1AdtP7aFNTSBhF_V3x92VT_eIgfsV8"
    static let googleApiKey = "AIzaSyBHJ1AdtP7aFNTSBhF_V3x92VT_eIgfsV8"
    
    ///////////   Console Printing  /////////////////
    
    static let consolePrintingEnabled = "1"
    
}
