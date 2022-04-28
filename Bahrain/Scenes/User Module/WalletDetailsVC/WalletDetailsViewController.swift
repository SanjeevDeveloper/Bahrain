
import UIKit

protocol WalletDetailsDisplayLogic: class {
  func displayWalletDetails(viewModel: [Wallet.ViewModel.refundDetails.walletDetail], salonName: String)
}

class WalletDetailsViewController: UIViewController, WalletDetailsDisplayLogic {
  var interactor: WalletDetailsBusinessLogic?
  var router: (NSObjectProtocol & WalletDetailsRoutingLogic & WalletDetailsDataPassing)?
  
  // MARK: Object lifecycle
  
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
    let interactor = WalletDetailsInteractor()
    let presenter = WalletDetailsPresenter()
    let router = WalletDetailsRouter()
    viewController.interactor = interactor
    viewController.router = router
    interactor.presenter = presenter
    presenter.viewController = viewController
    router.viewController = viewController
    router.dataStore = interactor
  }
  
  // MARK: Routing
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let scene = segue.identifier {
      let selector = NSSelectorFromString("routeTo\(scene)WithSegue:")
      if let router = router, router.responds(to: selector) {
        router.perform(selector, with: segue)
      }
    }
  }
  
  // MARK: Interface Builder outlets
  
  @IBOutlet weak var walletDetailsTableView: UITableView!
  
  var walletDetailsArray = [Wallet.ViewModel.refundDetails.walletDetail]()
  
  // MARK: View lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    hideBackButtonTitle()
    walletDetailsTableView.tableFooterView = UIView()
    interactor?.showWalletDetails()
  }
  
  func displayWalletDetails(viewModel: [Wallet.ViewModel.refundDetails.walletDetail], salonName: String) {
    let titleText = salonName.uppercased()
   CommonFunctions.sharedInstance.setNavigationTitleView(titleStr: titleText, onVC: self)
    walletDetailsArray = viewModel
    walletDetailsTableView.reloadData()
  }
}

extension WalletDetailsViewController: UITableViewDataSource, UITableViewDelegate {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return walletDetailsArray.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! WalletDetailsTableViewCell
    cell.setCellData(walletObject: walletDetailsArray[indexPath.row])
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    router?.routeToOrderDetail(bookingId: walletDetailsArray[indexPath.row].bookingId)
  }
}
