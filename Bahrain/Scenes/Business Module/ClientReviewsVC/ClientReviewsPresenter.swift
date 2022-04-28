
import UIKit

protocol ClientReviewsPresentationLogic
{
  func presentResponse(response: ApiResponse)
}

class ClientReviewsPresenter: ClientReviewsPresentationLogic
{
  weak var viewController: ClientReviewsDisplayLogic?
  
  // MARK: Do something
  
  func presentResponse(response: ApiResponse)
  {
    var viewModelArray = [ClientReviews.ViewModel.tableCellData]()
    var ViewModelObj:ClientReviews.ViewModel
    
    let apiResponseArray = response.result as! NSArray
    
    for item in apiResponseArray {
        let dataDict = item as! NSDictionary
        let userDict = dataDict["userId"] as! NSDictionary
        
        let createdDate = dataDict["createdAt"] as! Int
        let date = Date(milliseconds: createdDate)
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = UaeTimeZone
        dateFormatter.dateFormat = dateFormats.format1
        let day = dateFormatter.string(from: date)
        
        
        let obj = ClientReviews.ViewModel.tableCellData(name: userDict["name"] as! String, date: day, discription: dataDict["review"] as! String, profileImg: userDict["profileImage"] as! String, rating: dataDict["rating"] as! NSNumber)
        
        viewModelArray.append(obj)
    }
    ViewModelObj = ClientReviews.ViewModel(tableArray: viewModelArray)
    viewController?.displayResponse(viewModel: ViewModelObj)
  }
}
