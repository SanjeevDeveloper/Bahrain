
import UIKit

protocol WalletDetailsPresentationLogic
{
  func presentWalletDetails(viewModel: [Wallet.ViewModel.refundDetails.walletDetail], salonName: String)
}

class WalletDetailsPresenter: WalletDetailsPresentationLogic
{
  weak var viewController: WalletDetailsDisplayLogic?
  
  func presentWalletDetails(viewModel: [Wallet.ViewModel.refundDetails.walletDetail], salonName: String) {
   viewController?.displayWalletDetails(viewModel: viewModel, salonName: salonName)
  }
}
