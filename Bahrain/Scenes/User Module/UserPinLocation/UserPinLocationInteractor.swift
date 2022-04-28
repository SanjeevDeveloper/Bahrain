
import UIKit

protocol UserPinLocationBusinessLogic
{
    func getEditObject()
}

protocol UserPinLocationDataStore
{
    var bookingObject: [String: Any]! { get set }
    var bookingId: String? { get set }
    var editObject: AddressList.ViewModel? { get set }
}

class UserPinLocationInteractor: UserPinLocationBusinessLogic, UserPinLocationDataStore
{
  var presenter: UserPinLocationPresentationLogic?
  var worker: UserPinLocationWorker?
    
    var bookingObject: [String: Any]!
    var bookingId: String?
    var editObject: AddressList.ViewModel?
    
    func getEditObject() {
        presenter?.presentLocation(editObject)
    }
  
  // MARK: Do something

}
