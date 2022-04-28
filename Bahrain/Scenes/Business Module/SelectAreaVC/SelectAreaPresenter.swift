
import UIKit

protocol SelectAreaPresentationLogic
{
  func presentSomething(response: SelectArea.Response)
}

class SelectAreaPresenter: SelectAreaPresentationLogic
{
  weak var viewController: SelectAreaDisplayLogic?
  
  // MARK: Do something
  
  func presentSomething(response: SelectArea.Response)
  {
    let viewModel = SelectArea.ViewModel()
    viewController?.displaySomething(viewModel: viewModel)
  }
}
