
import UIKit

protocol AddressListRoutingLogic {
    func routeToAddAddressVc(editObj: AddressList.ViewModel)
    func routeToBusinessSummary(defaultAddress: AddressList.ViewModel)
    func routeToPaymentSelectionScreen(bookingId:String)
    func routeToAdd()
    func goBack()
}

protocol AddressListDataPassing {
    var dataStore: AddressListDataStore? { get }
}

class AddressListRouter: NSObject, AddressListRoutingLogic, AddressListDataPassing
{
    weak var viewController: AddressListViewController?
    var dataStore: AddressListDataStore?
    
    func goBack() {
        if let vcArray = viewController?.navigationController?.viewControllers {
            let vc = vcArray[vcArray.count-2]
            if vc.isKind(of: BookingSummaryViewController.self) {
                let destinationVC = vc as! BookingSummaryViewController
                var destinationDS = destinationVC.router!.dataStore!
                destinationDS.bookingId = dataStore?.bookingId
            }
        }
        viewController?.navigationController?.popViewController(animated: true)
    }
    
    func routeToAdd() {
        let destinationVC = viewController?.storyboard?.instantiateViewController(withIdentifier: "UserPinLocationViewController") as! UserPinLocationViewController
         destinationVC.isComingForBooking = true
        var destinationDS = destinationVC.router!.dataStore!
        destinationDS.bookingObject = dataStore?.bookingObject
        viewController?.navigationController?.pushViewController(destinationVC, animated: true)
    }
    
    func routeToAddAddressVc(editObj: AddressList.ViewModel) {
        let destinationVC = viewController?.storyboard?.instantiateViewController(withIdentifier: "UserPinLocationViewController") as! UserPinLocationViewController
         destinationVC.isComingForBooking = true
        var destinationDS = destinationVC.router?.dataStore
        passDataToAddAddressVc(editObj: editObj, destinationDS: &destinationDS!)
        viewController?.navigationController?.pushViewController(destinationVC, animated: true)
    }
    
    func passDataToAddAddressVc(editObj: AddressList.ViewModel, destinationDS: inout UserPinLocationDataStore) {
        destinationDS.editObject = editObj
        destinationDS.bookingObject = dataStore?.bookingObject
        destinationDS.bookingId = dataStore?.bookingId
    }
    
    func routeToBusinessSummary(defaultAddress: AddressList.ViewModel) {
        
        let vcArray = viewController?.navigationController?.viewControllers
        for vc in vcArray! {
            if vc.isKind(of: BookingSummaryViewController.self) {
                let destinationVC = vc as! BookingSummaryViewController
                var destinationDS = destinationVC.router?.dataStore!
                passDataToBusinessSummary(defaultAddress: defaultAddress, destinationDs: &destinationDS!)
                viewController?.navigationController?.popViewController(animated: true)
                break
            }
        }
    }
    
    func passDataToBusinessSummary(defaultAddress: AddressList.ViewModel, destinationDs: inout BookingSummaryDataStore) {
        destinationDs.selectedAddress = defaultAddress
    }
    
    func routeToPaymentSelectionScreen(bookingId:String) {
        var sourceDataStore: BookingSummaryDataStore?
        let vcArray = viewController?.navigationController?.viewControllers
        for vc in vcArray! {
            if vc.isKind(of: BookingSummaryViewController.self) {
                let destinationVC = vc as! BookingSummaryViewController
                sourceDataStore = destinationVC.router?.dataStore!
                break
            }
        }
        
        let price = sourceDataStore?.promoCodeDict?["priceAfterDiscount"] as? String ?? ""
        
        if price == "0.000" || price == "0" {
            CustomAlertController.sharedInstance.showAlertWith(subTitle: localizedTextFor(key: GeneralText.bookingConfirmedSuccessfully.rawValue), theme: .success) {
                self.routeToOrderDetail(id: bookingId)
            }
        } else {
            if let slotObj = sourceDataStore?.bookingData.first?.therapistSlots {
                let seconds = slotObj["start"] as! Int64
                let date = Date(largeMilliseconds: seconds)
                let dateFormatter = DateFormatter()
                dateFormatter.timeZone = UaeTimeZone
                dateFormatter.dateFormat = dateFormats.format10
                let formattedBookingDate = dateFormatter.string(from: date)
                
                
                let destinationVC = viewController?.storyboard?.instantiateViewController(withIdentifier: ViewControllersIds.PaymentMethodViewControllerID) as! PaymentMethodViewController
                var destinationDS = destinationVC.router!.dataStore!
                navigateToPaymentSelection(source: viewController!, destination: destinationVC)
                
                
                passDataToPaymentSelection(bookingId: bookingId, bookingDate: formattedBookingDate, source: sourceDataStore!, destination: &destinationDS)
            }
        }
    }
    
    func passDataToPaymentSelection(bookingId:String, bookingDate: String,source: BookingSummaryDataStore, destination: inout PaymentMethodDataStore) {
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
    
    func navigateToPaymentSelection(source: AddressListViewController, destination: PaymentMethodViewController) {
        viewController?.navigationController?.pushViewController(destination, animated: true)
    }
    
    func routeToOrderDetail(id: String) {
        let destinationVC = viewController?.storyboard?.instantiateViewController(withIdentifier: ViewControllersIds.OrderDetailViewControllerID) as! OrderDetailViewController
        var destinationDS = destinationVC.router!.dataStore!
        destinationDS.bookingId = id
        viewController?.show(destinationVC, sender: nil)
    }
    
}
