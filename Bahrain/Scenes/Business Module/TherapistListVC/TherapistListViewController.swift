
import UIKit
import SwipeCellKit

protocol TherapistListDisplayLogic: class
{
    func displayResponse(viewModel: TherapistList.ViewModel)
    func displayHitApiResponse()
    func displayHitcheckTherapistAssignedResponse()
}

class TherapistListViewController: UIViewController, TherapistListDisplayLogic
{
    
    var interactor: TherapistListBusinessLogic?
    var router: (NSObjectProtocol & TherapistListRoutingLogic & TherapistListDataPassing)?
    
    
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
        let interactor = TherapistListInteractor()
        let presenter = TherapistListPresenter()
        let router = TherapistListRouter()
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
    
    @IBOutlet weak var addLabel:UILabel!
    @IBOutlet weak var therapistsTableView:UITableView!
    @IBOutlet weak var addView:UIView!
    @IBOutlet weak var addTherapistLabel: UILabelFontSize!
    @IBOutlet weak var continueButton: UIButtonCustomClass?
    @IBOutlet weak var continueButtonOnAddView: UIButtonCustomClass!
    
    var offset = 0
    var therapistsArray = [TherapistList.ViewModel.tableCellData]()
    var delegate:movePageController!
    
    // MARK: View lifecycle
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        therapistsTableView.tableFooterView = UIView()
        hideBackButtonTitle()
        initialFunction()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        applyFontAndColor()
        applyLocalizedText()
        if self.therapistsArray.count == 0 {
            addView.isHidden = false
        }
        else {
            addView.isHidden = true
        }
        
        interactor?.hitApiAgain()
    }
    
    // MARK: Apply Font And Color
    func applyFontAndColor() {
        addLabel.textColor = appTxtfDarkColor
        addTherapistLabel.textColor = appTxtfDarkColor
        
        if appDelegateObj.isPageControlActive {
            continueButton?.backgroundColor = appBarThemeColor
            continueButtonOnAddView.backgroundColor = appBarThemeColor
        }
    }
    
    // MARK: Apply LocalizedText
    func applyLocalizedText() {
        CommonFunctions.sharedInstance.setNavigationTitleView(titleStr:   localizedTextFor(key: TherapistListSceneText.therapistListSceneTitle.rawValue), onVC: self)
        addLabel.text = localizedTextFor(key: TherapistListSceneText.therapistListSceneAddLabel.rawValue)
        addTherapistLabel.text = localizedTextFor(key: TherapistListSceneText.therapistListSceneAddLabel.rawValue)
        continueButton?.setTitle(localizedTextFor(key: TherapistListSceneText.therapistListSceneListBusinessButtonTitle.rawValue), for: .normal)
        
        //Added later
        continueButtonOnAddView?.setTitle(localizedTextFor(key: TherapistListSceneText.therapistListSceneListBusinessButtonTitle.rawValue), for: .normal)
    }
    
    // MARK: Button Actions
    
    @IBAction func continueButtonAction(_ sender: Any) {
        interactor?.HitcheckTherapistAssigned()
    }
    
    // MARK: Other Function
    func initialFunction()
    {
        if !appDelegateObj.isPageControlActive {
            continueButtonOnAddView?.removeFromSuperview()
            continueButton?.removeFromSuperview()
        }
        interactor?.HitListTherapistByBusinessId(offset: offset)
    }
    
    func showThankYouAlert() {
        let alertController = PMAlertController(textForegroundColor:UIColor.darkGray, viewBackgroundColor: UIColor.white, title: localizedTextFor(key: TherapistListSceneText.therapistListSceneThanksAlertTitle.rawValue), description: localizedTextFor(key: TherapistListSceneText.therapistListSceneThanksAlertSubtitle.rawValue), image: nil, style: .alert)
        
        alertController.addAction(PMAlertAction(title: localizedTextFor(key: GeneralText.doneButton.rawValue), style: .default, action: {
            alertController.dismiss(animated: true, completion: nil)
            
            appDelegateObj.isPageControlActive = false
            appDelegateObj.saloonStep1Data = nil
            appDelegateObj.selectedArea = nil
            
            //            var viewControllersArray = self.navigationController?.viewControllers
            
            //            let businessTodayViewControllerObj = self.storyboard?.instantiateViewController(withIdentifier: ViewControllersIds.BusinessTodayViewControllerID)
            //
            //             viewControllersArray?.removeAll()
            let storyboard = AppStoryboard.Main.instance
            let tabBarController = storyboard.instantiateViewController(withIdentifier: AppDelegatePaths.Identifiers.UserModuleNavigationControllerID)
            appDelegateObj.window?.rootViewController = tabBarController
            appDelegateObj.window?.makeKeyAndVisible()
            
            //            viewControllersArray?.append(businessTodayViewControllerObj!)
            //            self.navigationController?.setViewControllers(viewControllersArray!, animated: false)
        }))
        
        present(alertController, animated: true, completion: nil)
    }
    
    func displayHitApiResponse() {
        offset = 0
        therapistsArray.removeAll()
        interactor?.HitListTherapistByBusinessId(offset: offset)
    }
    
    // MARK: Display Response
    func displayResponse(viewModel: TherapistList.ViewModel)
    {
        printToConsole(item: viewModel.serviceListArray)
        
        therapistsArray = viewModel.serviceListArray
        
        printToConsole(item: therapistsArray)
        therapistsTableView.reloadData()
        if self.therapistsArray.count == 0 {
            addView.isHidden = false
        }
        else {
            addView.isHidden = true
        }
    }
    
    func displayHitcheckTherapistAssignedResponse() {
        showThankYouAlert()
    }
}

// MARK: UITableViewDelegate
extension TherapistListViewController : UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return therapistsArray.count
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
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReUseIdentifier, for: indexPath) as! TherapistListTableViewCell
        cell.delegate = self
        let therapistObj = therapistsArray[indexPath.section]
        cell.therapistNameLabel.text = therapistObj.therapistName
        if isCurrentLanguageArabic() {
            let flippedImage = UIImage(named: "pointing")?.imageFlippedForRightToLeftLayoutDirection()
            cell.pointImageView.image = flippedImage
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.section == (((self.offset + 1)*10) - 1) {
            self.offset += 1
            //            initialFunction()
        }
    }
}
// MARK: SwipeTableViewCellDelegate

extension TherapistListViewController :SwipeTableViewCellDelegate {
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        if isCurrentLanguageArabic() {
            guard orientation == .left else { return nil }
            
            let editAction = SwipeAction(style: .default, title: localizedTextFor(key: GeneralText.editRow.rawValue)) { action, indexPath in
                // handle action by updating model with deletion
                
                let currentObject = self.therapistsArray[indexPath.section]
                
                self.router?.routeToEditTherapist(segue: nil, dict: currentObject)
                
            }
            editAction.image = #imageLiteral(resourceName: "editIcon")
            editAction.backgroundColor = UIColor(red: 101.0/256, green: 194.0/256, blue: 90.0/256, alpha: 1.0)
            
            
            return [editAction]
        } else {
            guard orientation == .right else { return nil }
            
            let editAction = SwipeAction(style: .default, title: localizedTextFor(key: GeneralText.editRow.rawValue)) { action, indexPath in
                // handle action by updating model with deletion
                
                let currentObject = self.therapistsArray[indexPath.section]
                
                self.router?.routeToEditTherapist(segue: nil, dict: currentObject)
                
            }
            editAction.image = #imageLiteral(resourceName: "editIcon")
            editAction.backgroundColor = UIColor(red: 101.0/256, green: 194.0/256, blue: 90.0/256, alpha: 1.0)
            
            
            return [editAction]
        }
    }
}

// MARK: UITextFieldDelegate

extension TherapistListViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
