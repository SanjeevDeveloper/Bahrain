
import UIKit
import Cosmos
import MKMagneticProgress

protocol rateReviewDisplayLogic: class
{
  func displayResponse(viewModel: rateReview.ViewModel)
  func displayScreenName(isRated: Bool)
}

class rateReviewViewController: UIViewController, rateReviewDisplayLogic
{
  var interactor: rateReviewBusinessLogic?
  var router: (NSObjectProtocol & rateReviewRoutingLogic & rateReviewDataPassing)?

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
    let interactor = rateReviewInteractor()
    let presenter = rateReviewPresenter()
    let router = rateReviewRouter()
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
//      let selector = NSSelectorFromString("routeTo\(scene)WithSegue:")
//      if let router = router, router.responds(to: selector) {
//        router.perform(selector, with: segue)
//      }
        router?.routeToRateUs(segue: segue)
    }
  }
  
 /////////////////////////////////////////////////////////////////
    
    @IBOutlet weak var salonNameLabel: UILabel!
    @IBOutlet weak var avgRatingLabel: UILabel!
    @IBOutlet weak var avgRatingCosmoView: CosmosView!
    @IBOutlet weak var qualityProgressView: MKMagneticProgress!
    @IBOutlet weak var moneyProgressView: MKMagneticProgress!
    @IBOutlet weak var customerServiceProgressView: MKMagneticProgress!
    @IBOutlet weak var timingProgressView: MKMagneticProgress!
    @IBOutlet weak var qualityLabel: UILabel!
    @IBOutlet weak var moneyLabel: UILabel!
    @IBOutlet weak var serviceLabel: UILabel!
    @IBOutlet weak var timingLabel: UILabel!
    @IBOutlet weak var ratingTableView: UITableView!
    @IBOutlet weak var tableHieghtConstraint: NSLayoutConstraint!
    @IBOutlet weak var reviewBtn: UIButtonFontSize!
    
    var offset = 0
    var reviewArray = [rateReview.ViewModel.tableCellData]()
    var isNavigationHidden = false
    
    
  // MARK: View lifecycle
  
  override func viewDidLoad()
  {
    super.viewDidLoad()
    hideBackButtonTitle()
    applyLocalizedText()
    addObserverOnTableViewReload()
    qualityProgressView.orientation = .top
    moneyProgressView.orientation = .top
    customerServiceProgressView.orientation = .top
    timingProgressView.orientation = .top
    
    avgRatingCosmoView.filledColor = appBarThemeColor
    
    qualityProgressView.progressShapeColor = appBarThemeColor
    moneyProgressView.progressShapeColor = appBarThemeColor
    customerServiceProgressView.progressShapeColor = appBarThemeColor
    timingProgressView.progressShapeColor = appBarThemeColor
    
    qualityProgressView.percentColor = appBarThemeColor
    moneyProgressView.percentColor = appBarThemeColor
    customerServiceProgressView.percentColor = appBarThemeColor
    timingProgressView.percentColor = appBarThemeColor
  }
    
    override func viewWillAppear(_ animated: Bool) {
        if  self.navigationController?.isNavigationBarHidden == true {
            self.navigationController?.isNavigationBarHidden = false
            isNavigationHidden = true
        }
        interactor?.hitGetUserListReviews(offset: offset)
        interactor?.getScreenName()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if  isNavigationHidden {
            self.navigationController?.isNavigationBarHidden = true
        }
    }
    
    // MARK: Apply LocalizedText
    func applyLocalizedText() {
      
        CommonFunctions.sharedInstance.setNavigationTitleView(titleStr: localizedTextFor(key: rateReviewSceneText.RateReviewSceneTitle.rawValue), onVC: self)
        avgRatingLabel.text = localizedTextFor(key: rateReviewSceneText.AvgRatingLabel.rawValue)
        qualityLabel.text = localizedTextFor(key: rateReviewSceneText.Quality.rawValue)
        moneyLabel.text = localizedTextFor(key: rateReviewSceneText.Money.rawValue)
        serviceLabel.text = localizedTextFor(key: rateReviewSceneText.Services.rawValue)
        timingLabel.text = localizedTextFor(key: rateReviewSceneText.Timing.rawValue)
    reviewBtn.setTitle(localizedTextFor(key:rateReviewSceneText.ReviewBtn.rawValue), for: .normal)

    }
    
    
    func addObserverOnTableViewReload() {
        ratingTableView.addObserver(self, forKeyPath: tableContentSize, options: .new, context: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let obj = object as? UITableView {
            if obj == ratingTableView && keyPath == tableContentSize {
                if (change?[NSKeyValueChangeKey.newKey] as? CGSize) != nil {
                    tableHieghtConstraint.constant = ratingTableView.contentSize.height
                }
            }
        }
    }
    
    deinit {
        // ListTableView.removeObserver(self, forKeyPath: tableContentSize)
    }
  
  
  func displayResponse(viewModel: rateReview.ViewModel)
  {
    reviewArray = viewModel.tableArray
    ratingTableView.reloadData()
    salonNameLabel.text = viewModel.SalonName
    avgRatingCosmoView.rating = viewModel.SalonRating.doubleValue
    
    let quality = viewModel.qualityPercentage.floatValue
    let qualityData = quality/100
    let money = viewModel.moneyPercentage.floatValue
    let moneyData = money/100
    let service = viewModel.servicesPercentage.floatValue
    let serviceData = service/100
    let timing = viewModel.timingPercentage.floatValue
    let timingData =  timing/100
    
    qualityProgressView.setProgress(progress: CGFloat(qualityData), animated: true)
    moneyProgressView.setProgress(progress: CGFloat(moneyData), animated: true)
    timingProgressView.setProgress(progress: CGFloat(timingData), animated: true)
    customerServiceProgressView.setProgress(progress: CGFloat(serviceData), animated: true)
    
  }
    
    func displayScreenName(isRated: Bool) {
        if isRated {
            reviewBtn.isHidden = true
        }
    }
    
    @objc func expandButtonAction(sender:UIButton) {
    
        if sender.isSelected{
            sender.isSelected = false
        }
        else {
            sender.isSelected = true
        }
        
        var v:UIView = sender
        repeat { v = v.superview! } while !(v is UITableViewCell)
        let cell = v as! rateReviewTableCell
        let indexPath = ratingTableView.indexPath(for:cell)!
        var obj = reviewArray[indexPath.section]
        obj.isSelected = !obj.isSelected
        reviewArray[indexPath.section] = obj
        ratingTableView.reloadData()
    }
}

// MARK: UITableViewDelegate

extension rateReviewViewController : UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return reviewArray.count
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReUseIdentifier, for: indexPath) as! rateReviewTableCell
        
        let currentObj = reviewArray[indexPath.section]

        let userImage = currentObj.profileImg
        let imageUrl = Configurator().imageBaseUrl + userImage
        cell.userImage.sd_setImage(with: URL(string: imageUrl), placeholderImage: #imageLiteral(resourceName: "userIcon"), options: .retryFailed, completed: nil)

        cell.nameLabel.text = currentObj.name
        cell.dateLabel.text = currentObj.date
        cell.discriptionLabel.text = currentObj.discription
        cell.dateLabel.text = currentObj.date.description
        cell.cosmoView.rating = Double(truncating: currentObj.rating)
        cell.qualityRating.rating = currentObj.QualityRating.doubleValue
        cell.moneyRating.rating = currentObj.MoneyRating.doubleValue
        cell.serviceRating.rating = currentObj.CustomerRating.doubleValue
        cell.timingRating.rating = currentObj.TimingRating.doubleValue
        cell.playButton.addTarget(self, action: #selector(self.expandButtonAction(sender:)), for: .touchUpInside)

//        if currentObj.isSelected {
//            UIView.animate(withDuration: 0.3) {
//                cell.stackHeightConstraint.constant = 45
//            }
//        }
//        else {
//            UIView.animate(withDuration: 0.3) {
//                cell.stackHeightConstraint.constant = 0
//            }
//        }
        
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
//        if indexPath.section == (((self.offset + 1)*10) - 1) {
//            self.offset += 1
//            initialFunction()
//        }
    }
}
