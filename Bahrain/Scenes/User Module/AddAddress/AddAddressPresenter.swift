
import UIKit

protocol AddAddressPresentationLogic {
    func presentOldData(editObj: AddressList.ViewModel)
    func presentAddOrUpdateAddressResponse(response: ApiResponse, message: String, isEdit: Bool)
    func bookingConfirmed(response:ApiResponse)
    func presentLocationCordinate(location: LocationData)
}

class AddAddressPresenter: AddAddressPresentationLogic {
    weak var viewController: AddAddressDisplayLogic?
    
    func presentLocationCordinate(location: LocationData) {
        viewController?.displayLocationCordinate(location: location)
    }
    
    func presentAddOrUpdateAddressResponse(response: ApiResponse, message: String, isEdit: Bool) {
        if response.code == 200 {
            CustomAlertController.sharedInstance.showAlert(subTitle: message, type: .success)
            let obj = response.result as? [String: Any]
            let addressObject = AddressList.ViewModel(
                address: obj?["homeAddress"] as? String ?? "",
                addressID: obj?["_id"] as? String ?? "",
                title: obj?["title"] as? String ?? "",
                phoneNumber: obj?["phoneNumber"] as? String ?? "",
                countryCode: obj?["countryCode"] as? String ?? "",
                latitude: obj?["latitude"] as? String ?? "",
                longitude: obj?["longitude"] as? String ?? "",
                isDefault: obj?["isDefault"] as! Bool,
                road: obj?["otherAddress"] as? String ?? "",
                flatNumber: obj?["flatNumber"] as? String ?? "",
                houseNumber: obj?["houseNumber"] as? String ?? "",
                block: obj?["blockNumber"] as? String ?? ""
            )
            viewController?.displayAddOrUpdateResponse(defaultAddress: addressObject, isEdit: isEdit)
        } else if response.code == 404 {
          CommonFunctions.sharedInstance.showSessionExpireAlert()
        } else {
          CustomAlertController.sharedInstance.showErrorAlert(error: response.error ?? localizedTextFor(key: AddAddressSceneText.addErrorMessage.rawValue))
        }
    }
    
    func bookingConfirmed(response:ApiResponse) {
        let apiResponseDict = response.result as! NSDictionary
        let bookingId = apiResponseDict["bookingId"] as! String
        viewController?.bookingConfirmed(bookingId: bookingId)
    }
    
    func presentOldData(editObj: AddressList.ViewModel) {
        viewController?.displayOldData(editObj: editObj)
    }
}
