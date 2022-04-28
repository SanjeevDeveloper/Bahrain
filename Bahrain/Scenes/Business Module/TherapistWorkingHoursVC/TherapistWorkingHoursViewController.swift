
import UIKit

protocol TherapistWorkingHoursDisplayLogic: class
{
    func displayResponse(viewModel: TherapistWorkingHours.ViewModel,businessworkingHourArray:[TherapistWorkingHours.ViewModel.tableCellData])
}

class TherapistWorkingHoursViewController: UIViewController, TherapistWorkingHoursDisplayLogic
{
    var interactor: TherapistWorkingHoursBusinessLogic?
    var router: (NSObjectProtocol & TherapistWorkingHoursRoutingLogic & TherapistWorkingHoursDataPassing)?
    
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
        let interactor = TherapistWorkingHoursInteractor()
        let presenter = TherapistWorkingHoursPresenter()
        let router = TherapistWorkingHoursRouter()
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
    
    
    @IBOutlet weak var workingHourTableView: UITableView!
    var workingHourArray = [TherapistWorkingHours.ViewModel.tableCellData]()
    var isFromTextFieldActive = false
    var currentIndexPath = IndexPath()
    var businessWorkingHours = [TherapistWorkingHours.ViewModel.tableCellData]()
    
    // MARK: View lifecycle
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        initialFunction()
        applyLocalizedText()
        workingHourTableView.tableFooterView = UIView()
        addCustomRightBarButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
    }
    
    
    // MARK: Apply LocalizedText
    func applyLocalizedText() {
        CommonFunctions.sharedInstance.setNavigationTitleView(titleStr:   localizedTextFor(key: WorkingHourSceneText.workingHourSceneTitle.rawValue), onVC: self)
    }
    
    // MARK: Button Action
    
    func addCustomRightBarButton() {
        let btnApply = UIButton(type: UIButtonType.system)
        btnApply.frame = CGRect(x: 0, y: 0, width:60, height: 16)
        btnApply.layer.cornerRadius = 3
        btnApply.layer.borderWidth = 1
        btnApply.layer.borderColor = UIColor.white.cgColor
        btnApply.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        let title = localizedTextFor(key: WorkingHourSceneText.workingHourApplyText.rawValue)
        btnApply.setTitle(title, for: .normal)
        btnApply.tintColor = UIColor.white
        btnApply.addTarget(self, action: #selector(self.applyButtonAction), for: .touchUpInside)
        let customBarItem = UIBarButtonItem(customView: btnApply)
        self.navigationItem.rightBarButtonItem = customBarItem;
    }
    
    
    @objc func applyButtonAction() {
        self.router?.routeToAddTherapist(segue: nil, hoursArray: workingHourArray)
    }
    
    // MARK: InitialFunction
    
    func initialFunction() {
        interactor?.hitListBusinessWorkingHoursApi()
    }
    
    // MARK: Display Response
    func displayResponse(viewModel: TherapistWorkingHours.ViewModel,businessworkingHourArray:[TherapistWorkingHours.ViewModel.tableCellData])
    {
        if let errorString = viewModel.errorString {
            CustomAlertController.sharedInstance.showErrorAlert(error: errorString)
        }
        else {
            workingHourArray = viewModel.tableArray
            businessWorkingHours = businessworkingHourArray
            workingHourTableView.reloadData()
        }
    }
    
    @objc func switchButtonUpdated(sender:UISwitch) {
        var v:UIView = sender
        repeat { v = v.superview! } while !(v is UITableViewCell)
        let cell = v as! TherapistWorkingHoursTableViewCell
        let indexPath = workingHourTableView.indexPath(for:cell)!
        
        var obj = workingHourArray[indexPath.section]
        if sender.isOn {
            obj.active = "true"
        }
        else {
            obj.active = "false"
        }
        
        workingHourArray[indexPath.section] = obj
    }
    //MARK:- Handle DatePicker Target
    
    @objc func handleDatePicker(sender: UIDatePicker) {
        
        var currentObj = workingHourArray[currentIndexPath.section]
        printToConsole(item: currentObj)
        
        // From theripist working hours
        
        let fromWorkingIntValue = currentObj.fromTimestamp
        let fromWorkingDate = Date(largeMilliseconds: Int64(fromWorkingIntValue))
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = UaeTimeZone
        dateFormatter.dateFormat = dateFormats.format5
        let fromWorkingDatecomponents = getCalendar().dateComponents([.hour, .minute], from:  fromWorkingDate)
        let fromWorkingOldHour = fromWorkingDatecomponents.hour!
        let fromWorkingOldMinute = fromWorkingDatecomponents.minute!
        var fromNewSelectHour = Int()
        var fromNewSelectMinute = Int()
        printToConsole(item: fromWorkingOldHour)
        printToConsole(item: fromWorkingOldMinute)
        
        
        
        // To theripist working hours
        
        let toWorkingIntValue = currentObj.toTimestamp
        let toWorkingDate = Date(largeMilliseconds: Int64(toWorkingIntValue))
        dateFormatter.dateFormat = dateFormats.format5
        let toWorkingDatecomponents = getCalendar().dateComponents([.hour, .minute], from:  toWorkingDate)
        let toWorkingOldHour = toWorkingDatecomponents.hour!
        let toWorkingOldMinute = toWorkingDatecomponents.minute!
        var toNewSelectHour = Int()
        var ToNewSelectMinute = Int()
        printToConsole(item: toWorkingOldHour)
        printToConsole(item: toWorkingOldMinute)
        
        
        // business working hours
        
        let businessCurrentObj = businessWorkingHours[currentIndexPath.section]
        printToConsole(item: businessCurrentObj)
        // to date
        let toIntValue = businessCurrentObj.toTimestamp
        let toDate = Date(largeMilliseconds: Int64(toIntValue))
        dateFormatter.dateFormat = dateFormats.format5
        let components = getCalendar().dateComponents([.hour, .minute], from:  toDate)
        let toOldHour = components.hour!
        let toOldMinute = components.minute!
        printToConsole(item: toOldHour)
        printToConsole(item: toOldMinute)
        
        // fromdate
        
        let fromIntValue = businessCurrentObj.fromTimestamp
        let fromDate = Date(largeMilliseconds: Int64(fromIntValue))
        dateFormatter.dateFormat = dateFormats.format5
        let fromcomponents = getCalendar().dateComponents([.hour, .minute], from:  fromDate)
        let fromOldHour = fromcomponents.hour!
        let fromOldMinute = fromcomponents.minute!
        printToConsole(item: fromOldHour)
        printToConsole(item: fromOldMinute)
        
        if isFromTextFieldActive {
            let fromMilliSeconds = sender.date.millisecondsSince1970
            printToConsole(item: sender.date)
            // from
            let date = Date(largeMilliseconds: fromMilliSeconds)
            let dateFormatter = DateFormatter()
            dateFormatter.timeZone = UaeTimeZone
            dateFormatter.dateFormat = dateFormats.format2
            
            let fromcomponents = getCalendar().dateComponents([.hour, .minute], from:  sender.date)
            let fromNewHour = fromcomponents.hour!
            let fromNewMinute = fromcomponents.minute!
            printToConsole(item: fromNewHour)
            printToConsole(item: fromNewMinute)
            fromNewSelectHour = fromNewHour
            fromNewSelectMinute = fromNewMinute
            printToConsole(item: fromNewSelectHour)
            printToConsole(item: fromNewSelectMinute)
            printToConsole(item: toNewSelectHour)
            var isHour = Bool()
            if fromNewSelectHour == toWorkingOldHour {
                if fromNewSelectMinute < toWorkingOldMinute{
                    isHour = true
                }else{
                    isHour = false
                }
            }else if fromNewSelectHour < toWorkingOldHour{
                printToConsole(item: "Yes")
                isHour = true
            }else{
                printToConsole(item: "No")
                isHour = false
            }
            
            if isHour{
                if fromOldHour == fromNewHour{
                    if fromOldMinute <= fromNewMinute {
                        currentObj.fromTimestamp = fromMilliSeconds
                        let dateFormatter = DateFormatter()
                        dateFormatter.timeZone = UaeTimeZone
                        dateFormatter.dateFormat = dateFormats.format2
                        currentObj.from =  dateFormatter.string(from: sender.date)
                        printToConsole(item: currentObj.from)
                        workingHourArray[currentIndexPath.section] = currentObj
                        
                    }else{
                        CustomAlertController.sharedInstance.showErrorAlert(error:localizedTextFor(key: AddTherapistSceneText.addTherapistOpeningworkingHoursWrongText.rawValue))
                    }
                    
                }else if fromOldHour < fromNewHour {
                    if fromNewHour < toOldHour {
                        currentObj.fromTimestamp = fromMilliSeconds
                        let dateFormatter = DateFormatter()
                        dateFormatter.timeZone = UaeTimeZone
                        dateFormatter.dateFormat = dateFormats.format2
                        currentObj.from =  dateFormatter.string(from: sender.date)
                        printToConsole(item: currentObj.from)
                        workingHourArray[currentIndexPath.section] = currentObj
                    }else{
                        CustomAlertController.sharedInstance.showErrorAlert(error:localizedTextFor(key: AddTherapistSceneText.addTherapistOpeningworkingHoursWrongText.rawValue))
                        
                    }
                }
                else{
                    CustomAlertController.sharedInstance.showErrorAlert(error:localizedTextFor(key: AddTherapistSceneText.addTherapistOpeningworkingHoursWrongText.rawValue))
                }
            }else{
                 printToConsole(item: "from therpist")
                CustomAlertController.sharedInstance.showErrorAlert(error:localizedTextFor(key: AddTherapistSceneText.therapistOpeningHourText.rawValue))
            }
        }
        else {
            let toMilliSeconds = sender.date.millisecondsSince1970
            printToConsole(item: sender.date)
            let components = getCalendar().dateComponents([.hour, .minute], from:  sender.date)
            let toNewHour = components.hour!
            let ToNewMinute = components.minute!
            printToConsole(item: toNewHour)
            printToConsole(item: ToNewMinute)
            toNewSelectHour = toNewHour
            ToNewSelectMinute = ToNewMinute
            printToConsole(item: toNewSelectHour)
            printToConsole(item: ToNewSelectMinute)
            
            var isHour = Bool()
            if toNewSelectHour == fromWorkingOldHour {
                if ToNewSelectMinute > fromWorkingOldMinute{
                    isHour = true
                }else{
                    isHour = false
                }
            }else if toNewSelectHour > fromWorkingOldHour{
                printToConsole(item: "Yes")
                isHour = true
            }else{
                printToConsole(item: "No")
                isHour = false
            }
            
            if isHour {
                if toOldHour == toNewHour{
                    if ToNewMinute <= toOldMinute {
                        currentObj.toTimestamp = toMilliSeconds
                        let dateFormatter = DateFormatter()
                        dateFormatter.timeZone = UaeTimeZone
                        dateFormatter.dateFormat = dateFormats.format2
                        currentObj.to =  dateFormatter.string(from: sender.date)
                        workingHourArray[currentIndexPath.section] = currentObj
                        
                    }else{
                        CustomAlertController.sharedInstance.showErrorAlert(error:localizedTextFor(key: AddTherapistSceneText.addTherapistCloseworkingHoursWrongText.rawValue))
                    }
                    
                }else if toOldHour > toNewHour {
                    if toNewHour > fromOldHour {
                        currentObj.toTimestamp = toMilliSeconds
                        let dateFormatter = DateFormatter()
                        dateFormatter.timeZone = UaeTimeZone
                        dateFormatter.dateFormat = dateFormats.format2
                        currentObj.to =  dateFormatter.string(from: sender.date)
                        workingHourArray[currentIndexPath.section] = currentObj
                    }else if toNewHour == fromOldHour{
                        if ToNewMinute > fromOldMinute {
                            currentObj.toTimestamp = toMilliSeconds
                            let dateFormatter = DateFormatter()
                            dateFormatter.timeZone = UaeTimeZone
                            dateFormatter.dateFormat = dateFormats.format2
                            currentObj.to =  dateFormatter.string(from: sender.date)
                            workingHourArray[currentIndexPath.section] = currentObj
                        }else{
                            CustomAlertController.sharedInstance.showErrorAlert(error:localizedTextFor(key: AddTherapistSceneText.addTherapistCloseworkingHoursWrongText.rawValue))
                        }
                        
                    }
                    else {
                        CustomAlertController.sharedInstance.showErrorAlert(error:localizedTextFor(key: AddTherapistSceneText.addTherapistCloseworkingHoursWrongText.rawValue))
                        
                    }
                    
                }else{
                    CustomAlertController.sharedInstance.showErrorAlert(error:localizedTextFor(key: AddTherapistSceneText.addTherapistCloseworkingHoursWrongText.rawValue))
                }
            }else{
               printToConsole(item: "To Theripist")
                CustomAlertController.sharedInstance.showErrorAlert(error:localizedTextFor(key: AddTherapistSceneText.therapistCloseHourText.rawValue))
            }
        }
        
        printToConsole(item: workingHourArray)
    }
    
    @objc func dismissPicker() {
        workingHourTableView.reloadRows(at: [currentIndexPath], with: .automatic)
        self.view.endEditing(true)
    }
}

//MARK:- UITableViewDataSource
extension TherapistWorkingHoursViewController : UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return workingHourArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 15
    }
    
    func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        let footerView = view as! UITableViewHeaderFooterView
        footerView.tintColor = UIColor.clear
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReUseIdentifier, for: indexPath) as! TherapistWorkingHoursTableViewCell
        let currentObj = workingHourArray[indexPath.section]
        
        cell.weekTextLabel.text = currentObj.day.uppercased()
        //        let intFromvalue = currentObj.fromTimestamp
        //        let fromdate = Date(largeMilliseconds:Int64(intFromvalue))
        //        let dateFormatter = DateFormatter()
        //        dateFormatter.dateFormat = dateFormats.format2
        //        let fromtime = dateFormatter.string(from: fromdate)
        //        printToConsole(item: time)
        //
        //        let intToValue = currentObj.toTimestamp
        //        let todate = Date(largeMilliseconds:Int64(intToValue))
        //        let toTime = dateFormatter.string(from: todate)
        //        printToConsole(item: toTime)
        

        let date = Date(largeMilliseconds: currentObj.fromTimestamp)
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = UaeTimeZone
        dateFormatter.dateFormat = dateFormats.format2
        let fromTime = dateFormatter.string(from: date)
        
        //
        let toDate = Date(largeMilliseconds: currentObj.toTimestamp)
        let toTime = dateFormatter.string(from: toDate)
        
        
        cell.fromTextField.text = fromTime
        cell.tillTextField.text = toTime
        
        
        if currentObj.active == "false"{
            cell.switchButton.isOn = false
        }
        else {
            cell.switchButton.isOn = true
        }
        
        cell.switchButton.addTarget(self, action: #selector(self.switchButtonUpdated), for: .valueChanged)
        
        return cell
    }
}

//MARK:- UITextFieldDelegate
extension TherapistWorkingHoursViewController : UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.inputAccessoryView = UIToolbar().ToolbarPiker(mySelect: #selector(TherapistWorkingHoursViewController.dismissPicker))
        
        let datePickerView = getDatePicker()
        datePickerView.datePickerMode = .time
        textField.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(handleDatePicker(sender:)), for: .valueChanged)
        
        var v:UIView = textField
        repeat { v = v.superview! } while !(v is UITableViewCell)
        let cell = v as! TherapistWorkingHoursTableViewCell
        currentIndexPath = workingHourTableView.indexPath(for:cell)!
        
        if textField == cell.fromTextField {
            isFromTextFieldActive = true
        }
        else {
            isFromTextFieldActive = false
        }
    }
}
