
import UIKit

protocol PinLocationPresentationLogic
{
    func locationUpdated()
}

class PinLocationPresenter: PinLocationPresentationLogic
{
  weak var viewController: PinLocationDisplayLogic?
    
    func locationUpdated() {
        viewController?.locationUpdated()
    }
  
}
