
import Foundation

class RegistrationRequest: NSObject {
    var email: String = ""
    var name: String = ""
    var area = String()
    var block = String()
    var road = String()
    var houseNo = String()
    var flatno = String()
    var pinAddress = String()
    var password: String = ""
    var phoneNumber: String = ""
    var countryCode: String = ""
    var language: String = ""
    var address: String = ""
    var address2: String = ""
    var birthday: String = ""
    var notification: String = "true"
    var deviceId: String = ""
    var deviceType: String = ""
    var latitude: String = ""
    var longitude: String = ""
    var countryName: String = ""
    var gender: Int = 1
    
    override init() {
        super.init()
    }
}

