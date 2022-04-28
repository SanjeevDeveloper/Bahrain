
import UIKit

protocol ListScheduledBreakDisplayLogic: class
{
  func displayArrayData(viewModelTable: [AddScheduledBreak.ViewModel.tableCellData])
  func displayApiResponse(viewModel: AddScheduledBreak.ViewModel)
    func displayScheduleArray(scheduledArray: [AddScheduledBreak.ViewModel.tableCellData]?)
}

class ListScheduledBreakViewController: UIViewController, ListScheduledBreakDisplayLogic
{
   
    
  var interactor: ListScheduledBreakBusinessLogic?
  var router: (NSObjectProtocol & ListScheduledBreakRoutingLogic & ListScheduledBreakDataPassing)?

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
    let interactor = ListScheduledBreakInteractor()
    let presenter = ListScheduledBreakPresenter()
    let router = ListScheduledBreakRouter()
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
  
    
 /////////////////////////////////////////////////////////////////
    
    
    @IBOutlet weak var scheduledBreakTableView: UITableView!
    @IBOutlet weak var DoneButton: UIButtonCustomClass!
    @IBOutlet weak var addBreakLabel: UILabelFontSize!
    @IBOutlet weak var addView: UIView!
    @IBOutlet weak var addLabel: UILabelFontSize!
    
    var scheduledBreakArray = [AddScheduledBreak.ViewModel.tableCellData]()
    var offset = 0
    // MARK: View lifecycle
  
  override func viewDidLoad()
  {
    super.viewDidLoad()
    hideBackButtonTitle()
    scheduledBreakTableView.tableFooterView = UIView()
    interactor?.getScheduledArray()
//    initialFunction()
  }
        override func viewWillAppear(_ animated: Bool) {
        interactor?.getArrayData()
            
        CommonFunctions.sharedInstance.setNavigationTitleView(titleStr:   localizedTextFor(key: ListScheduledBreakSceneText.ListScheduledBreakSceneTitle.rawValue), onVC: self)
        DoneButton.setTitle(localizedTextFor(key: ListScheduledBreakSceneText.ListScheduledBreakSceneDoneButton.rawValue), for: .normal)
        addLabel.text = localizedTextFor(key: ListScheduledBreakSceneText.ListScheduledBreakSceneAddScheduledBreakLabel.rawValue)
        addBreakLabel.text = localizedTextFor(key: ListScheduledBreakSceneText.ListScheduledBreakSceneAddScheduledLabel.rawValue)
        
        if self.scheduledBreakArray.count == 0 {
            addView.isHidden = false
        }
        else {
            addView.isHidden = true
        }
    }
    
    // MARK: InitialFunction
    
    func initialFunction()
    {
        interactor?.HitListScheduleBreaks(offset: offset)
    }
  

 // MARK: DisplayApiResponse
    func displayApiResponse(viewModel: AddScheduledBreak.ViewModel) {
        
        scheduledBreakArray = viewModel.scheduledBreakArray
        scheduledBreakTableView.reloadData()
        if self.scheduledBreakArray.count == 0 {
            addView.isHidden = false
        }
        else {
            addView.isHidden = true
        }
        
    }
    
    func displayScheduleArray(scheduledArray: [AddScheduledBreak.ViewModel.tableCellData]?) {
        
        if scheduledArray != nil {
            scheduledBreakArray = scheduledArray!
        }
        
        scheduledBreakTableView.reloadData()
        if self.scheduledBreakArray.count == 0 {
            addView.isHidden = false
        }
        else {
            addView.isHidden = true
        }
    }
    
    
  func displayArrayData(viewModelTable: [AddScheduledBreak.ViewModel.tableCellData])
  {
    scheduledBreakArray.append(contentsOf: viewModelTable)
    scheduledBreakTableView.reloadData()
    if self.scheduledBreakArray.count == 0 {
        addView.isHidden = false
    }
    else {
        addView.isHidden = true
    }
    interactor?.deleteScheduleObj()
  }
    
     // MARK: Button Action
    
    @IBAction func doneButtonAction(_ sender: Any) {
        router?.routeToAddTherapist(segue: nil, scheduledArray: scheduledBreakArray)
    }
    
    @objc func deleteButtonAction(sender:UIButton) {
        var v:UIView = sender
        repeat { v = v.superview! } while !(v is UITableViewCell)
        let cell = v as! ListscheduledBreakTableViewCell
        let indexPath = scheduledBreakTableView.indexPath(for:cell)!
        
        showAlert(indexpath: indexPath.section)
        
    }
    
    func showAlert(indexpath:Int) {
        
        let alertController = PMAlertController(textForegroundColor:UIColor.darkGray, viewBackgroundColor: UIColor.white, title: "" , description:"Are you sure you want to delete this schedule break", image: nil , style: .alert)
        
        let yesButton = PMAlertAction(title: localizedTextFor(key: GeneralText.yes.rawValue), style: .default, action: {
            
            self.scheduledBreakArray.remove(at: indexpath)
            self.scheduledBreakTableView.reloadData()
        })
        
        let noButton = PMAlertAction(title: localizedTextFor(key: GeneralText.no.rawValue), style: .default, action: {
            alertController.dismiss(animated: true, completion: nil)
        })
        
        alertController.addAction(noButton)
        alertController.addAction(yesButton)
        
        present(alertController, animated: true, completion: nil)
    }
}

// MARK: UITableViewDelegate
extension ListScheduledBreakViewController : UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return scheduledBreakArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 15
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let headerView = view as! UITableViewHeaderFooterView
        headerView.tintColor = UIColor.clear
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReUseIdentifier, for: indexPath) as! ListscheduledBreakTableViewCell
        let currentObj = scheduledBreakArray[indexPath.section]
        cell.repeatInfo.text = currentObj.repeatInfo
        cell.titleLabel.text = currentObj.title
        cell.startTimeLabel.text = "Start- " + currentObj.start
        cell.endTimeLabel.text = "End- " + currentObj.end
         cell.deleteButton.addTarget(self, action: #selector(self.deleteButtonAction(sender:)), for: .touchUpInside)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.section == (((self.offset + 1)*10) - 1) {
            self.offset += 1
            //initialFunction()
        }
    }
    
}
