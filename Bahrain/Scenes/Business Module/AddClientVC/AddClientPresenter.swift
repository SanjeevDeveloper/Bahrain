
import UIKit

protocol AddClientPresentationLogic
{
    func clientCreationResponse(response:ApiResponse, isedit: Bool)
     func presentClientData(response: ClientList.ViewModel.tableCellData?, editClient: String?)
    func deleteClientResponse(response:ApiResponse)
    
}

class AddClientPresenter: AddClientPresentationLogic {
    
    
    
  weak var viewController: AddClientDisplayLogic?
  
    
    func presentClientData(response: ClientList.ViewModel.tableCellData?, editClient: String?) {
        viewController?.displayClientData(response: response, editClient: editClient)
    }
    
    
    func clientCreationResponse(response:ApiResponse, isedit: Bool) {
        
        viewController?.displayClientCreationResponse(isedit: isedit)
        
    }
    
    func deleteClientResponse(response: ApiResponse) {
        
        let apiResponseDict = response.result as! NSDictionary
        let msg = apiResponseDict["msg"] as! String
        viewController?.displayDeleteResponse(msg: msg)
    }
}
