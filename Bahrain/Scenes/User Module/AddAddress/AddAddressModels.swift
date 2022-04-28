

import UIKit

enum AddAddress {
    
    struct Request {
        var address: String
        var addressID: String
        var title: String
        var phoneNumber: String
        var countryCode: String
        var latitude: String
        var longitude: String
        var isDefault: Bool
        var road: String
        var flatNumber: String
        var houseNumber: String
        var block: String
    }
    struct Response {
    }
    struct ViewModel {
    }
}
