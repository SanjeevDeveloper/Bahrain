
import UIKit

protocol SettingDisplayLogic: class
{
    func displaySomething(viewModel: Setting.ViewModel)
}

class SettingViewController: BaseViewControllerBusiness, SettingDisplayLogic
{
    var interactor: SettingBusinessLogic?
    var router: (NSObjectProtocol & SettingRoutingLogic & SettingDataPassing)?
    
    var settingsArray = [Setting.ViewModel.header]()
    var isApprove = Bool()
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
        let interactor = SettingInteractor()
        let presenter = SettingPresenter()
        let router = SettingRouter()
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
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        doSomething()
        addSlideMenuButton()
        self.hideBackButtonTitle()
        listTableView.tableFooterView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        applyLocalizedText()
    }
    
    // MARK: Apply LocalizedText
    func applyLocalizedText() {
        
        CommonFunctions.sharedInstance.setNavigationTitleView(titleStr:   localizedTextFor(key: SettingsSceneText.settingSceneTitle.rawValue), onVC: self)
        
        let firstHeader = Setting.ViewModel.header(
            title: localizedTextFor(key: SettingsSceneText.headerClients.rawValue),
            image: #imageLiteral(resourceName: "clients"),
            rows: [
                Setting.ViewModel.row(title: localizedTextFor(key: SettingsSceneText.rowClientReviews.rawValue)),
                Setting.ViewModel.row(title: localizedTextFor(key: SettingsSceneText.rowClients.rawValue)),
                Setting.ViewModel.row(title: localizedTextFor(key: SettingsSceneText.rowAppointments.rawValue)),
                Setting.ViewModel.row(title: localizedTextFor(key: BusinessSideMenuText.calendarMenuTitle.rawValue)),
                Setting.ViewModel.row(title: localizedTextFor(key: BusinessSideMenuText.bookingMenuTitle.rawValue))
            ]
        )
        
        let secondHeader = Setting.ViewModel.header(
            title: localizedTextFor(key: SettingsSceneText.headerProfile.rawValue),
            image: #imageLiteral(resourceName: "profile"),
            rows: [
                Setting.ViewModel.row(title: localizedTextFor(key: SettingsSceneText.rowViewProfile.rawValue)),
                Setting.ViewModel.row(title: localizedTextFor(key: SettingsSceneText.rowPhotos.rawValue)),
                Setting.ViewModel.row(title: localizedTextFor(key: SettingsSceneText.rowServices.rawValue)),
                Setting.ViewModel.row(title: localizedTextFor(key: SettingsSceneText.rowCategories.rawValue))
            ]
        )
        
        let thirdHeader = Setting.ViewModel.header(
            title: localizedTextFor(key: SettingsSceneText.headerOffers.rawValue),
            image: #imageLiteral(resourceName: "offers"),
            rows: [
                Setting.ViewModel.row(title: localizedTextFor(key: SettingsSceneText.rowSpecialOffer.rawValue))
            ]
        )
        
        let fourthHeader = Setting.ViewModel.header(
            title: localizedTextFor(key: SettingsSceneText.headerSchedule.rawValue),
            image: #imageLiteral(resourceName: "schedule"),
            rows: [
                Setting.ViewModel.row(title: localizedTextFor(key: SettingsSceneText.rowWorkingHours.rawValue)),
                Setting.ViewModel.row(title: localizedTextFor(key: SettingsSceneText.rowTherapist.rawValue))
            ]
        )
        
        let fifthHeader = Setting.ViewModel.header(
            title: localizedTextFor(key: SettingsSceneText.headerAccount.rawValue),
            image: #imageLiteral(resourceName: "account"),
            rows: [
                Setting.ViewModel.row(title: localizedTextFor(key: SettingsSceneText.rowBasicInfo.rawValue)),
                Setting.ViewModel.row(title: localizedTextFor(key: SettingsSceneText.rowLocations.rawValue)),
                Setting.ViewModel.row(title: localizedTextFor(key: SettingsSceneText.rowAccountVisibility.rawValue))
            ]
        )
        settingsArray.append(firstHeader)
        settingsArray.append(secondHeader)
        settingsArray.append(thirdHeader)
        settingsArray.append(fourthHeader)
        settingsArray.append(fifthHeader)
    }
    
    @IBOutlet weak var listTableView:UITableView!
    
    func doSomething()
    {
        let request = Setting.Request()
        interactor?.doSomething(request: request)
    }
    
    func displaySomething(viewModel: Setting.ViewModel)
    {
        //nameTextField.text = viewModel.name
    }
    
    func getapproveddata() {
        let isapprove = userDefault.value(forKey: "isApproved") as? Bool
        if isapprove != nil {
            if isapprove == true {
                self.isApprove = true
            }
            else {
                self.isApprove = false
            }
        }
    }
}

// MARK: UITableViewDelegate

extension SettingViewController : UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.settingsArray.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerCell = tableView.dequeueReusableCell(withIdentifier: "Header") as! SectionTableViewCell
        
        let sectionDict = settingsArray[section]
        headerCell.sectionTextLabel.text = sectionDict.title
        headerCell.sectionImageView.image = sectionDict.image
        
        return headerCell
    }    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionObject = settingsArray[section]
        let rowsObject = sectionObject.rows
        return rowsObject.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let router = router {
            getapproveddata()
            switch indexPath {
            case [0,0]:
                //  CustomAlertController.sharedInstance.showComingSoonAlert()
                router.routeToAnotherScreen(identifier: ViewControllersIds.ClientReviewsViewControllerID)
                
            case [0,1]:
                // CustomAlertController.sharedInstance.showComingSoonAlert()
                router.routeToAnotherScreen(identifier: ViewControllersIds.ClientListViewControllerID)
                
            case [0,2]:
                // CustomAlertController.sharedInstance.showComingSoonAlert()
                if isApprove{
                    router.routeToAnotherScreen(identifier: ViewControllersIds.BusinessTodayViewControllerID)
                }
                else {
                    CustomAlertController.sharedInstance.showErrorAlert(error: localizedTextFor(key: BusinessSideMenuText.NotApproved.rawValue))
                }
                
            case [0,3]:
                // CustomAlertController.sharedInstance.showComingSoonAlert()
                if isApprove{
                    router.routeToAnotherScreen(identifier: ViewControllersIds.BusinessCalenderViewControllerID)
                }
                else {
                    CustomAlertController.sharedInstance.showErrorAlert(error: localizedTextFor(key: BusinessSideMenuText.NotApproved.rawValue))
                }
                
            case [0,4]:
                // CustomAlertController.sharedInstance.showComingSoonAlert()
                if isApprove{
                    router.routeToAnotherScreen(identifier: ViewControllersIds.BusinessBookingViewControllerID)
                }
                else {
                    CustomAlertController.sharedInstance.showErrorAlert(error: localizedTextFor(key: BusinessSideMenuText.NotApproved.rawValue))
                }
                
            case [1,0]:
                //  CustomAlertController.sharedInstance.showComingSoonAlert()
                router.routeToAnotherScreen(identifier: ViewControllersIds.ViewProfileViewControllerID)
                
            case [1,1]:
                //   CustomAlertController.sharedInstance.showComingSoonAlert()
                router.routeToAnotherScreen(identifier: ViewControllersIds.AddPhotosViewControllerID)
                
            case [1,2]:
                // CustomAlertController.sharedInstance.showComingSoonAlert()
                router.routeToAnotherScreen(identifier: ViewControllersIds.ListServiceViewControllerID)
                
            case [1,3]:
                
                //   CustomAlertController.sharedInstance.showComingSoonAlert()
                router.routeToAnotherScreen(identifier: ViewControllersIds.ListYourServiceViewControllerID)
                
            case [2,0]:
                // CustomAlertController.sharedInstance.showComingSoonAlert()
                router.routeToAnotherScreen(identifier: ViewControllersIds.SpecialOffersListViewControllerID)
                
                
            case [3,0]:
                //  CustomAlertController.sharedInstance.showComingSoonAlert()
                router.routeToAnotherScreen(identifier: ViewControllersIds.WorkingHoursViewControllerID)
                
                //            case [3,1]:
                //                router.routeToAnotherScreen(identifier: ViewControllersIds.BookingSettingViewControllerID)
                
            case [3,1]:
                //  CustomAlertController.sharedInstance.showComingSoonAlert()
                router.routeToAnotherScreen(identifier: ViewControllersIds.TherapistListViewControllerID)
                
            case [4,0]:
                //  CustomAlertController.sharedInstance.showComingSoonAlert()
                router.routeToAnotherScreen(identifier: ViewControllersIds.BasicInformationViewControllerID)
                
            case [4,1]:
                //  CustomAlertController.sharedInstance.showComingSoonAlert()
                router.routeToAnotherScreen(identifier: ViewControllersIds.LocationViewControllerID)
                
            case [4,2]:
                // CustomAlertController.sharedInstance.showComingSoonAlert()
                router.routeToAnotherScreen(identifier: ViewControllersIds.AccountVisibilityViewControllerID)
                
            default:
                break
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReUseIdentifier, for: indexPath) as! RowTableViewCell
        
        let sectionObject = settingsArray[indexPath.section]
        let rowsArray = sectionObject.rows
        let rowsObject = rowsArray[indexPath.row]
        cell.rowTextLabel?.text = rowsObject.title
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView()
        return footerView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 20
    }
}


