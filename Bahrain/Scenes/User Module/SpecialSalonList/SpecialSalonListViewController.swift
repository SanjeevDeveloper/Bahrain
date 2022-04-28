
import UIKit

protocol SpecialSalonListDisplayLogic: class {
    func displayResponse(viewModel: SpecialSalonList.ViewModel)
}

class SpecialSalonListViewController: UIViewController, SpecialSalonListDisplayLogic {
    var interactor: SpecialSalonListBusinessLogic?
    var router: (NSObjectProtocol & SpecialSalonListRoutingLogic & SpecialSalonListDataPassing)?
    
    // MARK: Object Life Cycle
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK: Setup
    
    private func setup() {
        let viewController = self
        let interactor = SpecialSalonListInteractor()
        let presenter = SpecialSalonListPresenter()
        let router = SpecialSalonListRouter()
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
    
    // MARK: Interface Builder Outlets
    
    @IBOutlet weak var specialSalonTblV: UITableView!
    @IBOutlet weak var noSalons: UILabelFontSize!
    @IBOutlet weak var backButton: UIButton!
    
    // MARK: Interface Builder Properties
    
    var salonsArray = [SpecialSalonList.SalonObject]()
    
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideBackButtonTitle()
        if isCurrentLanguageArabic() {
                   backButton.contentHorizontalAlignment = .right
                   backButton.setImage(UIImage(named: "whiteRightArrow"), for: .normal)
               } else {
                   backButton.contentHorizontalAlignment = .left
                   backButton.setImage(UIImage(named: "whiteBackIcon"), for: .normal)
               }
        noSalons.text = localizedTextFor(key: GeneralText.noSalonAvailableMessage.rawValue).uppercased()
        CommonFunctions.sharedInstance.setNavigationTitleView(titleStr: localizedTextFor(key: HomeSceneText.homeSceneSpecialOffer.rawValue).uppercased(), onVC: self)
        interactor?.getSalonsWithSpecialOffers(offset: 0)
    }
    
    // MARK: Display Response
    
    func displayResponse(viewModel: SpecialSalonList.ViewModel) {
        salonsArray = viewModel.listBusiness
        if salonsArray.count > 0 {
            specialSalonTblV.isHidden = false
            noSalons.isHidden = true
        } else {
            specialSalonTblV.isHidden = true
            noSalons.isHidden = false
        }
        specialSalonTblV.reloadData()
    }
    
    @IBAction func backBarButtonItem(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension SpecialSalonListViewController : UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return salonsArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReUseIdentifier, for: indexPath) as! SpecialSalonTableViewCell
        cell.displayCellData(salonObj: salonsArray[indexPath.section])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 10))
        headerView.backgroundColor = .clear
        return headerView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        router?.routeToSaloonDetail(businessId: salonsArray[indexPath.section].businessId ?? "")
    }
}
