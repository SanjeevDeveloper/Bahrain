

import UIKit

protocol UserPinLocationPresentationLogic
{
    func presentLocation(_ location: AddressList.ViewModel?)
}

class UserPinLocationPresenter: UserPinLocationPresentationLogic
{
  weak var viewController: UserPinLocationDisplayLogic?
  
    func presentLocation(_ location: AddressList.ViewModel?) {
        viewController?.displayLocation(location)
    }
}
