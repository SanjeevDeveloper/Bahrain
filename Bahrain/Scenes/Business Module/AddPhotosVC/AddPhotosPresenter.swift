

import UIKit

protocol AddPhotosPresentationLogic
{
  func presentResponse(response: ApiResponse)
  func galleryUpdated()
}

class AddPhotosPresenter: AddPhotosPresentationLogic
{
  weak var viewController: AddPhotosDisplayLogic?
  
  // MARK: Do something
  
  func presentResponse(response: ApiResponse)
  {
    var viewModelArray = [AddPhotos.ViewModel.tableCellData]()
    var ViewModelObj:AddPhotos.ViewModel
    
    if response.error != nil {
        ViewModelObj = AddPhotos.ViewModel(tableArray: viewModelArray, errorString: response.error)
    }
    else {
        
        let apiResponseDict = response.result as! NSDictionary
        let photosArr = apiResponseDict["gallery"] as! NSArray
        
        for arrData in photosArr {
            
            let obj = AddPhotos.ViewModel.tableCellData(imageUrl: arrData as? String, image: nil)
            viewModelArray.append(obj)
        }
        ViewModelObj = AddPhotos.ViewModel(tableArray: viewModelArray, errorString: response.error)
    }
    viewController?.displayResponse(viewModel: ViewModelObj)
  }
    
    func galleryUpdated() {
        viewController?.galleryUpdated()
    }
}
