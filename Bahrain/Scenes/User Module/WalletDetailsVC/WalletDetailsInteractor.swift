
import UIKit

protocol WalletDetailsBusinessLogic {
  func showWalletDetails()
}

protocol WalletDetailsDataStore {
  var walletDetailsArray: [Wallet.ViewModel.refundDetails.walletDetail]? { get set }
  var salonName: String? { get set }
}

class WalletDetailsInteractor: WalletDetailsBusinessLogic, WalletDetailsDataStore {
  var salonName: String?
  var walletDetailsArray: [Wallet.ViewModel.refundDetails.walletDetail]?
  var presenter: WalletDetailsPresentationLogic?
  var worker: WalletDetailsWorker?
  
  func showWalletDetails() {
    if let walletArray = walletDetailsArray {
      presenter?.presentWalletDetails(viewModel: walletArray, salonName: salonName!)
    }
  }
}
