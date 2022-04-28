
import UIKit

protocol FilterDisplayLogic: class
{
    func displayResponse(viewModel: Filter.ViewModel)
    func displaySelectedAreaText(ResponseMsg:String?)
    func displayData(response:NSDictionary, categoryArr: [Filter.ViewModel.tableCellData]?, paymentArr: [Filter.PaymentViewModel.tableCellData]?, fromScreen: String?,minimumValue:NSNumber,MaximunValue:NSNumber)
}

class FilterViewController: UIViewController, FilterDisplayLogic
{
    
    var interactor: FilterBusinessLogic?
    var router: (NSObjectProtocol & FilterRoutingLogic & FilterDataPassing)?
    
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
        let interactor = FilterInteractor()
        let presenter = FilterPresenter()
        let router = FilterRouter()
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
            if (scene == "SelectArea") {
                router?.routeToSelectArea(segue: segue)
            }
        }
    }
    
    //////////////////////////////////////////////////////////////////////////
    
    @IBOutlet weak var categoriesTableView: UITableView!
    @IBOutlet weak var categoriesTableHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var paymentTableView: UITableView!
    @IBOutlet weak var paymentTableHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var priceTitleLabel: UILabelFontSize!
    @IBOutlet weak var minPriceLabel: UILabelFontSize!
    @IBOutlet weak var minAmountLabel: UILabelFontSize!
    @IBOutlet weak var customRangeSlider: RangeSlider!
    @IBOutlet weak var maxPriceLabel: UILabelFontSize!
    @IBOutlet weak var maxAmountLabel: UILabelFontSize!
    @IBOutlet weak var categoriesTitleLabel: UILabelFontSize!
    @IBOutlet weak var selectAreaView: UIView!
    @IBOutlet weak var selectAreaTitleLabel: UILabelFontSize!
    @IBOutlet weak var addressLabel: UILabelFontSize!
    @IBOutlet weak var paymentMethodTitleLabel: UILabelFontSize!
    @IBOutlet weak var totalSelectionLabel: UILabelFontSize!
    @IBOutlet weak var applyButton: UIButtonCustomClass!
    @IBOutlet weak var lblCity: UILabelFontSize!
    @IBOutlet weak var bottomView: UIView!
    
    var categoriesArray = [Filter.ViewModel.tableCellData]()
    var paymentArray = [Filter.PaymentViewModel.tableCellData]()
    var selectionArray = [String]()
    var minimumPrice = NSNumber()
    var maximumPrice = NSNumber()
    
    var isClearFilter = Bool()
    
    
    // MARK: View lifecycle
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        isClearFilter = true
        selectAreaView.isHidden = true
        applyLocalizedText()
        applyFontAndColor()
        addObserverOnTableViewReload()
        addCustomRightBarButton()
        totalSelectionLabel.text = "0 " + localizedTextFor(key: FilterSceneText.FilterSceneSelectedTextLabel.rawValue)
        let obj1 = Filter.PaymentViewModel.tableCellData(name: localizedTextFor(key: FilterSceneText.FilterSceneCashText.rawValue), isSelected: true)
        paymentArray.append(obj1)
        customRangeSlider.addTarget(self, action: #selector(FilterViewController.rangeSliderValueChanged(_:)), for: .valueChanged)
        bottomView.backgroundColor = appBarThemeColor
        customRangeSlider.thumbBorderColor = appBarThemeColor
        customRangeSlider.trackHighlightTintColor = appBarThemeColor
        customRangeSlider.bottomShadowColor = appBarThemeColor
        selectAreaTitleLabel.textColor = appBarThemeColor
    }
    
    func addObserverOnTableViewReload() {
        categoriesTableView.addObserver(self, forKeyPath: tableContentSize, options: .new, context: nil)
        paymentTableView.addObserver(self, forKeyPath: tableContentSize, options: .new, context: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let obj = object as? UITableView {
            if obj == categoriesTableView && keyPath == tableContentSize {
                if (change?[NSKeyValueChangeKey.newKey] as? CGSize) != nil {
                    categoriesTableHeightConstraint.constant = categoriesTableView.contentSize.height
                }
            }
            else if obj == paymentTableView && keyPath == tableContentSize {
                if (change?[NSKeyValueChangeKey.newKey] as? CGSize) != nil {
                    paymentTableHeightConstraint.constant = paymentTableView.contentSize.height
                }
            }
        }
    }
    
    deinit {
        categoriesTableView.removeObserver(self, forKeyPath: tableContentSize)
        paymentTableView.removeObserver(self, forKeyPath: tableContentSize)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        interactor?.showSelectedArea()
        interactor?.getOldData()
       
    }
    
    // MARK: Apply Font And Color
    func applyFontAndColor() {
        priceTitleLabel.textColor = appBarThemeColor
        minPriceLabel.textColor = appTxtfDarkColor
        maxPriceLabel.textColor = appTxtfDarkColor
        categoriesTitleLabel.textColor = appBarThemeColor
       
    }
    
    // MARK: Apply LocalizedText
    func applyLocalizedText() {
         CommonFunctions.sharedInstance.setNavigationTitleView(titleStr:  localizedTextFor(key: FilterSceneText.FilterSceneTitleLabel.rawValue), onVC: self)
        priceTitleLabel.text = localizedTextFor(key: FilterSceneText.FilterScenePriceTitleLabel.rawValue)
        minPriceLabel.text = localizedTextFor(key: FilterSceneText.FilterSceneMinPriceLabel.rawValue)
        maxPriceLabel.text = localizedTextFor(key: FilterSceneText.FilterSceneMaxPriceLabel.rawValue)
        categoriesTitleLabel.text = localizedTextFor(key: FilterSceneText.FilterSceneCategoriesTitleLabel.rawValue)
        selectAreaTitleLabel.text = localizedTextFor(key: FilterSceneText.FilterSceneSelectAreaTitleLabel.rawValue)
       
        paymentMethodTitleLabel.text = localizedTextFor(key: FilterSceneText.FilterScenePaymentMethodTitleLabel.rawValue)
        applyButton.setTitle(localizedTextFor(key: FilterSceneText.FilterSceneApplyButtonTitle.rawValue), for: .normal)
       applyButton.setTitleColor(appBarThemeColor, for: .normal)
        // minAmountLabel.text = "0" + localizedTextFor(key: GeneralText.bhd.rawValue)
       // maxAmountLabel.text = "2000" + localizedTextFor(key: GeneralText.bhd.rawValue)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    // MARK: UIButton Actions
    
    func addCustomRightBarButton() {
        let btnClear = UIButton(type: UIButtonType.system)
        btnClear.frame = CGRect(x: 0, y: 0, width: 80, height: 16)
        btnClear.layer.cornerRadius = 5
        btnClear.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        let title = " " + localizedTextFor(key: FilterSceneText.FilterSceneClearButtonText.rawValue) + " "
        btnClear.setTitle(title, for: .normal)
        btnClear.tintColor = appBarThemeColor
        btnClear.setTitleColor(appBtnWhiteColor, for: .normal)
        btnClear.addTarget(self, action: #selector(self.clearButtonAction), for: .touchUpInside)
        let customBarItem = UIBarButtonItem(customView: btnClear)
        self.navigationItem.rightBarButtonItem = customBarItem;
    }
    
    @objc func clearButtonAction() {
        isClearFilter = true
        minAmountLabel.text = String(format: "%.3f", minimumPrice.floatValue) + GeneralText.bhd.rawValue.uppercased()
        maxAmountLabel.text = String(format: "%.3f", maximumPrice.floatValue) + GeneralText.bhd.rawValue.uppercased()
        
        customRangeSlider.lowerValue = Double(truncating: minimumPrice)
        customRangeSlider.upperValue = Double(truncating: maximumPrice)
        customRangeSlider.minimumValue = Double(truncating: minimumPrice)
        customRangeSlider.maximumValue = Double(truncating: maximumPrice)
        selectionArray.removeAll()
        
        for (index, _) in categoriesArray.enumerated() {
            categoriesArray[index].isSelected = false
        }
        categoriesTableView.reloadData()
        interactor?.clearAreatext()
    
        addressLabel.text = localizedTextFor(key: FilterSceneText.FilterSceneSelectAreaTitleLabel.rawValue)
        totalSelectionLabel.text = "0 " + localizedTextFor(key: FilterSceneText.FilterSceneSelectedTextLabel.rawValue)
    }
    
    @IBAction func selectAreaButtonAction(_ sender: Any) {
        performSegue(withIdentifier: FilterPaths.Identifiers.selectArea, sender: nil)
    }
    
    @IBAction func applyButtonAction(_ sender: Any) {
//        var isSelected = false
//        for data in categoriesArray {
//            if data.isSelected {
//                isSelected = true
//            }
//        }
        
        var area = ""
        
        if addressLabel.text != localizedTextFor(key: FilterSceneText.FilterSceneSelectAreaTitleLabel.rawValue) {
            area = addressLabel.text ?? ""
        }
        
        
      //  if isSelected
            let lowerValue:Int = Int(customRangeSlider.lowerValue)
            let upperValue:Int = Int(customRangeSlider.upperValue)
            let param = [
                "area": area,
                "maxPrice":upperValue.description,
                "minPrice":lowerValue.description,
                ]
        
        
            router?.routeToFavouriteScreen(segue: nil, dict: param as NSDictionary, categoriesArr: categoriesArray, paymentArr: paymentArray, isClearFilter: isClearFilter)
        }
       // else {
       //     CustomAlertController.sharedInstance.showErrorAlert(error: localizedTextFor(key: FilterSceneText.FilterSceneCategoryErrorMessage.rawValue))
      //  }
   // }
    
    // MARK: DisplaySelectedAreaText
    func displaySelectedAreaText(ResponseMsg: String?) {
        addressLabel.text = ResponseMsg
        if addressLabel.text != nil {
            isClearFilter = false
            addressLabel.textColor = UIColor.darkGray
        }
        else {
            addressLabel.text = localizedTextFor(key: FilterSceneText.FilterSceneSelectAreaTitleLabel.rawValue)
            addressLabel.textColor = UIColor.gray
        }
    }
    
    // MARK: DisplayGetServiceResponse
    func displayResponse(viewModel: Filter.ViewModel){
        categoriesArray = viewModel.servicesArray
        for item in categoriesArray {
            if item.isSelected{
                selectionArray.append(item.name)
            }
        }
        let selectedCount = categoriesArray.filter{$0.isSelected == true}
        totalSelectionLabel.text = "\(selectedCount.count)" + " " + localizedTextFor(key: FilterSceneText.FilterSceneSelectedTextLabel.rawValue)
        categoriesTableView.reloadData()
    }
    
    func displayData(response:NSDictionary, categoryArr: [Filter.ViewModel.tableCellData]?, paymentArr: [Filter.PaymentViewModel.tableCellData]?, fromScreen: String?,minimumValue:NSNumber,MaximunValue:NSNumber) {
        
        minimumPrice = minimumValue
        maximumPrice = MaximunValue

        if fromScreen != "selectArea"{
            printToConsole(item: response)
            if response.count != 0 {
                
                isClearFilter = false
                addressLabel.text = response["area"] as? String ?? ""
                
                if addressLabel.text == "" {
                     addressLabel.text = localizedTextFor(key: FilterSceneText.FilterSceneSelectAreaTitleLabel.rawValue)
                      addressLabel.textColor = UIColor.gray
                }
                else
                {
                     addressLabel.textColor = UIColor.darkGray
                }
                
              
        
                let currencyString = localizedTextFor(key: GeneralText.bhd.rawValue)
                let minText = response["minPrice"] as! String
                minAmountLabel.text = String(format: "%.3f", minText.floatValue()) + currencyString.uppercased()
                let maxText = response["maxPrice"] as! String
                maxAmountLabel.text = String(format: "%.3f", maxText.floatValue()) + currencyString.uppercased()
                customRangeSlider.lowerValue = Double(minText)!
                customRangeSlider.upperValue = Double(maxText)!
                customRangeSlider.minimumValue = Double(truncating: minimumPrice)
                customRangeSlider.maximumValue = Double(truncating: maximumPrice)
            }else{
                minAmountLabel.text = String(format: "%.3f", minimumValue.floatValue) + GeneralText.bhd.rawValue.uppercased()
                maxAmountLabel.text = String(format: "%.3f", MaximunValue.floatValue) + GeneralText.bhd.rawValue.uppercased()
                customRangeSlider.lowerValue = Double(truncating: minimumValue)
                customRangeSlider.upperValue = Double(truncating: MaximunValue)
                customRangeSlider.minimumValue = Double(truncating: minimumValue)
                customRangeSlider.maximumValue = Double(truncating: MaximunValue)
            }
            
            if fromScreen == "searchVC"  || fromScreen == "subCategoryFilter"  || fromScreen == "specialOfferVC"{
                selectAreaView.isHidden = false
            }
            else {
                selectAreaView.isHidden = true
            }
            
            if paymentArr != nil {
                if paymentArr?.count != 0{
                    paymentArray = paymentArr!
                    paymentTableView.reloadData()
                }
            }
            if categoryArr != nil {
                if categoryArr?.count != 0 {
                    let selectedCount = categoryArr?.filter{$0.isSelected == true}
                    totalSelectionLabel.text = "\(selectedCount!.count)" + " " + localizedTextFor(key: FilterSceneText.FilterSceneSelectedTextLabel.rawValue)
                    categoriesArray = categoryArr!
                    categoriesTableView.reloadData()
                }
            }
            else {
                interactor?.getServicesList()
            }
            
        }
    }
    
    // MARK: Button Action
    
    @objc func rangeSliderValueChanged(_ rangeSlider: RangeSlider) {
         isClearFilter = false
        let lowerValue = rangeSlider.lowerValue
        let upperValue = rangeSlider.upperValue
        
        let currencyString = localizedTextFor(key: GeneralText.bhd.rawValue)
        minAmountLabel.text = String(format: "%.3f", lowerValue) + currencyString.uppercased()
        maxAmountLabel.text = String(format: "%.3f", upperValue) + currencyString.uppercased()
        
    }
    
    @objc func categoryCheckBoxButtonAction(sender:UIButton) {
        isClearFilter = false
        var v:UIView = sender
        repeat { v = v.superview! } while !(v is UITableViewCell)
        let cell = v as! FilterTableViewCell
        let indexPath = categoriesTableView.indexPath(for:cell)!
        
        var obj = categoriesArray[indexPath.row]
        obj.isSelected = !obj.isSelected
        categoriesArray[indexPath.row] = obj
        categoriesTableView.reloadData()
        
        let stringText = obj.name
        if selectionArray.contains(stringText) {
            let index = selectionArray.index(of: stringText)
            selectionArray.remove(at: index!)
        }
        else{
            selectionArray.append(stringText)
        }
        
//        let selectionCount = String(selectionArray.count)
        let selectedString = localizedTextFor(key: FilterSceneText.FilterSceneSelectedTextLabel.rawValue)
        let selectedCount = categoriesArray.filter{$0.isSelected == true}
        totalSelectionLabel.text = "\(selectedCount.count)" + " " + selectedString
       
        
    }
    
    @objc func paymentCheckBoxButtonAction(sender:UIButton) {
        var v:UIView = sender
        repeat { v = v.superview! } while !(v is UITableViewCell)
        let cell = v as! FilterTableViewCell
        let indexPath = paymentTableView.indexPath(for:cell)!
        
        var obj = paymentArray[indexPath.row]
        obj.isSelected = !obj.isSelected
        paymentArray[indexPath.row] = obj
        paymentTableView.reloadData()
    }
    
}

// MARK: UITableViewDelegate
extension FilterViewController : UITableViewDataSource, UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == categoriesTableView {
            return categoriesArray.count
        }else if tableView == paymentTableView{
            return paymentArray.count
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReUseIdentifier, for: indexPath) as! FilterTableViewCell
        if tableView == categoriesTableView {
            let rowsObject = categoriesArray[indexPath.row]
            cell.nameLabel.text = rowsObject.name
            cell.checkBoxButton.isSelected = rowsObject.isSelected
            cell.checkBoxButton.addTarget(self, action: #selector(self.categoryCheckBoxButtonAction(sender:)), for: .touchUpInside)
        }
        else if tableView == paymentTableView{
            let rowsObject = paymentArray[indexPath.row]
            cell.nameLabel.text = rowsObject.name
            cell.checkBoxButton.isSelected = rowsObject.isSelected
        }
        return cell
    }
}



