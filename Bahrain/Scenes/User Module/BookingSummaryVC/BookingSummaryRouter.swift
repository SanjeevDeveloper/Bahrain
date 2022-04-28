
import UIKit

@objc protocol BookingSummaryRoutingLogic
{
    func routeToPaymentSelectionScreen(bookingId:String, bookingDate: String)
    func routeToAddressList(booking: [String: Any])
    func routeToAddAddress(booking: [String: Any])
}

protocol BookingSummaryDataPassing
{
    var dataStore: BookingSummaryDataStore? { get }
}

class BookingSummaryRouter: NSObject, BookingSummaryRoutingLogic, BookingSummaryDataPassing
{
    weak var viewController: BookingSummaryViewController?
    var dataStore: BookingSummaryDataStore?
    
    // MARK: Routing
    
    func routeToPaymentSelectionScreen(bookingId:String, bookingDate: String)
    {
        
        let price = dataStore?.promoCodeDict?["priceAfterDiscount"] as? String ?? ""
        
        if price == "0.000" || price == "0" {
            CustomAlertController.sharedInstance.showAlertWith(subTitle: localizedTextFor(key: GeneralText.bookingConfirmedSuccessfully.rawValue), theme: .success) {
                self.routeToOrderDetail(id: bookingId)
            }
        } else {
            let destinationVC = viewController?.storyboard?.instantiateViewController(withIdentifier: ViewControllersIds.PaymentMethodViewControllerID) as! PaymentMethodViewController
            var destinationDS = destinationVC.router!.dataStore!
            navigateToSomewhere(source: viewController!, destination: destinationVC)
            passDataToSomewhere(bookingId: bookingId, bookingDate: bookingDate, source: dataStore!, destination: &destinationDS)
        }
    }
    
    func routeToOrderDetail(id: String) {
        let destinationVC = viewController?.storyboard?.instantiateViewController(withIdentifier: ViewControllersIds.OrderDetailViewControllerID) as! OrderDetailViewController
        var destinationDS = destinationVC.router!.dataStore!
        passDataToOrderDetail(source: dataStore!, destination: &destinationDS, id: id)
        navigateToOrderDetail(source: viewController!, destination: destinationVC)
    }
    
    func navigateToOrderDetail(source: BookingSummaryViewController, destination: OrderDetailViewController){
        viewController?.navigationController?.pushViewController(destination, animated: true)
    }
    
    func passDataToOrderDetail(source: BookingSummaryDataStore, destination: inout OrderDetailDataStore, id: String) {
        destination.bookingId = id
    }
    
    
    
    // MARK: Navigation
    
    func navigateToSomewhere(source: BookingSummaryViewController, destination: PaymentMethodViewController)
    {
        viewController?.navigationController?.pushViewController(destination, animated: true)
    }
    
    func routeToAddressList(booking: [String: Any]) {
        let destinationVC = viewController?.storyboard?.instantiateViewController(withIdentifier: "AddressListViewControllerID") as! AddressListViewController
        var destinationDS = destinationVC.router!.dataStore!
        destinationDS.bookingObject = booking
        destinationDS.bookingId = dataStore?.bookingId
        viewController?.navigationController?.pushViewController(destinationVC, animated: true)
    }
    
    func routeToAddAddress(booking: [String: Any]) {
        let destinationVC = viewController?.storyboard?.instantiateViewController(withIdentifier: "UserPinLocationViewController") as! UserPinLocationViewController
        destinationVC.isComingForBooking = true
        var destinationDS = destinationVC.router!.dataStore!
        destinationDS.bookingObject = booking
        destinationDS.bookingId = dataStore?.bookingId
        viewController?.navigationController?.pushViewController(destinationVC, animated: true)
    }
    
    // MARK: Passing data
    
    func passDataToSomewhere(bookingId:String, bookingDate: String,source: BookingSummaryDataStore, destination: inout PaymentMethodDataStore)
    {
        var amount: NSNumber = 0
        if let promoDict = source.promoCodeDict {
            let priceAfterDiscount = promoDict["priceAfterDiscount"] as? String ?? ""
            amount = NSNumber(value: priceAfterDiscount.doubleValue())
        } else {
            amount = source.totalAmount ?? 0
        }
        destination.bookingDate = bookingDate
        destination.bookingData = source.bookingData
        destination.businessId =  source.businessId
        destination.isHome = source.isHome
        destination.specialInstructions = source.specialInstructions
        destination.offerId = source.offerId
        destination.totalAmount = amount
        destination.bookingId = bookingId
        destination.slotBlockedTill = source.slotBlockedTill
        
    }
}
