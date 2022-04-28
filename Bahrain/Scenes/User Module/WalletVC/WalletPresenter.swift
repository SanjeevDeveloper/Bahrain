

import UIKit

protocol WalletPresentationLogic
{
  func presentUserWalletResponse(response: ApiResponse)
}

class WalletPresenter: WalletPresentationLogic
{
  weak var viewController: WalletDisplayLogic?
  
  func presentUserWalletResponse(response: ApiResponse) {
    var refundsArray = [Wallet.ViewModel.refundDetails]()
    
    if let responseDict = response.result as? [String: Any] {
      if let refunds = responseDict["refunds"] as? [[String: Any]] {
       var walletDetailsArray = [Wallet.ViewModel.refundDetails.walletDetail]()
        
        for refundObj in refunds {
          if let walletDetails = refundObj["walletDetails"] as? [[String: Any]] {
            walletDetailsArray.removeAll()
            for obj in walletDetails {
              let walletDetailsObj = Wallet.ViewModel.refundDetails.walletDetail(orderId: obj["orderId"] as? String ?? "", bookingId: obj["bookingId"] as? String ?? "", walletId: obj["walletId"] as? String ?? "", walletAmount: obj["walletAmount"] as? NSNumber ?? 0, validTill: obj["validTill"] as? Int64 ?? 0)
              walletDetailsArray.append(walletDetailsObj)
            }
          }
          let refund = Wallet.ViewModel.refundDetails(salonName: refundObj["salonName"] as? String ?? "", totalWalletAmount: refundObj["totalWalletAmount"] as? NSNumber ?? 0, walletDetailsArray: walletDetailsArray)
          refundsArray.append(refund)
        }
      }
      let vm = Wallet.ViewModel(totalAmount: responseDict["totalAmount"] as? NSNumber ?? 0, refundDetailsArray: refundsArray)
      viewController?.displayUserWallet(viewModel: vm)
    }
  }
}
