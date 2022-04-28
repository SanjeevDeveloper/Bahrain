/**
 This file contains commonly used functions.
 */

import UIKit

public class MssCommonFunctions {
    
    /**
     Call this function to convert any object into json string
     */
    
    public static func getJsonString(_ object: Any) -> String {
        guard let data = try? JSONSerialization.data(withJSONObject: object, options: []) else {
            return ""
        }
        return String(data: data, encoding: String.Encoding.utf8) ?? ""
    }
    
    /**
     Call this function to convert model object to json
     */
    
    public static func convertModelObjectToJson<T: Encodable>(_ model: T) -> [String: Any]? {
        let jsonEncoder = JSONEncoder()
        jsonEncoder.outputFormatting = .prettyPrinted
        do {
            let data = try jsonEncoder.encode(model)
            do {
                if let jsonParameters = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] {
                    return jsonParameters
                }
            }
            catch {
                printToConsole("error \(error)")
            }
        }
        catch {
            printToConsole("error \(error)")
        }
        return nil
    }
    
    /**
     Call this function to convert json object to model
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
                printToConsole("error \(error)")
            }
        }
        catch {
            printToConsole("error \(error)")
        }
        return nil
    }
    
    public static func openUrlOutsideApp(url: URL) {
        if UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
            }
            else {
                UIApplication.shared.openURL(url)
            }
        }
        else {
            printToConsole("Can't open url")
        }
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
    return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
}
