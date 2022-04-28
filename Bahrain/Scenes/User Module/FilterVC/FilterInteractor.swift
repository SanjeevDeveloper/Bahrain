
import UIKit

protocol FilterBusinessLogic
{
    
    func showSelectedArea()
    func getServicesList()
    func getOldData()
    func clearAreatext()
    
}

protocol FilterDataStore
{
    var selectedArea: String? { get set }
    var filterDict:NSDictionary  { get set }
    var minimumValue : NSNumber { get set }
    var maximumValue : NSNumber { get set }
    var filterCategoryArr: [Filter.ViewModel.tableCellData]? { get set }
    var paymentArr: [Filter.PaymentViewModel.tableCellData]? { get set }
    var fromFav: String? { get set }
    var isFavorite: String? { get set }
    var serviceName: String? { get set }
    
}

class FilterInteractor: FilterBusinessLogic, FilterDataStore
{
    
    var isFavorite: String?
    var presenter: FilterPresentationLogic?
    var worker: FilterWorker?
    var minimumValue: NSNumber = 0
    var maximumValue: NSNumber = 0
    var selectedArea: String?
    var filterDict: NSDictionary = [:]
    var filterCategoryArr: [Filter.ViewModel.tableCellData]?
    var paymentArr: [Filter.PaymentViewModel.tableCellData]?
    var fromFav: String?
    var serviceName: String?
    
    // MARK: Do something
    
    func clearAreatext() {
        selectedArea = nil
    }
    
    func getServicesList() {
        worker = FilterWorker()
        
        worker?.getServicesList(apiResponse: { (response) in
            if response.code == 200 {
                self.presenter?.presentGetServiceResponse(response: response, serviceName: self.serviceName)
            }
            else if response.code == 404 {
                CommonFunctions.sharedInstance.showSessionExpireAlert()
            }
            else {
                CustomAlertController.sharedInstance.showErrorAlert(error: response.error!)
            }
            
        })
    }
    
    
    func showSelectedArea() {
        presenter?.presentSelectedArea(ResponseText: selectedArea)
    }
    
    func getOldData() {
        printToConsole(item: minimumValue)
        printToConsole(item: maximumValue)
        presenter?.presentOldData(response: filterDict, categoryArr: filterCategoryArr, paymentArr: paymentArr, fromScreen: fromFav,minimumValue:minimumValue,MaximunValue:maximumValue)
    }
}
