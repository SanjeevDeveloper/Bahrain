
import UIKit

protocol AboutSalonPresentationLogic
{
  func presentAboutScreenData(response: NSDictionary)
}

class AboutSalonPresenter: AboutSalonPresentationLogic
{
   
    
  weak var viewController: AboutSalonDisplayLogic?
  
  
    func presentAboutScreenData(response: NSDictionary) {
        let ViewModelObj = AboutSalon.ViewModel(
            salonName: response["saloonName"] as? String ?? "",                                                profileImage: response["profileImage"] as? String,                                                coverPhoto: response["coverPhoto"] as? String,                                                serviceType: response["serviceType"] as? String ?? "",                                                instaAccount: response["instaAccount"] as? String ?? "",                                                about: response["about"] as? String ?? "",                                                address: response["address"] as? String ?? "",                                                address2: response["address2"] as? String ?? "")
        
      viewController?.displayScreenData(viewModel: ViewModelObj)
    }
    
}
