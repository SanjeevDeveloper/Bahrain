
import UIKit

protocol CardDetailPresentationLogic
{
    func presentVerifyCardResponse(response: ApiResponse)
    func presentData(paymentMethodName:String,amount:Double)
}

class CardDetailPresenter: CardDetailPresentationLogic
{

    weak var viewController: CardDetailDisplayLogic?
    // MARK: Do something
    
    func presentData(paymentMethodName:String,amount:Double) {
        viewController?.displayData(paymentMethodName: paymentMethodName, amount: amount)
    }
    
    func presentVerifyCardResponse(response: ApiResponse)
    {
      viewController?.displayVerifyCardResponse()
    }
}
