
import UIKit
import Cosmos
import ScrollingPageControl

struct categoryArray {
    var categoryName: String
    var isCategorySelected: Bool
}

protocol SalonDetailDisplayLogic: class
{
    func displaybusinessIdResponse(viewModel: SalonDetail.ViewModel)
    func displayFavAddRemoveResponse(viewModel: ApiResponse)
    func displayAddReviewResponse()
    func preparedForBooking()
    func displaySpecialOffersList(specialOffers: [SalonDetail.SpecialOfferDetail])
}

class SalonDetailViewController: UIViewController, SalonDetailDisplayLogic
{
    var interactor: SalonDetailBusinessLogic?
    var router: (NSObjectProtocol & SalonDetailRoutingLogic & SalonDetailDataPassing)?
    
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
        let interactor = SalonDetailInteractor()
        let presenter = SalonDetailPresenter()
        let router = SalonDetailRouter()
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
    
    //////////////////////////////////////////////////////
    
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var noDataLabel: UILabel!
    @IBOutlet weak var salonButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var homeButton: UIButton!
    @IBOutlet weak var CosmoRatingView: CosmosView!
    @IBOutlet weak var reviewLabel: UILabelFontSize!
    @IBOutlet weak var rateUsView: UIView!
    @IBOutlet weak var salonNameLabel: UILabelFontSize!
    @IBOutlet weak var enjoyLabel: UILabelFontSize!
    @IBOutlet weak var ratingCosmoView: CosmosView!
    @IBOutlet weak var reviewTextView: UITextViewFontSize!
    @IBOutlet weak var cancelButton: UIButtonFontSize!
    @IBOutlet weak var submitButton: UIButtonFontSize!
    @IBOutlet weak var topCollectionView: UICollectionView!
    @IBOutlet weak var tabSwipeFrameView: UIView!
    @IBOutlet weak var tableScrollView: UIScrollView!
    @IBOutlet weak var mainPriceLabel: UILabelFontSize!
    @IBOutlet weak var availablePriceLabel: UILabelFontSize!
    @IBOutlet weak var selectedServicesCountLabel: UILabelFontSize!
    @IBOutlet weak var bookOrderButton: UIButtonFontSize!
    @IBOutlet weak var bookOrderViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var rateusTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var specialOfferBtnHeight: NSLayoutConstraint!
    
    @IBOutlet weak var specialOfferVw: UIView!
    @IBOutlet weak var specialOfferVwTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var pageControl: ScrollingPageControl!
    @IBOutlet weak var specialOfferColVw: UICollectionView!
    @IBOutlet weak var categoryNameCollectionView: UICollectionView!
    @IBOutlet weak var dismissBtn: UIButton!
    @IBOutlet weak var specialOfferBtn: UIButton!
    
    @IBOutlet weak var pagerView: FSPagerView! {
        didSet {
            self.pagerView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: cellReUseIdentifier)
            self.pagerView.itemSize = .zero
        }
    }
    @IBOutlet weak var rateusScrollView: UIScrollView!
    @IBOutlet weak var salonImageView: UIImageViewCustomClass!
    
    var topCollectionViewArray = [SalonDetail.StaticCollectionViewModel]()
    var imagesArray = [String]()
    var salonDetailViewModel: SalonDetail.ViewModel!
    var servicesArray: [[SalonDetail.ViewModel.service]]!
    var segmentedControl = HMSegmentedControl()
    var selectedServicesArray =  [SalonDetail.ViewModel.service]()
    var specialOffersList = [SalonDetail.SpecialOfferDetail]()
    var isFromSpecialSalon = false
    var selectedIndexPath = IndexPath()
    var isFromNotification = false
    var calculatedTotalPrice = Float()
    var offerType = ""
    var categoriesArr = [categoryArray]()
    var selectedSingleServiceArr = [[String: String]]()
    var totalOfferPrice: Double = 0.000
    var totalMainPrice: Double = 0.000
    var isInfoBtnSelected: Bool = false
    var isAddOnlyMianValue: Bool = false
    var isSinglePriceAdded: Bool = false
    var isMultiplePriceAdded: Bool = false
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialFunction()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        pagerView.transformer = FSPagerViewTransformer(type: .overlap)
        let transform = CGAffineTransform(scaleX: 0.7, y: 0.84)
        self.pagerView.itemSize = self.pagerView.frame.size.applying(transform)
        self.view.bringSubview(toFront: rateUsView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if self.specialOfferVwTopConstraint.constant == 0 {
            self.navigationController?.navigationBar.layer.zPosition = -1
        } else {
            self.navigationController?.navigationBar.layer.zPosition = 0
        }
        
        enjoyLabel.text = localizedTextFor(key: SalonDetailSceneText.SalonDetailSceneEnjoyLabel.rawValue)
        reviewTextView.placeholder = localizedTextFor(key: SalonDetailSceneText.SalonDetailSceneReviewTextViewPlaceholder.rawValue)
        cancelButton.setTitle(localizedTextFor(key: SalonDetailSceneText.SalonDetailSceneCancelButton.rawValue), for: .normal)
        submitButton.setTitle(localizedTextFor(key: SalonDetailSceneText.SalonDetailSceneSubmitButton.rawValue), for: .normal)
        bookOrderButton.setTitle(localizedTextFor(key: SalonDetailSceneText.SalonDetailSceneBookOrderText.rawValue), for: .normal)
        specialOfferBtn.setTitle(localizedTextFor(key: HomeSceneText.homeSceneSpecialOffer.rawValue), for: .normal)
        noDataLabel.text = localizedTextFor(key: SalonDetailSceneText.SalonDetailSceneNoServiceLabelText.rawValue)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.layer.zPosition = 0
    }
    
    // MARK: UIButton Actions
    
    @IBAction func specialOfferButton(_ sender: UIButton) {
        dismissBtn.isSelected = false
        self.navigationController?.navigationBar.layer.zPosition = -1
        self.view.bringSubview(toFront: self.specialOfferVw)
        UIView.animate(withDuration: 0.4) {
            self.specialOfferVwTopConstraint.constant = 0
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func dismissSpecialOfferButton(_ sender: UIButton) {
        sender.isSelected = true
        
        self.refreshCellData()
        self.navigationController?.navigationBar.layer.zPosition = 0
        UIView.animate(withDuration: 0.4, animations: {
            self.specialOfferVwTopConstraint.constant = -self.view.frame.height - 50
            self.view.layoutIfNeeded()
        }) { (_) in
            if self.specialOffersList.count > 0 {
                self.specialOfferColVw.scrollToItem(at: IndexPath(item: 0, section: 0), at: .left, animated: true)
            }
        }
        
        specialOfferColVw.reloadData()
    }
    
    @IBAction func cancelButtonAction(_ sender: Any) {
        rateUsView.isHidden = true
        ratingCosmoView.rating = 0
        reviewTextView.text = ""
    }
    
    @IBAction func roundLeftAction(_ sender: Any) {
        let visibleItems: NSArray = self.specialOfferColVw.indexPathsForVisibleItems as NSArray
        let currentItem: IndexPath = visibleItems.object(at: 0) as! IndexPath
        let nextItem: IndexPath = IndexPath(item: currentItem.item - 1, section: 0)
        if nextItem.row < specialOffersList.count && nextItem.row >= 0{
            self.specialOfferColVw.scrollToItem(at: nextItem, at: .right, animated: true)
        }
        refreshCellData()
    }
    
    @IBAction func roundRightAction(_ sender: Any) {
        let visibleItems: NSArray = self.specialOfferColVw.indexPathsForVisibleItems as NSArray
        let currentItem: IndexPath = visibleItems.object(at: 0) as! IndexPath
        let nextItem: IndexPath = IndexPath(item: currentItem.item + 1, section: 0)
        if nextItem.row < specialOffersList.count {
            self.specialOfferColVw.scrollToItem(at: nextItem, at: .left, animated: true)
        }
        refreshCellData()
    }
    
    @IBAction func submitButtonAction(_ sender: Any) {
        let request = SalonDetail.Request(rating: ratingCosmoView.rating.description, reviewText: reviewTextView.text)
        interactor?.hitAddReviewApi(request: request)
    }
    
    @IBAction func bookOrderAction(_ sender: Any) {
        if !isUserLoggedIn() {
            CommonFunctions.sharedInstance.showLoginAlert(referenceController: self)
        }else{
            interactor?.prepareForBooking(salonName:salonDetailViewModel.salonName, selectedServicesArray: selectedServicesArray, isHome: homeButton.isSelected)
        }
    }
    
    @IBAction func salonButtonAction(_ sender: Any) {
        salonButton.isSelected = true
        salonButton.isUserInteractionEnabled = false
        homeButton.isSelected = false
        homeButton.isUserInteractionEnabled = true
        servicesArray = salonDetailViewModel.servicesArray
        selectedServicesArray.removeAll()
        for view in tableScrollView.subviews {
            if let tableView = view as? UITableView {
                tableView.reloadData()
            }
        }
        updateBookOrderView()
        if servicesArray.count != 0 {
            noDataLabelHideShow()
        }
    }
    
    @IBAction func homeButtonAction(_ sender: Any) {
        homeButton.isSelected = true
        homeButton.isUserInteractionEnabled = false
        salonButton.isSelected = false
        salonButton.isUserInteractionEnabled = true
        servicesArray = salonDetailViewModel.servicesArray
        selectedServicesArray.removeAll()
        for view in tableScrollView.subviews {
            if let tableView = view as? UITableView {
                tableView.reloadData()
            }
        }
        updateBookOrderView()
        
        if servicesArray.count != 0 {
            noDataLabelHideShow()
        }
    }
    
    // MARK: Other Functions
    
    func initialFunction() {
        
        if isCurrentLanguageArabic() {
            backButton.contentHorizontalAlignment = .right
            backButton.setImage(UIImage(named: "whiteRightArrow"), for: .normal)
        } else {
            backButton.contentHorizontalAlignment = .left
            backButton.setImage(UIImage(named: "whiteBackIcon"), for: .normal)
        }
        selectedIndexPath = IndexPath(item: 0, section: 0)
        pageControl.dotColor = .darkGray
        pageControl.dotSize = 10
        pageControl.selectedColor = appBarThemeColor
        specialOfferVwTopConstraint.constant = -self.view.frame.height - 50
        if isFromSpecialSalon {
            interactor?.getSpecialOffers()
        } else {
            interactor?.getBusinessByIdApi()
        }
        
        specialOfferVw.semanticContentAttribute = .forceLeftToRight
        pageControl.semanticContentAttribute = .forceLeftToRight
        specialOfferColVw.semanticContentAttribute = .forceLeftToRight
        
        bookOrderButton.setTitleColor(appBarThemeColor, for: .normal)
        bottomView.backgroundColor = appBarThemeColor
        self.tabBarController?.tabBar.isHidden = true
        hideBackButtonTitle()
        
        ratingCosmoView.rating = 0
        // addCustomRightBarButton()
        self.navigationItem.rightBarButtonItem = nil
        fillStaticArray()
        
        // Updating review text view layer
        reviewTextView.layer.borderWidth = 1
        reviewTextView.layer.borderColor = UIColor.lightGray.cgColor
        reviewTextView.layer.cornerRadius = 5
    }
    
    func fillStaticArray() {
        topCollectionViewArray = [
            SalonDetail.StaticCollectionViewModel(title: localizedTextFor(key: SalonDetailSceneText.SalonDetailSceneAbout.rawValue), image: #imageLiteral(resourceName: "info")),
            SalonDetail.StaticCollectionViewModel(title: localizedTextFor(key: SalonDetailSceneText.SalonDetailSceneFavorites.rawValue), image: #imageLiteral(resourceName: "greyHeart")),
            SalonDetail.StaticCollectionViewModel(title: localizedTextFor(key: SalonDetailSceneText.SalonDetailSceneHours.rawValue), image: #imageLiteral(resourceName: "clockIconWhite")),
            SalonDetail.StaticCollectionViewModel(title: localizedTextFor(key: SalonDetailSceneText.SalonDetailSceneDirection.rawValue), image: #imageLiteral(resourceName: "map")),
            SalonDetail.StaticCollectionViewModel(title: localizedTextFor(key: SalonDetailSceneText.SalonDetailSceneStaff.rawValue), image: #imageLiteral(resourceName: "staff")),
            SalonDetail.StaticCollectionViewModel(title: localizedTextFor(key: SalonDetailSceneText.SalonDetailSceneShare.rawValue), image: #imageLiteral(resourceName: "share")),
            SalonDetail.StaticCollectionViewModel(title: localizedTextFor(key: SalonDetailSceneText.SalonDetailSceneWhatsApp.rawValue), image: #imageLiteral(resourceName: "whatsapp")),
        ]
    }
    
    func refreshCellData() {
        for (index, _) in specialOffersList.enumerated() {
            for (index2, _) in (specialOffersList[index].businessServicesId?.enumerated())! {
                specialOffersList[index].businessServicesId?[index2].isServiceAdded = false
            }
        }
        specialOfferColVw.reloadData()
    }
    
    func addCustomRightBarButton() {
        let btnRate = UIButton(type: UIButtonType.system)
        btnRate.frame = CGRect(x: 0, y: 0, width: 60, height: 16)
        btnRate.layer.cornerRadius = 5
        btnRate.backgroundColor = UIColor.white
        btnRate.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        let title = " " + localizedTextFor(key: SalonDetailSceneText.SalonDetailSceneRateUsButton.rawValue ) + " "
        btnRate.setTitle(title, for: .normal)
        btnRate.tintColor = UIColor.white
        btnRate.setTitleColor(appBarThemeColor, for: .normal)
        btnRate.addTarget(self, action: #selector(self.rateUsButtonAction), for: .touchUpInside)
        let customBarItem = UIBarButtonItem(customView: btnRate)
        self.navigationItem.rightBarButtonItem = customBarItem;
    }
    
    // MARK: Display Response
    func displayAddReviewResponse() {
        
        CustomAlertController.sharedInstance.showAlert(subTitle: localizedTextFor(key: SalonDetailSceneText.SalonDetailSceneAddreviewSuccessResponse.rawValue), type: .success)
        rateUsView.isHidden = true
        ratingCosmoView.rating = 0
        reviewTextView.text = ""
    }
    
    func updateBookOrderView() {
        if selectedServicesArray.count == 0 {
            
            if specialOffersList.count > 0 {
                self.totalOfferPrice = 0.000
                self.totalMainPrice  = 0.000
                specialOfferBtn.isHidden = false
                specialOfferBtnHeight.constant = 60
            } else {
                specialOfferBtn.isHidden = true
                specialOfferBtnHeight.constant = 0
            }
            
            bookOrderViewHeightConstraint.constant = 0
            
        } else {
            
            specialOfferBtn.isHidden = true
            specialOfferBtnHeight.constant = 0
            
            print("self.totalOfferPrice:- ",self.totalOfferPrice)
            print("self.totalMainPrice:- ",self.totalMainPrice)
            
            if isMultiplePriceAdded {
                
                if totalOfferPrice != 0.0 && totalMainPrice == 0.0 {
                    mainPriceLabel.isHidden = true
                    availablePriceLabel.text = totalOfferPrice.roundToDecimal(3).description + "00" + " " + localizedTextFor(key: GeneralText.bhd.rawValue)
                } else {
                    mainPriceLabel.isHidden = false
                    let completePrice = self.totalMainPrice.roundToDecimal(3).description + "00" + " " + localizedTextFor(key: GeneralText.bhd.rawValue)
                    mainPriceLabel.attributedText = NSAttributedString(string: completePrice, attributes: [NSAttributedString.Key.strikethroughStyle: 1, NSAttributedString.Key.strikethroughColor: UIColor.white])
                    
                    availablePriceLabel.text = totalOfferPrice.roundToDecimal(3).description + "00" + " " + localizedTextFor(key: GeneralText.bhd.rawValue)
                }
                
            } else {
                if self.totalOfferPrice != 0.0 && self.totalMainPrice != 0.0 {
                    mainPriceLabel.isHidden = false
                    let completePrice = self.totalMainPrice.roundToDecimal(3).description + "00" + " " + localizedTextFor(key: GeneralText.bhd.rawValue)
                    mainPriceLabel.attributedText = NSAttributedString(string: completePrice, attributes: [NSAttributedString.Key.strikethroughStyle: 1, NSAttributedString.Key.strikethroughColor: UIColor.white])
                    
                    availablePriceLabel.text = totalOfferPrice.roundToDecimal(3).description + "00" + " " + localizedTextFor(key: GeneralText.bhd.rawValue)
                } else {
                    mainPriceLabel.isHidden = true
                    availablePriceLabel.text = totalOfferPrice.roundToDecimal(3).description + "00" + " " + localizedTextFor(key: GeneralText.bhd.rawValue)
                }
            }
            
            //            if isInfoBtnSelected {
            //                if self.totalOfferPrice != 0.0 && self.totalMainPrice != 0.0{
            //                  availablePriceLabel.isHidden = false
            //                  mainPriceLabel.attributedText = NSAttributedString(string: completePrice, attributes: [NSAttributedString.Key.strikethroughStyle: 1, NSAttributedString.Key.strikethroughColor: UIColor.white])
            //                  availablePriceLabel.text = totalOfferPrice.roundToDecimal(3).description + "00" + " " + localizedTextFor(key: GeneralText.bhd.rawValue)
            //
            //                } else if self.totalOfferPrice == 0.0 && self.totalMainPrice != 0.0 {
            //                    availablePriceLabel.isHidden = true
            //                    let attributeString = NSMutableAttributedString(string: completePrice)
            //                    attributeString.removeAttribute(NSAttributedStringKey.strikethroughStyle, range: NSMakeRange(0, attributeString.length))
            //                    mainPriceLabel.attributedText = attributeString
            //                }
            //
            //            } else {
            //                if isSinglePriceAdded {
            //                    mainPriceLabel.isHidden = true
            //                    availablePriceLabel.text = totalOfferPrice.roundToDecimal(3).description + "00" + " " + localizedTextFor(key: GeneralText.bhd.rawValue)
            //
            //                } else {
            //                    mainPriceLabel.isHidden = false
            //                    mainPriceLabel.attributedText = NSAttributedString(string: completePrice, attributes: [NSAttributedString.Key.strikethroughStyle: 1, NSAttributedString.Key.strikethroughColor: UIColor.white])
            //
            //                    availablePriceLabel.text = totalOfferPrice.roundToDecimal(3).description + "00" + " " + localizedTextFor(key: GeneralText.bhd.rawValue)
            //                }
            //
            //            }
            
            selectedServicesCountLabel.text = selectedServicesArray.count.description
            bookOrderViewHeightConstraint.constant = 50
        }
    }
    
    func setupSwipeScrollView(viewModel: SalonDetail.ViewModel) {
        let viewWidth = Int(self.view.frame.size.width)
        self.tableScrollView.isPagingEnabled = true
        
        self.tableScrollView.contentSize = CGSize(width: viewWidth * viewModel.servicesArray.count, height: Int(tableScrollView.bounds.size.height))
        self.tableScrollView.delegate = self;
        
        for (index, _) in viewModel.servicesArray.enumerated() {
            let table = UITableView(frame: CGRect(x: viewWidth * index, y: 0, width: viewWidth, height: Int(tableScrollView.frame.size.height)))
            table.register(UINib(nibName: UserListCell, bundle: nil), forCellReuseIdentifier: cellReUseIdentifier)
            
            table.dataSource = self
            table.delegate = self
            table.tag = index
            table.tableFooterView = UIView()
            table.separatorStyle = .none
            table.estimatedRowHeight = 50
            table.rowHeight = UITableViewAutomaticDimension
            table.reloadData()
            self.tableScrollView.addSubview(table)
        }
    }
    
    func setupSegment(viewModel: SalonDetail.ViewModel) {
        let viewWidth = Int(self.view.frame.size.width)
        
        // Tying up the segmented control to a scroll view
        
        
        
        self.segmentedControl = HMSegmentedControl(frame: tabSwipeFrameView.frame)
        
        
        if isCurrentLanguageArabic() {
            self.segmentedControl.sectionTitles = viewModel.categoriesArray.reversed()
            self.segmentedControl.selectedSegmentIndex = viewModel.categoriesArray.count - 1
            for (ind,_) in self.segmentedControl.subviews.enumerated() {
                if self.segmentedControl.subviews[ind].isKind(of: UIScrollView.self) {
                    
                    //                    let bottomOffset = CGPoint(x: ((segmentedControl.subviews[ind] as? UIScrollView)?.contentSize.width ?? 0) - ((segmentedControl.subviews[ind] as? UIScrollView)?.bounds.size.width ?? 0), y: 0)
                    //                    (segmentedControl.subviews[ind] as? UIScrollView)?.setContentOffset(bottomOffset, animated: true)
                    //                    scrollView.setContentOffset(bottomOffset, animated: true)
                    //                    (segmentedControl.subviews[ind] as? UIScrollView)?.scrollTo(direction: .Left, animated: true)
                }
            }
        } else {
            self.segmentedControl.sectionTitles = viewModel.categoriesArray
            self.segmentedControl.selectedSegmentIndex = 0
        }
        
        self.segmentedControl.backgroundColor = UIColor.white
        
        let colorAttribute = [NSAttributedStringKey.foregroundColor: UIColor.gray]
        self.segmentedControl.titleTextAttributes = colorAttribute
        
        let selectedColorAttribute = [NSAttributedStringKey.foregroundColor: appBarThemeColor]
        self.segmentedControl.selectedTitleTextAttributes = selectedColorAttribute
        self.segmentedControl.selectionIndicatorColor = appBarThemeColor
        
        self.segmentedControl.selectionStyle = .textWidthStripe
        self.segmentedControl.selectionIndicatorLocation = .down
        
        
        
        weak var weakSelf = self
        segmentedControl.indexChangeBlock = {(_ index: Int) -> Void in
            weakSelf!.tableScrollView.scrollRectToVisible(CGRect(x: (viewWidth * index), y: 0, width: viewWidth, height: Int(self.tableScrollView.bounds.size.height)), animated: true)
            
            self.noDataLabelHideShow()
        }
        self.view.addSubview(self.segmentedControl)
        
        
    }
    
    @objc func rateUsButtonAction() {
        if !isUserLoggedIn() {
            CommonFunctions.sharedInstance.showLoginAlert(referenceController: self)
        }
        else {
            rateUsView.isHidden = false
        }
    }
    
    @IBAction func reviewBtn(_ sender: Any) {
        
        router?.routeToReviewScreen(identifier: ViewControllersIds.rateReviewViewControllerID)
    }
    
    @IBAction func backBarButtonItem(sender: UIButton) {
        if isFromNotification {
            let initialNavigationController = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: ViewControllersIds.HomeViewControllerIds)
            let navCtrl = OnBoardingModuleNavigationController(rootViewController: initialNavigationController)
            appDelegateObj.window?.rootViewController = navCtrl
            appDelegateObj.window?.makeKeyAndVisible()
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func preparedForBooking() {
        router?.routeToBooking()
    }
    
    func displaySpecialOffersList(specialOffers: [SalonDetail.SpecialOfferDetail]) {
        specialOffersList = specialOffers
        if isFromSpecialSalon {
            interactor?.getBusinessByIdApi()
        }
        if specialOffersList.count > 0 {
            if isFromSpecialSalon {
                specialOfferButton(specialOfferBtn)
            }
            specialOfferBtnHeight.constant = 60
            specialOfferBtn.isHidden = false
            if specialOffersList.count <= 1 {
                pageControl.isHidden = true
            } else if specialOffersList.count > 1 && specialOffersList.count <= 5 {
                pageControl.isHidden = false
                pageControl.maxDots = specialOffersList.count
                pageControl.centerDots = specialOffersList.count
            } else {
                pageControl.isHidden = false
                pageControl.maxDots = 5
                pageControl.centerDots = 3
            }
            self.pageControl.pages = specialOffersList.count
        } else {
            specialOfferBtn.isHidden = true
            specialOfferBtnHeight.constant = 0
            self.specialOfferVwTopConstraint.constant = -self.view.frame.height - 50
            self.navigationController?.navigationBar.layer.zPosition = 0
        }
        specialOfferColVw.reloadData()
    }
    
    func displaybusinessIdResponse(viewModel: SalonDetail.ViewModel) {
        
        salonDetailViewModel = viewModel
        servicesArray = salonDetailViewModel.servicesArray
        
        for (ind, category) in salonDetailViewModel.categoriesArray.enumerated() {
            var selected = false
            if ind == 0 {
                selected = true
            }
            categoriesArr.append(categoryArray(categoryName: category, isCategorySelected: selected))
        }
        //setupSegment(viewModel: viewModel)
        setupSwipeScrollView(viewModel: viewModel)
        
        // self.title = viewModel.salonName
        CommonFunctions.sharedInstance.setNavigationTitleView(titleStr:  viewModel.salonName, onVC: self)
        
        CosmoRatingView.rating = viewModel.avgRating
        CosmoRatingView.filledColor = appBarThemeColor
        reviewLabel.text = "(" + (viewModel.review?.description)! + ")" + " " + localizedTextFor(key: SalonDetailSceneText.SalonDetailSceneReviewStaticText.rawValue)
        reviewLabel.textColor = appBarThemeColor
        
        imagesArray = viewModel.galleryImages
        if imagesArray.count == 1 {
            pagerView.isInfinite = false
        }
        pagerView.reloadData()
        
        salonNameLabel.text = viewModel.salonName
        if let profileImageUrl = URL(string:Configurator().imageBaseUrl + viewModel.profileImage) {
            salonImageView.sd_setImage(with: profileImageUrl, placeholderImage: #imageLiteral(resourceName: "userIcon"), options: .retryFailed, completed: nil)
        }
        
        let obj = viewModel.isFavorite
        
        if obj == 0 {
            topCollectionViewArray[1].image = #imageLiteral(resourceName: "greyHeart")
        }
        else {
            topCollectionViewArray[1].image = #imageLiteral(resourceName: "redHeart")
        }
        topCollectionView.reloadData()
        categoryNameCollectionView.reloadData()
        if !isFromSpecialSalon {
            interactor?.getSpecialOffers()
        } else {
            self.view.bringSubview(toFront: self.specialOfferVw)
        }
    }
    
    
    func displayFavAddRemoveResponse(viewModel: ApiResponse) {
        if viewModel.error != nil {
            CustomAlertController.sharedInstance.showErrorAlert(error: viewModel.error!)
        }
        else {
            NotificationCenter.default.post(name: Notification.Name("FavoriteUpdated"), object: nil)
            
            
            let obj = viewModel.result as! NSDictionary
            
            if topCollectionViewArray[1].image == #imageLiteral(resourceName: "redHeart") {
                topCollectionViewArray[1].image = #imageLiteral(resourceName: "greyHeart")
            }
            else {
                topCollectionViewArray[1].image = #imageLiteral(resourceName: "redHeart")
            }
            let indexPath = IndexPath(item: 1, section: 0)
            topCollectionView.reloadItems(at: [indexPath])
            CustomAlertController.sharedInstance.showAlert(subTitle: obj["msg"] as? String, type: .success)
        }
    }
    
    // MARK: Keyboard management
    
    func addKeyboardObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    @objc func keyboardWillShow(notification:NSNotification){
        var userInfo = notification.userInfo!
        var keyboardFrame:CGRect = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
        
        var contentInset:UIEdgeInsets = self.rateusScrollView.contentInset
        contentInset.bottom = keyboardFrame.size.height
        rateusScrollView.contentInset = contentInset
        
        rateusTopConstraint.constant = -75
    }
    
    @objc func keyboardWillHide(notification:NSNotification){
        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        rateusScrollView.contentInset = contentInset
        
        rateusTopConstraint.constant = 75
    }
    
    func noDataLabelHideShow() {
        
        let page =  self.segmentedControl.selectedSegmentIndex
        let currentArray = self.servicesArray[Int(page)]
        
        printToConsole(item: page)
        printToConsole(item: currentArray)
        
        printToConsole(item: currentArray)
        
        if self.salonButton.isSelected {
            for item in currentArray {
                if item.type == "salon" || item.type == "both" {
                    self.noDataLabel.isHidden = true
                    break
                }
                else {
                    self.noDataLabel.isHidden = false
                }
            }
        }
        
        if self.homeButton.isSelected {
            for item in currentArray {
                if item.type == "home" || item.type == "both" {
                    self.noDataLabel.isHidden = true
                    break
                }
                else {
                    self.noDataLabel.isHidden = false
                }
            }
        }
    }
}

// MARK: UICollectionViewDataSource

extension SalonDetailViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == topCollectionView {
            return topCollectionViewArray.count
        } else if collectionView == categoryNameCollectionView {
            return categoriesArr.count
        } else {
            return specialOffersList.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == topCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReUseIdentifier, for: indexPath) as! ViewProfileCollectionViewCell
            let obj = topCollectionViewArray[indexPath.item]
            cell.titleImageView.image = obj.image
            cell.titleLabel.text = obj.title
            return cell
        } else if collectionView == categoryNameCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SalonDetailCategoryCollVwCell", for: indexPath) as! SalonDetailCategoryCollVwCell
            let category = categoriesArr[indexPath.item]
            
            if category.isCategorySelected {
                selectedIndexPath = indexPath
                cell.categoryNameLbl.textColor = appBarThemeColor
                cell.lineLbl.backgroundColor = appBarThemeColor
            } else {
                cell.categoryNameLbl.textColor = appTxtfDarkColor
                cell.lineLbl.backgroundColor = .clear
            }
            
            cell.categoryNameLbl.text = category.categoryName
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SpecialOffersCollectionViewCell", for: indexPath) as! SpecialOffersCollectionViewCell
            cell.checkoutBtn.tag = indexPath.item
            cell.displayCellData(specialOffer: specialOffersList[indexPath.item], vc: self)
            cell.checkoutBtn.addTarget(self, action: #selector(checkoutButtonAction(sender:)), for: .touchUpInside)
            return cell
        }
    }
    
    @objc func checkoutButtonAction(sender: UIButton) {
        self.offerType = specialOffersList[sender.tag].offerType ?? ""
        var place = ""
        if specialOffersList[sender.tag].serviceType == "home" {
            place = "home"
            self.calculatedTotalPrice = Float(specialOffersList[sender.tag].offerHomePrice ?? 0.0)
        } else {
            place = "salon"
            self.calculatedTotalPrice = Float(specialOffersList[sender.tag].offerSalonPrice ?? 0.0)
        }
        
        var serviceArr = [SalonDetail.ViewModel.service]()
        
        var specialOfferServices = [SalonDetail.SpecialOfferService]()
        
        if let services = specialOffersList[sender.tag].businessServicesId {
            if specialOffersList[sender.tag].offerType == "static" {
                specialOfferServices = services
            } else {
                let cell = specialOfferColVw.cellForItem(at: IndexPath(item: sender.tag, section: 0)) as! SpecialOffersCollectionViewCell
                specialOfferServices = cell.servicesArray.filter{$0.isServiceAdded == true}
            }
        }
        
        var price = 0.0
        var actualPrice = 0.0
        
        for serviceObj in specialOfferServices {
            
            if place == "home" {
                price += serviceObj.offerHomePrice ?? 0.0
                actualPrice += serviceObj.totalHomePrice ?? 0.0
            } else {
                price += serviceObj.offerSalonPrice ?? 0.0
                actualPrice += serviceObj.totalSalonPrice ?? 0.0
            }
            
            var serviceName = ""
            
            if isCurrentLanguageArabic() {
                serviceName = serviceObj.serviceNameArabic ?? ""
            } else {
                serviceName = serviceObj.serviceName ?? ""
            }
            
            let singleServiceObj: [String: String] = ["businessServiceId" : serviceObj._id ?? "",
                                                      "serviceName" : serviceName,
                                                      "serviceNameArabic" : serviceObj.serviceNameArabic ?? "",
                                                      "specialOfferId" : serviceObj.offerId ?? "",
                                                      "serviceType": serviceObj.serviceType ?? "",
                                                      "serviceDescription": serviceObj.serviceDescription ?? ""]
            
            
            if specialOffersList[sender.tag].offerType == "single service" {
                selectedSingleServiceArr.append(singleServiceObj)
            }
            
            var offerAvailable = false
            if (serviceObj.offerSalonPrice ?? 0.0) > 0.0 {
                offerAvailable = true
            } else {
                offerAvailable = false
            }
            
            var hOfferAvailable = false
            if (serviceObj.offerHomePrice ?? 0.0) > 0.0 {
                hOfferAvailable = true
            } else {
                hOfferAvailable = false
            }
            
            
            let service = SalonDetail.ViewModel.service(name: serviceName, duration: serviceObj.serviceDuration ?? "", salonPrice: "\(serviceObj.salonPrice ?? 0.0)", homePrice: "\(serviceObj.homePrice ?? 0.0)", type: specialOffersList[sender.tag].serviceType ?? "", id: serviceObj._id ?? "", isSelected: false, about: serviceObj.serviceDescription ?? "", salonOfferPrice: "\(serviceObj.offerSalonPrice ?? 0.0)", homeOfferPrice: "\(serviceObj.offerHomePrice ?? 0.0)", isOfferAvailable: hOfferAvailable, isSOfferAvailable: offerAvailable)
            serviceArr.append(service)
        }
        
        if specialOffersList[sender.tag].offerType == "single service" {
            self.calculatedTotalPrice = Float(price)
        }
        
        if !isUserLoggedIn() {
            CommonFunctions.sharedInstance.showLoginAlert(referenceController: self)
        }else{
            router?.routeToBookingForSpecialOffer(salonName: salonDetailViewModel.salonName, businessId: specialOffersList[sender.tag].businessId?._id ?? "", selectedServicesArray: serviceArr, offerId: specialOffersList[sender.tag]._id ?? "", totalPrice: String(format: "%.3f", self.calculatedTotalPrice), serviceType: specialOffersList[sender.tag].serviceType ?? "", selectedSingleserviceArray: self.selectedSingleServiceArr)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == topCollectionView {
            let width = collectionView.frame.size.width / 7
            return CGSize(width: width, height: 50)
        } else if collectionView == categoryNameCollectionView {
            return categoriesArr[indexPath.item].categoryName.size(withAttributes: nil)
        } else {
            return CGSize(width: collectionView.frame.size.width, height: collectionView.frame.size.height)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if collectionView == topCollectionView {
            let CellWidth = collectionView.frame.size.width / 7
            let totalCellWidth = Int(CellWidth) * topCollectionViewArray.count
            let leftInset = (collectionView.frame.size.width - CGFloat(totalCellWidth)) / 2
            let rightInset = leftInset
            return UIEdgeInsetsMake(0, leftInset, 0, rightInset)
        }  else {
            return .zero
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == topCollectionView {
            if let router = router {
                switch indexPath {
                case [0,0]:
                    router.routeToAboutScreen(identifier: ViewControllersIds.AboutSalonViewControllerID)
                    
                case [0,1]:
                    if !isUserLoggedIn() {
                        CommonFunctions.sharedInstance.showLoginAlert(referenceController: self)
                    }
                    else {
                        interactor?.hitAddRemoveFavoriteApi()
                    }
                    
                case [0,2]:
                    router.routeToAnotherScreen(identifier: ViewControllersIds.OpeningHoursViewControllerID)
                    
                case [0,3]:
                    
                    if LocationWrapper.sharedInstance.latitude != 0.0 { CommonFunctions.sharedInstance.openGoogleMap(destinationLatitude: salonDetailViewModel.latitude, destinationLongitude: salonDetailViewModel.longitude)
                    }
                    else {
                        LocationWrapper.sharedInstance.fetchLocation()
                    }
                case [0,4]:
                    router.routeToStaff()
                    
                case [0,5]:
                    router.routeToShare()
                    //Share
                case[0,6]:
                    //  CustomAlertController.sharedInstance.showComingSoonAlert()
                    //   router.routeToChat(identifier: ViewControllersIds.ChatViewControllerID)
                   // router.routeToChat()
                    //phoneNumber
                    router.routeToWhatsApp(mobileNum: "+97333124245" , description:"Hey! How are you? I have a query regarding" )
                    
                    
                default:
                    break
                }
            }
        }  else if collectionView == categoryNameCollectionView {
            
            for (ind, _) in categoriesArr.enumerated() {
                categoriesArr[ind].isCategorySelected = false
            }
            
            categoriesArr[indexPath.item].isCategorySelected = true
            
            self.tableScrollView.scrollRectToVisible(CGRect(x: (Int(self.view.frame.size.width) * indexPath.item), y: 0, width: Int(self.view.frame.size.width), height: Int(self.tableScrollView.bounds.size.height)), animated: true)
            
            self.noDataLabelHideShow()
            self.categoryNameCollectionView.reloadItems(at: [selectedIndexPath, indexPath])
            
            //            DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
            ////                let rect = self.categoryNameCollectionView.layoutAttributesForItem(at: IndexPath(item: 0, section: 0))?.frame
            ////                self.categoryNameCollectionView.scrollRectToVisible(rect!, animated: false)
            //
            //                self.categoryNameCollectionView.reloadData()
            //
            //            })
            
        }
    }
}

// MARK: FSPagerViewDataSource

extension SalonDetailViewController: FSPagerViewDataSource {
    
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

extension SalonDetailViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == specialOfferColVw {
            let visibleRect = CGRect(origin: self.specialOfferColVw.contentOffset, size: self.specialOfferColVw.bounds.size)
            let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
            if let visibleIndexPath = self.specialOfferColVw.indexPathForItem(at: visiblePoint) {
                self.pageControl.selectedPage = visibleIndexPath.row
            }
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == tableScrollView {
            let pageWidth = scrollView.frame.size.width
            let page = scrollView.contentOffset.x / pageWidth
            self.segmentedControl.selectedSegmentIndex = Int(page)
            for (ind, _) in categoriesArr.enumerated() {
                categoriesArr[ind].isCategorySelected = false
            }
            
            categoriesArr[Int(page)].isCategorySelected = true
            
            self.categoryNameCollectionView.reloadItems(at: [selectedIndexPath, IndexPath(item: Int(page), section: 0)])
            if isCurrentLanguageArabic() {
                self.categoryNameCollectionView.scrollToItem(at: IndexPath(item: Int(page), section: 0), at: .right, animated: true)
            } else {
                self.categoryNameCollectionView.scrollToItem(at: IndexPath(item: Int(page), section: 0), at: .centeredHorizontally, animated: true)
            }
            
            let currentArray = self.servicesArray[Int(page)]
            printToConsole(item: page)
            printToConsole(item: currentArray)
            
            if self.salonButton.isSelected {
                for item in currentArray {
                    if item.type == "salon" || item.type == "both" {
                        self.noDataLabel.isHidden = true
                        break
                    }
                    else {
                        self.noDataLabel.isHidden = false
                    }
                }
            }
            
            if self.homeButton.isSelected {
                for item in currentArray {
                    if item.type == "home" || item.type == "both" {
                        self.noDataLabel.isHidden = true
                        break
                    }
                    else {
                        self.noDataLabel.isHidden = false
                    }
                }
            }
        } else if scrollView == specialOfferColVw {
            for cell in specialOfferColVw.visibleCells {
                if let _ = specialOfferColVw.indexPath(for: cell) {
                    refreshCellData()
                }
            }
        }
    }
}

// MARK: UITableViewDelegate

extension SalonDetailViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let currentArray = servicesArray[tableView.tag]
        return currentArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        printToConsole(item: tableView.tag)
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReUseIdentifier, for: indexPath) as! UserListTableViewCell
        let currentArray = servicesArray[tableView.tag]
        let currentObj = currentArray[indexPath.row]
        printToConsole(item: currentObj)
        cell.serviceNameLabel.text = currentObj.name
        
        let isSelected = currentObj.isSelected
        cell.quantityAddedButton.isSelected = isSelected
        
        if isSelected {
            cell.quantityAddedButton.setBackgroundColor(color: appBarThemeColor, forState: .normal)
            cell.quantityAddedButton.layer.borderWidth = 0
            cell.quantityAddedButton.setImage(nil, for: .normal)
            cell.quantityAddedButton.setTitle(localizedTextFor(key: UserListSceneText.UserListSceneAddedButton.rawValue), for: .normal)
        }
        else {
            cell.quantityAddedButton.setBackgroundColor(color: UIColor.white, forState: .normal)
            cell.quantityAddedButton.layer.borderWidth = 1
            cell.quantityAddedButton.setImage(#imageLiteral(resourceName: "addIconGrey"), for: .normal)
            let title = " " + localizedTextFor(key: UserListSceneText.UserListSceneAddButton.rawValue ) + " "
            cell.quantityAddedButton.setTitle(title, for: .normal)
        }
        
        if servicesArray[tableView.tag][indexPath.row].about == "" {
            cell.infoButton.isHidden = true
        } else {
            cell.infoButton.isHidden = false
        }
        
        cell.quantityAddedButton.addTarget(self, action: #selector(self.quantityAddedButtonAction(sender:)), for: .touchUpInside)
        cell.infoButton.addTarget(self, action: #selector(self.infoButtonAction(sender:)), for: .touchUpInside)
        cell.infoButton.tintColor = appBarThemeColor
        
        let type = currentObj.type
        if salonButton.isSelected {
            
            if currentObj.isSOfferAvailable {
                cell.offerPriceLabel.isHidden = false
                cell.priceLabel.attributedText = NSAttributedString(string: currentObj.salonPrice, attributes: [NSAttributedStringKey.strikethroughStyle: 1, NSAttributedStringKey.strikethroughColor: appBarThemeColor])
                cell.offerPriceLabel.text = currentObj.salonOfferPrice
            } else {
                cell.offerPriceLabel.isHidden = true
                cell.priceLabel.text = currentObj.salonPrice
            }
            
            if type == "home" {
                cell.isHidden = true
            }
            else {
                cell.isHidden = false
            }
        }
        else if homeButton.isSelected {
            if currentObj.isOfferAvailable {
                cell.offerPriceLabel.isHidden = false
                cell.priceLabel.attributedText = NSAttributedString(string: currentObj.homePrice, attributes: [NSAttributedStringKey.strikethroughStyle: 1, NSAttributedStringKey.strikethroughColor: appBarThemeColor])
                cell.offerPriceLabel.text = currentObj.homeOfferPrice
            } else {
                cell.offerPriceLabel.isHidden = true
                cell.priceLabel.text = currentObj.homePrice
            }
            if type == "salon" {
                cell.isHidden = true
            }
            else {
                cell.isHidden = false
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let currentArray = servicesArray[tableView.tag]
        let currentObj = currentArray[indexPath.row]
        let type = currentObj.type
        if salonButton.isSelected {
            if type == "home" {
                return 0
            }
            else {
                return UITableViewAutomaticDimension
            }
        }
        else {
            if type == "salon" {
                return 0
            }
            else {
                return UITableViewAutomaticDimension
            }
        }
    }
    
    @objc func quantityAddedButtonAction(sender:UIButton) {
        
        var v:UIView = sender
        repeat { v = v.superview! } while !(v is UITableViewCell)
        let cell = v as! UserListTableViewCell
        
        var t:UIView = sender
        repeat { t = t.superview! } while !(t is UITableView)
        let currentTableView = t as! UITableView
        
        let indexPath = currentTableView.indexPath(for:cell)!
        let offerPrice = (self.servicesArray[currentTableView.tag][indexPath.row].salonOfferPrice).replacingOccurrences(of: " BHD", with: "", options: NSString.CompareOptions.literal, range: nil)
        let salonPrice = (self.servicesArray[currentTableView.tag][indexPath.row].salonPrice).replacingOccurrences(of: " BHD", with: "", options: NSString.CompareOptions.literal, range: nil)
        
        if servicesArray[currentTableView.tag][indexPath.row].about == "" {
            isInfoBtnSelected = false
            if !self.servicesArray[currentTableView.tag][indexPath.row].isSelected {
                self.servicesArray[currentTableView.tag][indexPath.row].isSelected = true
                self.selectedServicesArray.append(self.servicesArray[currentTableView.tag][indexPath.row])
                
                if offerPrice == "0.000" {
                    isSinglePriceAdded = true
                    isMultiplePriceAdded = false
                    if let myNumber = Double(salonPrice) {
                        self.totalOfferPrice = self.totalOfferPrice.roundToDecimal(3) + myNumber.roundToDecimal(3)
                    } else {
                        // what ever error code you need to write
                    }
                    
                } else {
                    isSinglePriceAdded = false
                    isMultiplePriceAdded = true
                    if let myNumber = Double(offerPrice) {
                        self.totalOfferPrice = self.totalOfferPrice.roundToDecimal(3) + myNumber.roundToDecimal(3)
                    } else {
                        // what ever error code you need to write
                    }
                    if let myNumber = Double(salonPrice) {
                        self.totalMainPrice = self.totalMainPrice.roundToDecimal(3) + myNumber.roundToDecimal(3)
                    } else {
                        
                    }
                }
                
                self.updateBookOrderView()
                
            } else{
                
                self.servicesArray[currentTableView.tag][indexPath.row].isSelected = false
                for (index, obj) in self.selectedServicesArray.enumerated() {
                    printToConsole(item: self.servicesArray[currentTableView.tag][indexPath.row].id)
                    printToConsole(item: obj.id)
                    printToConsole(item: index)
                    
                    if obj.id ==  self.servicesArray[currentTableView.tag][indexPath.row].id {
                        self.selectedServicesArray.remove(at: index)
                        
                        if offerPrice == "0.000" {
                            if let myNumber = Double(salonPrice) {
                                self.totalOfferPrice = self.totalOfferPrice.roundToDecimal(3) - myNumber.roundToDecimal(3)
                            } else {
                                // what ever error code you need to write
                            }
                            
                        } else {
                            
                            if let myNumber = Double(offerPrice) {
                                self.totalOfferPrice = self.totalOfferPrice.roundToDecimal(3) - myNumber.roundToDecimal(3)
                            } else {
                                // what ever error code you need to write
                            }
                            if let myNumber = Double(salonPrice) {
                                self.totalMainPrice = self.totalMainPrice.roundToDecimal(3) - myNumber.roundToDecimal(3)
                            } else {
                                
                            }
                        }
                    }
                }
                self.updateBookOrderView()
            }
            
            currentTableView.reloadData()
            
        } else {
            
            var v:UIView = sender
            repeat { v = v.superview! } while !(v is UITableViewCell)
            let cell = v as! UserListTableViewCell
            
            var t:UIView = sender
            repeat { t = t.superview! } while !(t is UITableView)
            let currentTableView = t as! UITableView
            
            let indexPath = currentTableView.indexPath(for:cell)!
            
            let aboutText = servicesArray[currentTableView.tag][indexPath.row].about
            
            let currentArray = servicesArray[currentTableView.tag]
            let currentObj = currentArray[indexPath.row]
            printToConsole(item: currentObj)
            cell.serviceNameLabel.text = currentObj.name
            
            if currentObj.isSelected {
                
                if !self.servicesArray[currentTableView.tag][indexPath.row].isSelected {
                    self.servicesArray[currentTableView.tag][indexPath.row].isSelected = true
                    self.selectedServicesArray.append(self.servicesArray[currentTableView.tag][indexPath.row])
                    
                    if offerPrice == "0.000" {
                        isSinglePriceAdded = true
                        isMultiplePriceAdded = false
                        if let myNumber = Double(salonPrice) {
                            self.totalOfferPrice = self.totalOfferPrice.roundToDecimal(3) + myNumber.roundToDecimal(3)
                        } else {
                            // what ever error code you need to write
                        }
                        
                    } else {
                        isSinglePriceAdded = false
                        isMultiplePriceAdded = true
                        if let myNumber = Double(offerPrice) {
                            self.totalOfferPrice = self.totalOfferPrice.roundToDecimal(3) + myNumber.roundToDecimal(3)
                        } else {
                            // what ever error code you need to write
                        }
                        if let myNumber = Double(salonPrice) {
                            self.totalMainPrice = self.totalMainPrice.roundToDecimal(3) + myNumber.roundToDecimal(3)
                        } else {
                            
                        }
                    }
                    self.updateBookOrderView()
                }
                else{
                    self.servicesArray[currentTableView.tag][indexPath.row].isSelected = false
                    
                    for (index, obj) in self.selectedServicesArray.enumerated() {
                        printToConsole(item: self.servicesArray[currentTableView.tag][indexPath.row].id)
                        printToConsole(item: obj.id)
                        printToConsole(item: index)
                        
                        if obj.id ==  self.servicesArray[currentTableView.tag][indexPath.row].id {
                            self.selectedServicesArray.remove(at: index)
                            
                            if offerPrice == "0.000" {
                                if let myNumber = Double(salonPrice) {
                                    self.totalOfferPrice = self.totalOfferPrice.roundToDecimal(3) - myNumber.roundToDecimal(3)
                                } else {
                                    // what ever error code you need to write
                                }
                                
                            } else {
                                
                                if let myNumber = Double(offerPrice) {
                                    self.totalOfferPrice = self.totalOfferPrice.roundToDecimal(3) - myNumber.roundToDecimal(3)
                                } else {
                                    // what ever error code you need to write
                                }
                                if let myNumber = Double(salonPrice) {
                                    self.totalMainPrice = self.totalMainPrice.roundToDecimal(3) - myNumber.roundToDecimal(3)
                                } else {
                                    
                                }
                            }
                        }
                    }
                    
                }
                self.updateBookOrderView()
                currentTableView.reloadData()
                
            } else {
                
                let alertController: UIAlertController = UIAlertController(title: aboutText, message: nil, preferredStyle: .alert)
                
                alertController.addAction(UIAlertAction(title: localizedTextFor(key: GeneralText.ok.rawValue), style: .default, handler: { [self] (_) in
                    
                    if !self.servicesArray[currentTableView.tag][indexPath.row].isSelected {
                        
                        self.servicesArray[currentTableView.tag][indexPath.row].isSelected = true
                        self.selectedServicesArray.append(self.servicesArray[currentTableView.tag][indexPath.row])
                        
                        if offerPrice == "0.000" {
                            isSinglePriceAdded = true
                            isMultiplePriceAdded = false
                            if let myNumber = Double(salonPrice) {
                                self.totalOfferPrice = self.totalOfferPrice.roundToDecimal(3) + myNumber.roundToDecimal(3)
                            } else {
                                // what ever error code you need to write
                            }
                            
                        } else {
                            isSinglePriceAdded = false
                            isMultiplePriceAdded = true
                            if let myNumber = Double(offerPrice) {
                                self.totalOfferPrice = self.totalOfferPrice.roundToDecimal(3) + myNumber.roundToDecimal(3)
                            } else {
                                // what ever error code you need to write
                            }
                            if let myNumber = Double(salonPrice) {
                                self.totalMainPrice = self.totalMainPrice.roundToDecimal(3) + myNumber.roundToDecimal(3)
                            } else {
                                
                            }
                        }
                        
                        self.updateBookOrderView()
                        
                    } else{
                        
                        self.servicesArray[currentTableView.tag][indexPath.row].isSelected = false
                        
                        for (index, obj) in self.selectedServicesArray.enumerated() {
                            printToConsole(item: self.servicesArray[currentTableView.tag][indexPath.row].id)
                            printToConsole(item: obj.id)
                            printToConsole(item: index)
                            
                            if obj.id ==  self.servicesArray[currentTableView.tag][indexPath.row].id {
                                self.selectedServicesArray.remove(at: index)
                                print("NEW_offerPrice:- ",offerPrice)
                                
                                if offerPrice == "0.000" {
                                    if let myNumber = Double(salonPrice) {
                                        self.totalOfferPrice = self.totalOfferPrice.roundToDecimal(3) - myNumber.roundToDecimal(3)
                                    } else {
                                        // what ever error code you need to write
                                    }
                                    
                                } else {
                                    
                                    if let myNumber = Double(offerPrice) {
                                        self.totalOfferPrice = self.totalOfferPrice.roundToDecimal(3) - myNumber.roundToDecimal(3)
                                    } else {
                                        // what ever error code you need to write
                                    }
                                    if let myNumber = Double(salonPrice) {
                                        self.totalMainPrice = self.totalMainPrice.roundToDecimal(3) - myNumber.roundToDecimal(3)
                                    } else {
                                        
                                    }
                                }
                            }
                        }
                        
                    }
                    
                    currentTableView.reloadData()
                    
                    alertController.dismiss(animated: true, completion: nil)
                }))
                self.present(alertController, animated: true, completion: nil)
            }
        }
        print("ARR:- ",self.selectedServicesArray)
    }
    
    @objc func infoButtonAction(sender:UIButton) {
        var v:UIView = sender
        repeat { v = v.superview! } while !(v is UITableViewCell)
        let cell = v as! UserListTableViewCell
        
        var t:UIView = sender
        repeat { t = t.superview! } while !(t is UITableView)
        let currentTableView = t as! UITableView
        
        let indexPath = currentTableView.indexPath(for:cell)!
        
        let aboutText = servicesArray[currentTableView.tag][indexPath.row].about
        
        let alertController: UIAlertController = UIAlertController(title: aboutText, message: nil, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: localizedTextFor(key: GeneralText.ok.rawValue), style: .default, handler: { (_) in
            alertController.dismiss(animated: true, completion: nil)
        }))
        self.present(alertController, animated: true, completion: nil)
    }
}
