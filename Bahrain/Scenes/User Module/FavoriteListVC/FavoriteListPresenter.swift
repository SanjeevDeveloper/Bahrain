
import UIKit

protocol FavoriteListPresentationLogic
{
    func presentResponse(isFilter:Bool, response: ApiResponse , isClear: Bool)
    func presentFilterResponse(isFilter:Bool, response: ApiResponse)
    func updateUI(name:String?, categoryId:String?, isFilterApplied:Bool)
  func presentSelectedArea(_ area: String)
}

class FavoriteListPresenter: FavoriteListPresentationLogic
{
    weak var viewController: FavoriteListDisplayLogic?
    
    // MARK: Do something
    
    func presentResponse(isFilter:Bool, response: ApiResponse, isClear: Bool)
    {
        var DataArray = [FavoriteList.ApiViewModel.tableCellData]()
        var ViewModelObj:FavoriteList.ApiViewModel
        let data = response.result as! NSDictionary
        
        
        let minPrice = data["minPrice"] as? NSNumber ?? 0
        let maxPrice = data["maxPrice"] as? NSNumber ?? 0
        
        
        if response.error != nil {
            ViewModelObj = FavoriteList.ApiViewModel(tableArray: DataArray, maximumPrice: 0, minimumPrice: 0, errorString: response.error)
        }
        else {
            let data = response.result as! NSDictionary
            let bussinesData = data["businessData"] as! NSArray
            for arrData in bussinesData {
                let dataDict = arrData as! NSDictionary
                let businessDict = dataDict["business"] as! NSDictionary
                
                var payment : String
                if businessDict["card"] as! Bool  {
                    payment = "card"
                    
                }else{
                    payment = "cash"
                }
                
                var latitude:Double?
                var longitude:Double?
                let latitudeString = businessDict["latitude"] as? String ?? ""
                let longitudeString = businessDict["longitude"] as? String ?? ""
                if !latitudeString.isEmptyString() {
                    if !longitudeString.isEmptyString() {
                        latitude = (latitudeString as NSString).doubleValue
                        longitude = (longitudeString as NSString).doubleValue
                    }
                }
                
                let website = businessDict["website"] as? String ?? ""
                
                let cash = (businessDict["cash"] as? NSNumber ?? 0).boolValue
                
                var name = ""
                var englishName = ""
                var arabicName = ""
                if let engName = businessDict["saloonName"] as? String {
                    englishName = engName
                }
                
                if let arName = businessDict["saloonNameArabic"] as? String {
                    arabicName = arName
                }
                
                if isCurrentLanguageArabic() {
                    if arabicName != "" {
                        name = arabicName
                    } else {
                        name = englishName
                    }
                    
                } else {
                    name = englishName
                }
                
                let obj = FavoriteList.ApiViewModel.tableCellData(
                    coverImage: businessDict["coverPhoto"] as! String,
                    name: name,//businessDict["saloonName"] as! String,
                    salonPlace: businessDict["area"] as! String,
                    salonImage: businessDict["profileImage"] as! String,
                    price: dataDict["minimumPrice"] as! NSNumber,
                    serviceType: businessDict["serviceType"] as! String,
                    paymentLabel: payment, rating: dataDict["avgRating"] as? Double ?? 0,
                    saloonId: businessDict["_id"] as! String,
                    latitude: latitude,
                    longitude: longitude,
                    website: website,
                    cash: cash )
                
                DataArray.append(obj)
            }
            ViewModelObj = FavoriteList.ApiViewModel(tableArray: DataArray, maximumPrice: maxPrice, minimumPrice: minPrice, errorString: nil)
            
        }
        viewController?.displayResponse(isFilter:isFilter, viewModel: ViewModelObj,isClear : isClear)
    }
    
    
    func presentFilterResponse(isFilter:Bool, response: ApiResponse)
    {
        var DataArray = [FavoriteList.ApiViewModel.tableCellData]()
        var ViewModelObj:FavoriteList.ApiViewModel
        
        if response.error != nil {
            ViewModelObj = FavoriteList.ApiViewModel(tableArray: DataArray, maximumPrice: 0, minimumPrice: 0, errorString: response.error)
        }
        else {
            let response = response.result as! NSDictionary
            let data = response["businessData"] as! NSArray
            for arrData in data {
                let dataDict = arrData as! NSDictionary
                let businessDict = dataDict["business"] as! NSDictionary
                
                var payment : String
                if businessDict["card"] as! Bool  {
                    payment = "card"
                }else{
                    payment = "cash"
                }
                
                var latitude:Double?
                var longitude:Double?
                let latitudeString = businessDict["latitude"] as? String ?? ""
                let longitudeString = businessDict["longitude"] as? String ?? ""
                if !latitudeString.isEmptyString() {
                    if !longitudeString.isEmptyString() {
                        latitude = (latitudeString as NSString).doubleValue
                        longitude = (longitudeString as NSString).doubleValue
                    }
                }
                
                let website = businessDict["website"] as? String ?? ""
                
                let cash = (businessDict["cash"] as? NSNumber ?? 0).boolValue
                
                var name = ""
                var englishName = ""
                var arabicName = ""
                if let engName = businessDict["saloonName"] as? String {
                    englishName = engName
                }
                
                if let arName = businessDict["saloonNameArabic"] as? String {
                    arabicName = arName
                }
                
                if isCurrentLanguageArabic() {
                    if arabicName != "" {
                        name = arabicName
                    } else {
                        name = englishName
                    }
                    
                } else {
                    name = englishName
                }
                
                let obj = FavoriteList.ApiViewModel.tableCellData(
                    coverImage: businessDict["coverPhoto"] as! String,
                    name: name,//businessDict["saloonName"] as! String,
                    salonPlace: businessDict["area"] as! String,
                    salonImage: businessDict["profileImage"] as! String,
                    price: dataDict["minimumPrice"] as! NSNumber,
                    serviceType: businessDict["serviceType"] as! String,
                    paymentLabel: payment, rating: dataDict["avgRating"] as? Double ?? 0,
                    saloonId: businessDict["_id"] as! String,
                    latitude: latitude,
                    longitude: longitude,
                    website: website,
                    cash: cash )
                
                DataArray.append(obj)
            }
            ViewModelObj = FavoriteList.ApiViewModel(tableArray: DataArray, maximumPrice: 0, minimumPrice: 0, errorString: nil)
        }
        viewController?.displayResponse(isFilter:isFilter, viewModel: ViewModelObj, isClear: true)
    }
    
    func updateUI(name:String?, categoryId:String?, isFilterApplied:Bool) {
        var viewModel: FavoriteList.ViewModel.UIModel
        if categoryId != nil {
            viewModel = FavoriteList.ViewModel.UIModel(title: name, type: .category)
        }
        else if name != nil {
            viewModel = FavoriteList.ViewModel.UIModel(title: name, type: .service)
        }
        else {
            viewModel = FavoriteList.ViewModel.UIModel(title: nil, type: .favorite)
        }
        viewController?.updateUI(viewObj: viewModel, isFilterApplied: isFilterApplied)
    }
  
  func presentSelectedArea(_ area: String) {
    viewController?.presentSelectedArea(area)
  }
}
