
import UIKit

protocol SpecialOffersListPresentationLogic
{
  func presentResponse(response: ApiResponse)
  func presentDeleteOfferResponse(response: ApiResponse, index:Int)
}

class SpecialOffersListPresenter: SpecialOffersListPresentationLogic
{
   
  weak var viewController: SpecialOffersListDisplayLogic?
  
  // MARK: Do something
  
  func presentResponse(response: ApiResponse)
  {
    var viewModelArray = [SpecialOffersList.ViewModel.tableCellData]()
    var ViewModelObj:SpecialOffersList.ViewModel
    let apiResponseArray = response.result as! NSArray
    
    for obj in apiResponseArray {
        let datadict = obj as! NSDictionary
        var serviceName = String()
        
        // Service Array
        let serviceDataArray = datadict["businessServicesId"] as! NSArray
        for serviceObj in serviceDataArray {
            let serviceDict = serviceObj as! NSDictionary
            let name = serviceDict["serviceName"] as! String
            
            if serviceName.isEmptyString() {
                serviceName.append(name)
            }
            else {
                serviceName.append(", \(name)")
            }
        }
        
        let expiryDate = datadict["expiryDate"] as! Int
        let date = Date(milliseconds: expiryDate)
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = UaeTimeZone
        dateFormatter.dateFormat = dateFormats.format9
        let day = dateFormatter.string(from: date)
        printToConsole(item: day)
        
        let obj = SpecialOffersList.ViewModel.tableCellData(offerImage: datadict["offerImage"] as! String, offerId: datadict["_id"] as! String, offerName: datadict["offerName"] as! String, serviceName: serviceName, serviceType: datadict["serviceType"] as! String, expiryDate: day, offerSalonPrice: datadict["offerSalonPrice"] as! NSNumber, offerHomePrice: datadict["offerHomePrice"] as! NSNumber, totalSalonPrice: datadict["totalSalonPrice"] as! NSNumber, totalHomePrice: datadict["totalHomePrice"] as! NSNumber)
        
        viewModelArray.append(obj)
    }
    ViewModelObj = SpecialOffersList.ViewModel(offerListArray: viewModelArray)
    viewController?.displayResponse(viewModel: ViewModelObj)
  }
    
    func presentDeleteOfferResponse(response: ApiResponse, index: Int) {
        
        let apiResponseDict = response.result as! NSDictionary
        let msg = apiResponseDict["msg"] as? String ?? ""
        viewController?.displayDeleteOfferResponse(msg: msg, index: index)
    }
    
}
