
import UIKit

protocol WorkingHoursDisplayLogic: class
{
    func displayResponse(viewModel: WorkingHours.ViewModel)
    
    func workingHoursUpdated()
}

class WorkingHoursViewController: UIViewController, WorkingHoursDisplayLogic
{
    var interactor: WorkingHoursBusinessLogic?
    var router: (NSObjectProtocol & WorkingHoursRoutingLogic & WorkingHoursDataPassing)?
    
    
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
        let interactor = WorkingHoursInteractor()
        let presenter = WorkingHoursPresenter()
        let router = WorkingHoursRouter()
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
    
    
    @IBOutlet weak var workingHourTableView:UITableView!
    @IBOutlet weak var doneButton: UIButtonCustomClass!
    var workingHourArray = [WorkingHours.ViewModel.tableCellData]()
    var currentIndexPath = IndexPath()
    var isFromTextFieldActive = false
    var delegate:movePageController!
    
    // MARK: View lifecycle
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        initialFunction()
        applyLocalizedText()
        applyFontAndColor()
        workingHourTableView.tableFooterView = UIView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    // MARK: Apply Font And Color
    func applyFontAndColor() {
        doneButton.backgroundColor = appBarThemeColor
        doneButton.tintColor = appBtnWhiteColor
    }
    
    // MARK: Apply LocalizedText
    func applyLocalizedText() {
        CommonFunctions.sharedInstance.setNavigationTitleView(titleStr:   localizedTextFor(key: WorkingHourSceneText.workingHourSceneTitle.rawValue), onVC: self)
        if appDelegateObj.isPageControlActive {
            doneButton.setTitle(localizedTextFor(key:GeneralText.Continue.rawValue), for: .normal)
        }else {
            doneButton.setTitle(localizedTextFor(key: GeneralText.doneButton.rawValue), for: .normal)
        }
    }
    
    // MARK: Button Actions
    
    @IBAction func continueButtonAction(_ sender: Any) {
        let request = WorkingHours.Request(hoursArray: workingHourArray)
        
        printToConsole(item: request)
        interactor?.hitUpdateBusinessApi(request: request)
    }
    
    
    // MARK: Other Functions
    
    func initialFunction() {
        interactor?.hitListBusinessWorkingHoursApi()
    }
    
    // MARK: Display Response
    func displayResponse(viewModel: WorkingHours.ViewModel)
    {
        if let errorString = viewModel.errorString {
            CustomAlertController.sharedInstance.showErrorAlert(error: errorString)
        }
        else {
            workingHourArray = viewModel.tableArray
            workingHourTableView.reloadData()
        }
    }
    
    // MARK: WorkingHoursUpdated
    func workingHoursUpdated() {
        CustomAlertController.sharedInstance.showAlert(subTitle: localizedTextFor(key: WorkingHourSceneText.workingHourSuccessMessage.rawValue), type: .success)
        
        if appDelegateObj.isPageControlActive {
            self.delegate.moveToNextPage()
        }
        else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @objc func switchButtonUpdated(sender:UISwitch) {
        var v:UIView = sender
        repeat { v = v.superview! } while !(v is UITableViewCell)
        let cell = v as! WorkingHourRowTableViewCell
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
    
    @objc func handleDatePicker(sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = UaeTimeZone
        dateFormatter.timeStyle = .short
        
        var currentObj = workingHourArray[currentIndexPath.section]
        
        
       // OldStarttime
        let oldStarTimeDate = currentObj.oldStartTime
        let OldStartdate = Date(largeMilliseconds: oldStarTimeDate)

        //TO Compare
        // start time not changing value used to compare only
        let starTimeDate = currentObj.fromTimestamp
        let date = Date(largeMilliseconds: starTimeDate)
        let calendar = getCalendar()
        let comp = calendar.dateComponents([.hour, .minute], from: date)
        let hour = comp.hour
        let minute = comp.minute

        // Old Ending time
        //Ending Time not changing value used to compare only
        let endTimeDate = currentObj.oldCloseTime
        let enddate = Date(largeMilliseconds: endTimeDate)


        // Current Ending Time
        let currentEndTimeDate = currentObj.toTimestamp
        let currentEnddate = Date(largeMilliseconds: currentEndTimeDate)
        let currentEndComp = calendar.dateComponents([.hour, .minute], from: currentEnddate)
        let CurrentEndHour = currentEndComp.hour
        let CurrentEndMinute = currentEndComp.minute


        if isFromTextFieldActive {
            let fromMilliSeconds = sender.date.millisecondsSince1970
            let startDate =  Date(largeMilliseconds: fromMilliSeconds)
            let startcomp = calendar.dateComponents([.hour, .minute], from: startDate)
            let startHour = startcomp.hour
            let startMinute = startcomp.minute
            if startHour! < CurrentEndHour! {
                    currentObj.fromTimestamp = fromMilliSeconds
                    currentObj.from =  dateFormatter.string(from: sender.date)

            }
            else {
               CustomAlertController.sharedInstance.showErrorAlert(error:localizedTextFor(key: WorkingHourSceneText.workingOpeningHoursWrongSelecttime.rawValue))
                currentObj.from =  dateFormatter.string(from: OldStartdate)
            }
        }
        else {
            let toMilliSeconds = sender.date.millisecondsSince1970
            let closingDate = Date(largeMilliseconds: toMilliSeconds)
            let comp2 = calendar.dateComponents([.hour, .minute], from: closingDate)
            let closingHour = comp2.hour
            let closingMinute = comp2.minute

            if closingHour! > hour! {

                    currentObj.to =  dateFormatter.string(from: sender.date)
                    currentObj.toTimestamp = toMilliSeconds
            }
            else {
              CustomAlertController.sharedInstance.showErrorAlert(error:localizedTextFor(key: WorkingHourSceneText.workingCloseHoursWrongSelecttime.rawValue))
                 currentObj.to =  dateFormatter.string(from: enddate)
            }
        }
        workingHourArray[currentIndexPath.section] = currentObj
    }
    
    @objc func dismissPicker() {
        workingHourTableView.reloadRows(at: [currentIndexPath], with: .automatic)
        self.view.endEditing(true)
    }
}

//MARK:- UITableViewDelegate
extension WorkingHoursViewController : UITableViewDataSource, UITableViewDelegate {
    
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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReUseIdentifier, for: indexPath) as! WorkingHourRowTableViewCell
        printToConsole(item: workingHourArray)
        let currentObj = workingHourArray[indexPath.section]
        printToConsole(item: currentObj)
        
        cell.weekTextLabel.text = currentObj.day.uppercased()
        cell.fromTextField.text = currentObj.from
        cell.tillTextField.text = currentObj.to
        
        if currentObj.active == "true" {
            cell.switchButton.isOn = true
        }
        else {
            cell.switchButton.isOn = false
        }
        
        cell.switchButton.addTarget(self, action: #selector(self.switchButtonUpdated), for: .valueChanged)
        
        return cell
    }
}

//MARK:- UITextFieldDelegate

extension WorkingHoursViewController : UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.inputAccessoryView = UIToolbar().ToolbarPiker(mySelect: #selector(WorkingHoursViewController.dismissPicker))
        
        let datePickerView = getDatePicker()
        datePickerView.datePickerMode = .time
        datePickerView.minuteInterval = 15
        
        textField.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(handleDatePicker(sender:)), for: .valueChanged)
        
        
        var v:UIView = textField
        repeat { v = v.superview! } while !(v is UITableViewCell)
        let cell = v as! WorkingHourRowTableViewCell
        currentIndexPath = workingHourTableView.indexPath(for:cell)!
        
        if textField == cell.fromTextField {
            isFromTextFieldActive = true
        }
        else {
            isFromTextFieldActive = false
        }
    }
}





