
import UIKit

protocol ClientListPresentationLogic
{
  func presentResponse(response: ApiResponse,isSearching : Bool)
  //func presentUpdatedClient(clientsArray: [client])
    func presentApiHitResponse()
    func presentScreenName(screenName: String?)
    
}

class ClientListPresenter: ClientListPresentationLogic
{
   
    
  weak var viewController: ClientListDisplayLogic?
  
  // MARK: Do something
    
    func presentScreenName(screenName: String?) {
        viewController?.displayScreenName(screenName: screenName)
    }
    
    
    func presentApiHitResponse() {
        viewController?.displayHitApiResponse()
    }
  
  func presentResponse(response: ApiResponse,isSearching : Bool)
  {
    var viewModelArray = [ClientList.ViewModel.tableCellData]()
    var ViewModelObj:ClientList.ViewModel
    let apiResponseArray = response.result as! NSArray
    
    for obj in apiResponseArray {
        
        let dataDict = obj as! NSDictionary
        
        let obj = ClientList.ViewModel.tableCellData(id: dataDict["_id"] as! String, ClientId: dataDict["userId"] as! String, firstName: dataDict["firstName"] as! String, lastName: dataDict["lastName"] as! String, phoneNumber: dataDict["phoneNumber"] as! String, countryCode: dataDict["countryCode"] as! String, profileImage: dataDict["profileImage"] as? String, isDelete: dataDict["isDelete"] as! Bool, isActive: dataDict["isActive"] as! Bool)
        viewModelArray.append(obj)
    }
    ViewModelObj = ClientList.ViewModel(clientListArray: viewModelArray)
    viewController?.displayResponse(viewModel: ViewModelObj,isSearching : isSearching)
  }
    
//    func presentUpdatedClient(clientsArray: [client]) {
//        viewController?.displayUpdatedClient(clientsArray: clientsArray)
//    }
}
