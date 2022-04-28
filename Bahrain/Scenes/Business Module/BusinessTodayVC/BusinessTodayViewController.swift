
import UIKit

protocol BusinessTodayDisplayLogic: class
{
    func displayResponse(viewModel: BusinessToday.ViewModel)
}

class BusinessTodayViewController: BaseViewControllerBusiness, BusinessTodayDisplayLogic
{
    var interactor: BusinessTodayBusinessLogic?
    var router: (NSObjectProtocol & BusinessTodayRoutingLogic & BusinessTodayDataPassing)?
    
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
        let interactor = BusinessTodayInteractor()
        let presenter = BusinessTodayPresenter()
        let router = BusinessTodayRouter()
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
    
    ////////////////////////////////////////////////////////
    
    @IBOutlet weak var todayTableView:UITableView!
    @IBOutlet weak var noAppointmentsLabel: UILabelFontSize!
    @IBOutlet weak var vwSegment: UIView!
    @IBOutlet weak var lblFrom: UILabel!
    @IBOutlet weak var txtfFromDate: UITextField!
    @IBOutlet weak var lblTo: UILabel!
    @IBOutlet weak var txtfToDate: UITextField!
    var segmentView : UISegmentedControl?
    var fromDatePicker : UIDatePicker?
    var toDatePicker : UIDatePicker?
    var offset = 0
    
    var appointmentArr = [BusinessToday.ViewModel.tableCellData]()
    
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSlideMenuButton()
        initialFunction()
        applyFontAndColor()
    
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        applyLocalizedText()
        if self.appointmentArr.count == 0 {
            noAppointmentsLabel.isHidden = false
        }
        else {
            noAppointmentsLabel.isHidden = true
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        setSegmentControl()
    }
    
    // MARK: Apply Font And Color
    func applyFontAndColor() {
        noAppointmentsLabel.textColor = appBarThemeColor
    }
    
    // MARK: Apply LocalizedText
    func applyLocalizedText() {
        
        CommonFunctions.sharedInstance.setNavigationTitleView(titleStr:   localizedTextFor(key: TodaySceneText.todaySceneTitle.rawValue), onVC: self)
        noAppointmentsLabel.text = localizedTextFor(key: GeneralText.noAppointmentsAvailableMessage.rawValue)
        lblFrom.text = localizedTextFor(key: GeneralText.from.rawValue)
        lblTo.text = localizedTextFor(key: GeneralText.to.rawValue)

    }
    
    // MARK: Other Functions
    
    func initialFunction() {
        txtfFromDate.delegate = self
        txtfToDate.delegate = self
        fromDatePicker = UIDatePicker()
        fromDatePicker?.timeZone = UaeTimeZone
        fromDatePicker?.datePickerMode = .date
        fromDatePicker?.tag = 0
        toDatePicker = UIDatePicker()
        toDatePicker?.timeZone = UaeTimeZone
        toDatePicker?.datePickerMode = .date
        toDatePicker?.tag = 1
        txtfFromDate.inputView = fromDatePicker
        txtfToDate.inputView = toDatePicker
        fromDatePicker?.addTarget(self, action: #selector(self.datePickerValueChanged), for: .valueChanged)
        toDatePicker?.addTarget(self, action: #selector(self.datePickerValueChanged), for: .valueChanged)

    }
    
    func setSegmentControl() {
        let titles = [localizedTextFor(key: BusinessTodaySceneText.upcoming.rawValue), localizedTextFor(key: BusinessTodaySceneText.pastAppointments.rawValue)]
        segmentView = UISegmentedControl(items: titles)
        segmentView?.selectedSegmentIndex = 0
        let attributesNormal = [
            NSAttributedStringKey.font: UIFont(name: appFont, size: 15)!,
            NSAttributedStringKey.foregroundColor: UIColor.white]
        let attributesSelected = [
            NSAttributedStringKey.font: UIFont(name: appFont, size: 15)!,
            NSAttributedStringKey.foregroundColor: UIColor.black]
        segmentView?.setTitleTextAttributes(attributesNormal, for: .normal)
        segmentView?.setTitleTextAttributes(attributesSelected, for: .selected)
        segmentView?.backgroundColor = appBarThemeColor
        segmentView?.tintColor = appTxtfLighterGrayColor
        segmentView?.frame = CGRect(x: 20, y: 14, width: vwSegment.frame.width-40, height: 34)
        segmentView?.addTarget(self, action: #selector(self.setPickerDate), for: .valueChanged)
        self.vwSegment.addSubview(segmentView!)
        setPickerDate(segmentView!)
    }
    // MARK: Display Response
    func displayResponse(viewModel: BusinessToday.ViewModel)
    {
        appointmentArr.append(contentsOf: viewModel.tableArray)
        todayTableView.reloadData()
        noAppointmentsLabel.isHidden = self.appointmentArr.count == 0 ? false : true
    }
    @objc func datePickerValueChanged(sender: UIDatePicker) {
        if sender == fromDatePicker {
            txtfFromDate.text = CommonFunctions.sharedInstance.formatDate(sender.date, format: dateFormats.format3)
        } else {
            txtfToDate.text = CommonFunctions.sharedInstance.formatDate(sender.date, format: dateFormats.format3)
        }
    }
    
    @objc func setPickerDate(_ value: UISegmentedControl) {
        view.endEditing(true)
        txtfToDate.text = nil
        txtfFromDate.text = nil
        initialFunction()
        if value.selectedSegmentIndex == 0 {
            fromDatePicker?.minimumDate = Date()
            toDatePicker?.minimumDate = Date()
        } else {
            fromDatePicker?.maximumDate = Date()
            toDatePicker?.maximumDate = Date()
        }
    }
    
    //MARK:- Btn Actions
    @IBAction func btnFromDate(_ sender: Any) {
        txtfFromDate.becomeFirstResponder()
        datePickerValueChanged(sender: fromDatePicker!)
    }
    @IBAction func btnToDate(_ sender: Any) {
        txtfToDate.becomeFirstResponder()
        datePickerValueChanged(sender: toDatePicker!)
    }
}

// MARK: UITableViewDelegate

extension BusinessTodayViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return appointmentArr.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReUseIdentifier, for: indexPath) as! BusinessTodayTableViewCell
        
        let currentObj = appointmentArr[indexPath.section]
        cell.setData(currentObj:currentObj)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let headerView = view as! UITableViewHeaderFooterView
        headerView.tintColor = UIColor.clear
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.section == (((self.offset + 1)*10) - 1) {
            self.offset += 1
            initialFunction()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let currentObj = appointmentArr[indexPath.section]
        self.router?.routeToAppoinmentDetail(segue: nil, orderDetailArray: currentObj)
    }
}

// MARK: UITextFieldDelegate
extension BusinessTodayViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
        if !txtfFromDate.text!.isEmpty && !txtfToDate.text!.isEmpty {
            interactor?.hitListBusinessAppointmentsApi(offset: offset, fromDate: "\(fromDatePicker!.date.millisecondsSince1970)", toDate: "\(fromDatePicker!.date.millisecondsSince1970)")
        }
    }
}
