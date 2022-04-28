
import UIKit
import Cosmos

struct RatingData {
    var id : String
    var rating : Double
}

protocol RateServicesDisplayLogic: class
{
    func displayAddReviewResponse()
    func displayArrayData(dataArray:[RateServices.ViewModel.tableCellData]?)
}

class RateServicesViewController: UIViewController, RateServicesDisplayLogic
{
    
    
    var interactor: RateServicesBusinessLogic?
    var router: (NSObjectProtocol & RateServicesRoutingLogic & RateServicesDataPassing)?
    
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
        let interactor = RateServicesInteractor()
        let presenter = RateServicesPresenter()
        let router = RateServicesRouter()
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
    
    
    ////////////////////////////////////////////////////
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var qualityLabel: UILabel!
    @IBOutlet weak var qualityRating: CosmosView!
    @IBOutlet weak var moneyLabel: UILabel!
    @IBOutlet weak var moneyRating: CosmosView!
    @IBOutlet weak var serviceLabel: UILabel!
    @IBOutlet weak var serviceRating: CosmosView!
    @IBOutlet weak var timingLabel: UILabel!
    @IBOutlet weak var timingRating: CosmosView!
    @IBOutlet weak var reviewTextView: UITextView!
    @IBOutlet weak var submitBtn: UIButtonFontSize!
    @IBOutlet weak var ratingTableView: UITableView!
    @IBOutlet weak var rateTherapistLabel: UILabel!
    @IBOutlet weak var tableHeightConstraint: NSLayoutConstraint!
    
    var therapistArray = [RateServices.ViewModel.tableCellData]()
    
    // MARK: View lifecycle
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        scrollView.manageKeyboard()
        hideBackButtonTitle()
        applyLocalizedText()
        reviewTextView.text = ""
        reviewTextView.layer.borderWidth = 1
        reviewTextView.layer.borderColor = UIColor.gray.cgColor
        interactor?.getArrayData()
        addObserverOnTableViewReload()
    }
    
    enum RateServicesSceneText:String {
        case RateServicesSceneTitle
        case ReviewTextView
        case SubmitBtn
    }
    
    
    // MARK: Apply LocalizedText
    func applyLocalizedText() {
        
        CommonFunctions.sharedInstance.setNavigationTitleView(titleStr: localizedTextFor(key: RateServicesSceneText.RateServicesSceneTitle.rawValue), onVC: self)
        reviewTextView.placeholder =  localizedTextFor(key: RateServicesSceneText.ReviewTextView.rawValue)
        submitBtn.setTitle(localizedTextFor(key:RateServicesSceneText.SubmitBtn.rawValue), for: .normal)
        
        qualityLabel.text = localizedTextFor(key: rateReviewSceneText.Quality.rawValue)
        
        moneyLabel.text = localizedTextFor(key: rateReviewSceneText.Money.rawValue)
        
        serviceLabel.text = localizedTextFor(key: rateReviewSceneText.Services.rawValue)
        
        timingLabel.text = localizedTextFor(key: rateReviewSceneText.Timing.rawValue)
        
        rateTherapistLabel.text = localizedTextFor(key: rateReviewSceneText.therapistRating.rawValue)
        
        
    }
    
    // MARK: Do something
    
    func addObserverOnTableViewReload() {
        ratingTableView.addObserver(self, forKeyPath: tableContentSize, options: .new, context: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let obj = object as? UITableView {
            if obj == ratingTableView && keyPath == tableContentSize {
                if (change?[NSKeyValueChangeKey.newKey] as? CGSize) != nil {
                    tableHeightConstraint.constant = ratingTableView.contentSize.height
                }
            }
        }
    }
    
    deinit {
        // staffServiceTableView.removeObserver(self, forKeyPath: tableContentSize)
    }
    
    func displayAddReviewResponse()
    {
        router?.routeToRateReview()
    }
    
    func displayArrayData(dataArray: [RateServices.ViewModel.tableCellData]?) {
        
        if dataArray != nil {
            therapistArray = dataArray!
            ratingTableView.reloadData()
        }
        
    }
    
    @IBAction func submitBtn(_ sender: Any) {
        
         var ratingArray = [RatingData]()
        
        for (index,item)in therapistArray.enumerated() {
            
            let cell = ratingTableView.cellForRow(at: IndexPath(row: 0, section: index)) as! RateServiceTableViewCell
            
            if cell.therapistRating.rating > 0 {
              
                let rating = cell.therapistRating.rating
                let id = item.therapistId
                
               let obj = RatingData(id: id, rating: rating)
                
                ratingArray.append(obj)
                
            }
        }
        
       
        let req = RateServices.Request(
            qualityRating: qualityRating.rating, moneyRating: moneyRating.rating, serviceRating: serviceRating.rating, timingRating: timingRating.rating, reviewText: reviewTextView.text_Trimmed(), ratingArray: ratingArray)
        
    printToConsole(item: req)
        
        interactor?.hitAddReviewApi(request: req)
        
    }
    
}

extension RateServicesViewController : UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return therapistArray.count
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReUseIdentifier, for: indexPath) as! RateServiceTableViewCell
        
         let currentObj = therapistArray[indexPath.section]
         cell.ratingLabel.text = currentObj.therapistName + "(" + currentObj.serviceName + ")"
        
        return cell
    }
}
