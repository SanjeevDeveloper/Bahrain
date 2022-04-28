
import UIKit

protocol ClientListBusinessLogic
{
    //func fetchUpdatedClient()
    //func hitClientListApi()
    func getListBusinessClient(offset:Int, filterText:String)
    func hitApiAgain()
    func getScreenName()
}

protocol ClientListDataStore
{
    var clientsArray: [client] { get set }
    var fromAddScreen: String? { get set }
    var fromBusinessBookingScreen: String? { get set }
}

class ClientListInteractor: ClientListBusinessLogic, ClientListDataStore
{
    
  var presenter: ClientListPresentationLogic?
  var worker: ClientListWorker?
  var clientsArray = [client]()
  var fromAddScreen: String?
  var fromBusinessBookingScreen: String?
  
  // MARK: Do something
    
//    func fetchUpdatedClient() {
//        presenter?.presentUpdatedClient(clientsArray: self.clientsArray)
//    }
    
//    func hitClientListApi() {
//        
//    }
    
    func getScreenName() {
        self.presenter?.presentScreenName(screenName: fromBusinessBookingScreen)
    }
  
  func getListBusinessClient(offset:Int, filterText:String)
  {
    worker = ClientListWorker()
    worker?.getListBusinessClient(offset: offset, filterText: filterText, apiResponse: { (response) in
        if response.code == 200 {
            printToConsole(item: filterText)
            if filterText != "" {
                self.presenter?.presentResponse(response: response, isSearching: true)
            }else {
                self.presenter?.presentResponse(response: response, isSearching: false)
            }
        }
        else if response.code == 404 {
            CommonFunctions.sharedInstance.showSessionExpireAlert()
        }
        else {
            CustomAlertController.sharedInstance.showErrorAlert(error: response.error!)
        }
        
    })
    
  }
    
    func hitApiAgain() {
        if fromAddScreen == "addClient"{
            self.presenter?.presentApiHitResponse()
        }
    }
}
