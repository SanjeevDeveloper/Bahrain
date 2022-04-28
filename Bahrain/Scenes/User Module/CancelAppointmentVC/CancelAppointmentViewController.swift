
import UIKit

protocol CancelAppointmentDisplayLogic: class
{
    func displayCancelReasonsResponse(viewModel: CancelAppointment.ViewModel)
    func displayCancelAppointmentResponse(msg: String)
}

class CancelAppointmentViewController: UIViewController, CancelAppointmentDisplayLogic
{
    var interactor: CancelAppointmentBusinessLogic?
    var router: (NSObjectProtocol & CancelAppointmentRoutingLogic & CancelAppointmentDataPassing)?
    
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
        let interactor = CancelAppointmentInteractor()
        let presenter = CancelAppointmentPresenter()
        let router = CancelAppointmentRouter()
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
    
    
    /////////////////////////////////////////////////////////////////////
    
    
    @IBOutlet weak var reasonsTableView: UITableView!
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var tableHeightConstraint: NSLayoutConstraint!
    
    var reasonsArray = [CancelAppointment.ViewModel.tableCellData]()
    
    var reasonText = ""

    
    
    // MARK: View lifecycle
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        hideBackButtonTitle()
        interactor?.hitGetBookingCancelReasonsApi()
        reasonsTableView.tableFooterView = UIView()
        applyLocalizedText()
        addObserverOnTableViewReload()
        reasonsTableView.layer.cornerRadius = 6
    }
    
    
    func addObserverOnTableViewReload() {
        reasonsTableView.addObserver(self, forKeyPath: tableContentSize, options: .new, context: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let obj = object as? UITableView {
            if obj == reasonsTableView && keyPath == tableContentSize {
                if (change?[NSKeyValueChangeKey.newKey] as? CGSize) != nil {
                    tableHeightConstraint.constant = reasonsTableView.contentSize.height
                }
            }
        }
    }
    
    deinit {
        // reasonsTableView.removeObserver(self, forKeyPath: tableContentSize)
    }
    
    
    // MARK: Apply LocalizedText
    func applyLocalizedText() {
        CommonFunctions.sharedInstance.setNavigationTitleView(titleStr: localizedTextFor(key: CancelAppointmentSceneText.CancelAppointmentSceneTitle.rawValue), onVC: self)
        submitBtn.setTitle(localizedTextFor(key: CancelAppointmentSceneText.CancelAppointmentSceneSubmitBtnTitle.rawValue), for: .normal)
    }
    
   
    
    // MARK: Button Actions
    
    @IBAction func submitBtn(_ sender: Any) {
        
        if reasonText != "" {
            showCancelAppoinmentAlert(reason: reasonText)
        }
        else {
            CustomAlertController.sharedInstance.showErrorAlert(error: localizedTextFor(key: CancelAppointmentSceneText.CancelAppointmentSceneSelectReasonAlert.rawValue))
        }
    }
    
    // MARK: ShowAlert
    func showCancelAppoinmentAlert(reason: String) {
        let alertController = PMAlertController(textForegroundColor:UIColor.darkGray, viewBackgroundColor: UIColor.white, title:  localizedTextFor(key: CancelAppointmentSceneText.CancelAppointmentScenePopupAlertTitle.rawValue), description: localizedTextFor(key: MyAppointmentSceneText.MyAppointmentSceneCancelAlertTitle.rawValue), image: nil, style: .alert)
        alertController.addAction(PMAlertAction(title: localizedTextFor(key: CancelAppointmentSceneText.CancelAppointmentScenePopupCancelBtnTitle.rawValue), style: .default, action: {
            alertController.dismiss(animated: true, completion: nil)
            
        }))
        
        alertController.addAction(PMAlertAction(title: localizedTextFor(key: CancelAppointmentSceneText.CancelAppointmentScenePopupConfirmBtnTitle.rawValue), style: .default, action: {
            self.interactor?.hitCancelAppoinmentApi(reason: reason)
        }))
        
        present(alertController, animated: true, completion: nil)
    }
    
    
    
    func displayCancelReasonsResponse(viewModel: CancelAppointment.ViewModel)
    {
        reasonsArray = viewModel.tableArray
        reasonsTableView.reloadData()
        printToConsole(item: reasonsArray)
    }
    
    // MARK: Display Cancel Appointment
    func displayCancelAppointmentResponse(msg: String) {
        CustomAlertController.sharedInstance.showAlert(subTitle: msg, type: .success)
//        router?.routeToMyAppoinmentVC()
         self.navigationController?.popViewController(animated: true)
    }
}

extension CancelAppointmentViewController : UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reasonsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReUseIdentifier, for: indexPath) as! CancelAppointmentTableViewCell
        
        let currentObj = reasonsArray[indexPath.row]
        
        if currentObj.isSelected {
            cell.selectionBtn.isSelected = true
        }
        else {
            cell.selectionBtn.isSelected = false
        }
        
        cell.reasonsLbl.text = currentObj.reason
        
    
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        for (index,_) in reasonsArray.enumerated(){
            reasonsArray[index].isSelected = false
        }
        
        var obj = reasonsArray[indexPath.row]
        obj.isSelected = !obj.isSelected
        reasonText = obj.reason
        reasonsArray[indexPath.row] = obj
        reasonsTableView.reloadData()
        
    }
    
}

//MARK:- UITextFieldDelegate
extension CancelAppointmentViewController : UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let updatedStr = (textView.text! as NSString).replacingCharacters(in: range, with: text)
        
        reasonText = updatedStr
        
        return true
        
    }
}
