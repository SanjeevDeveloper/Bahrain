
import UIKit

protocol rateReviewPresentationLogic
{
  func presentResponse(response: ApiResponse)
  func presentScreenName(isRated: Bool)
}

class rateReviewPresenter: rateReviewPresentationLogic
{
   
    
  weak var viewController: rateReviewDisplayLogic?
  
  // MARK: Do something
    
  func presentScreenName(isRated: Bool) {
        viewController?.displayScreenName(isRated: isRated)
    }
  
  func presentResponse(response: ApiResponse)
  {
   
    var viewModelArray = [rateReview.ViewModel.tableCellData]()
    var ViewModelObj:rateReview.ViewModel
    
    let resultDict = response.result as! NSDictionary
    
    let dataArray = resultDict["userRating"] as! NSArray
    
    for item in dataArray {
        
        let dataDict = item as! NSDictionary
        
        let createdDate = dataDict["rateAt"] as! Int
        let date = Date(milliseconds: createdDate)
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = UaeTimeZone
        dateFormatter.dateFormat = dateFormats.format6
        let day = dateFormatter.string(from: date)
        
        let obj = rateReview.ViewModel.tableCellData(name: dataDict["userName"] as! String, date: day, discription: dataDict["review"] as? String ?? "", profileImg: dataDict["userProfileImage"] as! String, rating: dataDict["avgRating"] as! NSNumber, isSelected: false, CustomerRating: dataDict["customerService"] as! NSNumber, QualityRating: dataDict["quality"] as! NSNumber, TimingRating: dataDict["timing"] as! NSNumber, MoneyRating: dataDict["valueOfMoney"] as! NSNumber)
        
        viewModelArray.append(obj)
    }
    
    ViewModelObj = rateReview.ViewModel(SalonName: resultDict["saloonName"] as! String,SalonRating: resultDict["salonOverallRating"] as! NSNumber, qualityPercentage: resultDict["qualityOverallPercentage"] as! NSNumber, moneyPercentage: resultDict["valueOfMoneyOverallPercentage"] as! NSNumber, servicesPercentage: resultDict["customerServiceOverallPercentage"] as! NSNumber, timingPercentage: resultDict["timingOverallPercentage"] as! NSNumber, tableArray: viewModelArray)
    viewController?.displayResponse(viewModel: ViewModelObj)
    
  }
}
