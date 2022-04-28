
import UIKit
import Cosmos

protocol ClientReviewsDisplayLogic: class
{
    func displayResponse(viewModel: ClientReviews.ViewModel)
}

class ClientReviewsViewController: UIViewController, ClientReviewsDisplayLogic
{
    var interactor: ClientReviewsBusinessLogic?
    var router: (NSObjectProtocol & ClientReviewsRoutingLogic & ClientReviewsDataPassing)?
    
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
        let interactor = ClientReviewsInteractor()
        let presenter = ClientReviewsPresenter()
        let router = ClientReviewsRouter()
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
    
    @IBOutlet weak var clientReviewTableView:UITableView!
    @IBOutlet weak var showHideLabel: UILabelFontSize!
    var clientReviewArray = [ClientReviews.ViewModel.tableCellData]()
    var offset = 0
    
    
    // MARK: View lifecycle
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        clientReviewTableView.tableFooterView = UIView()
        initialFunction()
        applyFontAndColor()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        applyLocalizedText()
        if self.clientReviewArray.count == 0 {
            showHideLabel.isHidden = false
        }
        else {
            showHideLabel.isHidden = true
        }
    }
    
    // MARK: Apply Font And Color
    func applyFontAndColor() {
        showHideLabel.textColor = appBarThemeColor
    }
    
    // MARK: Apply LocalizedText
    func applyLocalizedText() {
        CommonFunctions.sharedInstance.setNavigationTitleView(titleStr:   localizedTextFor(key: ClientReviewsSceneText.ClientReviewsSceneTitle.rawValue), onVC: self)
        showHideLabel.text = localizedTextFor(key: ClientReviewsSceneText.ClientReviewsSceneShowHideLabelText.rawValue)
    }
    
    // MARK: Other Functions
    
    func initialFunction() {
        interactor?.hitGetListReviewsByBusinessId(offset: offset)
    }
    
    // MARK: Display Response
    func displayResponse(viewModel: ClientReviews.ViewModel)
    {
        clientReviewArray.append(contentsOf: viewModel.tableArray)
        clientReviewTableView.reloadData()
        
        if self.clientReviewArray.count == 0 {
            showHideLabel.isHidden = false
        }
        else {
            showHideLabel.isHidden = true
        }
    }
}

// MARK: UITableViewDelegate

extension ClientReviewsViewController : UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return clientReviewArray.count
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReUseIdentifier, for: indexPath) as! ClientReviewsTableViewCell
        
        let currentObj = clientReviewArray[indexPath.section]
        
        let userImage = currentObj.profileImg
        let imageUrl = Configurator().imageBaseUrl + userImage
        cell.userImage.sd_setImage(with: URL(string: imageUrl), placeholderImage: #imageLiteral(resourceName: "userIcon"), options: .retryFailed, completed: nil)
        
        cell.nameLabel.text = currentObj.name
        cell.dateLabel.text = currentObj.date
        cell.discriptionLabel.text = currentObj.discription
        cell.dateLabel.text = currentObj.date.description
        cell.cosmoView.rating = Double(truncating: currentObj.rating)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let footerView = view as! UITableViewHeaderFooterView
        footerView.tintColor = UIColor.clear
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.section == (((self.offset + 1)*10) - 1) {
            self.offset += 1
            initialFunction()
        }
    }
}
