
import UIKit

protocol AddressListPresentationLogic {
    func presentDeleteResponse(index: Int, response: ApiResponse)
    func presentAddressListResponse(response: ApiResponse)
    func presentUseDefaultAddressResponse(response: ApiResponse, defaultAddress: AddressList.ViewModel)
    func bookingConfirmed(response:ApiResponse)
}

class AddressListPresenter: AddressListPresentationLogic {
    weak var viewController: AddressListDisplayLogic?
    
    func bookingConfirmed(response:ApiResponse) {
        let apiResponseDict = response.result as! NSDictionary
        let bookingId = apiResponseDict["bookingId"] as! String
        viewController?.bookingConfirmed(bookingId: bookingId)
    }
    
    func presentDeleteResponse(index: Int, response: ApiResponse) {
        
        if response.code == 200 {
            viewController?.displayDeleteResponse(index: index)
        } else if response.code == 404 {
          CommonFunctions.sharedInstance.showSessionExpireAlert()
        } else {
            CustomAlertController.sharedInstance.showErrorAlert(error: "Unable to delete address")
        }
    }
    
    func presentAddressListResponse(response: ApiResponse) {
        var addressList = [AddressList.ViewModel]()
        if response.code == 200 {
            if let list = response.result as? [[String: Any]] {
                for listObj in list {
                    let addressObject = AddressList.ViewModel(
                        address: listObj["homeAddress"] as? String ?? "",
                        addressID: listObj["_id"] as? String ?? "",
                        title: listObj["title"] as? String ?? "",
                        phoneNumber: listObj["phoneNumber"] as? String ?? "",
                        countryCode: listObj["countryCode"] as? String ?? "",
                        latitude: listObj["latitude"] as? String ?? "",
                        longitude: listObj["longitude"] as? String ?? "",
                        isDefault: listObj["isDefault"] as! Bool,
                        road: listObj["otherAddress"] as? String ?? "",
                        flatNumber: listObj["flatNumber"] as? String ?? "",
                        houseNumber: listObj["houseNumber"] as? String ?? "",
                        block: listObj["blockNumber"] as? String ?? ""
                    )
                    addressList.append(addressObject)
                }
                viewController?.displayAddressList(viewModel: addressList)
            }
        } else if response.code == 404 {
          CommonFunctions.sharedInstance.showSessionExpireAlert()
        } else {
            CustomAlertController.sharedInstance.showErrorAlert(error: "Unable to fetch address")
        }
    }
    
    func presentUseDefaultAddressResponse(response: ApiResponse, defaultAddress: AddressList.ViewModel) {
        if response.code == 200 {
            viewController?.displayUsedAddressResponse(defaultAddress: defaultAddress)
        }
    }
}
