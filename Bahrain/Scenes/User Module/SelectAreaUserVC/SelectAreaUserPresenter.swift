
import UIKit

protocol SelectAreaUserPresentationLogic
{
    func presentResponse(response: ApiResponse)
  func presentScreenName(screenNameText:String?, area: String)
}

class SelectAreaUserPresenter: SelectAreaUserPresentationLogic
{
    weak var viewController: SelectAreaUserDisplayLogic?
    
    // MARK: Do something
    
    func presentResponse(response: ApiResponse)
    {
        var DataArray = [SelectAreaUser.ViewModel.tableCellData]()
        
        var ViewModelObj:SelectAreaUser.ViewModel
        
        if response.error != nil {
            ViewModelObj = SelectAreaUser.ViewModel(tableArray: DataArray, errorString: response.error)
        }
        else {
            let apiResponseArray = response.result as! NSArray
            var cellDataObj:SelectAreaUser.ViewModel.tableCellData
            
            for (index, obj) in apiResponseArray.enumerated() {
                let dataDict = obj as! NSDictionary
                let headerDataDict = dataDict["capitalId"] as! NSDictionary
                let capitalName = headerDataDict["capitalName"] as! String
                
                let sectionObj = SelectAreaUser.ViewModel.tableSectionData(areaHeaderTitle: capitalName)
                 
                
                let rowObject = SelectAreaUser.ViewModel.tableRowData(areaListTitle: dataDict["name"] as! String)
                
                var rowObjectArray = [SelectAreaUser.ViewModel.tableRowData]()
                
                rowObjectArray.append(rowObject)
                
                if index == 0 {
                    cellDataObj = SelectAreaUser.ViewModel.tableCellData(header: sectionObj, row: rowObjectArray)
                    DataArray.append(cellDataObj)
                }
                else {
                    var isObjFound = false
                    for (index, dataObj) in DataArray.enumerated() {
                        if dataObj.header.areaHeaderTitle == capitalName {
                            DataArray[index].row.append(rowObject)
                            isObjFound = true
                        }
                    }
                        if !isObjFound {
                            cellDataObj = SelectAreaUser.ViewModel.tableCellData(header: sectionObj, row: rowObjectArray)
                            DataArray.append(cellDataObj)
                        }
                    
                }
            }
            
            ViewModelObj = SelectAreaUser.ViewModel(tableArray: DataArray, errorString: nil)
        }
        viewController?.displayResponse(viewModel: ViewModelObj)
    }
    
    func presentScreenName(screenNameText: String?, area: String) {
        viewController?.displayScreenName(ResponseMsg: screenNameText, area: area)
    }
}
