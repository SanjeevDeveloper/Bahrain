
import UIKit
import SwipeCellKit

protocol ListServiceDisplayLogic: class
{
    func displayResponse(viewModel: ListService.ViewModel)
    func displayDeleteResponse(message:String, index:Int)
    func displayHitApiResponse()
    
}

class ListServiceViewController: UIViewController, ListServiceDisplayLogic
{
    
    var interactor: ListServiceBusinessLogic?
    var router: (NSObjectProtocol & ListServiceRoutingLogic & ListServiceDataPassing)?
    
    
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
        let interactor = ListServiceInteractor()
        let presenter = ListServicePresenter()
        let router = ListServiceRouter()
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
    
    @IBOutlet weak var listServiceTableView:UITableView!
    @IBOutlet weak var addView:UIView!
    @IBOutlet weak var addLabel:UILabel!
    @IBOutlet weak var addServiceLabel: UILabelFontSize!
    @IBOutlet weak var continueButton: UIButtonCustomClass?
    var listServiceArray = [ListService.ViewModel.tableRowData]()
    var offset = 0
    var delegate:movePageController!
    
    
    
    // MARK: View lifecycle
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        hideBackButtonTitle()
        applyLocalizedText()
        listServiceTableView.tableFooterView = UIView()
        initialFunction()
       continueButton?.backgroundColor = appBarThemeColor
    }
    
    override func viewWillAppear(_ animated: Bool) {
         self.navigationController?.isNavigationBarHidden = false
        if self.listServiceArray.count == 0 {
            addView.isHidden = false
        }
        else {
            addView.isHidden = true
        }
        interactor?.hitApiAgain()
    }
    
    // MARK: Apply LocalizedText
    func applyLocalizedText() {
        CommonFunctions.sharedInstance.setNavigationTitleView(titleStr:   localizedTextFor(key: ListServiceSceneText.listServiceSceneTitle.rawValue), onVC: self)
        addLabel.text = localizedTextFor(key: ListServiceSceneText.listServiceSceneAddLabel.rawValue)
        addServiceLabel.text = localizedTextFor(key: ListServiceSceneText.listServiceSceneAddServiceLabel.rawValue)
        continueButton?.setTitle(localizedTextFor(key: ListServiceSceneText.listServiceSceneContinueButton.rawValue), for: .normal)
    }
    
    // MARK: Button Actions
    
    @IBAction func continueButtonAction(_ sender: Any) {
        CustomAlertController.sharedInstance.showAlert(subTitle: localizedTextFor(key: GeneralText.servicesAdded.rawValue), type: .success)
        delegate.moveToNextPage()
    }
    
    // MARK: Other Functions
    
    func initialFunction() {
        if !appDelegateObj.isPageControlActive {
            continueButton?.removeFromSuperview()
        }
        interactor?.hitGetListServicesByBusinessIdApi(offset: offset)
    }
    
    // MARK: Display Response
    
    func displayResponse(viewModel: ListService.ViewModel)
    {
        listServiceArray = viewModel.serviceListArray
        listServiceTableView.reloadData()
        
        if self.listServiceArray.count == 0 {
            addView.isHidden = false
        }
        else {
            addView.isHidden = true
        }
    }
    
    func displayDeleteResponse(message: String, index: Int) {
        
        listServiceArray.remove(at: index)
        listServiceTableView.reloadData()
        if self.listServiceArray.count == 0 {
            addView.isHidden = false
        }
        else {
            addView.isHidden = true
        }
        CustomAlertController.sharedInstance.showAlert(subTitle: message, type: .success)
    }
    
    func displayHitApiResponse() {
        offset = 0
        listServiceArray.removeAll()
        interactor?.hitGetListServicesByBusinessIdApi(offset: offset)
    }
    
    // MARK: Show Alert
    func showAlert(request:ListService.Request) {
        
        let alertController = PMAlertController(textForegroundColor:UIColor.darkGray, viewBackgroundColor: UIColor.white, title: "" , description:localizedTextFor(key: ListServiceSceneText.listServiceSceneDeleteServiceLabel.rawValue), image: nil , style: .alert)
        
        let yesButton = PMAlertAction(title: localizedTextFor(key: GeneralText.yes.rawValue), style: .default, action: {
            
            self.interactor?.hitDeleteBusinessServiceApi(request: request)
            
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
extension ListServiceViewController : UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return listServiceArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        let footerView = view as! UITableViewHeaderFooterView
        footerView.tintColor = UIColor.clear
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReUseIdentifier, for: indexPath) as! ListServiceRowTableViewCell
        
        cell.delegate = self
        let currentObject = listServiceArray[indexPath.section]
        cell.serviceRowTitle.text = currentObject.serviceName
        
        if isCurrentLanguageArabic() {
            let flippedImage = UIImage(named: "pointing")?.imageFlippedForRightToLeftLayoutDirection()
            cell.pointImageView.image = flippedImage
        }
        
        let BhdText = localizedTextFor(key: GeneralText.bhd.rawValue)
        
        if currentObject.serviceType == salonTypes.both.rawValue {
            cell.homeButton.isSelected = true
            cell.salonButton.isSelected = true
            
            cell.servicePriceAndTime.text = String(format: "%.3f", currentObject.homePrice.floatValue)  + " " + BhdText + " " + currentObject.serviceDuration + "/" + String(format: "%.3f", currentObject.salonPrice.floatValue) + " " + BhdText + " " + currentObject.serviceDuration
        }
        if currentObject.serviceType == salonTypes.home.rawValue {
            cell.homeButton.isSelected = true
            cell.salonButton.isSelected = false
            cell.servicePriceAndTime.text = String(format: "%.3f", currentObject.homePrice.floatValue)  + " " + BhdText + " " + currentObject.serviceDuration
        }
        if currentObject.serviceType == salonTypes.salon.rawValue {
            cell.salonButton.isSelected = true
            cell.homeButton.isSelected = false
            cell.servicePriceAndTime.text = String(format: "%.3f", currentObject.salonPrice.floatValue) + " " + BhdText + " " + currentObject.serviceDuration
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.section == (((self.offset + 1)*10) - 1) {
            self.offset += 1
            initialFunction()
        }
    }
}

// MARK: SwipeTableViewCellDelegate

extension ListServiceViewController :SwipeTableViewCellDelegate {
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        if isCurrentLanguageArabic() {
            guard orientation == .left else { return nil }
            
            let deleteAction = SwipeAction(style: .default, title: localizedTextFor(key: GeneralText.deleteRow.rawValue)) { action, indexPath in
                // handle action by updating model with deletion
                
                let currentObject = self.listServiceArray[indexPath.section]
                let id = currentObject.serviceId
                
                let req = ListService.Request(serviceId: id, indexPath: indexPath.section)
                self.showAlert(request: req)
            }
            deleteAction.image = UIImage(named: "deleteIcon")
            deleteAction.backgroundColor = UIColor.red
            
            let editAction = SwipeAction(style: .default, title: localizedTextFor(key: GeneralText.editRow.rawValue)) { action, indexPath in
                // handle action by updating model with deletion
                
                let currentObject = self.listServiceArray[indexPath.section]
                self.router?.routeToEditService(segue: nil, dict: currentObject)
                
            }
            editAction.image = UIImage(named: "editIcon")
            editAction.backgroundColor = UIColor(red: 101.0/256, green: 194.0/256, blue: 90.0/256, alpha: 1.0)
            
            return [deleteAction,editAction]
    } else {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .default, title: localizedTextFor(key: GeneralText.deleteRow.rawValue)) { action, indexPath in
            // handle action by updating model with deletion
            
            let currentObject = self.listServiceArray[indexPath.section]
            let id = currentObject.serviceId
            
            let req = ListService.Request(serviceId: id, indexPath: indexPath.section)
            self.showAlert(request: req)
        }
        deleteAction.image = UIImage(named: "deleteIcon")
        deleteAction.backgroundColor = UIColor.red
        
        let editAction = SwipeAction(style: .default, title: localizedTextFor(key: GeneralText.editRow.rawValue)) { action, indexPath in
            // handle action by updating model with deletion
            
            let currentObject = self.listServiceArray[indexPath.section]
            self.router?.routeToEditService(segue: nil, dict: currentObject)
            
        }
        editAction.image = UIImage(named: "editIcon")
        editAction.backgroundColor = UIColor(red: 101.0/256, green: 194.0/256, blue: 90.0/256, alpha: 1.0)
        
        return [deleteAction,editAction]
        }
    }
    
}

