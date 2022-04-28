
import UIKit

@objc protocol PaymentMethodRoutingLogic
{
    func routeToCardDetailScreen(isPaymentMethodMpgs:Bool, ispaymentTypePartial:Bool, advancePayment:Double, remainingAmt:Double,isWalletUsed:Bool,walletPayment:Double,cardPayment:Double,paymentMethodName:String)
    
    func routeToHomeVC()
   func routeToSalonDetailVC()
  func routeToOrderDetail()
}

protocol PaymentMethodDataPassing
{
    var dataStore: PaymentMethodDataStore? { get }
}

class PaymentMethodRouter: NSObject, PaymentMethodRoutingLogic, PaymentMethodDataPassing
{
    weak var viewController: PaymentMethodViewController?
    var dataStore: PaymentMethodDataStore?
    
    // MARK: Routing
  
  // MARK: Routing
  
  func routeToOrderDetail() {
    let destinationVC = viewController?.storyboard?.instantiateViewController(withIdentifier: ViewControllersIds.OrderDetailViewControllerID) as! OrderDetailViewController
    var destinationDS = destinationVC.router!.dataStore!
    passDataToOrderDetail(source: dataStore!, destination: &destinationDS)
    navigateToOrderDetail(source: viewController!, destination: destinationVC)
  }
  
  func navigateToOrderDetail(source: PaymentMethodViewController, destination: OrderDetailViewController){
    viewController?.navigationController?.pushViewController(destination, animated: true)
  }
  
  func passDataToOrderDetail(source: PaymentMethodDataStore, destination: inout OrderDetailDataStore) {
    destination.bookingId = source.bookingId
  }
  
  
    func routeToHomeVC() {
        for controller in (viewController?.navigationController?.viewControllers)! {
            if controller.isKind(of: HomeViewController.self) {
            viewController?.navigationController?.popToViewController(controller, animated: true)
            }
        }
    }
  
  func routeToSalonDetailVC() {
    for controller in (viewController?.navigationController?.viewControllers)! {
      if controller.isKind(of: SalonDetailViewController.self) {
        viewController?.navigationController?.popToViewController(controller, animated: true)
      }
    }
  }
    
    func routeToCardDetailScreen(isPaymentMethodMpgs:Bool,ispaymentTypePartial:Bool, advancePayment:Double, remainingAmt:Double,isWalletUsed:Bool,walletPayment:Double,cardPayment:Double,paymentMethodName:String)
    {
        
        let destinationVC = viewController?.storyboard?.instantiateViewController(withIdentifier: ViewControllersIds.CardDetailViewControllerID) as! CardDetailViewController
        var destinationDS = destinationVC.router!.dataStore!
        navigateToSomewhere(source: viewController!, destination: destinationVC)
        passDataToSomewhere(source: dataStore!, destination: &destinationDS, isPaymentMethodMpgs: isPaymentMethodMpgs, ispaymentTypePartial: ispaymentTypePartial, advancePayment: advancePayment, remainingAmt: remainingAmt, isWalletUsed: isWalletUsed, walletPayment: walletPayment, cardPayment: cardPayment, paymentMethodName: paymentMethodName)
    }
    
    // MARK: Navigation
    func navigateToSomewhere(source: PaymentMethodViewController, destination: CardDetailViewController)
    {
        viewController?.navigationController?.pushViewController(destination, animated: true)
    }
    
    // MARK: Passing data
    func passDataToSomewhere(source: PaymentMethodDataStore, destination: inout CardDetailDataStore,isPaymentMethodMpgs:Bool, ispaymentTypePartial:Bool, advancePayment:Double, remainingAmt:Double,isWalletUsed:Bool,walletPayment:Double,cardPayment:Double,paymentMethodName:String)
    {
        destination.bookingData = source.bookingData
        destination.businessId =  source.businessId
        destination.isHome = source.isHome
        destination.specialInstructions = source.specialInstructions
        destination.offerId = source.offerId
        destination.totalAmount = source.totalAmount
        destination.advanceAmount = advancePayment
        destination.remainingAmount = remainingAmt
        destination.isTypeMpgs = isPaymentMethodMpgs
        destination.bookingId = source.bookingId
        destination.isPaymentPartial = ispaymentTypePartial
        destination.isWalletUsed = isWalletUsed
        destination.walletPaidAmount = walletPayment
        destination.cardPaidAmount = cardPayment
        destination.paymentMethodName = paymentMethodName
    }
}
