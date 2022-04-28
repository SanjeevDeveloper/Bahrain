
import UIKit

protocol SendFeedBackBusinessLogic
{
    func hitSendFeedBackApi(request: SendFeedBack.Request)
}

protocol SendFeedBackDataStore
{
    //var name: String { get set }
}

class SendFeedBackInteractor: SendFeedBackBusinessLogic, SendFeedBackDataStore
{
    var presenter: SendFeedBackPresentationLogic?
    var worker: SendFeedBackWorker?
    
    // MARK: Do something
    
    func hitSendFeedBackApi(request: SendFeedBack.Request)
    {
        
        if isRequestValid(request: request) {
            
            worker = SendFeedBackWorker()
            
            let param = [
                "userId":getUserData(._id),
                "feedback":request.feedBackText,
                ]
            worker?.hitSendFeedBackApi(parameters: param, apiResponse: { (response) in
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
        
    }
    
    func isRequestValid(request: SendFeedBack.Request) -> Bool {
        var isValid = true
        let validator = Validator()
        if !validator.validateRequired(request.feedBackText, errorKey: SendFeedBackSceneText.SendFeedBackSceneEmptyTextMsg.rawValue)  {
            isValid = false
        }
        return isValid
    }
}
