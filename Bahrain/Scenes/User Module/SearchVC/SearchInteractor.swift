
import UIKit

protocol SearchBusinessLogic
{
    func hitListBusinessApi(offset:Int, filterText:String, parameters: [String : Any])
    func hitSearchSalonFilterApi(offset:Int, filterText:String)
    func clearFilterData()
    func getSelectedArea()
}

protocol SearchDataStore
{
    var filterDict:NSDictionary? { get set }
    var filterData:String? { get set }
    var filterCategoryArr: [Filter.ViewModel.tableCellData]? { get set }
    var paymentArr: [Filter.PaymentViewModel.tableCellData]? { get set }
    var isclear : Bool? { get set }
    var selectedArea: String? { get set }
}

class SearchInteractor: SearchBusinessLogic, SearchDataStore
{
    var presenter: SearchPresentationLogic?
    var worker: SearchWorker?
    var filterDict: NSDictionary?
    var filterData: String?
    var filterCategoryArr: [Filter.ViewModel.tableCellData]?
    var paymentArr: [Filter.PaymentViewModel.tableCellData]?
    var isclear : Bool?
    var selectedArea: String?
    var latitude: Double = 0.0
    var longitude: Double = 0.0
    
    // MARK: Do something
    
    
    func clearFilterData() {
        filterDict = nil
        filterData = ""
        filterCategoryArr = nil
        paymentArr = nil
    }
    
    
    func getSelectedArea() {
        let area = selectedArea ?? ""
        if area == "currentLocation"{
            presenter?.presentSelectedArea("Your current location selected")
        } else {
            presenter?.presentSelectedArea(area)
        }
    }
    
    func hitListBusinessApi(offset:Int, filterText:String, parameters: [String : Any])
    {
        worker = SearchWorker()
        worker?.getListBusiness(offset:offset, filterText: filterText, parameters: parameters, apiResponse: { (response) in
            if response.code == 200 {
                self.presenter?.presentResponse(isFilter: false, response: response)
            }
            else if response.code == 404 {
                CommonFunctions.sharedInstance.showSessionExpireAlert()
            }
            else {
                CustomAlertController.sharedInstance.showErrorAlert(error: response.error!)
            }
            
        })
    }
    
    func hitSearchSalonFilterApi(offset: Int, filterText:String) {
        
        worker = SearchWorker()
        
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
                
                worker?.searchSalonFilterApi(offset: offset, filterText: filterText, parameters: param, apiResponse: { (response) in
                    
                    if response.code == 200 {
                        self.presenter?.presentResponse(isFilter: true, response: response)
                    }
                    else if response.code == 404 {
                        CommonFunctions.sharedInstance.showSessionExpireAlert()
                    }
                    else {
                        CustomAlertController.sharedInstance.showErrorAlert(error: response.error!)
                    }
                    
                    
                })
                
            }
            else if filterData == "clearFilter" {
                
                
                var lat = 0.0
                var lon = 0.0
                LocationWrapper.sharedInstance.fetchLocation()
                if selectedArea == "currentLocation"{
                    lat = LocationWrapper.sharedInstance.latitude
                    lon = LocationWrapper.sharedInstance.longitude
                }
                
                var area = selectedArea ?? ""
                if area == "currentLocation"{
                    area = ""
                }
                
                let param = [
                    "count":100,
                    "page":0,
                    "latitude":lat,
                    "longitude":lon,
                    "area":area,
                    "keyword":  filterText,
                    "gender": "\(CommonFunctions.sharedInstance.genderValue())"
                    ] as [String : Any]
                worker?.getListBusiness(offset:0, filterText: filterText, parameters: param, apiResponse: { (response) in
                    
                    if response.code == 200 {
                        self.presenter?.presentResponse(isFilter: false, response: response)
                    }
                    else if response.code == 404 {
                        CommonFunctions.sharedInstance.showSessionExpireAlert()
                    }
                    else {
                        CustomAlertController.sharedInstance.showErrorAlert(error: response.error!)
                    }
                    
                })
            } else {
                var lat = 0.0
                var lon = 0.0
                LocationWrapper.sharedInstance.fetchLocation()
                if selectedArea == "currentLocation"{
                    lat = LocationWrapper.sharedInstance.latitude
                    lon = LocationWrapper.sharedInstance.longitude
                }
                
                var area = selectedArea ?? ""
                if area == "currentLocation"{
                    area = ""
                }
                
                let param = [
                    "count":100,
                    "page":0,
                    "latitude":lat,
                    "longitude":lon,
                    "area":area,
                    "keyword":  filterText,
                    "gender": "\(CommonFunctions.sharedInstance.genderValue())"
                    ] as [String : Any]
                worker?.getListBusiness(offset:0, filterText: filterText, parameters: param, apiResponse: { (response) in
                    
                    if response.code == 200 {
                        self.presenter?.presentResponse(isFilter: false, response: response)
                    }
                    else if response.code == 404 {
                        CommonFunctions.sharedInstance.showSessionExpireAlert()
                    }
                    else {
                        CustomAlertController.sharedInstance.showErrorAlert(error: response.error!)
                    }
                    
                })
                
            }
        } else {
            var lat = 0.0
            var lon = 0.0
            LocationWrapper.sharedInstance.fetchLocation()
            if selectedArea == "currentLocation"{
                lat = LocationWrapper.sharedInstance.latitude
                lon = LocationWrapper.sharedInstance.longitude
            }
            
            var area = selectedArea ?? ""
            if area == "currentLocation"{
                area = ""
            }
            
            let param = [
                "count":100,
                "page":0,
                "latitude":lat,
                "longitude":lon,
                "area":area,
                "keyword":  filterText,
                "gender": "\(CommonFunctions.sharedInstance.genderValue())"
                ] as [String : Any]
            worker?.getListBusiness(offset:0, filterText: filterText, parameters: param, apiResponse: { (response) in
                
                if response.code == 200 {
                    self.presenter?.presentResponse(isFilter: false, response: response)
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
