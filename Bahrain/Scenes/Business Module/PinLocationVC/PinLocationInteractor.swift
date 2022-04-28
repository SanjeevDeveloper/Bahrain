
import UIKit

protocol PinLocationBusinessLogic
{
    func updateLocation(request:PinLocation.Request)
}

protocol PinLocationDataStore
{
}

class PinLocationInteractor: PinLocationBusinessLogic, PinLocationDataStore
{
  var presenter: PinLocationPresentationLogic?
  var worker: PinLocationWorker?
    
    func updateLocation(request:PinLocation.Request) {
        let param = [
            "latitude": request.latitude,
            "longitude": request.longitude,
            "step": "3",
            "userId": getUserData(._id)
        ]
        worker = PinLocationWorker()
        worker?.updateBusinessLocation(parameters: param, apiResponse: { (response) in
            if response.code == 200 {
                self.presenter?.locationUpdated()
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
