
import UIKit

protocol AddScheduledBreakPresentationLogic
{
  func presentSomething(response: AddScheduledBreak.Response)
}

class AddScheduledBreakPresenter: AddScheduledBreakPresentationLogic
{
  weak var viewController: AddScheduledBreakDisplayLogic?
  
  // MARK: Do something
  
  func presentSomething(response: AddScheduledBreak.Response)
  {

  }
}
