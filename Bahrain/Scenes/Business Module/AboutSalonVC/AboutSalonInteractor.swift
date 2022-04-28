
import UIKit

protocol AboutSalonBusinessLogic
{
  func showAboutScreenData()
}

protocol AboutSalonDataStore
{
  var resultDict:NSDictionary? { get set }
}

class AboutSalonInteractor: AboutSalonBusinessLogic, AboutSalonDataStore
{
    
  var presenter: AboutSalonPresentationLogic?
  var worker: AboutSalonWorker?
  var resultDict: NSDictionary?
  
  // MARK: Do something
  
   func showAboutScreenData() {
    presenter?.presentAboutScreenData(response: resultDict!)
    }
    
    
}
