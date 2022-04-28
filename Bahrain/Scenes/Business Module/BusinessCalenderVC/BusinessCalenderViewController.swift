

import UIKit

protocol BusinessCalenderDisplayLogic: class
{
    func displayResponse(viewModel: BusinessToday.ViewModel)
    func displayDeleteAppointmentResponse(msg: String, index:Int)
}

class BusinessCalenderViewController: BaseViewControllerBusiness, BusinessCalenderDisplayLogic
{
    var interactor: BusinessCalenderBusinessLogic?
    var router: (NSObjectProtocol & BusinessCalenderRoutingLogic & BusinessCalenderDataPassing)?
    
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
        let interactor = BusinessCalenderInteractor()
        let presenter = BusinessCalenderPresenter()
        let router = BusinessCalenderRouter()
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
    
    //////////////////////////////////////////////////////////////////
    
    @IBOutlet weak var calenderFrameView: UIView!
    @IBOutlet weak var appointmentListTableView: UITableView!
    @IBOutlet weak var noAppointmentLabel: UILabelFontSize!
    
    //offset not used
    var offset = 0
    var appointmentArr = [BusinessToday.ViewModel.tableCellData]()
    var layoutBool = true
    
    var calenderView: CalenderView = {
        let calenderView = CalenderView(theme: MyTheme.dark)
        return calenderView
    }()
    
    
    // MARK: View lifecycle
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        initialFunction()
        hideBackButtonTitle()
        addSlideMenuButton()
        applyFontAndColor()
        appointmentListTableView.tableFooterView = UIView()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        applyLocalizedText()
        if self.appointmentArr.count == 0 {
            noAppointmentLabel.isHidden = false
        }
        else {
            noAppointmentLabel.isHidden = true
        }
    }
    
    // MARK: Apply Font And Color
    func applyFontAndColor() {
        noAppointmentLabel.textColor = appBarThemeColor
    }
    
    // MARK: Apply LocalizedText
    func applyLocalizedText() {
        noAppointmentLabel.text = localizedTextFor(key: GeneralText.noAppointmentsAvailableMessage.rawValue)
        CommonFunctions.sharedInstance.setNavigationTitleView(titleStr:   localizedTextFor(key: BusinessCalenderSceneText.BusinessCalenderSceneTitle.rawValue), onVC: self)
    }
    
    // MARK: Calender SubViews Function
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        if layoutBool{
            calenderView.myCollectionView.collectionViewLayout.invalidateLayout()
        }
        
    }
    
    override func viewDidLayoutSubviews() {
        if layoutBool{
            calenderView.frame = CGRect(x: 0, y: 0, width: calenderFrameView.bounds.size.width, height: calenderFrameView.bounds.size.height)
            calenderView.changeTheme()
        }
        layoutBool = true
        
    }
    
    // MARK: InitialFunction
    
    func initialFunction() {
        calenderView.delegate = self
        calenderFrameView.addSubview(calenderView)
        let todayDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = UaeTimeZone
        dateFormatter.dateFormat = dateFormats.format3
        let dateMilliseconds = todayDate.millisecondsSince1970
        interactor?.hitListBusinessAppointmentsApi(offset: offset, timeStamp: dateMilliseconds)
    }
    
    // MARK: Display Response
    func displayResponse(viewModel: BusinessToday.ViewModel)
    {
        layoutBool = false
        appointmentArr = viewModel.tableArray
        appointmentListTableView.reloadData()
        if self.appointmentArr.count == 0 {
            noAppointmentLabel.isHidden = false
        }
        else {
            noAppointmentLabel.isHidden = true
        }
    }
    
    func displayDeleteAppointmentResponse(msg: String, index: Int) {
//        appointmentArr.remove(at: index)
//        let indexPath = IndexPath(row: 0, section: index)
//        let indexSet = IndexSet(indexPath)
//        appointmentListTableView.deleteSections(indexSet, with: .fade)
        
        CustomAlertController.sharedInstance.showAlert(subTitle: msg, type: .success)
    }
}

// MARK: CalenderDelegate
extension BusinessCalenderViewController : CalenderDelegate {
    
    func didTapDate(date: String, available: Bool) {

        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = UaeTimeZone
        dateFormatter.dateFormat = dateFormats.format3
        let selectedDate = dateFormatter.date(from: date)
        let selectedDateMilliseconds = selectedDate?.millisecondsSince1970
        
        interactor?.hitListBusinessAppointmentsApi(offset: offset, timeStamp: selectedDateMilliseconds!)
    }
}

// MARK: UITableViewDelegate
extension BusinessCalenderViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return appointmentArr.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReUseIdentifier, for: indexPath) as! BusinessCalenderTableViewCell
        
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
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let btnEdit = UITableViewRowAction(style: .default, title: "Cancel") { action, indexPath in
            
            let alertController = PMAlertController(textForegroundColor:UIColor.darkGray, viewBackgroundColor: UIColor.white, title: localizedTextFor(key:""), description: localizedTextFor(key: BusinessCalenderSceneText.BusinessCalenderDeleteAlert.rawValue), image: nil, style: .alert)
            alertController.addAction(PMAlertAction(title: localizedTextFor(key: GeneralText.cancelButton.rawValue), style: .default, action: {
                alertController.dismiss(animated: true, completion: nil)
                
            }))
            
            alertController.addAction(PMAlertAction(title: localizedTextFor(key: BusinessCalenderSceneText.BusinessCalenderConfirmPopupTitle.rawValue), style: .default, action: {
                let currentObj = self.appointmentArr[indexPath.section]
                let id  = currentObj.appointmentId
                self.interactor?.hitDeleteAppoinmentApi(id: id, indexPath: indexPath.section)
            }))
            
            self.present(alertController, animated: true, completion: nil)
        }
        return [btnEdit]
    }
    
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//
//
//        }
//    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let currentObj = appointmentArr[indexPath.section]
        self.router?.routeToAppoinmentDetail(segue: nil, orderDetailArray: currentObj)
    }
}

