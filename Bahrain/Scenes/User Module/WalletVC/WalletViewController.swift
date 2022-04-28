
import UIKit

protocol WalletDisplayLogic: class
{
    func displayUserWallet(viewModel: Wallet.ViewModel)
}

class WalletViewController: UIViewController, WalletDisplayLogic
{
    var interactor: WalletBusinessLogic?
    var router: (NSObjectProtocol & WalletRoutingLogic & WalletDataPassing)?
    
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
        let interactor = WalletInteractor()
        let presenter = WalletPresenter()
        let router = WalletRouter()
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
    
    @IBOutlet weak var currentAmountLbl: UILabel!
    @IBOutlet weak var currentBalanceLbl: UILabel!
    @IBOutlet weak var refundTableView: UITableView!
    @IBOutlet weak var bottomInfoLabel: UILabel!
    @IBOutlet weak var noDataLbl: UILabel!
    @IBOutlet weak var topView: UIView!
    
    var refundsArray = [Wallet.ViewModel.refundDetails]()
    var salonName = ""
    var isNavigationHidden = false
    
    // MARK: View lifecycle
    
    
    enum WalletSceneText:String {
        case WalletSceneTitle
        case WalletSceneCurrentBalanceLblTitle
        case WalletSceneBottomInfoLabelTitle
        case WalletSceneNoDataLblTitle
        
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        topView.backgroundColor = appBarThemeColor
        noDataLbl.textColor = appBarThemeColor
        hideBackButtonTitle()
        interactor?.getUserWalletApi()
        refundTableView.tableFooterView = UIView()
        applyLocalizedText()
    }
    
    
    func applyLocalizedText() {
        CommonFunctions.sharedInstance.setNavigationTitleView(titleStr: localizedTextFor(key: WalletSceneText.WalletSceneTitle.rawValue), onVC: self)
        currentBalanceLbl.text = localizedTextFor(key: WalletSceneText.WalletSceneCurrentBalanceLblTitle.rawValue)
        bottomInfoLabel.text = localizedTextFor(key: WalletSceneText.WalletSceneBottomInfoLabelTitle.rawValue)
        noDataLbl.text = localizedTextFor(key: WalletSceneText.WalletSceneNoDataLblTitle.rawValue)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        if  self.navigationController?.isNavigationBarHidden == true {
            self.navigationController?.isNavigationBarHidden = false
            isNavigationHidden = true
        }
        
        if refundsArray.count != 0 {
            noDataLbl.isHidden = true
        }else {
            noDataLbl.isHidden = false
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if  isNavigationHidden {
            self.navigationController?.isNavigationBarHidden = true
        }
    }
    
    
    func displayUserWallet(viewModel: Wallet.ViewModel)  {
        let colorAttribute = [NSAttributedStringKey.foregroundColor: UIColor.white,NSAttributedStringKey.font:UIFont(name: "SourceSansPro-Regular", size: 24) ?? UIFont.systemFont(ofSize: 24)]
        
//        var blns: NSNumber?
//        
//        if viewModel.totalAmount == 0 {
//            blns = viewModel.totalAmount.intValue as NSNumber
//        } else {
//            blns = viewModel.totalAmount.floatValue as NSNumber
//        }
    
        let totalAmountString = String(format: "%.3f", viewModel.totalAmount.floatValue)
        let currentBalance = NSMutableAttributedString(string: totalAmountString, attributes: colorAttribute)
        currentBalance.append(NSAttributedString(string: "  \(localizedTextFor(key: GeneralText.bhd.rawValue))", attributes: [NSAttributedStringKey.baselineOffset:-5,NSAttributedStringKey.font:UIFont(name: "SourceSansPro-Regular", size: 15) ?? UIFont.systemFont(ofSize: 15)]))
        

        currentAmountLbl.attributedText = currentBalance
        printToConsole(item: viewModel.refundDetailsArray)
        
        refundsArray = viewModel.refundDetailsArray
        refundTableView.reloadData()
        if refundsArray.count != 0 {
            noDataLbl.isHidden = true
        }else {
            noDataLbl.isHidden = false
        }
    }
}

extension WalletViewController : UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return refundsArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let footerView = view as! UITableViewHeaderFooterView
        footerView.tintColor = UIColor.clear
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReUseIdentifier, for: indexPath) as! WalletTableViewCell
        let currentObj = refundsArray[indexPath.section]
        cell.salonNameLbl.text = currentObj.salonName
        cell.refundAmtLbl.text = String(format: "%.3f", currentObj.totalWalletAmount.floatValue) + " " + localizedTextFor(key: GeneralText.bhd.rawValue)
        cell.layer.cornerRadius = 8
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        router?.routeToWalletDetails(walletDetails: refundsArray[indexPath.section].walletDetailsArray, salonName: refundsArray[indexPath.section].salonName)
    }
}
