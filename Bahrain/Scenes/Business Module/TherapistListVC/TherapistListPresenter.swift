
import UIKit

protocol TherapistListPresentationLogic
{
    func presentResponse(response: ApiResponse)
    func presentApiHitResponse()
    func presentApiHitcheckTherapistAssignedResponse()
    //func presentUpdatedTherapists(therapistsArray: [Therapist])
}

class TherapistListPresenter: TherapistListPresentationLogic
{
    weak var viewController: TherapistListDisplayLogic?
    
    // MARK: Do something
    
    func presentApiHitResponse() {
        viewController?.displayHitApiResponse()
    }
    
    func presentResponse(response: ApiResponse)
    {
        var viewModelArray = [TherapistList.ViewModel.tableCellData]()
        var ViewModelObj:TherapistList.ViewModel
        
        let apiResponseArray = response.result as! NSArray
        
        for obj in apiResponseArray {
            let datadict = obj as! NSDictionary
            
            printToConsole(item: datadict)
            
            let listObj = TherapistList.ViewModel.tableCellData(
                therapistName: datadict["name"] as! String,
                therapistArabicName: datadict["nameArabic"] as? String ?? "",
                jobTitle: datadict["jobTitle"] as? String ?? "",
                jobTitleArabic: datadict["jobTitleArabic"] as? String ?? "",
                workingHourArr: datadict["workingHours"] as! NSArray,
                serviceArray: datadict["businessCategoryServices"] as! NSArray,
                therapistProfileImage: datadict["therapistProfileImage"] as? String,
                therapistId: datadict["_id"] as! String,
                isActive: datadict["isActive"] as! Bool
            )
            
            viewModelArray.append(listObj)
        }
        ViewModelObj = TherapistList.ViewModel(serviceListArray: viewModelArray)
        viewController?.displayResponse(viewModel: ViewModelObj)
    }
    
    func presentApiHitcheckTherapistAssignedResponse() {
        viewController?.displayHitcheckTherapistAssignedResponse()
    }
    
    //    func presentUpdatedTherapists(therapistsArray: [Therapist]) {
    //        viewController?.displayUpdatedTherapists(therapistsArray: therapistsArray)
    //    }
    
}
