
import UIKit

protocol AddressListBusinessLogic {
    func deleteAddress(addressID: String, index: Int)
    func getAddressList()
    func setDefaultAddressList(defaultAddress: AddressList.ViewModel)
    func confirmBooking(_ selectedAddress: AddressList.ViewModel)
}

protocol AddressListDataStore {
    var bookingObject: [String: Any]! { get set }
    var bookingId: String? { get set }
}

class AddressListInteractor: AddressListBusinessLogic, AddressListDataStore {
    var presenter: AddressListPresentationLogic?
    var worker: AddressListWorker?
    var bookingObject: [String: Any]!
    var bookingId: String?
    // MARK: APIs
    
    func deleteAddress(addressID: String, index: Int) {
        worker = AddressListWorker()
        worker?.deleteAddressApi(id: addressID, apiResponse: { (response) in
            self.presenter?.presentDeleteResponse(index: index, response: response)
        })
    }
    
    func getAddressList() {
        worker = AddressListWorker()
        worker?.getAddressListApi(apiResponse: { (response) in
            self.presenter?.presentAddressListResponse(response: response)
        })
    }
    
    func setDefaultAddressList(defaultAddress: AddressList.ViewModel) {
        worker = AddressListWorker()
        worker?.setDefaultAddressApi(id: defaultAddress.addressID, apiResponse: { (response) in
            self.presenter?.presentUseDefaultAddressResponse(response: response, defaultAddress: defaultAddress)
        })
    }
    
    func confirmBooking(_ selectedAddress: AddressList.ViewModel) {
        bookingObject["bookingId"] = self.bookingId ?? ""
        bookingObject.updateValue(selectedAddress.address, forKey: "homeAddress")
        bookingObject.updateValue(selectedAddress.road, forKey: "otherAddress")
        bookingObject.updateValue(selectedAddress.houseNumber, forKey: "houseNumber")
        bookingObject.updateValue(selectedAddress.flatNumber, forKey: "flatNumber")
        bookingObject.updateValue(selectedAddress.title, forKey: "title")
        bookingObject.updateValue(selectedAddress.phoneNumber, forKey: "phoneNumber")
        bookingObject.updateValue(selectedAddress.countryCode, forKey: "countryCode")
        bookingObject.updateValue(selectedAddress.latitude, forKey: "latitude")
        bookingObject.updateValue(selectedAddress.longitude, forKey: "longitude")
        bookingObject.updateValue(selectedAddress.block, forKey: "blockNumber")
        
        worker = AddressListWorker()
        worker?.confirmBooking(parameters: bookingObject, apiResponse: { (response) in
            if response.code == 200 {
                let apiResponseDict = response.result as! NSDictionary
                let id = apiResponseDict["bookingId"] as! String
                self.bookingId = id
                self.presenter?.bookingConfirmed(response: response)
            }
            else if response.code == 404 {
                CommonFunctions.sharedInstance.showSessionExpireAlert()
            }
            else {
                CustomAlertController.sharedInstance.showErrorAlert(error: response.error!)
            }
        })
    }
}
