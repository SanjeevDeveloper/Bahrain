
import UIKit

protocol WalletRoutingLogic {
  func routeToWalletDetails(walletDetails: [Wallet.ViewModel.refundDetails.walletDetail], salonName: String)
}

protocol WalletDataPassing {
  var dataStore: WalletDataStore? { get }
}

class WalletRouter: NSObject, WalletRoutingLogic, WalletDataPassing
{
  weak var viewController: WalletViewController?
  var dataStore: WalletDataStore?
  
  
  func routeToWalletDetails(walletDetails: [Wallet.ViewModel.refundDetails.walletDetail], salonName: String) {
    let destinationVC = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: "WalletDetailsViewControllerID") as! WalletDetailsViewController
    var destinationDS = destinationVC.router?.dataStore
    passDataToWalletDetails(walletDetails: walletDetails, destination: &destinationDS!, salonName: salonName)
    viewController?.navigationController?.pushViewController(destinationVC, animated: true)
  }
  
  func passDataToWalletDetails(walletDetails: [Wallet.ViewModel.refundDetails.walletDetail], destination: inout WalletDetailsDataStore, salonName: String) {
    destination.walletDetailsArray = walletDetails
    destination.salonName = salonName
  }
}
