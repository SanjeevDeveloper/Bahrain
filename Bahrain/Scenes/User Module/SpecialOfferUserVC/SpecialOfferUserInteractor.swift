
import UIKit

protocol SpecialOfferUserBusinessLogic
{
    func hitListAllOffers(offset:Int)
    func hitListAllOffersFilterApi(offset:Int)
    func bookNow(index:Int)
}

protocol SpecialOfferUserDataStore
{
    var servicesArray: NSArray! { get set }
    var filterDict:NSDictionary? { get set }
    var filterData:String? { get set }
    var filterCategoryArr: [Filter.ViewModel.tableCellData]? { get set }
    var paymentArr: [Filter.PaymentViewModel.tableCellData]? { get set }
    var isclear : Bool? { get set }
}

class SpecialOfferUserInteractor: SpecialOfferUserBusinessLogic, SpecialOfferUserDataStore
{
    
    var presenter: SpecialOfferUserPresentationLogic?
    var worker: SpecialOfferUserWorker?
    var servicesArray: NSArray!
    var filterDict: NSDictionary?
    var filterData: String?
    var filterCategoryArr: [Filter.ViewModel.tableCellData]?
    var paymentArr: [Filter.PaymentViewModel.tableCellData]?
    var isclear : Bool?
    
    // MARK: Do something
    
    func bookNow(index:Int) {
        if let obj =  servicesArray[index] as? NSDictionary {
            self.presenter?.presentBookNowResponse(responseObj: obj)
        }
    }
    
    func hitListAllOffers(offset:Int) {
        worker = SpecialOfferUserWorker()
        worker?.getListAllOffers(offset:offset, apiResponse: { (response) in
            if response.code == 200 {
                let data = response.result as! NSDictionary
                self.servicesArray = data["businessData"] as! NSArray
                self.presenter?.presentResponse(isFilter: false, isClearFilter: false, response: response)
            } else  if response.code == 404 {
                CommonFunctions.sharedInstance.showSessionExpireAlert()
            }
        })
    }
    
    func hitListAllOffersFilterApi(offset: Int) {
        worker = SpecialOfferUserWorker()
        
        if filterData != nil {
            if filterData == "filter"{
                let categoryIdArray = NSMutableArray()
                
                for data in filterCategoryArr!{
                    if data.isSelected != false {
                        let obj1  = data.id
                        categoryIdArray.add(obj1)
                    }
                }
                let param = [
                    "area":filterDict?["area"] as? String ?? "",
                    "categoryIds":categoryIdArray,
                    "maxPrice":filterDict?["maxPrice"] as? String ?? "",
                    "minPrice":filterDict?["minPrice"] as? String ?? ""
                    ] as [String : Any]
                
                printToConsole(item: param)
                
                worker?.listAllOffersFilterApi(offset: offset, parameters: param, apiResponse: { (response) in
                    
                    if response.code == 200 {
                        self.presenter?.presentResponse(isFilter: true, isClearFilter: false, response: response)
                    }
                    else  if response.code == 404 {
                        CommonFunctions.sharedInstance.showSessionExpireAlert()
                        
                    }
                    else {
                        CustomAlertController.sharedInstance.showErrorAlert(error: response.error!)
                    }
                })
                
            }
            else if filterData == "clearFilter" {
                worker?.getListAllOffers(offset:0, apiResponse: { (response) in
                    if response.code == 200 {
                        self.presenter?.presentResponse(isFilter: false, isClearFilter: true, response: response)
                    }
                    else if response.code == 404 {
                         CommonFunctions.sharedInstance.showSessionExpireAlert()
                    }
                    
                })
            }
        }
    }
    
}
