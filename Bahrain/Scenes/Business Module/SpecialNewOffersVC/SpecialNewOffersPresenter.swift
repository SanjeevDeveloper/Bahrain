
import UIKit

protocol SpecialNewOffersPresentationLogic
{
    func presentOfferData(response: SpecialNewOffers.ViewModel, isHome: Bool?)
    func presentCreateOfferResponse()
    
}

class SpecialNewOffersPresenter: SpecialNewOffersPresentationLogic
{
    
    
    weak var viewController: SpecialNewOffersDisplayLogic?
    
    // MARK: Do something
    
    func presentCreateOfferResponse() {
        viewController?.displayCreateOfferApiResponse()
    }
    
    
    func presentOfferData(response: SpecialNewOffers.ViewModel, isHome: Bool?)
    {
        
        var calculatedTotalPrice: Float = 0
        for obj in response.selectedServicesArray {
            let type = obj.type
            printToConsole(item: obj.type)
            
            if let isHomeBool = isHome {
                if isHomeBool {
                    let stringHome = NSString(string: obj.homePrice)
                    let homePrice = stringHome.floatValue
                    calculatedTotalPrice = calculatedTotalPrice + homePrice
                }
                else {
                    let stringSalon = NSString(string: obj.salonPrice)
                    let salonPrice = stringSalon.floatValue
                    calculatedTotalPrice = calculatedTotalPrice + salonPrice
                }
            }
            else {
                if type == "salon" {
                    let stringSalon = NSString(string: obj.salonPrice)
                    let salonPrice = stringSalon.floatValue
                    calculatedTotalPrice = calculatedTotalPrice + salonPrice
                }
                else {
                    let stringHome = NSString(string: obj.homePrice)
                    let homePrice = stringHome.floatValue
                    calculatedTotalPrice = calculatedTotalPrice + homePrice
                }
            }
        }
        
        let viewModel = SpecialNewOffers.ViewModel(selectedServicesArray: response.selectedServicesArray, offerObj: response.offerObj, offerName: response.offerName, offerImage: response.offerImage, TotalPrice: calculatedTotalPrice as NSNumber)
        viewController?.displayResponse(viewModel: viewModel, isHome: isHome)
    }
}
