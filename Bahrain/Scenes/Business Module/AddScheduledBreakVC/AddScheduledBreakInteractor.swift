
import UIKit

protocol AddScheduledBreakBusinessLogic
{
  func doSomething(request: AddScheduledBreak.Request)
}

protocol AddScheduledBreakDataStore
{
  //var name: String { get set }
}

class AddScheduledBreakInteractor: AddScheduledBreakBusinessLogic, AddScheduledBreakDataStore
{
  var presenter: AddScheduledBreakPresentationLogic?
  var worker: AddScheduledBreakWorker?
  //var name: String = ""
  
  // MARK: Do something
  
  func doSomething(request: AddScheduledBreak.Request)
  {
    worker = AddScheduledBreakWorker()
    worker?.doSomeWork()
    
    let response = AddScheduledBreak.Response()
    presenter?.presentSomething(response: response)
  }
}
