
import UIKit

 protocol BookingRoutingLogic
{
    func routeToBookingSummary(segue: UIStoryboardSegue?, specialInstructions: String?, bookingDate:String?,  bookingData: [Booking.selectedTherapistModel],offerId:String?, totalPrice:String, calendarTimeStamp: Int64)
}

protocol BookingDataPassing
{
  var dataStore: BookingDataStore? { get }
}

class BookingRouter: NSObject, BookingRoutingLogic, BookingDataPassing
{
  weak var viewController: BookingViewController?
  var dataStore: BookingDataStore?
  
  // MARK: Routing
  
  func routeToBookingSummary(segue: UIStoryboardSegue?, specialInstructions: String?, bookingDate:String?, bookingData: [Booking.selectedTherapistModel],offerId:String?, totalPrice:String, calendarTimeStamp: Int64)
  {
    let destinationVC = viewController?.storyboard?.instantiateViewController(withIdentifier: ViewControllersIds.BookingSummaryViewControllerID) as! BookingSummaryViewController
    var destinationDS = destinationVC.router!.dataStore!
    passDataToSomewhere(calendarTimeStamp: calendarTimeStamp, specialInstructions: specialInstructions, bookingDate: bookingDate, bookingData: bookingData,source: dataStore!, offerId:offerId, totalPrice: totalPrice, destination: &destinationDS)
    navigateToSomewhere(source: viewController!, destination: destinationVC)
  }

    
  // MARK: Navigation
  func navigateToSomewhere(source: BookingViewController, destination: BookingSummaryViewController)
  {
    viewController?.navigationController?.pushViewController(destination, animated: true)
  }
  
    
  // MARK: Passing data
    func passDataToSomewhere(calendarTimeStamp: Int64, specialInstructions: String?, bookingDate:String?, bookingData: [Booking.selectedTherapistModel], source: BookingDataStore,offerId:String?, totalPrice:String, destination: inout BookingSummaryDataStore)
  {
    destination.specialInstructions = specialInstructions
    destination.bookingDate = bookingDate
    destination.bookingData = bookingData
    destination.businessId = source.businessId
    destination.saloonName = source.saloonName
    destination.selectedServicesArray = source.selectedServicesArray
    destination.selectedSingleServiceArr = source.selectedSingleserviceArray
    destination.isHome = source.isHome
    destination.offerId = source.offerId
    destination.OfferPrice = totalPrice
    destination.calendarTimeStamp = calendarTimeStamp
  }
}
