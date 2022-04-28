
import UIKit

protocol OrderDetailBusinessLogic
{
    func showData()
    func hitCancelAppoinmentApi(id: String)
    func getBookingData()
    
}

protocol OrderDetailDataStore
{
    var orderDetailArray: MyAppointments.ViewModel.tableCellData? { get set }
    var tableScreen: Bool? { get set }
    var isFromWalletDetails: Bool? { get set }
    var bookingId: String? { get set }
}

class OrderDetailInteractor: OrderDetailBusinessLogic, OrderDetailDataStore
{
    var bookingId: String?
    var isFromWalletDetails: Bool?
    var presenter: OrderDetailPresentationLogic?
    var worker: OrderDetailWorker?
    var orderDetailArray: MyAppointments.ViewModel.tableCellData?
    var tableScreen: Bool?
    
    // MARK: Do something
    
    
    func getBookingData() {
        presenter?.presentBookingData(response: orderDetailArray!)
    }
    
    
    func hitCancelAppoinmentApi(id: String) {
        worker = OrderDetailWorker()
        worker?.cancelAppoinmentApi(id: id, apiResponse: { (response) in
            if response.code == 200{
                self.presenter?.presentCancelResponse(response: response)
            } else if response.code == 404 {
                CommonFunctions.sharedInstance.showSessionExpireAlert()
            } else {
                CustomAlertController.sharedInstance.showErrorAlert(error: response.error!)
            }
        })
    }
    
    func hitOrderDetailAPI() {
        worker = OrderDetailWorker()
        worker?.orderDetailApi(bookingId: bookingId ?? "", apiResponse: { (response) in
            if response.code == 200{
                self.presenter?.presentOrderDetailResponse(response: response)
            } else if response.code == 404 {
                CommonFunctions.sharedInstance.showSessionExpireAlert()
            } else {
                CustomAlertController.sharedInstance.showErrorAlert(error: response.error ?? "Unable to find detail")
            }
        })
    }
    
    
    func showData() {
        hitOrderDetailAPI()
    }
}
