
import UIKit

protocol FavoriteListBusinessLogic
{
    func hitListBusinessByCategoryIdApi(offset:Int, filterText:String)
    func hitListBusinessByServiceNameApi(offset:Int, filterText:String)
    func hitListFavouriteApi(offset:Int, filterText:String)
    func updateUI()
    func hitAdvanceFilterBusinessApi(offset:Int, filterText:String)
    func clearFilterData()
  func getSelectedArea()
}

protocol FavoriteListDataStore
{
    var name: String? { get set }
    var categoryId: String? { get set }
    var reqName: String? { get set }
    var filterDict:NSDictionary  { get set }
    var filterCategoryArr: [Filter.ViewModel.tableCellData]? { get set }
    var fromScreen: String? { get set }
    var paymentArr: [Filter.PaymentViewModel.tableCellData]? { get set }
    var isFavoriteString: String? { get set }
    var isclear : Bool? { get set }
    var serviceId: String? { get set }
    var selectedArea: String? { get set }
    
}

class FavoriteListInteractor: FavoriteListBusinessLogic, FavoriteListDataStore
{
   
    var isclear: Bool?
    var isFavoriteString: String?
    var presenter: FavoriteListPresentationLogic?
    var worker: FavoriteListWorker?
    var name: String?
    var categoryId: String?
    var reqName: String?
    var filterDict: NSDictionary = [:]
    var fromScreen: String?// to check filter or clear filtered
    var filterCategoryArr: [Filter.ViewModel.tableCellData]?
    var paymentArr: [Filter.PaymentViewModel.tableCellData]?
    var serviceId: String?
    var selectedArea: String?
    
    
    
    func clearFilterData() {
        filterDict = [:]
        filterCategoryArr = nil
        paymentArr = nil
        fromScreen = nil
    }
  
  func getSelectedArea() {
    let area = selectedArea ?? ""
    if area == "currentLocation"{
      presenter?.presentSelectedArea("Your current location selected")
    } else {
      presenter?.presentSelectedArea(area)
    }
  }
    
    
    func hitListBusinessByCategoryIdApi(offset:Int, filterText:String)
    {
        worker = FavoriteListWorker()
        let param = [
            "count":400,
            "page":0,
            "latitude":0,
            "longitude":0,
            "keyword":filterText
            ] as [String : Any]
        
        worker?.getListBusinessByCategoryId(parameters: param, categoryId: categoryId!, apiResponse: { (response) in
            if response.code == 200 {
                self.presenter?.presentResponse(isFilter: false, response: response, isClear: false)
            }
            else if response.code == 404{
                CommonFunctions.sharedInstance.showSessionExpireAlert()
                
            }
            else {
                CustomAlertController.sharedInstance.showErrorAlert(error: response.error!)
            }
            
        })
    }
    
    // serviceId is used instead of service Name(api changed)
    func hitListBusinessByServiceNameApi(offset:Int, filterText:String) {
        worker = FavoriteListWorker()
        
        let param = [
            "count":400,
            "page":0,
            "latitude":0,
            "longitude":0,
            "keyword":filterText,
            "gender": "\(CommonFunctions.sharedInstance.genderValue())"
            ] as [String : Any]
        
        worker?.getListBusinessByServiceName(parameters: param, serviceName: serviceId!, apiResponse: { (response) in
            if response.code == 200 {
                self.presenter?.presentResponse(isFilter: false, response: response, isClear: false)
            }
            else if response.code == 404 {
                CommonFunctions.sharedInstance.showSessionExpireAlert()
                
            }
            else {
                CustomAlertController.sharedInstance.showErrorAlert(error: response.error!)
            }
            
        })
    }
    
    func hitListFavouriteApi(offset:Int, filterText:String) {
        worker = FavoriteListWorker()
        let param = [
            "count":400,
            "page":0,
            "latitude":0,
            "longitude":0,
            "keyword":filterText
            ] as [String : Any]
        
        worker?.getListFavorite(parameters: param, apiResponse: { (response) in
            if response.code == 200 {
                self.presenter?.presentResponse(isFilter: false, response: response, isClear: false)
            }
            else if response.code == 404 {
                CommonFunctions.sharedInstance.showSessionExpireAlert()

            }
            else {
                CustomAlertController.sharedInstance.showErrorAlert(error: response.error!)
            }
            
        })
        
    }
    
    func updateUI()
    {
        var filter = false
        if fromScreen != nil {
            filter = true
        }
        presenter?.updateUI(name: self.name, categoryId: self.categoryId, isFilterApplied:filter)
    }
    
    func hitAdvanceFilterBusinessApi(offset:Int, filterText:String) {
        worker = FavoriteListWorker()
    
        if fromScreen != nil {
            if fromScreen == "filter"{
                
                let categoryIdArray = NSMutableArray()
                
                for data in filterCategoryArr!{
                    
                    if data.isSelected != false {
                        let obj1  = data.id
                        categoryIdArray.add(obj1)
                        
                    }
                }
                var param = [
                    "area":filterDict["area"] as? String ?? "",
                    "categoryIds":categoryIdArray,
                    "maxPrice":filterDict["maxPrice"] as? String ?? "",
                    "minPrice":filterDict["minPrice"] as? String ?? "",
                    // "paymentMethod": "CASH",
                    ] as [String : Any]
                
                if isFavoriteString == "subCategoryFilter" {
                    param["subCategoryId"] = categoryId!
                }
                
                printToConsole(item: param)
                
                if isFavoriteString == "favFilter"{
                    worker?.hitFilterFavoriteBusinessApi(offset: offset, parameters: param, apiResponse: { (response) in
                        if response.code == 200 {
                            self.presenter?.presentFilterResponse(isFilter: true, response: response)
                        }else if response.code == 404  {
                            CommonFunctions.sharedInstance.showSessionExpireAlert()
                        }
                        else {
                            CustomAlertController.sharedInstance.showErrorAlert(error: response.error!)
                        }
                        
                    })
                }
                else if isFavoriteString == "categoryFilter"{
                    worker?.hitAdvanceFilterBusinessApi(offset:offset, filterText:filterText, parameters: param , apiResponse: { (response) in
                        if response.code == 200 {
                            self.presenter?.presentFilterResponse(isFilter: true, response: response)
                        }else if response.code == 404{
                            CommonFunctions.sharedInstance.showSessionExpireAlert()
                        }
                        else {
                            CustomAlertController.sharedInstance.showErrorAlert(error: response.error!)
                        }
                        
                        
                    })
                }
                else {
                    worker?.hitBusinessByCategoryIdFilterApi(offset: offset, categoryId: categoryId!, parameters: param, apiResponse: { (response) in
                        if response.code == 200 {
                            self.presenter?.presentFilterResponse(isFilter: true, response: response)
                        }else if response.code == 404{
                            CommonFunctions.sharedInstance.showSessionExpireAlert()
                            
                        }
                        else {
                            CustomAlertController.sharedInstance.showErrorAlert(error: response.error!)
                        }
                        
                    })
                }
                
            }
            else{
                
                var lat = 0.0
                var lon = 0.0
                LocationWrapper.sharedInstance.fetchLocation()
                if selectedArea == "currentLocation"{
                    lat = LocationWrapper.sharedInstance.latitude
                    lon = LocationWrapper.sharedInstance.longitude
                }
                var param = [
                    "count":400,
                    "page":0,
                    "latitude":lat,
                    "longitude":lon,
                    "keyword":filterText,
                    "gender": "\(CommonFunctions.sharedInstance.genderValue())"
                    ] as [String : Any]
                
                if selectedArea != nil && selectedArea != "currentLocation" {
                    param["area"] = selectedArea
                }
        
            
                if isFavoriteString == "favFilter"{
                    worker = FavoriteListWorker()
                    worker?.getListFavorite(parameters: param, apiResponse: { (response) in
                        if response.code == 200 {
                            self.presenter?.presentResponse(isFilter: false, response: response,isClear: self.isclear!)
                        }
                        else if response.code == 404 {
                            CommonFunctions.sharedInstance.showSessionExpireAlert()
                            
                        }
                        else {
                            CustomAlertController.sharedInstance.showErrorAlert(error: response.error!)
                        }
                        
                    })
                }
                else if isFavoriteString == "categoryFilter"{
                    worker = FavoriteListWorker()
                    
                    worker?.getListBusinessByServiceName(parameters: param, serviceName: serviceId!, apiResponse: { (response) in
                        if response.code == 200 {
                            self.presenter?.presentResponse(isFilter: false, response: response, isClear: self.isclear!)
                        }
                        else  if response.code == 404{
                            CommonFunctions.sharedInstance.showSessionExpireAlert()
                            
                        }
                        else {
                            CustomAlertController.sharedInstance.showErrorAlert(error: response.error!)
                        }
                        
                    })
                }
                else {
                    worker?.getListBusinessByCategoryId(parameters: param, categoryId: categoryId!, apiResponse: { (response) in
                        if response.code == 200 {
                            self.presenter?.presentResponse(isFilter: false, response: response, isClear: self.isclear!)
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
            
        }
    }
}
