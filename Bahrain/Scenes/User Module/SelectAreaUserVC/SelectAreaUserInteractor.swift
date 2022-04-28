
import UIKit

protocol SelectAreaUserBusinessLogic
{
    func hitAreasListApi()
    func showScreenName()
}

protocol SelectAreaUserDataStore
{
    var screenName: String { get set }
    var categoryType: String? { get set }
  var selectedArea: String? { get set }
}

class SelectAreaUserInteractor: SelectAreaUserBusinessLogic, SelectAreaUserDataStore
{
   
    var presenter: SelectAreaUserPresentationLogic?
    var worker: SelectAreaUserWorker?
    var screenName: String = ""
    var categoryType: String?
  var selectedArea: String?
    
    // MARK: Do something
    
    func hitAreasListApi()
    {
        worker = SelectAreaUserWorker()
        
        worker?.getAreasList(apiResponse: { (response) in
            if response.code == 200 {
                self.presenter?.presentResponse(response: response)
            }
            else if response.code == 404{
                CommonFunctions.sharedInstance.showSessionExpireAlert()
            }
            else {
                CustomAlertController.sharedInstance.showErrorAlert(error: response.error!)
            }
            
        })
    }
    
    func showScreenName() {
      presenter?.presentScreenName(screenNameText: screenName, area: selectedArea ?? "")
    }
}
