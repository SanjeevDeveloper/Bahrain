
import UIKit

protocol AddScheduledBreakDisplayLogic: class
{
}

class AddScheduledBreakViewController: UIViewController, AddScheduledBreakDisplayLogic
{
    
    var interactor: AddScheduledBreakBusinessLogic?
    var router: (NSObjectProtocol & AddScheduledBreakRoutingLogic & AddScheduledBreakDataPassing)?
    
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
        let interactor = AddScheduledBreakInteractor()
        let presenter = AddScheduledBreakPresenter()
        let router = AddScheduledBreakRouter()
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
    
    // MARK: View lifecycle
    
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var titleTextField: UITextFieldFontSize!
    @IBOutlet weak var arabicTitleTxtField: UITextFieldFontSize!
    @IBOutlet weak var breakLabel: UILabelFontSize!
    @IBOutlet weak var startDateAndTimeTextField: UITextFieldFontSize!
    @IBOutlet weak var priceLabel: UILabelFontSize!
    @IBOutlet weak var endDateAndTimeTextField: UITextFieldFontSize!
    @IBOutlet weak var endTextView: UIViewCustomClass!
    @IBOutlet weak var doneButton: UIButtonCustomClass!
    @IBOutlet weak var breakPopupView: UIView!
    @IBOutlet weak var selectBreakLabel: UILabelFontSize!
    @IBOutlet weak var fullDayLabel: UILabel!
    @IBOutlet weak var fullDayBtn: UIButton!
    @IBOutlet weak var customLabel: UILabel!
    @IBOutlet weak var customBtn: UIButton!
    @IBOutlet weak var everyDayView: UIViewCustomClass!
    @IBOutlet weak var everyDayLabel: UILabel!
    @IBOutlet weak var everyDayBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButtonFontSize!
    @IBOutlet weak var doneBtn: UIButtonFontSize!
    
    
    var scheduledBreakArray = [AddScheduledBreak.ViewModel.tableCellData]()
    
    var startMilliSecond : Int64?
    var endMilliSecond : Int64?
    
    // MARK: Life Cycle
    override func viewDidLoad()
    {
        super.viewDidLoad()
        //fullDaySwitchButton.isOn = false
        scrollView.manageKeyboard()
        applyLocalizedText()
        applyFontAndColor()
    }
    
    override func viewWillAppear(_ animated: Bool) {
    }
    
    // MARK: Apply Font And Color
    func applyFontAndColor() {
        doneButton.setTitleColor(appBtnWhiteColor, for: .normal)
        doneButton.backgroundColor = appBarThemeColor
        doneBtn.backgroundColor = appBarThemeColor
        cancelBtn.backgroundColor = appBarThemeColor
    }
    
    // MARK: Apply LocalizedText
    func applyLocalizedText() {
        let colorAttribute = [NSAttributedStringKey.foregroundColor: UIColor.darkGray]
        CommonFunctions.sharedInstance.setNavigationTitleView(titleStr:   localizedTextFor(key: AddScheduledBreakSceneText.AddScheduledBreakSceneTitle.rawValue), onVC: self)
        
        selectBreakLabel.text = localizedTextFor(key: AddScheduledBreakSceneText.AddScheduledBreakSceneBreakTypeTitle.rawValue)
        
        breakLabel.text = localizedTextFor(key: AddScheduledBreakSceneText.AddScheduledBreakSceneBreakTypeTitle.rawValue)
        fullDayLabel.text = localizedTextFor(key: AddScheduledBreakSceneText.AddScheduledBreakSceneFullDayLabel.rawValue)
        
        customLabel.text = localizedTextFor(key: AddScheduledBreakSceneText.AddScheduledBreakSceneCustomLabelTitle.rawValue)
        
        let  titleTextFieldPlaceholder = NSMutableAttributedString(string: localizedTextFor(key: AddScheduledBreakSceneText.AddScheduledBreakSceneTitleLabel.rawValue), attributes: colorAttribute)
        titleTextFieldPlaceholder.append(asterik)
        titleTextField.attributedPlaceholder = titleTextFieldPlaceholder
        
        let  startDateAndTimeTextFieldPlaceholder = NSMutableAttributedString(string: localizedTextFor(key: AddScheduledBreakSceneText.AddScheduledBreakSceneStartDateAndTimeTextField.rawValue), attributes: colorAttribute)
        startDateAndTimeTextFieldPlaceholder.append(asterik)
        startDateAndTimeTextField.attributedPlaceholder = startDateAndTimeTextFieldPlaceholder
        
        let  EndDateAndTimeTextFieldPlaceholder = NSMutableAttributedString(string: localizedTextFor(key: AddScheduledBreakSceneText.AddScheduledBreakSceneEndDateAndTimeTextField.rawValue), attributes: colorAttribute)
        EndDateAndTimeTextFieldPlaceholder.append(asterik)
        endDateAndTimeTextField.attributedPlaceholder = EndDateAndTimeTextFieldPlaceholder
        
        everyDayLabel.text = localizedTextFor(key: AddScheduledBreakSceneText.AddScheduledBreakSceneEveryDayLabel.rawValue)
        
        doneButton.setTitle(localizedTextFor(key: AddScheduledBreakSceneText.AddScheduledBreakSceneDoneButton.rawValue), for: .normal)
    }
    
    // MARK: Button Actions
    
    
    @IBAction func popupButtonAction(_ sender: Any) {
        breakPopupView.isHidden = false
    }
    @IBAction func fullDayBtn(_ sender: Any) {
        fullDayBtn.isSelected = true
        customBtn.isSelected = false
        everyDayView.isHidden = true
        startDateAndTimeTextField.text = ""
        endDateAndTimeTextField.text = ""
    }
    @IBAction func customBtn(_ sender: Any) {
        customBtn.isSelected = true
        fullDayBtn.isSelected = false
        everyDayView.isHidden = false
        startDateAndTimeTextField.text = ""
        endDateAndTimeTextField.text = ""
    }
    @IBAction func everyDayBtn(_ sender: Any) {
        if everyDayBtn.isSelected {
            everyDayBtn.isSelected = false
        }
        else {
            everyDayBtn.isSelected = true
        }
        
    }
    @IBAction func cancelBtn(_ sender: Any) {
        breakPopupView.isHidden = true
        fullDayBtn.isSelected = false
        customBtn.isSelected = false
    }
    @IBAction func doneBtn(_ sender: Any) {
        breakPopupView.isHidden = true
    }
    
    //    @IBAction func switchButtonAction(_ sender: UISwitch) {
    //
    //        if sender.isOn {
    //            endTextView.isHidden = true
    //            endDateAndTimeTextField.text = ""
    //        }
    //        else {
    //            endTextView.isHidden = false
    //        }
    //    }
    
    
    @IBAction func doneButtonAction(_ sender: Any) {
        
        if isRequestValid() {
            
            let startTime = startDateAndTimeTextField.text
            let endTime = endDateAndTimeTextField.text
            
            let dateFormatter = DateFormatter()
            dateFormatter.timeZone = UaeTimeZone
            if fullDayBtn.isSelected {
                dateFormatter.dateFormat = dateFormats.format9
            }
            else {
                dateFormatter.dateFormat = dateFormats.format2
            }
            //Start time
            var selectedDateMilliseconds : Int64?
            let selectedDate = dateFormatter.date(from: startTime!)
             selectedDateMilliseconds = selectedDate?.millisecondsSince1970
            
            //End time
            var selectedEndDateMilliseconds : Int64?
            if endDateAndTimeTextField.text_Trimmed() != "" {
                let selectedEndDate = dateFormatter.date(from: endTime!)
                selectedEndDateMilliseconds = selectedEndDate?.millisecondsSince1970
                
                if fullDayBtn.isSelected {
                    selectedEndDateMilliseconds = selectedEndDateMilliseconds! + 85860000
                }
                
            }
            
            var repeatData = ""
            if everyDayBtn.isSelected{
                repeatData = "Every Day"
            }
            else {
                repeatData = "Never"
                selectedDateMilliseconds = startMilliSecond
                selectedEndDateMilliseconds = endMilliSecond
            }
            
            let obj = AddScheduledBreak.ViewModel.tableCellData(title: titleTextField.text_Trimmed(), start: (selectedDateMilliseconds?.description)!, end: (selectedEndDateMilliseconds?.description) ?? "", fullday: fullDayBtn.isSelected, repeatInfo: repeatData)
            
            router?.routeToSomewhere(scheduledArray: obj)
            
        }
        
    }
    
    // MARK: Validation
    func isRequestValid() -> Bool {
        var isValid = true
        let validator = Validator()
        if !validator.validateRequired(titleTextField.text_Trimmed(), errorKey: AddScheduledBreakSceneText.AddScheduledBreakSceneSelectTitleAlert.rawValue)  {
            isValid = false
        }
        else if !validator.validateRequired(startDateAndTimeTextField.text_Trimmed(), errorKey: AddScheduledBreakSceneText.AddScheduledBreakSceneSelectStartTimeAlert.rawValue)  {
            isValid = false
        }
            
        else if !validator.validateRequired(endDateAndTimeTextField.text_Trimmed(), errorKey: AddScheduledBreakSceneText.AddScheduledBreakSceneSelectEndTimeAlert.rawValue) {
            isValid = false
        }
        
        
        return isValid
    }
    
    @objc func handleStartDateTimePicker(sender: UIDatePicker){
         startMilliSecond = (sender.date.millisecondsSince1970)
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = UaeTimeZone
        if fullDayBtn.isSelected {
            dateFormatter.dateFormat = dateFormats.format9
        }
        else {
            dateFormatter.dateFormat = dateFormats.format2
        }
        startDateAndTimeTextField.text = dateFormatter.string(from: sender.date)
    }
    
    @objc func handleEndDateTimePicker(sender: UIDatePicker){
        
          endMilliSecond = (sender.date.millisecondsSince1970)
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = UaeTimeZone
        if fullDayBtn.isSelected {
            dateFormatter.dateFormat = dateFormats.format9
        }
        else {
            dateFormatter.dateFormat = dateFormats.format2
        }
        
        if startDateAndTimeTextField.text != "" {
            let startDate = dateFormatter.date(from: startDateAndTimeTextField.text!)!
            
            let startMilli = startDate.millisecondsSince1970
            let EndMilli = sender.date.millisecondsSince1970

            let calendar = getCalendar()
            
            let sDate =  Date(largeMilliseconds: startMilli)
            let startcomp = calendar.dateComponents([.hour, .minute], from: sDate)
            let startHour = startcomp.hour
            let startMinute = startcomp.minute
        
            
            let currentEnddate = Date(largeMilliseconds: EndMilli)
            let currentEndComp = calendar.dateComponents([.hour, .minute], from: currentEnddate)
            let CurrentEndHour = currentEndComp.hour
            let CurrentEndMinute = currentEndComp.minute
            
            
            if fullDayBtn.isSelected {
                if startMilli < EndMilli {
                    endDateAndTimeTextField.text = dateFormatter.string(from: sender.date)
                }
                else {
                    CustomAlertController.sharedInstance.showAlert(subTitle: localizedTextFor(key: AddScheduledBreakSceneText.AddScheduledBreakSceneEndDateGreaterAlert.rawValue), type: .error)
                }
            }
            else {
                if startHour! < CurrentEndHour! {
                    endDateAndTimeTextField.text = dateFormatter.string(from: sender.date)
                }
                else {
                    if startHour! == CurrentEndHour! {
                        if startMinute! < CurrentEndMinute! {
                            endDateAndTimeTextField.text = dateFormatter.string(from: sender.date)
                        }
                        else {
                        CustomAlertController.sharedInstance.showAlert(subTitle: localizedTextFor(key: AddScheduledBreakSceneText.AddScheduledBreakSceneEndTimeGreaterAlert.rawValue), type: .error)
                        }
                    }
                    else {
                        CustomAlertController.sharedInstance.showAlert(subTitle: localizedTextFor(key: AddScheduledBreakSceneText.AddScheduledBreakSceneEndTimeGreaterAlert.rawValue), type: .error)
                    }
                }
            }
            
        }
        else {
            CustomAlertController.sharedInstance.showAlert(subTitle: localizedTextFor(key: AddScheduledBreakSceneText.AddScheduledBreakSceneSelectDateAlert.rawValue), type: .error)
        }
        
    }
}

// MARK: UITextFieldDelegate
extension AddScheduledBreakViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        if fullDayBtn.isSelected || customBtn.isSelected {
            let datePickerView = getDatePicker()
            if fullDayBtn.isSelected {
                datePickerView.datePickerMode = .date
                datePickerView.minimumDate = Date()
            }
            else {
                datePickerView.datePickerMode = .time
                datePickerView.minuteInterval = 15
            }
            
            if textField == startDateAndTimeTextField{
                textField.inputView = datePickerView
                datePickerView.addTarget(self, action: #selector(handleStartDateTimePicker(sender:)), for: .valueChanged)
                
            }else if textField == endDateAndTimeTextField{
                textField.inputView = datePickerView
                datePickerView.addTarget(self, action: #selector(handleEndDateTimePicker(sender:)), for: .valueChanged)
            }
            return true
        }
        else {
            CustomAlertController.sharedInstance.showAlert(subTitle: localizedTextFor(key: AddScheduledBreakSceneText.AddScheduledBreakSceneSelectBreakTypeAlert.rawValue), type: .error)
            return false
        }
    }
}


