
import UIKit


protocol ViewProfileDisplayLogic: class
{
    func displaybusinessIdResponse(viewModel: SalonDetail.ViewModel)
}

class ViewProfileViewController: UIViewController, ViewProfileDisplayLogic
{
    var interactor: ViewProfileBusinessLogic?
    var router: (NSObjectProtocol & ViewProfileRoutingLogic & ViewProfileDataPassing)?
    
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
        let interactor = ViewProfileInteractor()
        let presenter = ViewProfilePresenter()
        let router = ViewProfileRouter()
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
    
    //////////////////////////////////////////////////
    
    @IBOutlet weak var topCollectionView: UICollectionView!
    @IBOutlet weak var tabSwipeFrameView: UIView!
    @IBOutlet weak var tableScrollView: UIScrollView!
    @IBOutlet weak var pagerView: FSPagerView! {
        didSet {
            self.pagerView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: cellReUseIdentifier)
            self.pagerView.itemSize = .zero
        }
    }
    
    var topCollectionViewArray = [SalonDetail.StaticCollectionViewModel]()
    var imagesArray = [String]()
    
    var salonDetailViewModel: SalonDetail.ViewModel!
    var servicesArray: [[SalonDetail.ViewModel.service]]!
    var segmentedControl = HMSegmentedControl()
    var selectedServicesArray =  [SalonDetail.ViewModel.service]()
    
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialFunction()
        topCollectionView.layer.borderWidth = 1
        topCollectionView.layer.borderColor = UIColor.white.cgColor
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        pagerView.transformer = FSPagerViewTransformer(type: .overlap)
        
        let transform = CGAffineTransform(scaleX: 0.7, y: 0.84)
        self.pagerView.itemSize = self.pagerView.frame.size.applying(transform)
    }
    
    // MARK: Static Array Pass
    func fillStaticArray() {
        topCollectionViewArray = [
            SalonDetail.StaticCollectionViewModel(title: localizedTextFor(key: SalonDetailSceneText.SalonDetailSceneAbout.rawValue), image: #imageLiteral(resourceName: "info")),
            SalonDetail.StaticCollectionViewModel(title: localizedTextFor(key: SalonDetailSceneText.SalonDetailSceneHours.rawValue), image: #imageLiteral(resourceName: "clockIconWhite")),
            SalonDetail.StaticCollectionViewModel(title: localizedTextFor(key: SalonDetailSceneText.SalonDetailSceneChat.rawValue), image: #imageLiteral(resourceName: "chat")),
            SalonDetail.StaticCollectionViewModel(title: localizedTextFor(key: SalonDetailSceneText.SalonDetailSceneDirection.rawValue), image: #imageLiteral(resourceName: "map")),
            SalonDetail.StaticCollectionViewModel(title: localizedTextFor(key: SalonDetailSceneText.SalonDetailSceneStaff.rawValue), image: #imageLiteral(resourceName: "staff"))
        ]
    }
    
    // MARK: initialFunction
    func initialFunction() {
        hideBackButtonTitle()
        interactor?.getBusinessByIdApi()
        fillStaticArray()
    }
    
    // MARK: Display Response
    func displaybusinessIdResponse(viewModel: SalonDetail.ViewModel) {
        salonDetailViewModel = viewModel
        servicesArray = salonDetailViewModel.servicesArray
        
        setupSegment(viewModel: viewModel)
        setupSwipeScrollView(viewModel: viewModel)
        
        CommonFunctions.sharedInstance.setNavigationTitleView(titleStr:   viewModel.salonName, onVC: self)
        imagesArray = viewModel.galleryImages
        if imagesArray.count == 1 {
            pagerView.isInfinite = false
        }
        pagerView.reloadData()
    }
    
    // MARK: SetupSwipeScrollView
    func setupSwipeScrollView(viewModel: SalonDetail.ViewModel) {
        let viewWidth = Int(self.view.frame.size.width)
        self.tableScrollView.isPagingEnabled = true
        
        self.tableScrollView.contentSize = CGSize(width: viewWidth * viewModel.servicesArray.count, height: Int(tableScrollView.bounds.size.height))
        self.tableScrollView.delegate = self;
        
        for (index, _) in viewModel.servicesArray.enumerated() {
            let table = UITableView(frame: CGRect(x: viewWidth * index, y: 0, width: viewWidth, height: Int(tableScrollView.frame.size.height)))
            table.register(UINib(nibName: ViewProfileServicesCell, bundle: nil), forCellReuseIdentifier: cellReUseIdentifier)
            
            table.backgroundColor = UIColor.clear
            table.separatorColor = UIColor.white
            table.separatorInset.right = table.separatorInset.left
            table.dataSource = self
            table.tag = index
            table.tableFooterView = UIView()
            table.estimatedRowHeight = 50
            table.rowHeight = UITableViewAutomaticDimension
            table.reloadData()
            self.tableScrollView.addSubview(table)
        }
    }
    
    // MARK: SetupSegment
    func setupSegment(viewModel: SalonDetail.ViewModel) {
        let viewWidth = Int(self.view.frame.size.width)
        
        // Tying up the segmented control to a scroll view
        self.segmentedControl = HMSegmentedControl(frame: tabSwipeFrameView.frame)
        self.segmentedControl.sectionTitles = viewModel.categoriesArray
        
        self.segmentedControl.selectedSegmentIndex = 0
        
        self.segmentedControl.backgroundColor = UIColor.clear
        
        let colorAttribute = [NSAttributedStringKey.foregroundColor: UIColor.darkGray]
        self.segmentedControl.titleTextAttributes = colorAttribute
        
        let selectedColorAttribute = [NSAttributedStringKey.foregroundColor: appBarThemeColor]
        self.segmentedControl.selectedTitleTextAttributes = selectedColorAttribute
        self.segmentedControl.selectionIndicatorColor = appBarThemeColor
        
        self.segmentedControl.selectionStyle = .textWidthStripe
        self.segmentedControl.selectionIndicatorLocation = .down
        
        
        weak var weakSelf = self
        segmentedControl.indexChangeBlock = {(_ index: Int) -> Void in
            weakSelf!.tableScrollView.scrollRectToVisible(CGRect(x: (viewWidth * index), y: 0, width: viewWidth, height: Int(self.tableScrollView.bounds.size.height)), animated: true)
            
        }
        self.view.addSubview(self.segmentedControl)
    }
}

// MARK: UICollectionViewDataSource

extension ViewProfileViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return topCollectionViewArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReUseIdentifier, for: indexPath) as! ViewProfileCollectionViewCell
        
        let obj = topCollectionViewArray[indexPath.item]
        cell.titleImageView.image = obj.image
        cell.titleLabel.text = obj.title
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = collectionView.frame.size.width / 5
        return CGSize(width: width, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let CellWidth = collectionView.frame.size.width / 5
        let totalCellWidth = Int(CellWidth) * topCollectionViewArray.count
        
        let leftInset = (collectionView.frame.size.width - CGFloat(totalCellWidth)) / 2
        let rightInset = leftInset
        
        return UIEdgeInsetsMake(0, leftInset, 0, rightInset)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let router = router {
            switch indexPath {
            case [0,0]:
                router.routeToAboutScreen(identifier: ViewControllersIds.AboutSalonViewControllerID)
                // CustomAlertController.sharedInstance.showComingSoonAlert()
                
            case [0,1]:
                router.routeToAnotherScreen(identifier: ViewControllersIds.WorkingHoursViewControllerID)
                
            case [0,2]:
                router.routeToChat()
               // CustomAlertController.sharedInstance.showComingSoonAlert()
                
            case [0,3]:
                if LocationWrapper.sharedInstance.latitude != 0.0 { CommonFunctions.sharedInstance.openGoogleMap(destinationLatitude: salonDetailViewModel.latitude, destinationLongitude: salonDetailViewModel.longitude)
                }
                else {
                    LocationWrapper.sharedInstance.fetchLocation()
                }
                
            case [0,4]:
                router.routeToAnotherScreen(identifier: ViewControllersIds.TherapistListViewControllerID)
                
            default:
                break
            }
        }
    }
}

// MARK: FSPagerViewDataSource

extension ViewProfileViewController: FSPagerViewDataSource {
    
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        return imagesArray.count
    }
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: cellReUseIdentifier, at: index)
        let currentObj = imagesArray[index]
        let imageUrl = Configurator().imageBaseUrl + currentObj
        cell.imageView?.sd_setImage(with: URL(string: imageUrl), completed: nil)
        cell.imageView?.contentMode = .scaleAspectFill
        cell.imageView?.clipsToBounds = true
        cell.counterLabel?.text = "\(index + 1)/\(imagesArray.count)"
        return cell
    }
}

// MARK: UIScrollViewDelegate

extension ViewProfileViewController: UIScrollViewDelegate {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == tableScrollView {
            let pageWidth = scrollView.frame.size.width
            let page = scrollView.contentOffset.x / pageWidth
            
            self.segmentedControl.selectedSegmentIndex = Int(page)
        }
    }
}

// MARK: UITableViewDataSource

extension ViewProfileViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let currentArray = servicesArray[tableView.tag]
        return currentArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        printToConsole(item: tableView.tag)
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReUseIdentifier, for: indexPath) as! ViewProfileServicesListTableViewCell
        
        let currentArray = servicesArray[tableView.tag]
        let currentObj = currentArray[indexPath.row]
        cell.serviceNameLabel.text = currentObj.name
        if currentObj.homePrice == "0 BHD" {
            cell.homePriceLabel.text = "-"
        }else {
            cell.homePriceLabel.text = currentObj.homePrice
        }
        if currentObj.salonPrice == "0 BHD" {
            cell.salonPriceLabel.text = "-"
        }else {
            cell.salonPriceLabel.text = currentObj.salonPrice
        }
        cell.durationLabel.text = currentObj.duration
        return cell
    }
}



