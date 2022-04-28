
import UIKit

protocol RegisterNamePresentationLogic
{
  func dataStoreUpdatedWithName()
}

class RegisterNamePresenter: RegisterNamePresentationLogic
{
  weak var viewController: RegisterNameDisplayLogic?
  
  // MARK: Do something
  
  func dataStoreUpdatedWithName()
  {
    viewController?.dataStoreUpdated()
  }
}
