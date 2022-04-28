
import UIKit

protocol AddTherapistDisplayLogic: class
{
    func displayServiceResponse(comingFromEdit:Bool, viewModel: AddTherapist.SelectService.ViewModel)
    func displayHoursArray(response: [TherapistWorkingHours.ViewModel.tableCellData]?)
    func displayAddTherapistResponse(isAdd: Bool)
    func displayTherapistDetailResponse(viewModel: TherapistWorkingHours.ViewModel)
    func displayDisableResponse(isActive: Bool)
    func displayScheduledArray(response: [AddScheduledBreak.ViewModel.tableCellData]?)
    //Scheduled
    func displayApiResponse(viewModel: AddScheduledBreak.ViewModel)
    
}

class AddTherapistViewController: UIViewController, AddTherapistDisplayLogic
{
    
    
    var interactor: AddTherapistBusinessLogic?
    var router: (NSObjectProtocol & AddTherapistRoutingLogic & AddTherapistDataPassing)?
    
    // MARK: Object lifecycle
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?)
    {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK: Setup
    
    private func setup()
    {
        let viewController = self
        let interactor = AddTherapistInteractor()
        let presenter = AddTherapistPresenter()
        let router = AddTherapistRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
    
    // MARK: Routing
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if let scene = segue.identifier {
            let selector = NSSelectorFromString("routeTo\(scene)WithSegue:")
            if let router = router, router.responds(to: selector) {
                router.perform(selector, with: segue)
            }
        }
    }
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var nameTextField:UITextField!
    @IBOutlet weak var arabicNameTextField: UITextFieldCustomClass!
    @IBOutlet weak var jobTitleTxtField: UITextFieldCustomClass!
    @IBOutlet weak var jobTitleArabicTxtField: UITextFieldCustomClass!
    @IBOutlet weak var serviceTextField:UITextField!
    @IBOutlet weak var workingHoursTextField:UITextField!
    @IBOutlet weak var scheduledBreakTextField: UITextFieldCustomClass!
    @IBOutlet weak var continueButton:UIButton!
    
    @IBOutlet weak var disableButton: UIButtonCustomClass?
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var selectServiceMainView: UIView!
    @IBOutlet weak var selectServiceView: UIView!
    @IBOutlet weak var selectServiceLabel: UILabel!
    @IBOutlet weak var listServiceTableView: UITableView!
    @IBOutlet weak var cancelButton: UIButtonFontSize!
    @IBOutlet weak var doneButton: UIButtonFontSize!
    
    @IBOutlet weak var cameraBtnTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var cameraBtnLeadingConstraint: NSLayoutConstraint!
    
    var offset = 0
    var listServiceArray = [AddTherapist.SelectService.ViewModel.tableCellData]()
    var selectedServiceArray = [AddTherapist.SelectService.ViewModel.tableCellData]()
    var workingHoursArray = [TherapistWorkingHours.ViewModel.tableCellData]()
    var therapistImage: UIImage?
    var therapistID = ""
    var scheduledBreakArray = [AddScheduledBreak.ViewModel.tableCellData]()
    
    // MARK: View lifecycle
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        scrollView.manageKeyboard()
        arabicNameTextField.textAlignment = .right
        jobTitleArabicTxtField.textAlignment = .right
        hideBackButtonTitle()
        initialFunction()

        
        continueButton.setTitle(localizedTextFor(key: AddTherapistSceneText.addTherapistSceneSaveChangesButton.rawValue), for: UIControlState.selected)
        continueButton.setTitle(localizedTextFor(key: AddTherapistSceneText.addTherapistSceneContinueButton.rawValue), for: .normal)
        if disableButton != nil {
            disableButton?.setTitle(localizedTextFor(key: AddTherapistSceneText.addTherapistSceneDisableButton.rawValue), for: UIControlState.selected)
            disableButton?.setTitle(localizedTextFor(key: AddTherapistSceneText.addTherapistSceneEnableButton.rawValue), for: .normal)
        }
        
        let languageIdentifier = UserDefaults.standard.value(forKey: userDefualtKeys.currentLanguage.rawValue) as! String
        if languageIdentifier == Languages.Arabic {
            cameraBtnLeadingConstraint.isActive = true
            cameraBtnTrailingConstraint.isActive = false
        }
        else {
            cameraBtnLeadingConstraint.isActive = false
            cameraBtnTrailingConstraint.isActive = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        interactor?.getHoursArray()
        interactor?.getTherapistData()
        interactor?.getscheduledArray()
        applyLocalizedText()
        applyFontAndColor()
    }
    
    
    // MARK: Apply Font And Color
    func applyFontAndColor() {
      nameTextField.backgroundColor = apptxtfBackGroundColor
      arabicNameTextField.backgroundColor = apptxtfBackGroundColor
      jobTitleTxtField.backgroundColor = apptxtfBackGroundColor
      jobTitleArabicTxtField.backgroundColor = apptxtfBackGroundColor
      serviceTextField.backgroundColor = apptxtfBackGroundColor
      workingHoursTextField.backgroundColor = apptxtfBackGroundColor
      nameTextField.textColor = appTxtfDarkColor
      arabicNameTextField.textColor = appTxtfDarkColor
      serviceTextField.textColor = appTxtfDarkColor
      workingHoursTextField.textColor = appTxtfDarkColor
      cancelButton.setTitleColor(appBtnWhiteColor, for: .normal)
        cancelButton.backgroundColor = appBarThemeColor
        doneButton.setTitleColor(appBtnWhiteColor, for: .normal)
        doneButton.backgroundColor = appBarThemeColor
        disableButton?.backgroundColor = appBarThemeColor
        continueButton.backgroundColor = appBarThemeColor
    }
    
    // MARK: Apply LocalizedText
    func applyLocalizedText() {
     
        CommonFunctions.sharedInstance.setNavigationTitleView(titleStr:   localizedTextFor(key: AddTherapistSceneText.addTherapistSceneTitle.rawValue), onVC: self)
        
        let colorAttribute = [NSAttributedStringKey.foregroundColor: UIColor.darkGray]
        let nameTextFieldPlaceholder = NSMutableAttributedString(string: localizedTextFor(key: AddTherapistSceneText.addTherapistSceneNameFieldPlaceholder.rawValue), attributes: colorAttribute)
        nameTextFieldPlaceholder.append(asterik)
        nameTextField.attributedPlaceholder = nameTextFieldPlaceholder
        
        arabicNameTextField.attributedPlaceholder = NSMutableAttributedString(string: localizedTextFor(key: AddTherapistSceneText.addTherapistSceneArabicNameFieldPlaceholder.rawValue), attributes: colorAttribute)
        
        let jobTileTxtFldPlaceholder = NSMutableAttributedString(string: localizedTextFor(key: AddTherapistSceneText.addTherapistSceneJobTitleFieldPlaceholder.rawValue), attributes: colorAttribute)
        jobTileTxtFldPlaceholder.append(asterik)
        jobTitleTxtField.attributedPlaceholder = jobTileTxtFldPlaceholder
        
        
        jobTitleArabicTxtField.attributedPlaceholder = NSMutableAttributedString(string: localizedTextFor(key: AddTherapistSceneText.addTherapistSceneJobTitleArabicFieldPlaceholder.rawValue), attributes: colorAttribute)
        
        let serviceTextFieldPlaceholder = NSMutableAttributedString(string: localizedTextFor(key: AddTherapistSceneText.addTherapistSceneServicesFieldPlaceholder.rawValue), attributes: colorAttribute)
        serviceTextFieldPlaceholder.append(asterik)
        serviceTextField.attributedPlaceholder = serviceTextFieldPlaceholder
        
        let workingHoursTextFieldPlaceholder = NSMutableAttributedString(string: localizedTextFor(key: AddTherapistSceneText.addTherapistSceneWorkingHourFieldPlaceholder.rawValue), attributes: colorAttribute)
        workingHoursTextFieldPlaceholder.append(asterik)
        workingHoursTextField.attributedPlaceholder = workingHoursTextFieldPlaceholder
    }

    
    // MARK: Do something
    
    
    @IBAction func cancelButtonAction(_ sender: Any) {
        selectServiceView.isHidden = true
        selectServiceMainView.isHidden = true
    }
    
    @IBAction func disableButtonAction(_ sender: Any) {
        showAlert()
    }
    
    @IBAction func doneButtonAction(_ sender: Any) {
        
        if selectedServiceArray.count != 0 {
            serviceTextField.text = localizedTextFor(key: AddTherapistSceneText.addTherapistSceneServiceSelectedText.rawValue)
            selectServiceView.isHidden = true
            selectServiceMainView.isHidden = true
        }
        else {
            CustomAlertController.sharedInstance.showErrorAlert(error: localizedTextFor(key: AddTherapistSceneText.addTherapistSceneSelectServiceError.rawValue))
        }
    }
    
    func initialFunction()
    {
        interactor?.hitGetListServicesByBusinessIdApi(offset: offset)
        listServiceTableView.tableFooterView = UIView()
    }
    
    //Scheduled
    func displayApiResponse(viewModel: AddScheduledBreak.ViewModel) {
        
        scheduledBreakArray = viewModel.scheduledBreakArray
        if scheduledBreakArray.count != 0 {
            scheduledBreakTextField.text = localizedTextFor(key: AddTherapistSceneText.addTherapistSceneBreakSelectedText.rawValue)
        }
    }
    
    
    func displayServiceResponse(comingFromEdit:Bool, viewModel: AddTherapist.SelectService.ViewModel)
    {
        
        listServiceArray.append(contentsOf: viewModel.tableArray)
        printToConsole(item: listServiceArray)
        listServiceTableView.reloadData()
        
        
        printToConsole(item: viewModel.tableArray)
        
        if comingFromEdit {
            for (index, obj1) in viewModel.tableArray.enumerated() {
                let headerTitle = obj1.header.areaHeaderTitle
                printToConsole(item: headerTitle)
                
                let sectionObj = AddTherapist.SelectService.ViewModel.tableSectionData(areaHeaderTitle: obj1.header.areaHeaderTitle, businessCategoryId: obj1.header.businessCategoryId)
                
               // if index == 0 {
                    for (index, obj2) in obj1.businessServices.enumerated(){

                        printToConsole(item: obj1.businessServices)
                        let serviceId = obj2.businessServiceId
            
                        if index == 0 {
                            if obj2.isSelected {
                                let rowObj = AddTherapist.SelectService.ViewModel.tableRowData(serviceName: obj2.serviceName, businessServiceId: obj2.businessServiceId, serviceDuration: obj2.serviceDuration, isSelected: obj2.isSelected)
                                let array = AddTherapist.SelectService.ViewModel.tableCellData(header: sectionObj, businessServices: [rowObj])
                                selectedServiceArray.append(array)
                            }
                        }
                        else {
                            //var isObjFound = false
                            for (index, dataObj) in selectedServiceArray.enumerated() {
                                if dataObj.header.areaHeaderTitle == headerTitle {
                                    for obj2 in obj1.businessServices {
                                        printToConsole(item: obj2.businessServiceId)
                                        printToConsole(item: serviceId)
                                        
                                        if obj2.businessServiceId == serviceId {
                                            if obj2.isSelected {
                                                let rowObj = AddTherapist.SelectService.ViewModel.tableRowData(serviceName: obj2.serviceName, businessServiceId: obj2.businessServiceId, serviceDuration: obj2.serviceDuration, isSelected: obj2.isSelected)
                                                
                                                selectedServiceArray[index].businessServices.append(rowObj)
                                              //  isObjFound = true
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
            }
            
            serviceTextField.text = localizedTextFor(key: AddTherapistSceneText.addTherapistSceneServiceSelectedText.rawValue)
            
            
            nameTextField.text = viewModel.therapistName
            arabicNameTextField.text = viewModel.arabicTherapistName
            
            jobTitleTxtField.text = viewModel.jobTilte
            jobTitleArabicTxtField.text = viewModel.jobTilteArabic
            
            if viewModel.therapistProfileImage != "" {
                let imageUrl = viewModel.therapistProfileImage
                userImageView.sd_setImage(with: URL(string: imageUrl!), completed: nil)
            }
            therapistID = viewModel.therapistId!
            continueButton.isSelected = true
            disableButton?.isSelected = viewModel.isActive
            
            interactor?.HitListScheduleBreaks(offset: 0, therapistId: therapistID)
        }
            
        else {
            
            disableButton?.removeFromSuperview()
            continueButton.isSelected = false
        }
       
    }
    
    func displayHoursArray(response: [TherapistWorkingHours.ViewModel.tableCellData]?) {
        workingHoursArray = response!
        workingHoursTextField.text = localizedTextFor(key: AddTherapistSceneText.addTherapistSceneHoursSelectedText.rawValue)
    }
    
    func displayScheduledArray(response: [AddScheduledBreak.ViewModel.tableCellData]?) {
        scheduledBreakArray = response!
        
        if scheduledBreakArray.count == 0 {
            scheduledBreakTextField.text = "Select Schedule Break"
        }
        else {
            scheduledBreakTextField.text = localizedTextFor(key: AddTherapistSceneText.addTherapistSceneBreakSelectedText.rawValue)
        }
    }
    
    func displayAddTherapistResponse(isAdd: Bool) {
        
        if isAdd {
            CustomAlertController.sharedInstance.showAlert(subTitle: localizedTextFor(key: AddTherapistSceneText.addTherapistSceneAddTherapistSuccessMessage.rawValue), type: .success)
        }
        else {
            CustomAlertController.sharedInstance.showAlert(subTitle: localizedTextFor(key: AddTherapistSceneText.addTherapistSceneUpdateTherapistSuccessMessage.rawValue), type: .success)
        }
        router?.routeToTherapistList()
    }
    
    func displayTherapistDetailResponse(viewModel: TherapistWorkingHours.ViewModel) {
        workingHoursArray = viewModel.tableArray
        workingHoursTextField.text = localizedTextFor(key: AddTherapistSceneText.addTherapistSceneHoursSelectedText.rawValue)
    }
    
    
    func displayDisableResponse(isActive: Bool) {
        disableButton?.isSelected = isActive
    }
    
    @IBAction func cameraButtonAction(_ sender:AnyObject) {
        let customPicker = CustomImagePicker()
        customPicker.delegate = self
        customPicker.openImagePicker(controller: self, source: (sender as! UIButton))
    }
    
    @IBAction func continueButtonAction(_ sender:AnyObject) {
        let name = nameTextField.text_Trimmed()
        let request = AddTherapist.SelectService.Request(serviceArray: selectedServiceArray, hoursArray: workingHoursArray, name: name, arabicName: arabicNameTextField.text_Trimmed(), jobTitle: jobTitleTxtField.text_Trimmed(), jobTitleArabic: jobTitleArabicTxtField.text_Trimmed(), imageView: therapistImage, imageTitle: "therapistProfileImage", scheduledArray: scheduledBreakArray)
        
        
        if continueButton.isSelected {
            interactor?.hitSaveTherapistChangesApi(request: request, therapistId: therapistID)
        }
        else {
            interactor?.hitAddBusinessTherapistApi(request: request)
        }
        
        
    }
    
    @objc func categoryCheckBoxButtonAction(sender:UIButton) {
        printToConsole(item: selectedServiceArray)
        var v:UIView = sender
        repeat { v = v.superview! } while !(v is UITableViewCell)
        let cell = v as! AddTherapistRowTableViewCell
        let indexPath = listServiceTableView.indexPath(for:cell)!
        
        if listServiceArray[indexPath.section].businessServices[indexPath.row].isSelected {
            for (index, dataObj) in selectedServiceArray.enumerated() {
                
                if dataObj.header.businessCategoryId == listServiceArray[indexPath.section].header.businessCategoryId {
                    if  dataObj.businessServices.count == 1 {
                        selectedServiceArray.remove(at: index)
                    }
                    else {
                        for (serviceIndex, service) in selectedServiceArray[index].businessServices.enumerated() {
                            if service.businessServiceId == listServiceArray[indexPath.section].businessServices[indexPath.row].businessServiceId {
                                selectedServiceArray[index].businessServices.remove(at: serviceIndex)
                            }
                        }
                    }
                }
            }
        }
        else {
            let object = listServiceArray[indexPath.section]
            let servicesArrayObj = object.businessServices[indexPath.row]
            
            let title = object.header.areaHeaderTitle
            
            let dataObj = AddTherapist.SelectService.ViewModel.tableCellData(header: object.header , businessServices: [servicesArrayObj])
            
            var isObjFound = false
            for (index, dataObj) in selectedServiceArray.enumerated() {
                if dataObj.header.areaHeaderTitle == title {
                    selectedServiceArray[index].businessServices.append(servicesArrayObj)
                    isObjFound = true
                }
            }
            
            if !isObjFound {
                selectedServiceArray.append(dataObj)
            }
        }
        listServiceArray[indexPath.section].businessServices[indexPath.row].isSelected = !listServiceArray[indexPath.section].businessServices[indexPath.row].isSelected
        listServiceTableView.reloadData()
        printToConsole(item: selectedServiceArray)
        
    }
    
    func showAlert() {
        
        var alertText = ""
        var active = Bool()
        
        if (disableButton?.isSelected)!{
            alertText = localizedTextFor(key: AddTherapistSceneText.addTherapistSceneDisableTherapistText.rawValue)
            active = false
        }
        else {
            alertText = localizedTextFor(key: AddTherapistSceneText.addTherapistSceneEnableTherapistText.rawValue)
            active = true
        }
        
        let alertController = PMAlertController(textForegroundColor:UIColor.darkGray, viewBackgroundColor: UIColor.white, title:"" , description:alertText, image: nil , style: .alert)
        
        let yesButton = PMAlertAction(title: localizedTextFor(key: GeneralText.yes.rawValue), style: .default, action: {
            //alertController.dismiss(animated: true, completion: nil)
            self.interactor?.hitDisableTherapistApi(therapistId: self.therapistID, isActive: active)
        })
        
        let noButton = PMAlertAction(title: localizedTextFor(key: GeneralText.no.rawValue), style: .default, action: {
            alertController.dismiss(animated: true, completion: nil)
        })
        
        alertController.addAction(yesButton)
        alertController.addAction(noButton)
        
        present(alertController, animated: true, completion: nil)
    }
}


extension AddTherapistViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        if textField == serviceTextField {
            selectServiceView.isHidden = false
            selectServiceMainView.isHidden = false
            return false
        }
        else if textField == workingHoursTextField {
            self.router?.routeToTherapistWorkingHour(segue: nil, HoursArray: workingHoursArray)
            return false
        }
        else if textField == scheduledBreakTextField {
            self.router?.routeToAddScheduledBreak(segue: nil, therapistID: therapistID, scheduledBreakArray: scheduledBreakArray)
            return false
        }
        return true
    }
}

extension AddTherapistViewController : CustomImagePickerProtocol {
    func didFinishPickingImage(image:UIImage) {
        userImageView.image = image
        therapistImage = image
    }
}

extension AddTherapistViewController : UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return listServiceArray.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerCell = tableView.dequeueReusableCell(withIdentifier: "HeaderCell") as! AddTherapistSectionTableViewCell
        headerCell.backgroundColor = appBarThemeColor
        headerCell.contentView.backgroundColor = appBarThemeColor
        let sectionObject = listServiceArray[section]
        headerCell.serviceTitleNameLabel.text = sectionObject.header.areaHeaderTitle
        return headerCell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let sectionObject = listServiceArray[section]
        let rowsObject = sectionObject.businessServices
        return rowsObject.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReUseIdentifier, for: indexPath) as! AddTherapistRowTableViewCell
        
        let sectionObject = listServiceArray[indexPath.section]
        let rowsObject = sectionObject.businessServices
        cell.serviceNameLabel.text = rowsObject[indexPath.row].serviceName
        cell.selectedButton.isSelected = rowsObject[indexPath.row].isSelected
        cell.selectedButton.addTarget(self, action: #selector(self.categoryCheckBoxButtonAction(sender:)), for: .touchUpInside)
        return cell
    }
    
    func didCancelPickingImage() {
        
    }
}




