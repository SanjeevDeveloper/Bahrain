
import UIKit

protocol AddSpecialOfferDisplayLogic: class
{
    func displaybusinessIdResponse(viewModel: SalonDetail.ViewModel,isComingFromEdit:Bool, offerName:String, offerImage:String)
    func offerPrepared()
}

class AddSpecialOfferViewController: UIViewController, AddSpecialOfferDisplayLogic
{
    var interactor: AddSpecialOfferBusinessLogic?
    var router: (NSObjectProtocol & AddSpecialOfferRoutingLogic & AddSpecialOfferDataPassing)?
    
    
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
        let interactor = AddSpecialOfferInteractor()
        let presenter = AddSpecialOfferPresenter()
        let router = AddSpecialOfferRouter()
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
    
    ////////////////////////////////////////////////
    
    @IBOutlet weak var topImageView: UIImageViewCustomClass!
    @IBOutlet weak var salonButton: UIButton!
    @IBOutlet weak var homeButton: UIButton!
    @IBOutlet weak var offerNameTextField: UITextFieldCustomClass!
    @IBOutlet weak var continueButton: UIButtonCustomClass!
    @IBOutlet weak var tabSwipeFrameView: UIView!
    @IBOutlet weak var tableScrollView: UIScrollView!
    
    
    var salonDetailViewModel: SalonDetail.ViewModel!
    var servicesArray: [[SalonDetail.ViewModel.service]]!
    var segmentedControl = HMSegmentedControl()
    var selectedServicesArray =  [SalonDetail.ViewModel.service]()
    var isComingFromEdit = false
    var offerImage:UIImage?
    
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialFunction()
        applyFontAndColor()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        applyLocalizedText()
    }
    
    // MARK: Apply Font And Color
    func applyFontAndColor() {
        offerNameTextField.textColor = appTxtfDarkColor
        continueButton.backgroundColor = appBarThemeColor
        continueButton.setTitleColor(appBtnWhiteColor, for: .normal)
    }
    
    // MARK: Apply LocalizedText
    func applyLocalizedText() {
        let colorAttribute = [NSAttributedStringKey.foregroundColor: UIColor.darkGray]
        
        let  offerNameTextFieldPlaceholder = NSMutableAttributedString(string: localizedTextFor(key: AddSpecialOfferSceneText.AddSpecialOfferSceneOfferNameTextField.rawValue), attributes: colorAttribute)
        offerNameTextFieldPlaceholder.append(asterik)
        offerNameTextField.attributedPlaceholder = offerNameTextFieldPlaceholder
        
        
        continueButton.setTitle(localizedTextFor(key: AddSpecialOfferSceneText.AddSpecialOfferSceneContinueButton.rawValue), for: .normal)
    }
    
    // MARK: Button Action
    @IBAction func addImageButtonAction(_ sender: Any) {
        let customPicker = CustomImagePicker()
        customPicker.delegate = self
        customPicker.openImagePicker(controller: self, source: (sender as! UIButton))
    }
    
    @IBAction func salonButtonAction(_ sender: Any) {
        if !isComingFromEdit{
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
        }
    }
    
    @IBAction func homeButtonAction(_ sender: Any) {
        if !isComingFromEdit{
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
        }
    }
    
    @IBAction func continueButtonAction(_ sender: Any) {
            interactor?.prepareOffer(offerName:offerNameTextField.text_Trimmed(), selectedServicesArray: selectedServicesArray, offerImage:offerImage, isHome: homeButton.isSelected)
    }
        // MARK: Other Functions
        
        func initialFunction() {
            hideBackButtonTitle()
            interactor?.getBusinessByIdApi()
        }
        
        // MARK: Display Response
        func displaybusinessIdResponse(viewModel: SalonDetail.ViewModel, isComingFromEdit:Bool, offerName:String,offerImage:String) {
            self.isComingFromEdit = isComingFromEdit
            
            if isComingFromEdit {
                if let coverImageUrl = URL(string:Configurator().imageBaseUrl + offerImage) {
                    topImageView.sd_setImage(with: coverImageUrl, placeholderImage: #imageLiteral(resourceName: "plusWhite"), options: .retryFailed, completed: nil)
                    topImageView.contentMode = .scaleAspectFill
                    topImageView.clipsToBounds = true
                }
                offerNameTextField.text = offerName
                CommonFunctions.sharedInstance.setNavigationTitleView(titleStr:   localizedTextFor(key: AddSpecialOfferSceneText.AddSpecialOfferSceneEditOfferTitle.rawValue), onVC: self)
                
                for obj in viewModel.servicesArray {
                    for obj2 in obj {
                        if obj2.isSelected {
                            selectedServicesArray.append(obj2)
                        }
                    }
                }
            }
            else {
                CommonFunctions.sharedInstance.setNavigationTitleView(titleStr:   localizedTextFor(key: AddSpecialOfferSceneText.AddSpecialOfferSceneAddOfferTitle.rawValue), onVC: self)
            }
            
            salonDetailViewModel = viewModel
            servicesArray = salonDetailViewModel.servicesArray
            
            setupSegment(viewModel: viewModel)
            setupSwipeScrollView(viewModel: viewModel)
        }
        
        // MARK: SetupSwipeScrollView
        func setupSwipeScrollView(viewModel: SalonDetail.ViewModel) {
            let viewWidth = Int(self.view.frame.size.width)
            self.tableScrollView.isPagingEnabled = true
            
            self.tableScrollView.contentSize = CGSize(width: viewWidth * viewModel.servicesArray.count, height: Int(tableScrollView.bounds.size.height))
            self.tableScrollView.delegate = self;
            
            for (index, _) in viewModel.servicesArray.enumerated() {
                let table = UITableView(frame: CGRect(x: viewWidth * index, y: 0, width: viewWidth, height: Int(tableScrollView.frame.size.height)))
                table.register(UINib(nibName: BusinessServiceCell, bundle: nil), forCellReuseIdentifier: cellReUseIdentifier)
                
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
        
        func offerPrepared() {
            router?.routeToPreview()
        }
    }
    
    // MARK: UITextFieldDelegate
    extension AddSpecialOfferViewController : UITextFieldDelegate {
        
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            textField.resignFirstResponder()
            return true
        }
    }
    
    // MARK: UIScrollViewDelegate
    extension AddSpecialOfferViewController: UIScrollViewDelegate {
        
        func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
            if scrollView == tableScrollView {
                let pageWidth = scrollView.frame.size.width
                let page = scrollView.contentOffset.x / pageWidth
                
                self.segmentedControl.selectedSegmentIndex = Int(page)
            }
        }
    }
    
    // MARK: UITableViewDelegate
    extension AddSpecialOfferViewController: UITableViewDataSource, UITableViewDelegate {
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            let currentArray = servicesArray[tableView.tag]
            return currentArray.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            printToConsole(item: tableView.tag)
            let cell = tableView.dequeueReusableCell(withIdentifier: cellReUseIdentifier, for: indexPath) as! BusinessServiceTableViewCell
            let currentArray = servicesArray[tableView.tag]
            let currentObj = currentArray[indexPath.row]
            printToConsole(item: currentObj)
            cell.serviceNameLabel.text = currentObj.name
            cell.durationLabel.text = currentObj.duration
            
            let isSelected = currentObj.isSelected
            cell.quantityAddedButton.isSelected = isSelected
            
            if isSelected {
                cell.quantityAddedButton.setBackgroundColor(color: appBarThemeColor, forState: .normal)
                cell.quantityAddedButton.layer.borderWidth = 0
                cell.quantityAddedButton.setImage(nil, for: .normal)
                cell.quantityAddedButton.setTitle(localizedTextFor(key: UserListSceneText.UserListSceneAddedButton.rawValue), for: .normal)
            }
            else {
                cell.quantityAddedButton.setBackgroundColor(color: UIColor.clear, forState: .normal)
                cell.quantityAddedButton.layer.borderWidth = 1
                cell.quantityAddedButton.setImage(#imageLiteral(resourceName: "addIconGrey"), for: .normal)
                let title = "  " + localizedTextFor(key: UserListSceneText.UserListSceneAddButton.rawValue ) + "  "
                cell.quantityAddedButton.setTitle(title, for: .normal)
            }
            
            cell.quantityAddedButton.addTarget(self, action: #selector(self.quantityAddedButtonAction(sender:)), for: .touchUpInside)
            
            let type = currentObj.type
            if salonButton.isSelected {
                cell.priceLabel.text = currentObj.salonPrice + " " +  localizedTextFor(key: GeneralText.bhd.rawValue)
                if type == "home" {
                    cell.isHidden = true
                }
                else {
                    cell.isHidden = false
                }
            }
            else if homeButton.isSelected {
                cell.priceLabel.text = currentObj.homePrice + " " +  localizedTextFor(key: GeneralText.bhd.rawValue)
                if type == "salon" {
                    cell.isHidden = true
                }
                else {
                    cell.isHidden = false
                }
            }
            return cell
        }
        
        @objc func quantityAddedButtonAction(sender:UIButton) {
            var v:UIView = sender
            repeat { v = v.superview! } while !(v is UITableViewCell)
            let cell = v as! BusinessServiceTableViewCell
            
            var t:UIView = sender
            repeat { t = t.superview! } while !(t is UITableView)
            let currentTableView = t as! UITableView
            
            let indexPath = currentTableView.indexPath(for:cell)!
            
            
            if !servicesArray[currentTableView.tag][indexPath.row].isSelected {
                servicesArray[currentTableView.tag][indexPath.row].isSelected = true
                selectedServicesArray.append(servicesArray[currentTableView.tag][indexPath.row])
            }
            else{
                servicesArray[currentTableView.tag][indexPath.row].isSelected = false
                
                for (index, obj) in selectedServicesArray.enumerated() {
                    printToConsole(item: servicesArray[currentTableView.tag][indexPath.row].id)
                    printToConsole(item: obj.id)
                    printToConsole(item: index)
                    printToConsole(item: selectedServicesArray)
                    if obj.id ==  servicesArray[currentTableView.tag][indexPath.row].id {
                        selectedServicesArray.remove(at: index)
                    }
                }
            }
            currentTableView.reloadData()
            printToConsole(item: selectedServicesArray)
        }
    }
    
    // MARK: CustomImagePickerProtocol
    extension AddSpecialOfferViewController: CustomImagePickerProtocol{
        
        func didFinishPickingImage(image:UIImage) {
            offerImage = image
            topImageView.contentMode = .scaleAspectFill
            topImageView.clipsToBounds = true
            topImageView.image = image
        }
        func didCancelPickingImage() {
        }
}
