
import UIKit

protocol LocationPresentationLogic
{
    func presentSelectedArea(ResponseText: String?)
    func gotBusinessInfo(info:NSDictionary)
    func locationUpdated()
}

class LocationPresenter: LocationPresentationLogic
{
  weak var viewController: LocationDisplayLogic?
    
    func presentSelectedArea(ResponseText: String?) {
        viewController?.displaySelectedAreaText(ResponseMsg: ResponseText)
    }
    
    func gotBusinessInfo(info:NSDictionary) {
        
        printToConsole(item: info)
        let area = info["area"] as? String ?? ""
        let address1Block = info["address"] as? String ?? ""
        let address1Street = info["address2"] as? String ?? ""
        let avenue = info["avenue"] as? String ?? ""
        let buildingFloor = info["buildingFloor"] as? String ?? ""
        let specialLocation = info["specialLocation"] as? String ?? ""
        
        let viewModel = Location.ViewModel(area: area, address1Block: address1Block, address1Street: address1Street, avenue: avenue, buildingFloor: buildingFloor, specialLocation: specialLocation, crNumberText: info["crNumberText"] as? String ?? "", crDocument: info["crNumber"] as? String ?? "")
        viewController?.gotBusinessInfo(viewModel: viewModel)
    }
    
    func locationUpdated() {
        viewController?.locationUpdated()
    }
  
}
