
import UIKit

protocol BasicInformationPresentationLogic
{
    func imageUploaded(imageData:BasicInformation.imageRequest)
    func infoUpdated()
    func gotBusinessInfo(info:NSDictionary)
    func requestValidated()
}

class BasicInformationPresenter: BasicInformationPresentationLogic
{
  weak var viewController: BasicInformationDisplayLogic?
  
  // MARK: Do something
  
  func imageUploaded(imageData:BasicInformation.imageRequest) {
    viewController?.imageUploaded(imageData:imageData)
  }
    
    func requestValidated() {
        viewController?.requestValidated()
    }
    
    func infoUpdated() {
        viewController?.infoUpdated()
    }
    
    func gotBusinessInfo(info:NSDictionary) {
        let salonName = info["saloonName"] as? String ?? ""
        let arabicName = info["saloonNameArabic"] as? String ?? ""
        let website = info["website"] as? String ?? ""
        let instagramAccount = info["instaAccount"] as? String ?? ""
        let phoneNumber = info["phoneNumber"] as? String ?? ""
        let about = info["about"] as? String ?? ""
        let arabicAbout = info["aboutArabic"] as? String ?? ""
        let profileImageUrl = info["profileImage"] as? String ?? ""
        let coverImageUrl = info["coverPhoto"] as? String ?? ""
        
        let viewModel = BasicInformation.ViewModel(saloonName: salonName, arabicName: arabicName, website: website, instagramAccount: instagramAccount, phoneNumber: phoneNumber, about: about, arabicAbout: arabicAbout, profileImageUrl: profileImageUrl, coverImageUrl: coverImageUrl)
        viewController?.gotBusinessInfo(viewModel: viewModel)
    }
}
