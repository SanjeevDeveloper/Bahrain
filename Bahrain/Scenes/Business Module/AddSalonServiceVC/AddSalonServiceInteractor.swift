
import UIKit

protocol AddSalonServiceBusinessLogic
{
    func hitGetCategoriesApi(categoryId:String)
    func hitAddBusinessServiceApi(request: AddSalonService.Request)
    func addOnRequestValidation(request: addOn)
    func getOldData()
    func getServicesList()
}

protocol AddSalonServiceDataStore
{
    var dataDict: ListService.ViewModel.tableRowData?  { get set }
    var editService: String? { get set }
}

class AddSalonServiceInteractor: AddSalonServiceBusinessLogic, AddSalonServiceDataStore
{
    
    var presenter: AddSalonServicePresentationLogic?
    var worker: AddSalonServiceWorker?
    var dataDict: ListService.ViewModel.tableRowData?
    var editService: String?
    
    
    func getOldData() {
        self.presenter?.presentOldData(response: dataDict, editService: editService)
    }
    
    
    func hitGetCategoriesApi(categoryId:String)
    {
        worker = AddSalonServiceWorker()
        worker?.getCategoriesList(categoryId: categoryId, apiResponse: { (response) in
            self.presenter?.presentResponse(response: response)
        })
    }
    
    func getServicesList() {
        worker = AddSalonServiceWorker()
        worker?.getServicesList(apiResponse: { (response) in
            if response.code == 200 {
                printToConsole(item: response)
                self.presenter?.presentMainServiceResponse(response: response)
            }
            else if response.code == 404 {
                CommonFunctions.sharedInstance.showSessionExpireAlert()
            }
            else {
                CustomAlertController.sharedInstance.showErrorAlert(error: response.error!)
            }
        })
    }
    
    func hitEditBusinessServiceApi(serviceId: String) {
        worker = AddSalonServiceWorker()
    }
    
    func hitAddBusinessServiceApi(request: AddSalonService.Request) {
        worker = AddSalonServiceWorker()
        
        if isRequestValid(request: request) {
            
            let dataArray = NSMutableArray()
            for item in request.addOnArray {
                
                printToConsole(item: item.addOnSaloonPrice)
                var dict = [
                    "addonServiceType": item.addonServiceType,
                    "addOnName": item.addOnName,
                    "addOnSaloonPrice": item.addOnSaloonPrice,
                    "addOnHomePrice": item.addOnhomePrice,
                    "addOnDuration": item.addOnDuration,
                    ] as [String : Any]
                
                if item.addonServiceType == "home" {
                    dict["addOnSaloonPrice"] = ""
                }
                
                if item.addonServiceType == "salon" {
                    dict["addOnHomePrice"] = ""
                }
                
                dataArray.add(dict)
            }
            
            var param = [
                
                "addOn":dataArray,
                "businessId":getUserData(.businessId),
                "homePrice":request.homePrice,
                "salonPrice":request.salonPrice,
                "serviceMainId":request.maincategoryId,
                "serviceCategoryId":request.categoryId,
                "serviceDescription":request.serviceDescription,
                "serviceDuration":request.serviceDuration,
                "serviceName":request.serviceName,
                "serviceNameArabic":request.arabicName,
                "serviceDescriptionArabic":request.arabicDescription,
                "serviceType":request.serviceType,
                "serviceDurationNumber":request.serviceDurationNumber
                
                ] as [String : Any]
            
            if request.serviceType == "home" {
                param["salonPrice"] = "0"
            }
            if request.serviceType == "salon" {
                param["homePrice"] = "0"
            }
            
            
            if editService == "edit"{
                worker?.editBusinessServiceApi(id: (dataDict?.serviceId)!, parameters: param, apiResponse: { (response) in
                    if response.code == 200{
                        self.presenter?.presentServiceResponse(response: response)
                    }
                    else if response.code == 404 {
                        CommonFunctions.sharedInstance.showSessionExpireAlert()
                    }
                    else {
                        CustomAlertController.sharedInstance.showErrorAlert(error: response.error!)
                    }
                })
                
            }
            else {
                worker?.hitAddBusinessServiceApi(parameters: param, apiResponse: { (response) in
                    
                    if response.code == 200{
                        
              self.presenter?.presentServiceResponse(response: response)
                        
                    }
                    else if response.code == 404 {
                        CommonFunctions.sharedInstance.showSessionExpireAlert()
                    }
                    else {
                        CustomAlertController.sharedInstance.showErrorAlert(error: response.error!)
                    }
                })
            }
        }
    }
    
    func addOnRequestValidation(request: addOn) {
        
        if isAddOnRequestValid(request: request){
            
            self.presenter?.presentAddOnValidResponse(response: request)
        }
        
    }
    
    
    func isAddOnRequestValid(request: addOn) -> Bool {
        var addOnValid = true
        let validator = Validator()
        
        if !validator.validateRequired(request.addOnName, errorKey: localizedTextFor(key: AddSalonServiceSceneText.addSalonServiceSceneAddOnNameValidation.rawValue))  {
            addOnValid = false
        }
        else if request.addonServiceType == "both"{
            
            if !validator.validateRequired(request.addOnhomePrice, errorKey: localizedTextFor(key: AddSalonServiceSceneText.addSalonServiceSceneAddOnHomePriceValidation.rawValue))  {
                addOnValid = false
            }
                
            else if !validator.validateRequired(request.addOnSaloonPrice, errorKey: localizedTextFor(key: AddSalonServiceSceneText.addSalonServiceSceneAddOnSalonPriceValidation.rawValue))  {
                addOnValid = false
            }
            
        }
        else if request.addonServiceType == "home"{
            
            if !validator.validateRequired(request.addOnhomePrice, errorKey: localizedTextFor(key: AddSalonServiceSceneText.addSalonServiceSceneAddOnHomePriceValidation.rawValue))  {
                addOnValid = false
            }
            
        }
        else if request.addonServiceType == "salon"{
            
            if !validator.validateRequired(request.addOnSaloonPrice, errorKey: localizedTextFor(key: AddSalonServiceSceneText.addSalonServiceSceneAddOnSalonPriceValidation.rawValue))  {
                addOnValid = false
            }
        }
        
        return addOnValid
    }
    
    
    
    func isRequestValid(request: AddSalonService.Request) -> Bool {
        var isValid = true
        let validator = Validator()
        if !validator.validateRequired(request.maincategoryId, errorKey: localizedTextFor(key: AddSalonServiceSceneText.addSalonServiceSceneMainCategoryValidation.rawValue))  {
            isValid = false
        }
       else if !validator.validateRequired(request.categoryId, errorKey: localizedTextFor(key: AddSalonServiceSceneText.addSalonServiceSceneCategoryValidation.rawValue))  {
            isValid = false
        }
        else if !validator.validateRequired(request.serviceName, errorKey: localizedTextFor(key: AddSalonServiceSceneText.addSalonServiceSceneServiceNameValidation.rawValue))  {
            isValid = false
        }
            
        else if !validator.validateRequired(request.serviceDuration, errorKey: localizedTextFor(key: AddSalonServiceSceneText.addSalonServiceSceneDurationValidation.rawValue))  {
            isValid = false
        }
        else if request.serviceType == "both"{
            
            if !validator.validateRequired(request.homePrice, errorKey: localizedTextFor(key: AddSalonServiceSceneText.addSalonServiceSceneHomePriceValidation.rawValue))  {
                isValid = false
            }
                
            else if !validator.validateRequired(request.salonPrice, errorKey: localizedTextFor(key: AddSalonServiceSceneText.addSalonServiceSceneSalonPriceValidation.rawValue))  {
                isValid = false
            }
                
               
            
            else if (request.homePrice as NSString).floatValue <= 0.0 || (request.salonPrice as NSString).floatValue <= 0.0 {
                 CustomAlertController.sharedInstance.showErrorAlert(error: localizedTextFor(key: "price should be greater than zero"))
                isValid = false
            }
            
        }
        else if request.serviceType == "home"{
            
            if !validator.validateRequired(request.homePrice, errorKey: localizedTextFor(key: AddSalonServiceSceneText.addSalonServiceSceneHomePriceValidation.rawValue))  {
                isValid = false
                
            }
            
            else if (request.homePrice as NSString).floatValue <= 0.0 {
                CustomAlertController.sharedInstance.showErrorAlert(error: localizedTextFor(key: "price should be greater than zero"))
                 isValid = false
            }
            
        }
        else if request.serviceType == "salon"{
            
            if !validator.validateRequired(request.salonPrice, errorKey: localizedTextFor(key: AddSalonServiceSceneText.addSalonServiceSceneSalonPriceValidation.rawValue))  {
                isValid = false
                
            }
            else if (request.salonPrice as NSString).floatValue <= 0.0 {
                CustomAlertController.sharedInstance.showErrorAlert(error: localizedTextFor(key: "price should be greater than zero"))
                isValid = false
            }
            
        }
        
        
        return isValid
    }
    
}
