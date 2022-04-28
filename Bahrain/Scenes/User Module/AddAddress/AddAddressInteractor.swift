

import UIKit

protocol AddAddressBusinessLogic {
  func getOldData()
    func getLocationCoordinate()
    func confirmBooking(_ selectedAddress: AddressList.ViewModel, isEdit: Bool)
  func addressAddOrUpdateAPI(request: AddAddress.Request)
}

protocol AddAddressDataStore {
  var editObject: AddressList.ViewModel? { get set }
    
    var bookingObject: [String: Any]! { get set }
    var bookingId: String? { get set }
    var location: LocationData? { get set }
}

class AddAddressInteractor: AddAddressBusinessLogic, AddAddressDataStore {
  var editObject: AddressList.ViewModel?
  var presenter: AddAddressPresentationLogic?
  var worker: AddAddressWorker?
    var bookingObject: [String: Any]!
    var bookingId: String?
    var location: LocationData?
  
  func getOldData() {
    if editObject != nil {
      self.presenter?.presentOldData(editObj: editObject!)
    }
  }
    
    func getLocationCoordinate() {
        if location != nil {
            presenter?.presentLocationCordinate(location: location!)
        }
    }
  
    func confirmBooking(_ selectedAddress: AddressList.ViewModel, isEdit: Bool) {
        if !isEdit {
            editObject = selectedAddress
        }
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
        
        worker = AddAddressWorker()
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
  
  func addressAddOrUpdateAPI(request: AddAddress.Request) {
    worker = AddAddressWorker()
    
    let param = ["userId": getUserData(._id),
                 "homeAddress": request.address,
                 "otherAddress": request.road,
                 "title": request.title,
                 "phoneNumber": request.phoneNumber,
                 "countryCode": request.countryCode,
                 "latitude": request.latitude,
                 "longitude": request.longitude,
                 "houseNumber": request.houseNumber,
                 "flatNumber": request.flatNumber,
                 "isDefault": request.isDefault,
                 "blockNumber": request.block] as [String: Any]
    
    if editObject != nil {
      worker?.updateAddressApi(id: (editObject?.addressID)!, parameters: param, apiResponse: { (response) in
        self.presenter?.presentAddOrUpdateAddressResponse(response: response, message: localizedTextFor(key: AddAddressSceneText.addressUpdatedMessage.rawValue), isEdit: true)
      })
    } else {
      worker?.addAddressApi(parameters: param, apiResponse: { (response) in
         self.presenter?.presentAddOrUpdateAddressResponse(response: response, message: localizedTextFor(key: AddAddressSceneText.addressAddedMesage.rawValue), isEdit: false)
      })
    }
  }
}
