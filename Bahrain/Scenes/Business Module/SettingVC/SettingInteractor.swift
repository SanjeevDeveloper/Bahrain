
import UIKit

protocol SettingBusinessLogic
{
  func doSomething(request: Setting.Request)
}

protocol SettingDataStore
{
  //var name: String { get set }
}

class SettingInteractor: SettingBusinessLogic, SettingDataStore
{
  var presenter: SettingPresentationLogic?
  var worker: SettingWorker?
  //var name: String = ""
  
  // MARK: Do something
  
  func doSomething(request: Setting.Request)
  {
    worker = SettingWorker()
    worker?.doSomeWork()
    
    let response = Setting.Response()
    presenter?.presentSomething(response: response)
  }
}
