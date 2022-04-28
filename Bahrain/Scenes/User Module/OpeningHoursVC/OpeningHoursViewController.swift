
import UIKit

protocol OpeningHoursDisplayLogic: class
{
    func displayResponse(viewModel: OpeningHours.ViewModel)
}

class OpeningHoursViewController: UIViewController, OpeningHoursDisplayLogic
{
    var interactor: OpeningHoursBusinessLogic?
    var router: (NSObjectProtocol & OpeningHoursRoutingLogic & OpeningHoursDataPassing)?
    
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
        let interactor = OpeningHoursInteractor()
        let presenter = OpeningHoursPresenter()
        let router = OpeningHoursRouter()
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
    
    //////////////////////////////////////////////////////////////////////
    
    @IBOutlet weak var openingHoursTableView: UITableView!
    @IBOutlet weak var backButton: UIButton!
    
    var openingHoursArray = [OpeningHours.ViewModel.tableCellData]()
    
    // MARK: View lifecycle
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.hideBackButtonTitle()
        openingHoursTableView.tableFooterView = UIView()
        initialFunction()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        CommonFunctions.sharedInstance.setNavigationTitleView(titleStr:  localizedTextFor(key: OpeningHoursSceneText.OpeningHoursSceneTitle.rawValue), onVC: self)
    }
    
    @IBAction func backBarButtonItem(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: Other Functions
    
    func initialFunction() {
        
        if isCurrentLanguageArabic() {
            backButton.contentHorizontalAlignment = .right
            backButton.setImage(UIImage(named: "whiteRightArrow"), for: .normal)
        } else {
            backButton.contentHorizontalAlignment = .left
            backButton.setImage(UIImage(named: "whiteBackIcon"), for: .normal)
        }
        
        interactor?.getBusinessByIdApi()
    }
    
    // MARK: DisplayResponse
    func displayResponse(viewModel: OpeningHours.ViewModel)
    {
        if let errorString = viewModel.errorString {
            CustomAlertController.sharedInstance.showErrorAlert(error: errorString)
        }
        else {
            openingHoursArray = viewModel.tableArray
            openingHoursTableView.reloadData()
        }
    }
}

// MARK: UITableViewDelegate
extension OpeningHoursViewController : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return openingHoursArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReUseIdentifier, for: indexPath) as! OpeningHoursTableViewCell
        
        let rowsObject = openingHoursArray[indexPath.row]
        
        switch rowsObject.day.capitalized {
        case "Sunday":
            cell.weekLabel.text = localizedTextFor(key: GeneralText.arsun.rawValue)
        case "Monday":
            cell.weekLabel.text = localizedTextFor(key: GeneralText.armon.rawValue)
        case "Tuesday":
            cell.weekLabel.text = localizedTextFor(key: GeneralText.artue.rawValue)
        case "Wednesday":
            cell.weekLabel.text = localizedTextFor(key: GeneralText.arwed.rawValue)
        case "Thursday":
            cell.weekLabel.text = localizedTextFor(key: GeneralText.arthu.rawValue)
        case "Friday":
            cell.weekLabel.text = localizedTextFor(key: GeneralText.arfri.rawValue)
        default:
            cell.weekLabel.text = localizedTextFor(key: GeneralText.arsat.rawValue)
        }
        
        cell.timeLabel.text = rowsObject.timeFrom + " " + localizedTextFor(key: OpeningHoursSceneText.OpeningHoursSceneToText.rawValue) + " " + rowsObject.timeTo
        
        
        return cell
    }
}

