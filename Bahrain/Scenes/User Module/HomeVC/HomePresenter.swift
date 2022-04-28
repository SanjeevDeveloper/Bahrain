
import UIKit

protocol HomePresentationLogic
{
    func presentCategoriesResponse(response: ApiResponse)
    func presentFavouriteResponse(response: ApiResponse)
    func presentListResponse(response: ListYourService.Response)
   
}

class HomePresenter: HomePresentationLogic
{
    
    weak var viewController: HomeDisplayLogic?
    
    // MARK: Do something
    func presentCategoriesResponse(response: ApiResponse) {
        var categoriesArray = [Home.ViewModel.Category]()
        var ViewModelObj:Home.ViewModel
       
        
        if (response.code == 200) {
            let dataArray = response.result as! NSArray
            for arrData in dataArray {
                let dataDict = arrData as! NSDictionary
                let obj = Home.ViewModel.Category(
                    categoryName: dataDict["categoryName"] as! String ,
                    categoryId: dataDict["_id"] as! String ,
                    categoryImageUrl: dataDict["icon"] as! String
                )
                
                if dataDict["serviceCount"] != nil {
                    if (dataDict["serviceCount"] as? Int ?? 0) > 0 {
                        categoriesArray.append(obj)
                    }
                } else {
                    categoriesArray.append(obj)
                }
                
                
            }
            ViewModelObj = Home.ViewModel(categoriesArray: categoriesArray, errorString: nil)
        }
        else {
                ViewModelObj = Home.ViewModel(categoriesArray: categoriesArray, errorString: response.error)
        }
        
        viewController?.displayCategoriesResponse(viewModel: ViewModelObj)
        
    }
    
    func presentFavouriteResponse(response: ApiResponse) {
        var DataArray = [Home.FavouriteApiViewModel.CellData]()
        var ViewModelObj:Home.FavouriteApiViewModel
        
        if response.error != nil {
            ViewModelObj = Home.FavouriteApiViewModel(tableArray: DataArray, errorString: response.error)
        }
        else {
            let data = response.result as! NSDictionary
             let bussinesData = data["businessData"] as! NSArray
            for arrData in bussinesData {
                let dataDict = arrData as! NSDictionary
                let businessDict = dataDict["business"] as! NSDictionary
                
                let obj = Home.FavouriteApiViewModel.CellData(salonImage: businessDict["profileImage"] as! String, favImage: nil, saloonId: businessDict["_id"] as! String)
                
                DataArray.append(obj)
            }
            
            ViewModelObj = Home.FavouriteApiViewModel(tableArray: DataArray, errorString: nil)
        }
        
        viewController?.displayFavouriteResponse(viewModel: ViewModelObj)
    }
    
    
    func presentListResponse(response: ListYourService.Response) {
        
        var viewModelArray = [ListYourService.ViewModel.service]()
        
        for obj in response.servicesArray {
            let dict = obj as! NSDictionary
            let name = dict["name"] as! String
             let keyName = dict["keyName"] as! String
            let imageName = dict["serviceIcon"] as! String
            let id = dict["_id"] as! String
            let bgImageName = dict["serviceBgImage"] as? String ?? ""
            let serviceModelObj = ListYourService.ViewModel.service(keyName: keyName, name: name, imageName: imageName, id: id, bgImageName: bgImageName, isSelected: false)
            viewModelArray.append(serviceModelObj)
        }
        viewController?.presentServicesResponse(viewModelArray: viewModelArray)
    }
}
