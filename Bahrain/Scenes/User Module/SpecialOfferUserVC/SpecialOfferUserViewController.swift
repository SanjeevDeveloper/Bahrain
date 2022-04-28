
import UIKit

protocol SpecialOfferUserDisplayLogic: class
{
    func displayResponse(viewModel: SpecialOfferUser.ViewModel,isClearFilter:Bool)
    func displayBookNowResponse(servicesArray: [SalonDetail.ViewModel.service], businessId: String, saloonName:String,offerId:String, totalPrice:String)
    func displayFilterResponse(viewModel: SpecialOfferUser.ViewModel)
}

class SpecialOfferUserViewController: UIViewController, SpecialOfferUserDisplayLogic
{
    var interactor: SpecialOfferUserBusinessLogic?
    var router: (NSObjectProtocol & SpecialOfferUserRoutingLogic & SpecialOfferUserDataPassing)?

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
        let interactor = SpecialOfferUserInteractor()
        let presenter = SpecialOfferUserPresenter()
        let router = SpecialOfferUserRouter()
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
            else if scene == "FilterScreen" {
                if let router = router {
                    if MinimumValue == maximumValue {
                        let minusValue =  MinimumValue.intValue - 20
                        MinimumValue = minusValue as NSNumber
                    }
                    router.routeToFilterScreen(segue: segue,minimumValue: MinimumValue,MaximumValue:maximumValue)
                }
            }
        }
        
    }
    
    //////////////////////////////////////////////////////////////////////////
    
    @IBOutlet weak var offersTableView: UITableView!
    @IBOutlet weak var noSalonLabel: UILabelFontSize!
    
    var offersArray = [SpecialOfferUser.ViewModel.tableCellData]()
    var offset = 0
    
    var maximumValue = NSNumber()
    var MinimumValue = NSNumber()
    
    // MARK: View lifecycle
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        offersTableView.tableFooterView = UIView()
        applyLocalizedText()
        applyFontAndColor()
        initialFunction()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        interactor?.hitListAllOffersFilterApi(offset: offset)
    }
    
    // MARK: Apply Font And Color
    func applyFontAndColor() {
     noSalonLabel.textColor = appBarThemeColor
    }
    
    // MARK: Apply LocalizedText
    func applyLocalizedText() {
        self.tabBarController?.tabBar.isHidden = true
         CommonFunctions.sharedInstance.setNavigationTitleView(titleStr:   localizedTextFor(key: SpecialOfferListUserSceneText.specialOfferListUserSceneTitle.rawValue), onVC: self)
        noSalonLabel.text = localizedTextFor(key: SpecialOfferListUserSceneText.specialOfferListUserSceneNoOfferAvailableLabel.rawValue)
    }
    
    // MARK: Other Functions
    
    func initialFunction() {
        interactor?.hitListAllOffers(offset:offset)
    }
    
    // MARK: Display Response
  
  func displayResponse(viewModel: SpecialOfferUser.ViewModel,isClearFilter:Bool)
  {
    if let errorString = viewModel.errorString {
      CustomAlertController.sharedInstance.showErrorAlert(error: errorString)
    }
    else {
      
      maximumValue = viewModel.maximumPrice
      MinimumValue = viewModel.minimumPrice
      
      if offset == 0 {
        if viewModel.tableArray.count == 0 {
          noSalonLabel.isHidden = false
          self.navigationItem.rightBarButtonItems![0].isEnabled = false
        } else if viewModel.tableArray.count == 1{
          noSalonLabel.isHidden = true
          self.navigationItem.rightBarButtonItems![0].isEnabled = false
        }
        else {
          noSalonLabel.isHidden = true
          self.navigationItem.rightBarButtonItems![0].isEnabled = true
        }
      }
      else {
        noSalonLabel.isHidden = true
        if viewModel.tableArray.count == 1 {
          self.navigationItem.rightBarButtonItems![0].isEnabled = false
        } else {
          self.navigationItem.rightBarButtonItems![0].isEnabled = true
        }
      }
      if isClearFilter{
        offersArray.removeAll()
      }
      
      offersArray = viewModel.tableArray
      offersTableView.reloadData()
    }
  }
    
    func displayFilterResponse(viewModel: SpecialOfferUser.ViewModel) {
        if let errorString = viewModel.errorString {
            CustomAlertController.sharedInstance.showErrorAlert(error: errorString)
        }
        else {
            if offset == 0 {
                if viewModel.tableArray.count == 0 {
                    noSalonLabel.isHidden = false
                }
                else {
                    noSalonLabel.isHidden = true
                }
            }
            else {
                noSalonLabel.isHidden = true
            }
            offersArray.removeAll()
            offersArray = viewModel.tableArray
            offersTableView.reloadData()
        }
    }
    
    func displayBookNowResponse(servicesArray: [SalonDetail.ViewModel.service], businessId: String, saloonName: String,offerId:String,totalPrice:String) {
        router?.routeToBooking(salonName: saloonName, businessId: businessId, selectedServicesArray: servicesArray,offerId:offerId, totalPrice: totalPrice)
    }
    
     @objc func bookNowButtonAction(sender:UIButton) {
        if !isUserLoggedIn() {
            CommonFunctions.sharedInstance.showLoginAlert(referenceController: self)
        }else{
        var v:UIView = sender
        repeat { v = v.superview! } while !(v is UITableViewCell)
        let cell = v as! SpecialOfferUserTableViewCell
        let indexPath = offersTableView.indexPath(for:cell)!
        interactor?.bookNow(index: indexPath.section)
        }
    }
}

// MARK: UITableViewDelegate
extension SpecialOfferUserViewController : UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return offersArray.count
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
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReUseIdentifier, for: indexPath) as! SpecialOfferUserTableViewCell
        let currentObj = offersArray[indexPath.section]
        cell.setData(currentObj: currentObj)
        cell.bookNowButton.addTarget(self, action: #selector(self.bookNowButtonAction(sender:)), for: .touchUpInside)
        return cell
    }
    
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        if indexPath.section == (((self.offset + 1)*10) - 1) {
//            self.offset += 1
//            initialFunction()
//        }
//    }
}

