
import UIKit

protocol AddPhotosBusinessLogic
{
    func hitGetBusinessGalleryApi()
    func hituploadBusinessGalleryApi(request: AddPhotos.Request)
}

protocol AddPhotosDataStore
{
    //var name: String { get set }
}

class AddPhotosInteractor: AddPhotosBusinessLogic, AddPhotosDataStore
{
    var presenter: AddPhotosPresentationLogic?
    var worker: AddPhotosWorker?
    //var name: String = ""
    
    // MARK: Do something
    
    func hitGetBusinessGalleryApi()
    {
        worker = AddPhotosWorker()
        worker?.getBusinessGallery(apiResponse: { (response) in
            if response.code == 200 {
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
    
    func hituploadBusinessGalleryApi(request: AddPhotos.Request) {
        if request.imageReq.count != 0 {
            worker = AddPhotosWorker()
            
            var imageUrl  = [String]()
            var images = [UIImage]()
            
            for data in request.imageReq {
                if data.imageUrl == nil {
                    images.append(data.image!)
                }
                else {
                    imageUrl.append(data.imageUrl!)
                }
                
            }
            
            let param = [
                "step": "4",
                "existImageUrl" : imageUrl
                ] as [String : Any]
            
            worker?.hituploadBusinessGalleryApi(paremetres: param, images: images, apiResponse: { (response) in
                
                if response.code == 200 {
                    self.presenter?.galleryUpdated()
                }
                else if response.code == 404 {
                    CommonFunctions.sharedInstance.showSessionExpireAlert()
                }
                else {
                    CustomAlertController.sharedInstance.showErrorAlert(error: response.error!)
                }
            })
        }
        else {
            CustomAlertController.sharedInstance.showErrorAlert(error: localizedTextFor(key: PhotosSceneText.emptyImagesArray.rawValue))
        }
    }
    
}
