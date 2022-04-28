

import UIKit

protocol BusinessBookingBusinessLogic
{
    func hitGetListServicesByBusinessIdApi()
    func listTherapistTimeSlots(request: BusinessBooking.Booking.Request)
    func getClientData()
    func confirmBooking(request: [Booking.selectedTherapistModel], ClientId:String, paymentPlace: String, paymentType: String, totalAmount:NSNumber)
}

protocol BusinessBookingDataStore
{
    var ClintDataObj: ClientList.ViewModel.tableCellData?  { get set }
}

class BusinessBookingInteractor: BusinessBookingBusinessLogic, BusinessBookingDataStore
{
    
    var ClintDataObj: ClientList.ViewModel.tableCellData?
    func getClientData() {
        self.presenter?.presentClientData(response: ClintDataObj)
    }
    
    func confirmBooking(request: [Booking.selectedTherapistModel], ClientId:String, paymentPlace: String, paymentType: String, totalAmount:NSNumber) {
        
        worker = BusinessBookingWorker()
        
        if isRequestValid(request: request, ClientId: ClientId){
            var rawBookingDataObj = [NSDictionary]()
            for obj in request {
                let dict:NSDictionary = [
                    "businessServiceId": obj.businessServiceId,
                    "isServiceCancel": obj.isServiceCancel,
                    "therapistId": obj.therapistId,
                    "therapistSlots": obj.therapistSlots
                ]
                rawBookingDataObj.append(dict)
            }
            
            let param = [
                "bookingData": rawBookingDataObj,
                "businessId": getUserData(.businessId),
                "clientId": ClientId,
                "createdBy": "business",
                "paymentPlace": paymentPlace,
                "paymentType": paymentType,
                "specialInstructions": "",
                "totalAmount": totalAmount
                ] as [String : Any]
            
            printToConsole(item: param)
            
            worker?.confirmBooking(parameters: param, apiResponse: { (response) in
                if response.code == 200 {
                    self.presenter?.bookingConfirmed()
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
    
    func listTherapistTimeSlots(request: BusinessBooking.Booking.Request) {
        worker = BusinessBookingWorker()
        
        let param = [
            "bookingTimestamp": request.timeStamp,
            "businessId": getUserData(.businessId),
            "businessServicesId": request.serviceId,
            "totalPrice": request.totalPrice
            ] as [String : Any]
        
        worker?.hitTherapistTimeSlotApi(parameters: param, apiResponse: { (response) in
            if response.code == 200{
                self.presenter?.presentResponse(response: response)
            }
            else if response.code == 404 {
                CommonFunctions.sharedInstance.showSessionExpireAlert()
            }
            else {
                CustomAlertController.sharedInstance.showErrorAlert(error: response.error!)
            }
        })
    }
    
    var presenter: BusinessBookingPresentationLogic?
    var worker: BusinessBookingWorker?
    //var name: String = ""
    
    // MARK: Do something
    
    func hitGetListServicesByBusinessIdApi()
    {
        worker = BusinessBookingWorker()
        worker?.getListServicesByBusinessId(apiResponse: { (response) in
            
            if response.code == 200 {
                self.presenter?.presentServiceResponse(response: response)
            }
            else if response.code == 404 {
                CommonFunctions.sharedInstance.showSessionExpireAlert()
            }
            else {
                CustomAlertController.sharedInstance.showErrorAlert(error: response.error!)
            }
        })
    }
    
    
    func isRequestValid(request: [Booking.selectedTherapistModel], ClientId:String) -> Bool {
        var isValid = true
        let validator = Validator()
        if request.count == 0  {
            CustomAlertController.sharedInstance.showErrorAlert(error: localizedTextFor(key: BusinessBookingSceneText.BusinessBookingSceneTimingSlotErrorAlert.rawValue))
            isValid = false
        }
        else if !validator.validateRequired(ClientId, errorKey: BusinessBookingSceneText.BusinessBookingSceneSelectClientErrorAlert.rawValue)  {
            isValid = false
        }
        
        return isValid
    }
    
    
    
}
