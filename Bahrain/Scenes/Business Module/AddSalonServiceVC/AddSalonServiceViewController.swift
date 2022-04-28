

import UIKit

protocol AddSalonServiceDisplayLogic: class
{
    func displayResponse(viewModel: AddSalonService.ViewModel)
    func displayAddOnValidResponse(response: addOn)
    func displayOldData(response: ListService.ViewModel.tableRowData?, editService: String?)
    func displayServiceResponse()
    func displayMainCategoryResponse(viewModel: AddSalonService.MainCategoryViewModel)
    
}

class AddSalonServiceViewController: UIViewController, AddSalonServiceDisplayLogic
{
    
    var interactor: AddSalonServiceBusinessLogic?
    var router: (NSObjectProtocol & AddSalonServiceRoutingLogic & AddSalonServiceDataPassing)?
    
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
        let interactor = AddSalonServiceInteractor()
        let presenter = AddSalonServicePresenter()
        let router = AddSalonServiceRouter()
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
    ////////////////////////////////////////////////////////////////////
    
    @IBOutlet weak var homeLabel: UILabel!
    @IBOutlet weak var salonLabel: UILabel!
    @IBOutlet weak var homeButton: UIButton!
    @IBOutlet weak var salonButton: UIButton!
    @IBOutlet weak var mainCategoyTextField: UITextFieldFontSize!
    @IBOutlet weak var selectServiceCategoryTextField: UITextField!
    @IBOutlet weak var serviceNameTextField: UITextField!
    @IBOutlet weak var arabicNameTextField: UITextFieldFontSize!
    @IBOutlet weak var homePriceView: UIView!
    @IBOutlet weak var homePriceTextField: UITextField!
    @IBOutlet weak var homePriceLabel: UILabel!
    @IBOutlet weak var salonPriceView: UIView!
    @IBOutlet weak var salonPriceTextField: UITextField!
    @IBOutlet weak var salonPriceLabel: UILabel!
    @IBOutlet weak var durationTextField: UITextField!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var aboutServiceTextView: UITextView!
    @IBOutlet weak var arabicAboutTextView: UITextViewFontSize!
    @IBOutlet weak var addOnContentView: UIViewCustomClass!
    @IBOutlet weak var moreAddOnLabel: UILabel!
    @IBOutlet weak var addOnPlusImg: UIImageView!
    @IBOutlet weak var addOnHomeLabel: UILabel!
    @IBOutlet weak var addOnSalonLabel: UILabel!
    @IBOutlet weak var addOnNameTextField: UITextField!
    @IBOutlet weak var addOnHomePriceView: UIView!
    @IBOutlet weak var addOnHomePriceTextField: UITextField!
    @IBOutlet weak var addOnHomePriceLabel: UILabel!
    @IBOutlet weak var addOnSalonPriceView: UIView!
    @IBOutlet weak var addOnSalonPriceTextField: UITextField!
    @IBOutlet weak var addOnSalonPriceLabel: UILabel!
    @IBOutlet weak var addOnDurationTextField: UITextFieldFontSize!
    @IBOutlet weak var saveButton: UIButtonCustomClass!
    @IBOutlet weak var cancelButton: UIButtonCustomClass!
    @IBOutlet weak var continueButton: UIButtonCustomClass!
    @IBOutlet weak var addOnHomeButton: UIButton!
    @IBOutlet weak var addOnSalonButton: UIButton!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var addOnStackView: UIStackView!
    @IBOutlet  var addOnViewZeroHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var addOnStaticLabel: UILabel!
    @IBOutlet weak var addOnLabelTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var addOnTableView: UITableView!
    @IBOutlet weak var addOnTableHieghtContraints: NSLayoutConstraint!
    @IBOutlet weak var moreAddOnViewHeightConstraints: NSLayoutConstraint!
    
    var serviceCategoryArray = [AddSalonService.ViewModel.pickerData]()
    var addOnServiceArray = [addOn]()
    var mainCategoryId = String()
    var categoryId = String()
    var dummyIndex:Int?
    let serviceCategoryPicker = UIPickerView()
    var mainCategoryArray = [AddSalonService.MainCategoryViewModel.mainCategoryData]()
    //var durationPicker = UIPickerView()
     var totalMinutes = 0
     var isFromEdit = false
    
    var numberPick = ["1", "2", "3", "4", "5", "6","7","8","9","10","11", "12", "13", "14", "15", "16","17","18","19","20","21", "22", "23", "24", "25", "26","27","28","29","30","31", "32", "33", "34", "35", "36","37","38","39","40","41", "42", "43", "44", "45", "46","47","48","49","50","51", "52", "53", "54", "55", "56","57","58","59"]
    
    // MARK: View lifecycle
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        arabicNameTextField.textAlignment = .right
        initialFunction()
        applyLocalizedText()
        applyFontAndColor()
        scrollView.manageKeyboard()
        homePriceView.isHidden = true
        addOnHomePriceView.isHidden = true
        hideBackButtonTitle()
        addObserverOnTableViewReload()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        interactor?.getOldData()
        
    }
    
    // MARK: Apply Font And Color
    func applyFontAndColor() {
        homeLabel.textColor = appTxtfDarkColor
        salonLabel.textColor = appTxtfDarkColor
        homePriceView.backgroundColor = apptxtfBackGroundColor
        selectServiceCategoryTextField.backgroundColor = apptxtfBackGroundColor
        serviceNameTextField.backgroundColor = apptxtfBackGroundColor
        arabicNameTextField.backgroundColor = apptxtfBackGroundColor
        salonPriceTextField.backgroundColor = apptxtfBackGroundColor
        mainCategoyTextField.backgroundColor = apptxtfBackGroundColor
        durationTextField.backgroundColor = apptxtfBackGroundColor
        aboutServiceTextView.backgroundColor = apptxtfBackGroundColor
        arabicAboutTextView.backgroundColor = apptxtfBackGroundColor
        moreAddOnLabel.backgroundColor = apptxtfBackGroundColor
        moreAddOnLabel.textColor = appTxtfDarkColor
        continueButton.backgroundColor = appBarThemeColor
        selectServiceCategoryTextField.textColor = appTxtfDarkColor
        serviceNameTextField.textColor = appTxtfDarkColor
        selectServiceCategoryTextField.textColor = appTxtfDarkColor
        salonPriceTextField.textColor = appTxtfDarkColor
        durationTextField.textColor = appTxtfDarkColor
        aboutServiceTextView.textColor = appTxtfDarkColor
        moreAddOnLabel.textColor = appTxtfDarkColor
        continueButton.setTitleColor(appBtnWhiteColor, for: .normal)
        addOnNameTextField.backgroundColor = apptxtfBackGroundColor
        addOnNameTextField.textColor = appTxtfDarkColor
        addOnSalonPriceTextField.backgroundColor = apptxtfBackGroundColor
        addOnSalonPriceTextField.textColor = appTxtfDarkColor
        addOnDurationTextField.backgroundColor = apptxtfBackGroundColor
        addOnDurationTextField.textColor = appTxtfDarkColor
        cancelButton.backgroundColor = UIColor.gray
        saveButton.backgroundColor = appBarThemeColor
        continueButton.setTitleColor(appBtnWhiteColor, for: .normal)
        addOnSalonButton.setTitleColor(appBtnWhiteColor, for: .normal)
    }
    
    // MARK: Apply LocalizedText
    func applyLocalizedText() {
        aboutServiceTextView.layer.cornerRadius = 8
        arabicAboutTextView.layer.cornerRadius = 8
        
        let colorAttribute = [NSAttributedStringKey.foregroundColor: UIColor.darkGray]
        CommonFunctions.sharedInstance.setNavigationTitleView(titleStr:   localizedTextFor(key: AddSalonServiceSceneText.addSalonServiceSceneTitle.rawValue), onVC: self)
        
        homeLabel.text = localizedTextFor(key: AddSalonServiceSceneText.addSalonServiceSceneHomeLabel.rawValue)
        
        salonLabel.text = localizedTextFor(key: AddSalonServiceSceneText.addSalonServiceSceneSalonLabel.rawValue)
        
        let mainCategoryTextFieldPlaceholder = NSMutableAttributedString(string: localizedTextFor(key: AddSalonServiceSceneText.addSalonServiceSceneMainCategoryTextFieldPlaceholder.rawValue), attributes: colorAttribute)
        mainCategoryTextFieldPlaceholder.append(asterik)
        mainCategoyTextField.attributedPlaceholder = mainCategoryTextFieldPlaceholder
        
        let selectServiceCategoryTextFieldPlaceholder = NSMutableAttributedString(string: localizedTextFor(key: AddSalonServiceSceneText.addSalonServiceSceneSelectServiceCategoryTextFieldPlaceholder.rawValue), attributes: colorAttribute)
        selectServiceCategoryTextFieldPlaceholder.append(asterik)
        selectServiceCategoryTextField.attributedPlaceholder = selectServiceCategoryTextFieldPlaceholder
        
        let serviceNameTextFieldPlaceholder = NSMutableAttributedString(string: localizedTextFor(key: AddSalonServiceSceneText.addSalonServiceSceneServiceNameTextFieldPlaceholder.rawValue), attributes: colorAttribute)
        serviceNameTextFieldPlaceholder.append(asterik)
        serviceNameTextField.attributedPlaceholder = serviceNameTextFieldPlaceholder
        
        let arabicNameTextFieldPlaceholder = NSMutableAttributedString(string: localizedTextFor(key: AddSalonServiceSceneText.addSalonServiceSceneArabicNameTextFieldPlaceholder.rawValue), attributes: colorAttribute)
        arabicNameTextField.attributedPlaceholder = arabicNameTextFieldPlaceholder
        
        
        let homePriceTextFieldPlaceholder = NSMutableAttributedString(string: localizedTextFor(key: AddSalonServiceSceneText.addSalonServiceSceneHomePriceTextFieldPlaceholder.rawValue), attributes: colorAttribute)
        homePriceTextFieldPlaceholder.append(asterik)
        homePriceTextField.attributedPlaceholder = homePriceTextFieldPlaceholder
        
        homePriceLabel.text = localizedTextFor(key: GeneralText.bhd.rawValue)
        
        let salonPriceTextFieldPlaceholder = NSMutableAttributedString(string: localizedTextFor(key: AddSalonServiceSceneText.addSalonServiceSceneSalonPriceTextFieldPlaceholder.rawValue), attributes: colorAttribute)
        salonPriceTextFieldPlaceholder.append(asterik)
        salonPriceTextField.attributedPlaceholder = salonPriceTextFieldPlaceholder
        
        salonPriceLabel.text = localizedTextFor(key: GeneralText.bhd.rawValue)
        
        let durationTextFieldPlaceholder = NSMutableAttributedString(string: localizedTextFor(key: AddSalonServiceSceneText.addSalonSceneDurationTextFieldPlaceholder.rawValue), attributes: colorAttribute)
        durationTextFieldPlaceholder.append(asterik)
        durationTextField.attributedPlaceholder = durationTextFieldPlaceholder
        
        durationLabel.text = localizedTextFor(key: AddSalonServiceSceneText.addSalonServiceSceneDurationLabel.rawValue)
        
        let  aboutServiceTextViewPlaceholder = NSMutableAttributedString(string:  "  " + localizedTextFor(key: AddSalonServiceSceneText.addSalonServiceSceneAboutServiceTextView.rawValue), attributes: colorAttribute)
        aboutServiceTextView.attributedPlaceholder = aboutServiceTextViewPlaceholder
        
        let  arabicAboutTextViewPlaceholder = NSMutableAttributedString(string:  "  " + localizedTextFor(key: AddSalonServiceSceneText.addSalonServiceSceneArabicAboutTextView.rawValue), attributes: colorAttribute)
        arabicAboutTextView.attributedPlaceholder = arabicAboutTextViewPlaceholder
        
        moreAddOnLabel.text = localizedTextFor(key: AddSalonServiceSceneText.addSalonServiceSceneMoreAddOnLabel.rawValue)
        
        addOnHomeLabel.text = localizedTextFor(key: AddSalonServiceSceneText.addSalonServiceSceneAddOnHomeLabel.rawValue)
        
        addOnSalonLabel.text = localizedTextFor(key: AddSalonServiceSceneText.addSalonServiceSceneAddOnSalonLabel.rawValue)
        
        
        let addOnNameTextFieldPlaceholder = NSMutableAttributedString(string: localizedTextFor(key: AddSalonServiceSceneText.addSalonServiceSceneAddOnNameTextFieldPlaceholder.rawValue), attributes: colorAttribute)
        addOnNameTextFieldPlaceholder.append(asterik)
        addOnNameTextField.attributedPlaceholder = addOnNameTextFieldPlaceholder
        
        
        let  addOnHomePriceTextFieldPlaceholder = NSMutableAttributedString(string: localizedTextFor(key: AddSalonServiceSceneText.addSalonServiceSceneAddOnHomePriceTextFieldPlaceholder.rawValue), attributes: colorAttribute)
        addOnHomePriceTextFieldPlaceholder.append(asterik)
        addOnHomePriceTextField.attributedPlaceholder = addOnHomePriceTextFieldPlaceholder
        
        addOnHomePriceLabel.text = localizedTextFor(key: GeneralText.bhd.rawValue)
        
        let  addOnSalonPriceTextFieldPlaceholder = NSMutableAttributedString(string: localizedTextFor(key: AddSalonServiceSceneText.addSalonServiceSceneAddOnSalonPriceTextFieldPlaceholder.rawValue), attributes: colorAttribute)
        addOnSalonPriceTextFieldPlaceholder.append(asterik)
        addOnSalonPriceTextField.attributedPlaceholder = addOnSalonPriceTextFieldPlaceholder
        
        addOnSalonPriceLabel.text = localizedTextFor(key: GeneralText.bhd.rawValue)
        
        let addOnDurationTextFieldPlaceholder = NSMutableAttributedString(string: localizedTextFor(key: AddSalonServiceSceneText.addSalonServiceSceneAddOnDurationTextFieldPlaceholder.rawValue), attributes: colorAttribute)
        addOnDurationTextFieldPlaceholder.append(asterik)
        addOnDurationTextField.attributedPlaceholder = addOnDurationTextFieldPlaceholder
        
        
        saveButton.setTitle(localizedTextFor(key: AddSalonServiceSceneText.addSalonServiceSceneSaveButton.rawValue), for: .normal)
        
        cancelButton.setTitle(localizedTextFor(key: AddSalonServiceSceneText.addSalonServiceSceneCancelButton.rawValue), for: .normal)
        
        addOnStaticLabel.text = localizedTextFor(key: AddSalonServiceSceneText.addSalonServiceSceneMoreAddOnColonLabel.rawValue)
        
    }
    
    // MARK: AddObserverOnTableViewReload
    func addObserverOnTableViewReload() {
        addOnTableView.addObserver(self, forKeyPath: tableContentSize, options: .new, context: nil)
    }
    
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let obj = object as? UITableView {
            if obj == addOnTableView && keyPath == tableContentSize {
                if (change?[NSKeyValueChangeKey.newKey] as? CGSize) != nil {
                    addOnTableHieghtContraints.constant = addOnTableView.contentSize.height
                }
            }
        }
    }
    
    deinit {
        addOnTableView.removeObserver(self, forKeyPath: tableContentSize)
    }
    
    // MARK: Button Actions
    
    @IBAction func homeButton(_ sender: UIButton) {
        if sender.isSelected {
            sender.isSelected = false
            addOnHomeButton.isSelected = false
            homePriceView.isHidden = true
            
            addOnHomeButton.isSelected = false
            addOnHomePriceView.isHidden = true
            
        }else{
            sender.isSelected = true
            homePriceView.isHidden = false
            
            addOnHomeButton.isSelected = true
            addOnHomePriceView.isHidden = false
        }
    }
    
    @IBAction func salonButton(_ sender: UIButton) {
        
        if sender.isSelected {
            sender.isSelected = false
            salonPriceView.isHidden = true
            addOnSalonButton.isSelected = false
            addOnSalonPriceView.isHidden = true
            
        }else{
            sender.isSelected = true
            salonPriceView.isHidden = false
            addOnSalonButton.isSelected = true
            addOnSalonPriceView.isHidden = false
        }
    }
    
    @IBAction func addOnButton(_ sender: UIButton) {
        
        if sender.isSelected {
            addOnViewZeroHeightConstraint.isActive = false
            sender.isSelected = false
            addOnPlusImg.isHighlighted = true
        }
        else{
            addOnViewZeroHeightConstraint.isActive = true
            sender.isSelected = true
            addOnPlusImg.isHighlighted = false
        }
    }
    
    @IBAction func addOnHomeButton(_ sender: UIButton) {
        if sender.isSelected {
            sender.isSelected = false
            addOnHomePriceView.isHidden = true
        }else{
            sender.isSelected = true
            addOnHomePriceView.isHidden = false
        }
    }
    
    @IBAction func addOnSalonButton(_ sender: UIButton) {
        if sender.isSelected {
            sender.isSelected = false
            addOnSalonPriceView.isHidden = true
        }else{
            sender.isSelected = true
            addOnSalonPriceView.isHidden = false
        }
    }
    
    @IBAction func saveButtonAction(_ sender: Any) {
        var addServiceType = ""
        
        if addOnHomeButton.isSelected {
            addServiceType = salonTypes.home.rawValue
        }
        
        if addOnSalonButton.isSelected {
            addServiceType = salonTypes.salon.rawValue
        }
        
        if addOnHomeButton.isSelected && addOnSalonButton.isSelected {
            addServiceType = salonTypes.both.rawValue
        }
        
        let obj = addOn(addonServiceType: addServiceType, addOnName: addOnNameTextField.text!, addOnSaloonPrice: addOnSalonPriceTextField.text!, addOnhomePrice: addOnHomePriceTextField.text!, addOnDuration: addOnDurationTextField.text!)
        
        printToConsole(item: obj)
        
        interactor?.addOnRequestValidation(request: obj)
        
    }
    
    func displayAddOnValidResponse(response: addOn) {
        
        let obj = response
        
        
        if let index = dummyIndex {
            addOnServiceArray.remove(at: index)
            addOnServiceArray.insert(obj, at: index)
        }
        else {
            addOnServiceArray.append(obj)
        }
        addOnTableView.reloadData()
        
        addOnStaticLabel.isHidden = false
        addOnLabelTopConstraint.constant = 10
        tableTopConstraint.constant = 10
        
        dummyIndex = nil
        addOnViewZeroHeightConstraint.isActive = true
        moreAddOnViewHeightConstraints.constant = 45
        
        addOnNameTextField.text = ""
        addOnSalonPriceTextField.text = ""
        addOnHomePriceTextField.text = ""
        addOnDurationTextField.text = ""
    }
    
    
    @IBAction func cancelButtonAction(_ sender: Any) {
        
        moreAddOnViewHeightConstraints.constant = 45
        addOnViewZeroHeightConstraint.isActive = true
        
        //addOnPlusImg.isHighlighted = false
        addOnNameTextField.text = ""
        addOnSalonPriceTextField.text = ""
        addOnHomePriceTextField.text = ""
        addOnDurationTextField.text = ""
        
    }
    
    @IBAction func continueButtonAction(_ sender: Any) {
        
        var serviceType = ""
        
        if homeButton.isSelected {
            serviceType = salonTypes.home.rawValue
        }
        
        if salonButton.isSelected {
            serviceType = salonTypes.salon.rawValue
        }
        
        if homeButton.isSelected && salonButton.isSelected {
            serviceType = salonTypes.both.rawValue
        }
        
        let request = AddSalonService.Request(maincategoryId: mainCategoryId, serviceType: serviceType, categoryId: categoryId, serviceName: serviceNameTextField.text_Trimmed(), arabicName: arabicNameTextField.text_Trimmed(), homePrice: homePriceTextField.text_Trimmed(), salonPrice: salonPriceTextField.text_Trimmed(), serviceDuration: durationTextField.text_Trimmed(), serviceDurationNumber: totalMinutes, serviceDescription: aboutServiceTextView.text_Trimmed(), arabicDescription: arabicAboutTextView.text_Trimmed(), addOnArray: addOnServiceArray)
        
        
        interactor?.hitAddBusinessServiceApi(request: request)
        
    }
    
    
    @objc func deleteButtonAction(sender:UIButton) {
        var v:UIView = sender
        repeat { v = v.superview! } while !(v is UITableViewCell)
        let cell = v as! AddSalonServiceTableViewCell
        let indexPath = addOnTableView.indexPath(for:cell)!
        
        addOnServiceArray.remove(at: indexPath.section)
        addOnTableView.reloadData()
        
        if addOnServiceArray.count == 0 {
            addOnStaticLabel.isHidden = true
            addOnLabelTopConstraint.constant = 0
            tableTopConstraint.constant = 0
        }
    }
    
    
    
    // MARK: Other Functions
    
    func initialFunction() {
        interactor?.getServicesList()
    }
    
    
    //MARK:- Handle DatePicker Target
    
    @objc func handleTimePicker(sender: UIDatePicker){
        
        let calendar = getCalendar()
        let hour = calendar.component(.hour, from: sender.date)
        let minutes = calendar.component(.minute, from: sender.date)
        totalMinutes = hour * 60 + minutes
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = UaeTimeZone
        let requiredFormat = "HH' hours 'mm' mins'"
        dateFormatter.dateFormat = requiredFormat
        
        var dateFormatterString =  dateFormatter.string(from: sender.date)
        if dateFormatterString.contains("00 hours") {
            dateFormatterString = dateFormatterString.replacingOccurrences(of: "00 hours", with: "")
        }
        
        if dateFormatterString.contains("00 mins") {
            dateFormatterString = dateFormatterString.replacingOccurrences(of: "00 mins", with: "")
        }
        
        
        printToConsole(item: dateFormatterString)
        durationTextField.text = dateFormatterString
    }
    
    @objc func addOnHandleTimePicker(sender: UIDatePicker){
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = UaeTimeZone
        let requiredFormat = "HH' hours 'mm' mins'"
        dateFormatter.dateFormat = requiredFormat
        var dateFormatterString = dateFormatter.string(from: sender.date)
       
        printToConsole(item: dateFormatterString)
        if dateFormatterString.contains("00 hours ") {
            dateFormatterString = dateFormatterString.replacingOccurrences(of: "00 hours", with: "")
        }
        
        if dateFormatterString.contains(" 00 mins") {
            dateFormatterString = dateFormatterString.replacingOccurrences(of: "00 mins", with: "")
        }
        addOnDurationTextField.text = dateFormatterString
    }
    
    
    
    @objc func dismissPicker() {
        self.view.endEditing(true)
    }
    
    
    //MARK:- Display Response
    
    func displayMainCategoryResponse(viewModel: AddSalonService.MainCategoryViewModel) {
        mainCategoryArray = viewModel.mainCategoryArray
    }
    
    
    func displayResponse(viewModel: AddSalonService.ViewModel)
    {
        if let errorString = viewModel.errorString {
            CustomAlertController.sharedInstance.showErrorAlert(error: errorString)
        }
        else {
            serviceCategoryArray = viewModel.pickerArray
            serviceCategoryPicker.dataSource = self
            serviceCategoryPicker.delegate = self
            serviceCategoryPicker.tag = 100
            self.selectServiceCategoryTextField.inputView = serviceCategoryPicker
            
            if serviceCategoryArray.count != 0 {
                self.selectServiceCategoryTextField.becomeFirstResponder()
            }
        }
    }
    
    
    func displayOldData(response: ListService.ViewModel.tableRowData?, editService: String?) {
        
        if editService == salonTypes.edit.rawValue {
            isFromEdit = true
            if response?.serviceType == salonTypes.both.rawValue {
                homeButton.isSelected = true
                salonButton.isSelected = true
                homePriceView.isHidden = false
                salonPriceView.isHidden = false
                salonPriceTextField.text = String(format: "%.3f", (response?.salonPrice.floatValue)!)
                homePriceTextField.text = String(format: "%.3f", (response?.homePrice.floatValue)!)
            }
            if response?.serviceType == salonTypes.home.rawValue {
                homeButton.isSelected = true
                salonButton.isSelected = false
                homePriceView.isHidden = false
                salonPriceView.isHidden = true
                homePriceTextField.text = String(format: "%.3f", (response?.homePrice.floatValue)!)
            }
            
            if response?.serviceType == salonTypes.salon.rawValue {
                salonButton.isSelected = true
                homeButton.isSelected = false
                homePriceView.isHidden = true
                salonPriceView.isHidden = false
                homePriceView.isHidden = true
                salonPriceTextField.text = String(format: "%.3f", (response?.salonPrice.floatValue)!)
                
            }
            
            
            totalMinutes = response?.serviceDurationNumber as! Int
            
            mainCategoryId = response?.serviceMainId ?? ""
            mainCategoyTextField.isUserInteractionEnabled = false
            selectServiceCategoryTextField.isUserInteractionEnabled = false
            
            mainCategoyTextField.text = response?.serviceMainName
            selectServiceCategoryTextField.text = response?.categoryName
            serviceNameTextField.text = response?.serviceName
            arabicNameTextField.text = response?.arabicServiceName
            
            durationTextField.text = response?.serviceDuration
            aboutServiceTextView.text = response?.serviceDescription
            arabicAboutTextView.text = response?.arabicServiceDescription
            
            categoryId = (response?.categoryId)!
            
            for obj in (response?.addOnData)! {
                
                printToConsole(item: obj)
                
                addOnServiceArray.append(obj)
            }
            addOnTableView.reloadData()
            
            continueButton.setTitle(localizedTextFor(key: AddSalonServiceSceneText.addSalonServiceSceneContinueSaveChangesButton.rawValue), for: .normal)
            
            addOnViewZeroHeightConstraint.isActive = true
            
        }
        else {
            continueButton.setTitle(localizedTextFor(key: AddSalonServiceSceneText.addSalonServiceSceneContinueButton.rawValue), for: .normal)
        }
        
    }
    func displayServiceResponse() {
        var message = ""
        if isFromEdit {
            message = localizedTextFor(key: GeneralText.serviceUpdated.rawValue)
        }else {
            message = localizedTextFor(key: GeneralText.serviceAdded.rawValue)
        }
        
        CustomAlertController.sharedInstance.showAlert(subTitle: message, type: .success)
        router?.routeToListService()
    }
}

//MARK:- UIPickerViewDelegate
extension AddSalonServiceViewController : UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 1{
            return mainCategoryArray.count
        }
        else if serviceCategoryPicker.tag == 100 {
            return serviceCategoryArray.count
        }else if serviceCategoryPicker.tag == 200{
            return numberPick.count
        }else{
            return numberPick.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 1{
            let obj = mainCategoryArray[row]
            return obj.categoryName
        }
        else if serviceCategoryPicker.tag == 100 {
            let obj = serviceCategoryArray[row]
            return obj.serviceName
        }
        else if serviceCategoryPicker.tag == 200{
            let obj = numberPick[row]
            durationTextField.text = obj
            return obj
        }
        else{
            let obj = numberPick[row]
            addOnDurationTextField.text = obj
            return obj
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        if pickerView.tag == 1{
            let obj = mainCategoryArray[row]
            mainCategoyTextField.text = obj.categoryName
            mainCategoryId = obj.categoryId
            serviceCategoryArray.removeAll()
            selectServiceCategoryTextField.text = ""
        }
        else if serviceCategoryPicker.tag == 100 {
            let obj = serviceCategoryArray[row]
            selectServiceCategoryTextField.text = obj.serviceName
            categoryId = obj.categoryId
        }else if serviceCategoryPicker.tag == 200{
            let obj = numberPick[row]
            durationTextField.text =  obj + " " + localizedTextFor(key: AddSalonServiceSceneText.addSalonServiceScenemins.rawValue)
        }else{
            let obj = numberPick[row]
            addOnDurationTextField.text =  obj + " " + localizedTextFor(key: AddSalonServiceSceneText.addSalonServiceScenemins.rawValue)
        }
        return
    }
}

//MARK:- UITextFieldDelegate
extension AddSalonServiceViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        if textField == mainCategoyTextField {
            let serviceCategoryPicker = UIPickerView()
            serviceCategoryPicker.dataSource = self
            serviceCategoryPicker.delegate = self
            self.mainCategoyTextField.inputView = serviceCategoryPicker
            serviceCategoryPicker.tag = 1
            
        }

      else  if textField == selectServiceCategoryTextField {
            if serviceCategoryArray.count == 0 {
                interactor?.hitGetCategoriesApi(categoryId: mainCategoryId)
                return false
            }
            else {
                return true
            }
            
        } else if textField == durationTextField{
            
            //  durationTextField.inputAccessoryView = UIToolbar().ToolbarPiker(mySelect: #selector(AddSalonServiceViewController.dismissPicker))
            
            
            //            serviceCategoryPicker.dataSource = self
            //            serviceCategoryPicker.delegate = self
            //            serviceCategoryPicker.tag = 200
            //            durationTextField.inputView = serviceCategoryPicker
            
            
            
            let now = Date()
            let datePickerView = UIDatePicker()
            datePickerView.timeZone = UaeTimeZone
            datePickerView.datePickerMode = .time
            var calendar = getCalendar()
            calendar.timeZone = UaeTimeZone!
            datePickerView.minimumDate = calendar.date(bySettingHour: 0, minute: 0, second: 0, of: now)
            datePickerView.maximumDate = calendar.date(bySettingHour: 5, minute: 45, second: 0, of: now)
            
            datePickerView.minuteInterval = 15
            let locale = Locale(identifier: "ro_RO")
            datePickerView.locale = locale
            
            if isCurrentLanguageArabic() {
                for views in datePickerView.subviews {
                    views.semanticContentAttribute = .forceRightToLeft
                }
            }
            
            textField.inputView = datePickerView
            datePickerView.addTarget(self, action: #selector(handleTimePicker(sender:)), for: .valueChanged)
            
        }
            
        else if textField == addOnDurationTextField{
            
            self.resignFirstResponder()
            
            serviceCategoryPicker.dataSource = self
            serviceCategoryPicker.delegate = self
            serviceCategoryPicker.tag = 300
            addOnDurationTextField.inputView = serviceCategoryPicker
            
            //            addOnDurationTextField.inputAccessoryView = UIToolbar().ToolbarPiker(mySelect: #selector(AddSalonServiceViewController.dismissPicker))
            //
            //            let datePickerView = UIDatePicker()
            //            datePickerView.datePickerMode = .time
            //            let locale = Locale(identifier: "ro_RO")
            //            datePickerView.locale = locale
            //            textField.inputView = datePickerView
            //            datePickerView.addTarget(self, action: #selector(addOnHandleTimePicker(sender:)), for: .valueChanged)
            
        }
        return true
    }
    
    func textField(_ textField: UITextField,shouldChangeCharactersIn range: NSRange,replacementString string: String) -> Bool
    {
        if textField == salonPriceTextField || textField == homePriceTextField || textField == addOnSalonPriceTextField || textField == addOnHomePriceTextField {
            
            
            ///////////////////------Disallow another language numbers ------------//////////////////
            
            let disallowedCharacterSet = NSCharacterSet(charactersIn: "0123456789.").inverted
            if (string.rangeOfCharacter(from: disallowedCharacterSet)) != nil {
                CustomAlertController.sharedInstance.showErrorAlert(error: localizedTextFor(key: GeneralText.englishDigitsError.rawValue))
                return false
            }
            
            
            ////////////////////////////////////////////////////////////////////////////////////////
            
            
            
            
            //           ///////////////////------Avoid decimal at start ------------//////////////////
            //
            //          let currentText = textField.text ?? ""
            //          if currentText == "" {
            //            if string == "." {
            //              return false
            //            }
            //          }
            
            
            ////////////////////////////////////////////////////////////////////////////////////////
            
            
            
            
            ///////////////////------Disallow multiple decimal ------------//////////////////
            
            let array = Array(textField.text ?? "")
            var decimalCount = 0
            for character in array {
                if character == "." {
                    decimalCount += 1
                }
            }
            
            if decimalCount == 1 {
                if string == "." {
                    return false
                }
            }
            
            /////////////////////////////////////////////////////////////////////////////////////////
            
            let newString = (textField.text as NSString?)?.replacingCharacters(in: range, with: string)
            
            let numberOfDecimalPoints = (textField.text?.components(separatedBy: ".").count)! - 1
            
            let sep = newString?.components(separatedBy: ".")
            if (sep?.count ?? 0) >= 2 {
                if  numberOfDecimalPoints > 3 {
                    textField.deleteBackward()
                }
                let sepStr = "\(sep?[1] ?? "")"
                return !(sepStr.count > 3)
                
            }
            else {
                return true
            }
        }
        else {
            return true
        }
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == salonPriceTextField || textField == homePriceTextField || textField == addOnSalonPriceTextField || textField == addOnHomePriceTextField {
            let text = textField.text ?? ""
            if text != "" {
                textField.text = String(format: "%.3f", text.floatValue())
            }
        }
    }
    
    
}

//MARK:- UITableViewDelegate
extension AddSalonServiceViewController : UITableViewDataSource, UITableViewDelegate {
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return addOnServiceArray.count
        
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        let footerView = view as! UITableViewHeaderFooterView
        footerView.tintColor = UIColor.clear
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReUseIdentifier, for: indexPath) as! AddSalonServiceTableViewCell
        
        
        let currentObject = addOnServiceArray[indexPath.section]
        
        cell.serviceNameLabel.text = currentObject.addOnName
        
        let durationText = currentObject.addOnDuration
        let BhdText = localizedTextFor(key: GeneralText.bhd.rawValue)
        
        printToConsole(item: currentObject.addOnSaloonPrice)
        printToConsole(item: currentObject.addOnhomePrice)
        
        if currentObject.addOnSaloonPrice != ""  {
            
            cell.priceLabel.text = currentObject.addOnSaloonPrice + " " + BhdText + " " + durationText
        }
        
        if currentObject.addOnhomePrice != "" {
            cell.priceLabel.text = currentObject.addOnhomePrice + " " + BhdText + " " + durationText
        }
        
        if currentObject.addOnSaloonPrice != "" && currentObject.addOnhomePrice != "" {
            
            cell.priceLabel.text = currentObject.addOnhomePrice + " " + BhdText + " " + durationText + "/" + currentObject.addOnSaloonPrice + " " + BhdText + " " + durationText
        }
        
        cell.deleteButton.addTarget(self, action: #selector(self.deleteButtonAction(sender:)), for: .touchUpInside)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentObj = addOnServiceArray[indexPath.section]
        
        moreAddOnViewHeightConstraints.constant = 0
        addOnViewZeroHeightConstraint.isActive = false
        addOnNameTextField.text = currentObj.addOnName
        addOnSalonPriceTextField.text =  currentObj.addOnSaloonPrice
        addOnHomePriceTextField.text = currentObj.addOnhomePrice
        addOnDurationTextField.text = currentObj.addOnDuration
        
        // update dummy index
        dummyIndex = indexPath.section
        
    }
}



