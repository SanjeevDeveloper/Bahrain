
import UIKit

 protocol SpecialOfferUserRoutingLogic
{
  func routeToBooking(salonName:String, businessId:String, selectedServicesArray: [SalonDetail.ViewModel.service],offerId:String,totalPrice:String)
  func routeToFilterScreen(segue: UIStoryboardSegue?,minimumValue: NSNumber,MaximumValue:NSNumber)
}

protocol SpecialOfferUserDataPassing
{
  var dataStore: SpecialOfferUserDataStore? { get }
}

class SpecialOfferUserRouter: NSObject, SpecialOfferUserRoutingLogic, SpecialOfferUserDataPassing
{
  weak var viewController: SpecialOfferUserViewController?
  var dataStore: SpecialOfferUserDataStore?
  
  // MARK: Routing
    
    
    
    func routeToFilterScreen(segue: UIStoryboardSegue?, minimumValue: NSNumber, MaximumValue: NSNumber) {
        let destinationVC = segue!.destination as! FilterViewController
        var destinationDS = destinationVC.router!.dataStore!
        passDataTofilter(source: self.dataStore!, destination: &destinationDS, minimumValue: minimumValue, MaximumValue: MaximumValue)
    }
    
    func routeToBooking(salonName: String, businessId: String, selectedServicesArray: [SalonDetail.ViewModel.service],offerId:String,totalPrice:String) {
        let destinationVC = viewController?.storyboard?.instantiateViewController(withIdentifier: ViewControllersIds.BookingViewControllerID) as! BookingViewController
        var destinationDS = destinationVC.router!.dataStore!
        passDataToBooking(source: dataStore!, destination: &destinationDS, salonName: salonName, businessId: businessId, selectedServicesArray: selectedServicesArray,offerId:offerId, totalPrice: totalPrice)
        navigateToSomewhere(source: viewController!, destination: destinationVC)
    }


  // MARK: Navigation
  
  func navigateToSomewhere(source: SpecialOfferUserViewController, destination: BookingViewController)
  {
    viewController?.navigationController?.pushViewController(destination, animated: true)
  }

    
//  // MARK: Passing data
    func passDataToBooking(source: SpecialOfferUserDataStore, destination: inout BookingDataStore, salonName:String, businessId:String, selectedServicesArray: [SalonDetail.ViewModel.service],offerId:String,totalPrice:String)
    {
        print(selectedServicesArray)
        
        if selectedServicesArray[0].type == "salon" {
            destination.isHome = false
        } else {
            destination.isHome = true
        }
        
        destination.saloonName = salonName
        destination.businessId = businessId
        destination.selectedServicesArray = selectedServicesArray
        destination.offerId = offerId
        destination.totalPrice = totalPrice
    }
    
    func passDataTofilter(source: SpecialOfferUserDataStore, destination: inout FilterDataStore,minimumValue: NSNumber,MaximumValue:NSNumber)
    {
        if source.filterDict != nil {
            destination.filterDict = source.filterDict!
        }
        destination.filterCategoryArr = source.filterCategoryArr
        destination.paymentArr = source.paymentArr
        destination.minimumValue = minimumValue
        destination.maximumValue = MaximumValue
        destination.fromFav = "specialOfferVC"
    }
}
