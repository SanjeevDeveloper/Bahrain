
import UIKit

class SpecialNewOffersWorker
{
    func hitCreateOfferApi(image:UIImage?,parameters:[String:Any], apiResponse:@escaping(responseHandler)) {
        if let unwrappedImage = image {
            let url = ApiEndPoints.Business.createOffer
            NetworkingWrapper.sharedInstance.connectWithMultiPart(urlEndPoint: url, httpMethod: .post, parameters: parameters, headers: ApiHeaders.sharedInstance.headerWithAuthAndUserId(), images: [unwrappedImage], imageName:"offerImage") { (response) in
                apiResponse(response)
            }
        }else{
            let url = ApiEndPoints.Business.createOffer
            NetworkingWrapper.sharedInstance.connectWithMultiPart(urlEndPoint: url, httpMethod: .post, headers: ApiHeaders.sharedInstance.headerWithAuthAndUserId(), parameters: parameters) { (response) in
                apiResponse(response)
            
                }
            }
        }
    
    func hitEditOfferApi(image:UIImage?,parameters:[String:Any], offerId: String,  apiResponse:@escaping(responseHandler)) {
        
        if let unwrappedImage = image {
             let url = ApiEndPoints.Business.editOfferDetail + "/" + offerId
            NetworkingWrapper.sharedInstance.connectWithMultiPart(urlEndPoint: url, httpMethod: .put, parameters: parameters, headers: ApiHeaders.sharedInstance.headerWithAuthAndUserId(), images: [unwrappedImage], imageName:"offerImage") { (response) in
                apiResponse(response)
            }
        }else {
        let url = ApiEndPoints.Business.editOfferDetail + "/" + offerId
        NetworkingWrapper.sharedInstance.connectWithMultiPart(urlEndPoint: url, httpMethod: .put, headers: ApiHeaders.sharedInstance.headerWithAuthAndUserId(), parameters: parameters) { (response) in
            apiResponse(response)
            }
        }
    }
}
