
import UIKit

protocol AddClientBusinessLogic
{
    func createClient(client: client)
    func getClientData()
    func hitSaveClientChangesApi(ClientId: String, client: client)
    func hitDeleteBusinessClientApi(ClientId: String)
}

protocol AddClientDataStore
{
    var clientObj: client? { get set }
    var ClintDataObj: ClientList.ViewModel.tableCellData?  { get set }
    var editClient: String? { get set }
}

class AddClientInteractor: AddClientBusinessLogic, AddClientDataStore
{
    
    var presenter: AddClientPresentationLogic?
    var worker: AddClientWorker?
    var clientObj: client?
    var ClintDataObj: ClientList.ViewModel.tableCellData?
    var editClient: String?
    
    
    func getClientData() {
        self.presenter?.presentClientData(response: ClintDataObj, editClient: editClient)
    }
    
    func hitDeleteBusinessClientApi(ClientId: String) {
        worker = AddClientWorker()
        
        worker?.deleteBusinessClientApi(clientId: ClientId, apiResponse: { (response) in
            if response.code == 200 {
                 self.presenter?.deleteClientResponse(response:response)
            }
            else if response.code == 404 {
                CommonFunctions.sharedInstance.showSessionExpireAlert()
            }
            else {
                CustomAlertController.sharedInstance.showErrorAlert(error: response.error!)
            }
        })
    }
    
    
    func hitSaveClientChangesApi(ClientId: String, client: client) {
        if isRequestValid(request: client) {
            let parameters = [
                "businessId": getUserData(.businessId),
                "firstName": client.firstName,
                "lastName": client.lastName,
                "countryCode":client.countryCode,
                "phoneNumber": client.phoneNumber
            ]
            worker = AddClientWorker()
            worker?.hitEditBusinessClientInfoApi(clientId: ClientId, image: client.profileImage, imageName: "profileImage", parameters: parameters, apiResponse: { (response) in
                if response.code == 200 {
                    self.presenter?.clientCreationResponse(response:response, isedit: true)
                }
                else if response.code == 404 {
                    CommonFunctions.sharedInstance.showSessionExpireAlert()
                }
                else {
                    CustomAlertController.sharedInstance.showErrorAlert(error: response.error!)
                }
                
            })
            
        }
    }
    
    
    func createClient(client: client) {
        if isRequestValid(request: client) {
            let parameters = [
                "businessId": getUserData(.businessId),
                "firstName": client.firstName,
                "lastName": client.lastName,
                "countryCode":client.countryCode,
                "phoneNumber": client.phoneNumber
                ]
            worker = AddClientWorker()
            worker?.hitCreateClientApi(image: client.profileImage, imageName: "profileImage", parameters: parameters, apiResponse: { (response) in
                if response.code == 200 {
                   // self.updateDataStore(response: response)
                    self.presenter?.clientCreationResponse(response:response, isedit: false)
                }
                else if response.code == 404 {
                    CommonFunctions.sharedInstance.showSessionExpireAlert()
                }
                else {
                    CustomAlertController.sharedInstance.showErrorAlert(error: response.error!)
                }
               
            })
        }
    }
    
//    func updateDataStore(response:ApiResponse) {
//        let result = response.result as! NSDictionary
//        let firstName = result["firstName"] as? String ?? ""
//        let lastName = result["lastName"] as? String ?? ""
//        let phoneNumber = result["phoneNumber"] as? String ?? ""
//        let countryCode = result["countryCode"] as? String ?? ""
//        let profileImageUrlString = result["profileImage"] as? String ?? ""
//
//        let clientObj = client(firstName: firstName, lastName: lastName, phoneNumber: phoneNumber, countryCode: countryCode, profileImage: nil, profileImageUrlString: profileImageUrlString)
//        self.clientObj = clientObj
//    }
    
    func isRequestValid(request: client) -> Bool {
        var isValid = true
        let validator = Validator()
       if !validator.validateRequired(request.phoneNumber, errorKey: AddClientSceneText.addClientSceneEmptyPhoneNumberValidation.rawValue)  {
            isValid = false
        }
        else if !validator.validateMinCharactersCount(request.phoneNumber, minCount: 7,  minCountErrorKey: ValidationsText.phoneNumberMinLength.rawValue)  {
            isValid = false
        }
       else if !validator.validateRequired(request.countryCode, errorKey: AddClientSceneText.addClientSceneEmptyCountryCodeValidation.rawValue)  {
        isValid = false
       }
       else if !validator.validateRequired(request.firstName, errorKey: AddClientSceneText.addClientSceneEmptyNameValidation.rawValue)  {
            isValid = false
        }
        return isValid
    }
}
