
import UIKit

protocol SettingPresentationLogic
{
  func presentSomething(response: Setting.Response)
}

class SettingPresenter: SettingPresentationLogic
{
  weak var viewController: SettingDisplayLogic?
  
  // MARK: Do something
  
  func presentSomething(response: Setting.Response)
  {
    let viewModel = Setting.ViewModel()
    viewController?.displaySomething(viewModel: viewModel)
  }
}
