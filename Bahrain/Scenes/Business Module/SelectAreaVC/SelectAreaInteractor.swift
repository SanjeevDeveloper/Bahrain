
import UIKit

protocol SelectAreaBusinessLogic
{
  func doSomething(request: SelectArea.Request)
}

protocol SelectAreaDataStore
{
  //var name: String { get set }
}

class SelectAreaInteractor: SelectAreaBusinessLogic, SelectAreaDataStore
{
  var presenter: SelectAreaPresentationLogic?
  var worker: SelectAreaWorker?
  //var name: String = ""
  
  // MARK: Do something
  
  func doSomething(request: SelectArea.Request)
  {
    worker = SelectAreaWorker()
    worker?.doSomeWork()
    
    let response = SelectArea.Response()
    presenter?.presentSomething(response: response)
  }
}
