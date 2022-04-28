
import UIKit

protocol SpecialOffersListDisplayLogic: class
{
    func displayResponse(viewModel: SpecialOffersList.ViewModel)
    func displayDeleteOfferResponse(msg: String, index:Int)
    
}

class SpecialOffersListViewController: UIViewController, SpecialOffersListDisplayLogic
{
    
    
    var interactor: SpecialOffersListBusinessLogic?
    var router: (NSObjectProtocol & SpecialOffersListRoutingLogic & SpecialOffersListDataPassing)?
    
    
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
        let interactor = SpecialOffersListInteractor()
        let presenter = SpecialOffersListPresenter()
        let router = SpecialOffersListRouter()
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
    
    @IBOutlet weak var offerListTableView: UITableView!
    @IBOutlet weak var addOffersLabel: UILabelFontSize!
    var OffersListArray = [SpecialOffersList.ViewModel.tableCellData]()
    
    @IBOutlet weak var addView: UIView!
    @IBOutlet weak var addLabel: UILabelFontSize!
    var offset = 0
    
    // MARK: View lifecycle
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        hideBackButtonTitle()
        offerListTableView.tableFooterView = UIView()
        initialFunction()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        applyLocalizedText()
        if self.OffersListArray.count == 0 {
            addView.isHidden = false
        }
        else {
            addView.isHidden = true
        }
    }
    
    
    // MARK: Apply LocalizedText
    func applyLocalizedText() {
        CommonFunctions.sharedInstance.setNavigationTitleView(titleStr:   localizedTextFor(key: SpecialOffersListSceneText.SpecialOffersListSceneTitle.rawValue), onVC: self)
        addOffersLabel.text = localizedTextFor(key: SpecialOffersListSceneText.SpecialOffersListSceneAddOfferLabel.rawValue)
        addLabel.text = localizedTextFor(key: SpecialOffersListSceneText.SpecialOffersListSceneAddOfferLabel.rawValue)
    }
    
    
    // MARK: Other Functions
    
    func initialFunction() {
        interactor?.hitGetListBusinessOffersAPI(offset: offset)
    }
    
    // MARK: Button Actions
    
    @IBAction func addOfferButtonAction(_ sender: Any) {
        
    }
    
    @objc func deleteButtonAction(sender:UIButton) {
        var v:UIView = sender
        repeat { v = v.superview! } while !(v is UITableViewCell)
        let cell = v as! SpecialOffersListTableViewCell
        let indexPath = offerListTableView.indexPath(for:cell)!
        
        let obj = OffersListArray[indexPath.section]
        
        let req = SpecialOffersList.Request(offerId: obj.offerId, indexPath: indexPath.section)
        showAlert(request: req)
    }
    
    
    // MARK: Display Response
    func displayResponse(viewModel: SpecialOffersList.ViewModel)
    {
        OffersListArray.append(contentsOf: viewModel.offerListArray)
        offerListTableView.reloadData()
        if self.OffersListArray.count == 0 {
            addView.isHidden = false
        }
        else {
            addView.isHidden = true
        }
    }
    
    func displayDeleteOfferResponse(msg: String, index: Int) {
        OffersListArray.remove(at: index)
        offerListTableView.reloadData()
        CustomAlertController.sharedInstance.showAlert(subTitle: msg, type: .success)
    }
    
    func showAlert(request: SpecialOffersList.Request) {
        let alertController = PMAlertController(textForegroundColor:UIColor.darkGray, viewBackgroundColor: UIColor.white, title: "", description: localizedTextFor(key: SpecialOffersListSceneText.SpecialOffersListSceneDeleteOfferText.rawValue), image: nil, style: .alert)
        alertController.addAction(PMAlertAction(title: localizedTextFor(key: GeneralText.no.rawValue), style: .default, action: {
            alertController.dismiss(animated: true, completion: nil)
            
        }))
        
        alertController.addAction(PMAlertAction(title: localizedTextFor(key: GeneralText.yes.rawValue), style: .default, action: {
            let request = SpecialOffersList.Request(offerId: request.offerId, indexPath: request.indexPath)
            self.interactor?.hitDeleteOfferApi(request: request)
            
        }))
        
        present(alertController, animated: true, completion: nil)
    }
}

// MARK: UITableViewDelegate

extension SpecialOffersListViewController : UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return OffersListArray.count
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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReUseIdentifier, for: indexPath) as! SpecialOffersListTableViewCell
        
        let currentObj = OffersListArray[indexPath.section]
        cell.setData(currentObj: currentObj)
        cell.deleteButton.addTarget(self, action: #selector(self.deleteButtonAction(sender:)), for: .touchUpInside)
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.section == (((self.offset + 1)*10) - 1) {
            self.offset += 1
            initialFunction()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        router?.routeToEditOffer()
    }
}
