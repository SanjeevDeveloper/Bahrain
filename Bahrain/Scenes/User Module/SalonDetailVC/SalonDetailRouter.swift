
import UIKit

protocol SalonDetailRoutingLogic
{
    func routeToAnotherScreen(identifier:String)
    func routeToAboutScreen(identifier:String)
    func routeToStaff()
    func routeToBooking()
    func routeToChat()
    func routeToReviewScreen(identifier:String)
    func routeToBookingForSpecialOffer(salonName: String, businessId: String, selectedServicesArray: [SalonDetail.ViewModel.service],offerId:String,totalPrice:String, serviceType: String, selectedSingleserviceArray: [[String: String]])
    func routeToWhatsApp(mobileNum : String, description : String)
    func routeToShare()
}

protocol SalonDetailDataPassing
{
    var dataStore: SalonDetailDataStore? { get }
}

class SalonDetailRouter: NSObject, SalonDetailRoutingLogic, SalonDetailDataPassing
{
    weak var viewController: SalonDetailViewController?
    var dataStore: SalonDetailDataStore?
    
    // MARK: Routing
    
    func routeToAnotherScreen(identifier:String)
    {
        let destinationVC = viewController?.storyboard?.instantiateViewController(withIdentifier: identifier) as! OpeningHoursViewController
        var ds = destinationVC.router?.dataStore
        passDataToOpeningHours(destination: &ds!)
        viewController?.navigationController?.pushViewController(destinationVC, animated: true)
    }
    
    func routeToChat()
    {
        let destinationVC = AppStoryboard.Chat.instance.instantiateViewController(withIdentifier: ViewControllersIds.ChatViewControllerID) as! ChatViewController
        var ds = destinationVC.router?.dataStore
        passDataToChat(destination: &ds!)
        viewController?.navigationController?.pushViewController(destinationVC, animated: true)
    }
    
    func routeToStaff()
    {
        let destinationVC = viewController?.storyboard?.instantiateViewController(withIdentifier: ViewControllersIds.StaffViewControllerID) as! StaffViewController
        var ds = destinationVC.router?.dataStore
        passDataToStaff(destination: &ds!)
        viewController?.navigationController?.pushViewController(destinationVC, animated: true)
    }
    
    func routeToReviewScreen(identifier:String)
    {
        let destinationVC = viewController?.storyboard?.instantiateViewController(withIdentifier: identifier) as! rateReviewViewController
        var ds = destinationVC.router?.dataStore
        passDataToRateReview(destination: &ds!)
        viewController?.navigationController?.pushViewController(destinationVC, animated: true)
    }
    
    func routeToAboutScreen(identifier:String)
    {
        let destinationVC = viewController?.storyboard?.instantiateViewController(withIdentifier: identifier) as! AboutSalonViewController
        var ds = destinationVC.router?.dataStore
        passDataToAbout(destination: &ds!)
        viewController?.navigationController?.pushViewController(destinationVC, animated: true)
    }
    
    func routeToBooking() {
        let destinationVC = viewController?.storyboard?.instantiateViewController(withIdentifier: ViewControllersIds.BookingViewControllerID) as! BookingViewController
        var ds = destinationVC.router?.dataStore
        
        passDataToBooking(destination: &ds!)
        viewController?.navigationController?.pushViewController(destinationVC, animated: true)
    }
    
    func routeToBookingForSpecialOffer(salonName: String, businessId: String, selectedServicesArray: [SalonDetail.ViewModel.service],offerId:String,totalPrice:String, serviceType: String, selectedSingleserviceArray: [[String: String]]) {
        let destinationVC = viewController?.storyboard?.instantiateViewController(withIdentifier: ViewControllersIds.BookingViewControllerID) as! BookingViewController
        var destinationDS = destinationVC.router!.dataStore!
        passDataToBooking(destination: &destinationDS, salonName: salonName, businessId: dataStore?.saloonId ?? "", selectedServicesArray: selectedServicesArray,offerId:offerId, totalPrice: totalPrice, serviceType: serviceType, selectedSingleserviceArray: selectedSingleserviceArray)
        navigateToSomewhere(source: viewController!, destination: destinationVC)
    }
    
    func routeToWhatsApp(mobileNum : String, description : String){
        let urlWhats = "whatsapp://send?phone=\(mobileNum)&text=\(description)"
            if let urlString = urlWhats.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed) {
                if let whatsappURL = URL(string: urlString) {
                    if UIApplication.shared.canOpenURL(whatsappURL) {
                        UIApplication.shared.open(whatsappURL, options: [:], completionHandler: nil)
                    } else {
                        print("Install Whatsapp")
                    }
                }
            }
    }
    func routeToShare(){
        
    }
    // MARK: Navigation
    
    func navigateToSomewhere(source: SalonDetailViewController, destination: BookingViewController)
    {
        viewController?.navigationController?.pushViewController(destination, animated: true)
    }
    
    
    //  // MARK: Passing data
    func passDataToBooking(destination: inout BookingDataStore, salonName:String, businessId:String, selectedServicesArray: [SalonDetail.ViewModel.service],offerId:String,totalPrice:String, serviceType: String, selectedSingleserviceArray: [[String: String]])
    {
        print(selectedServicesArray)
        
        if serviceType == "salon" {
            destination.isHome = false
        } else {
            destination.isHome = true
        }
        
        destination.saloonName = salonName
        destination.businessId = businessId
        destination.selectedSingleserviceArray = selectedSingleserviceArray
        destination.selectedServicesArray = selectedServicesArray
        destination.offerId = offerId
        destination.totalPrice = totalPrice
    }
    
    // MARK: Passing data
    
    func passDataToAbout( destination: inout AboutSalonDataStore)
    {
        destination.resultDict = self.dataStore?.aboutResultDict
    }
    
    func passDataToChat( destination: inout ChatDataStore)
    {
        destination.salonName = self.dataStore?.saloonName
        destination.salonImage = self.dataStore?.profileImage
        destination.buisnessId = self.dataStore?.saloonId
        destination.isFromMessage = true
    }
    
    func passDataToStaff( destination: inout StaffDataStore)
    {
        destination.saloonId = self.dataStore?.saloonId
    }
    
    func passDataToBooking(destination: inout BookingDataStore)
    {
        destination.businessId = self.dataStore?.saloonId
        destination.saloonName = self.dataStore?.saloonName
        destination.isHome = self.dataStore?.isHome
        destination.selectedServicesArray = self.dataStore?.selectedServicesArray
    }
    
    func passDataToOpeningHours(destination: inout OpeningHoursDataStore)
    {
        destination.buisnessId = self.dataStore?.saloonId
        
    }
    
    func passDataToRateReview(destination: inout rateReviewDataStore)
    {
        destination.salonId = self.dataStore?.saloonId
        destination.isRated = true
    }
}
