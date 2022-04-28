
import UIKit

@objc protocol WalletDetailsRoutingLogic {
  func routeToOrderDetail(bookingId: String)
}

protocol WalletDetailsDataPassing {
  var dataStore: WalletDetailsDataStore? { get }
}

class WalletDetailsRouter: NSObject, WalletDetailsRoutingLogic, WalletDetailsDataPassing {
  weak var viewController: WalletDetailsViewController?
  var dataStore: WalletDetailsDataStore?
  
  func routeToOrderDetail(bookingId: String) {
    let destinationVC = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: "OrderDetailViewControllerID") as! OrderDetailViewController
    var destinationDS = destinationVC.router?.dataStore
    passDataToWalletDetails(bookingId: bookingId, destination: &destinationDS!)
    viewController?.navigationController?.pushViewController(destinationVC, animated: true)
  }
  
  func passDataToWalletDetails(bookingId: String, destination: inout OrderDetailDataStore) {
    
    destination.bookingId = bookingId
    destination.isFromWalletDetails = true
  }
  
}
