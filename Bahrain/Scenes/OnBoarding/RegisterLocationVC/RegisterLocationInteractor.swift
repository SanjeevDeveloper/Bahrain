
import UIKit
import MapKit

protocol RegisterLocationBusinessLogic
{
    func registerUser(request: RegistrationRequest)
    func hitUpdateProfileImageApi()
}

protocol RegisterLocationDataStore
{
    var registerRequest: RegistrationRequest? { get set }
    var selectedArea: String? { get set }
    var selectedAreaCapital: String? { get set }
    var selectedBlock: String? { get set }
    var coordinate: CLLocationCoordinate2D? { get set }
    var pinAddress: String? { get set }
    var profileImageRequest: UIImage? { get set }
}

class RegisterLocationInteractor: RegisterLocationBusinessLogic, RegisterLocationDataStore
{
    var pinAddress: String?
    var coordinate: CLLocationCoordinate2D?
    var presenter: RegisterLocationPresentationLogic?
    var worker: RegisterLocationWorker?
    var registerRequest: RegistrationRequest?
    var selectedArea: String?
    var selectedAreaCapital: String?
    var selectedBlock: String?
    var profileImageRequest: UIImage?
    
    func registerUser(request: RegistrationRequest) {
        if isRequestValid(request: request) {
            worker = RegisterLocationWorker()
            
            let birthDateString = request.birthday
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = dateFormats.format1
            dateFormatter.timeZone = UaeTimeZone
            let birthDate = dateFormatter.date(from: birthDateString)
            let birthDateMilliseconds = birthDate?.millisecondsSince1970
            let birthMillisecondsString = birthDateMilliseconds?.description ?? ""
            
            let parameters: [String: Any] = [
                "email":request.address,
                "name":registerRequest!.name,
                "password":registerRequest!.password,
                "phoneNumber":registerRequest!.phoneNumber,
                "countryCode":registerRequest!.countryCode,
                "language":userDefault.value(forKey: userDefualtKeys.currentLanguage.rawValue) as? String ?? "",
                "address":"",
                "address2":request.address2,
                "birthday":birthMillisecondsString,
                "notification":registerRequest!.notification,
                "role": "user",
                "countryName": registerRequest!.countryName,
               // "deviceId":userDefault.value(forKey: userDefualtKeys.firebaseToken.rawValue) as? String ?? "",
               // "deviceType":deviceType,
                "latitude": request.latitude,
                "longitude": request.longitude,
                "area": request.area,
                "capitalName": selectedAreaCapital ?? "",
                "block": request.block,
                "road": request.road,
                "houseNumber": request.houseNo,
                "flatNumber": request.flatno,
                "deviceType" : "ios",
                "gender": registerRequest!.gender,
                "deviceId" : userDefault.value(forKey: userDefualtKeys.firebaseToken.rawValue) as? String ?? ""
            ]
            
            worker?.hitRegistrationApi(parameters: parameters, apiResponse: { (response) in
                
                if response.code == 200 {
                    // saving complete user object
                    let resultDict = response.result as! NSDictionary
                    printToConsole(item: resultDict)
                    let resultData = NSKeyedArchiver.archivedData(withRootObject: resultDict.mutableCopy())
                    
                    //Registered Date
                    let createdAt = resultDict["createdAt"] as! Int64
                    let createdDate = Date(largeMilliseconds: createdAt)
                    let dateFormatterC = DateFormatter()
                    dateFormatterC.dateFormat = dateFormats.format10
                    dateFormatterC.timeZone = UaeTimeZone
                    let createDate = dateFormatterC.string(from: createdDate)
                    
                    userDefault.set(createDate, forKey: userDefualtKeys.registeredDate.rawValue)
                    
                    
                    userDefault.set(resultData, forKey: userDefualtKeys.UserObject.rawValue)
                    appDelegateObj.unarchiveUserData()
                    
                    // updating user log in status
                    userDefault.set(true, forKey: userDefualtKeys.userLoggedIn.rawValue)
                }
                self.presenter?.presentRegistrationResponse(response: response)
            })
        }
    }
    
    func hitUpdateProfileImageApi() {
        worker = RegisterLocationWorker()
        worker?.hitUpdateProfileImageApi(image: profileImageRequest!, apiResponse: { (response) in
            
            if response.code == 404 {
                CommonFunctions.sharedInstance.showSessionExpireAlert()
            }
            else {
                self.presenter?.presentUpdateImageResponse(response: response)
            }
        })
    }
    
    func isRequestValid(request: RegistrationRequest) -> Bool {
        var isValid = true
        let validator = Validator()
        // email validation 
        printToConsole(item: request.address)
        if request.address != "" {
        if !validator.validateEmail(request.address, errorKey: localizedTextFor(key: ValidationsText.invalidEmail.rawValue)) {
            isValid = false
          }
        } else if request.area != "" {
            if !validator.validateRequired(request.area, errorKey: localizedTextFor(key: ValidationsText.enterArea.rawValue)) {
                isValid = false
            }
        } else if request.block != "" {
            if !validator.validateRequired(request.area, errorKey: localizedTextFor(key: ValidationsText.enterBlock.rawValue)) {
                isValid = false
            }
        }
        return isValid
    }
}
