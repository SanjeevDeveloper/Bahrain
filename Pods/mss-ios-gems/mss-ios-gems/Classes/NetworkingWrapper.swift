/**
 This is a wrapper of Networking library .
 */

import UIKit
import Alamofire

public class NetworkingWrapper {
    
    public static let sharedInstance = NetworkingWrapper()
    public typealias httpUrlResponse = (_ response: DataResponse<Any>) ->()
    public typealias multipartUploadResponse = (_ response: DataResponse<Any>?, _ error: String?) ->()
    private var alertWindow: UIWindow?
    static let apiManager = Alamofire.SessionManager.default
    
    let reachabilityManager = Alamofire.NetworkReachabilityManager(host: "www.apple.com")
    
    /**
     Call this function to check if the internet is active or not.
     */
    
    public func isConnectedToInternet() -> Bool {
        return reachabilityManager!.isReachable
    }
    
    /**
     Call this function to hit api with headers and parameters
     */
    
    public func connect(url:String, httpMethod:HTTPMethod, headers:HTTPHeaders?, parameters:[String:Any]?, showHudder: Bool,  apiResponse:@escaping(httpUrlResponse)) {
        
        let validUrlString = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        printToConsole(parameters as Any)
        printToConsole(headers as Any)
        printToConsole(validUrlString!)
        
        if showHudder {
            ManageHudder.sharedInstance.startActivityIndicator()
        }
        Alamofire.request(url, method: httpMethod, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { httpUrlResponse in
            if let value = httpUrlResponse.result.value {
                printToConsole(value)
            }
            if showHudder {
                ManageHudder.sharedInstance.stopActivityIndicator()
            }
            apiResponse(httpUrlResponse)
        }
        
    }
    
    /**
     Call this function to hit api without headers and with parameters
     */
    
    public func connect(url:String, httpMethod:HTTPMethod, parameters:[String:Any]?, showHudder: Bool,  apiResponse:@escaping(httpUrlResponse)) {
        connect(url: url, httpMethod: httpMethod, headers: nil, parameters: parameters, showHudder: showHudder) { (httpUrlResponse) in
            apiResponse(httpUrlResponse)
        }
    }
    
    /**
     Call this function to hit api with headers and without parameters
     */
    
    public func connect(url:String, httpMethod:HTTPMethod, headers:HTTPHeaders?, showHudder: Bool,  apiResponse:@escaping(httpUrlResponse)) {
        connect(url: url, httpMethod: httpMethod, headers: headers, parameters: nil, showHudder: showHudder) { (httpUrlResponse) in
            apiResponse(httpUrlResponse)
        }
    }
    
    /**
     Call this function to hit api without headers and without parameters
     */
    
    public func connect(url:String, httpMethod:HTTPMethod, showHudder: Bool,  apiResponse:@escaping(httpUrlResponse)) {
        connect(url: url, httpMethod: httpMethod, headers: nil, parameters: nil, showHudder: showHudder) { (response) in
            apiResponse(response)
        }
    }
    
    /**
     Call this function to hit Multi part api
     */
    
    public func connectWithMultiPart(url:String, httpMethod:HTTPMethod, parameters:[String:Any]?, headers:HTTPHeaders?, images:[UIImage]?, imageNames:[String]?, showHudder: Bool, progress: @escaping((_ progress: Double) ->()), apiResponse:@escaping(multipartUploadResponse)) {
        
        let validUrlString = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        if showHudder {
            ManageHudder.sharedInstance.startActivityIndicator()
        }
        hitMultiPartApi(url: validUrlString!, httpMethod: httpMethod, parameters: parameters, headers: headers, images: images, imageNames: imageNames, showHudder: showHudder, progress: { (uploadProgress) in
            progress(uploadProgress)
        }) { response, error   in
            apiResponse(response, error)
        }
        
    }
    
    private func hitMultiPartApi(url:String, httpMethod:HTTPMethod, parameters:[String:Any]?, headers:HTTPHeaders?, images:[UIImage]?, imageNames:[String]?, showHudder: Bool, progress: @escaping((_ progress: Double) ->()), apiResponse:@escaping(multipartUploadResponse)) {
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            
            if let imagesArray = images {
                for (index, image) in imagesArray.enumerated() {
                    let imageName = imageNames?[index] ?? "image"
                    multipartFormData.append(image.jpegData(compressionQuality: 1)!, withName: "\(imageName)", fileName: "\(imageName).jpeg", mimeType: "image/jpeg")
                    
                }
            }
            
            if parameters != nil {
                for (key, value) in parameters! {
                    multipartFormData.append(("\(value)").data(using: String.Encoding.utf8)!, withName: key)
                }
            }
        }, usingThreshold: UInt64.init(),
           to: url,
           method: httpMethod,
           headers: headers)
        { (result) in
            
            switch result {
            case .success(let upload, _, _):
                
                upload.uploadProgress(closure: { (uploadProgress) in
                    progress(uploadProgress.fractionCompleted)
                })
                
                upload.responseJSON { response in
                    printToConsole(response.result)
                    if showHudder {
                        ManageHudder.sharedInstance.stopActivityIndicator()
                    }
                    
                    apiResponse(response, nil)
                }
                
            case .failure(let encodingError):
                if showHudder {
                    ManageHudder.sharedInstance.stopActivityIndicator()
                }
                printToConsole(encodingError.localizedDescription)
                apiResponse(nil, encodingError.localizedDescription)
            }
        }
    }
    
    /**
     Call this function to hit Multipart api without image
     */
    
    public func connectWithMultiPart(url:String, httpMethod:HTTPMethod, headers:HTTPHeaders?, parameters:[String:Any], showHudder: Bool, progress: @escaping((_ progress: Double) ->()),  apiResponse:@escaping(multipartUploadResponse)) {
        
        connectWithMultiPart(url: url, httpMethod: httpMethod, parameters: parameters, headers: headers, images: nil, imageNames: nil, showHudder: showHudder, progress: { (uploadProgress) in
            progress(uploadProgress)
        }) { (response, error) in
            apiResponse(response, error)
        }
    }
    
    
    /**
     Call this function to hit Multipart api with parameters and without image and without headers
     */
    
    public func connectWithMultiPart(url:String, httpMethod:HTTPMethod, parameters:[String:Any]?, showHudder: Bool, progress: @escaping((_ progress: Double) ->()),  apiResponse:@escaping(multipartUploadResponse)) {
        
        connectWithMultiPart(url: url, httpMethod: httpMethod, parameters: parameters, headers: nil, images: nil, imageNames: nil, showHudder: showHudder, progress: { (uploadProgress) in
            progress(uploadProgress)
        }) { (response, error) in
            apiResponse(response, error)
        }
    }
    
    
    /**
     Call this function to hit Multipart api with headers and without parameters
     */
    
    public func connectWithMultiPart(url:String, httpMethod:HTTPMethod, headers:HTTPHeaders?, images:[UIImage]?, imageNames: [String]?, showHudder: Bool, progress: @escaping((_ progress: Double) ->()),  apiResponse:@escaping(multipartUploadResponse)) {
        
        connectWithMultiPart(url: url, httpMethod: httpMethod, parameters: nil, headers: headers, images: images, imageNames: imageNames, showHudder: showHudder, progress: { (uploadProgress) in
            progress(uploadProgress)
        }) { (response, error) in
            apiResponse(response, error)
        }
    }
    
    
    /**
     Call this function to hit Multipart api without headers and with parameters
     */
    
    public func connectWithMultiPart(url:String, httpMethod:HTTPMethod, parameters:[String:Any]?, images:[UIImage]?, imageNames: [String]?, showHudder: Bool, progress: @escaping((_ progress: Double) ->()),  apiResponse:@escaping(multipartUploadResponse)) {
        
        connectWithMultiPart(url: url, httpMethod: httpMethod, parameters: parameters, headers: nil, images: images, imageNames: imageNames, showHudder: showHudder, progress: { (uploadProgress) in
            progress(uploadProgress)
        }) { (response, error) in
            apiResponse(response, error)
        }
    }
    
    
    /**
     Call this function to hit Multipart api without headers and without parameters
     */
    
    public func connectWithMultiPart(url:String, httpMethod:HTTPMethod, images:[UIImage]?, imageNames: [String]?, showHudder: Bool, progress: @escaping((_ progress: Double) ->()),  apiResponse:@escaping(multipartUploadResponse)) {
        
        connectWithMultiPart(url: url, httpMethod: httpMethod, parameters: nil, headers: nil, images: images, imageNames: imageNames, showHudder: showHudder, progress: { (uploadProgress) in
            progress(uploadProgress)
        }) { (response, error) in
            apiResponse(response, error)
        }
    }
}
