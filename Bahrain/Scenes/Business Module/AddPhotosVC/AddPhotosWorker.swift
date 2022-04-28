

import UIKit

class AddPhotosWorker
{
    func getBusinessGallery(apiResponse:@escaping(responseHandler)) {
        
        let url = ApiEndPoints.Business.getBusinessGallery + "/" + getUserData(.businessId)
        
        NetworkingWrapper.sharedInstance.connect(urlEndPoint: url, httpMethod: .get, headers: ApiHeaders.sharedInstance.headerWithAuth()) { (response) in
            apiResponse(response)
        }
    }
    
    func hituploadBusinessGalleryApi(paremetres:[String:Any], images:[UIImage], apiResponse:@escaping(responseHandler)) {
        let url = ApiEndPoints.Business.uploadBusinessGallery + "/" + getUserData(.businessId)
        NetworkingWrapper.sharedInstance.connectWithMultiPart(urlEndPoint: url, httpMethod: .put, parameters: paremetres , headers: ApiHeaders.sharedInstance.headerWithAuthAndUserId(), images: images, imageName: "gallery") { (response) in
            apiResponse(response)
        }
    }
}
