
import UIKit

protocol SpecialNewOffersDisplayLogic: class
{
    func displayResponse(viewModel: SpecialNewOffers.ViewModel, isHome: Bool?)
    func displayCreateOfferApiResponse()
}

class SpecialNewOffersViewController: UIViewController, SpecialNewOffersDisplayLogic
{
    
    
    var interactor: SpecialNewOffersBusinessLogic?
    var router: (NSObjectProtocol & SpecialNewOffersRoutingLogic & SpecialNewOffersDataPassing)?
    
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
        let interactor = SpecialNewOffersInteractor()
        let presenter = SpecialNewOffersPresenter()
        let router = SpecialNewOffersRouter()
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
    
    
    //////////////////////////////////////////////////////////////////
    
    @IBOutlet weak var topImageView: UIImageView!
    @IBOutlet weak var tableHeightConstraints: NSLayoutConstraint!
    @IBOutlet weak var offersTableView: UITableView!
    @IBOutlet weak var setPriceLabel: UILabelFontSize!
    @IBOutlet weak var bhdLabel: UILabelFontSize!
    @IBOutlet weak var setPriceTextField: UITextFieldFontSize!
    @IBOutlet weak var totalPriceLabel: UILabelFontSize!
    @IBOutlet weak var totalPriceTextField: UITextFieldFontSize!
    @IBOutlet weak var expireDateLabel: UILabelFontSize!
    @IBOutlet weak var expireDateTextField: UITextFieldFontSize!
    @IBOutlet weak var expirationSwitchButton: UISwitch!
    @IBOutlet weak var doneButton: UIButtonCustomClass!
    @IBOutlet weak var previewOfferButton: UIButtonCustomClass!
    
    var specialOfferArray = [SalonDetail.ViewModel.service]()
    var offerId = ""
    var isHomeTrue = Bool()
    
    
    // MARK: View lifecycle
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        hideBackButtonTitle()
        offersTableView.tableFooterView = UIView()
        expirationSwitchButton.transform = CGAffineTransform(scaleX: 0.8, y: 0.8);
        expirationSwitchButton.isOn = false
        addObserverOnTableViewReload()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        applyLocalizedText()
        interactor?.getData()
    }
    
    // MARK: Apply LocalizedText
    func applyLocalizedText() {
        offersTableView.reloadData()
        
        let colorAttribute = [NSAttributedStringKey.foregroundColor: UIColor.darkGray]
        setPriceLabel.text = localizedTextFor(key: SpecialNewOffersSceneText.SpecialNewOffersSceneSetPriceLabel.rawValue)
        
        
        let priceTextFieldPlaceholder = NSMutableAttributedString(string: localizedTextFor(key: GeneralText.bhd.rawValue), attributes: colorAttribute)
        priceTextFieldPlaceholder.append(asterik)
        
        bhdLabel.text = localizedTextFor(key: GeneralText.bhd.rawValue)
        setPriceTextField.attributedPlaceholder = priceTextFieldPlaceholder
        totalPriceLabel.text = localizedTextFor(key: SpecialNewOffersSceneText.SpecialNewOffersSceneTotalPriceLabel.rawValue)
        expireDateLabel.text = localizedTextFor(key: SpecialNewOffersSceneText.SpecialNewOffersSceneExpirationDateLabel.rawValue)
        
        previewOfferButton.setTitle(localizedTextFor(key: SpecialNewOffersSceneText.SpecialNewOffersScenePreviewOfferButton.rawValue), for: .normal)
        
        doneButton.setTitle(localizedTextFor(key: SpecialNewOffersSceneText.SpecialNewOffersSceneDoneButton.rawValue), for: .normal)
    }
    
    // MARK: AddObserverOnTableViewReload
    func addObserverOnTableViewReload() {
        offersTableView.addObserver(self, forKeyPath: tableContentSize, options: .new, context: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let obj = object as? UITableView {
            if obj == offersTableView && keyPath == tableContentSize {
                if (change?[NSKeyValueChangeKey.newKey] as? CGSize) != nil {
                    tableHeightConstraints.constant = offersTableView.contentSize.height
                }
            }
        }
    }
    
    deinit {
        offersTableView.removeObserver(self, forKeyPath: tableContentSize)
    }
    
    
    // MARK: Button Actions
    
    @IBAction func expirySwitchButtonAction(_ sender: UISwitch) {
        
        if sender.isOn{
            self.expireDateTextField.becomeFirstResponder()
        }
    }
    
    
    @IBAction func previewOfferButtonAction(_ sender: Any) {
        doneButton.isHidden = true
        previewOfferButton.isHidden = true
        offersTableView.isUserInteractionEnabled = false
        setPriceTextField.isUserInteractionEnabled = false
        totalPriceTextField.isUserInteractionEnabled = false
        expireDateTextField.isUserInteractionEnabled = false
        let closeBarButton = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(self.closeButtonAction))
        self.navigationItem.rightBarButtonItem = closeBarButton
    }
    
    @objc func closeButtonAction() {
        doneButton.isHidden = false
        previewOfferButton.isHidden = false
        offersTableView.isUserInteractionEnabled = true
        setPriceTextField.isUserInteractionEnabled = true
        totalPriceTextField.isUserInteractionEnabled = true
        expireDateTextField.isUserInteractionEnabled = true
        self.navigationItem.rightBarButtonItem = nil
    }
    
    @IBAction func doneButtonAction(_ sender: Any) {
        
        if expireDateTextField.text == "" {
            
            CustomAlertController.sharedInstance.showErrorAlert(error: localizedTextFor(key: SpecialNewOffersSceneText.SpecialNewOffersSceneExpiryDateValidationText.rawValue))
            
        }
        else if setPriceTextField.text == "" {
            
            CustomAlertController.sharedInstance.showErrorAlert(error: localizedTextFor(key: SpecialNewOffersSceneText.SpecialNewOffersSceneSetPriceValidationText.rawValue))
        }
        else if specialOfferArray.count == 0{
            
            CustomAlertController.sharedInstance.showErrorAlert(error: localizedTextFor(key: SpecialNewOffersSceneText.SpecialNewOffersSceneOfferArrayValidationText.rawValue))
        }
        else if (totalPriceTextField.text?.intValue())! <= (setPriceTextField.text?.intValue())! {
            
            CustomAlertController.sharedInstance.showErrorAlert(error:localizedTextFor(key: SpecialNewOffersSceneText.SpecialNewOffersSceneOfferPriceValidationText.rawValue))
        }
        else {
            
            printToConsole(item: specialOfferArray)
            var servicesIdsArray = [String]()
            for service in self.specialOfferArray {
                servicesIdsArray.append(service.id)
            }
            
            let dateFormatter = DateFormatter()
            dateFormatter.timeZone = UaeTimeZone
            let expirydateString = expireDateTextField.text
            dateFormatter.dateFormat = dateFormats.format5
            let expiryDate = dateFormatter.date(from: expirydateString!)
            let milliSecond = expiryDate?.millisecondsSince1970
            
            let string = NSString(string: setPriceTextField.text!)
            let price = string.floatValue
            
            let stringTotalPrice = NSString(string: totalPriceTextField.text!)
            let totalPrice = stringTotalPrice.floatValue
            
            let req = SpecialNewOffers.Request(expiryDate: milliSecond!, activeExpiryDate: expirationSwitchButton.isOn, offerSalonPrice: price as NSNumber, totalSalonPrice: totalPrice as NSNumber, servicesIdsArray: servicesIdsArray)
            
            if offerId == "" {
                interactor?.hitCreateOfferApi(request: req)
            }
            else {
                interactor?.hitEditOfferApi(request: req, offerId: offerId)
            }
        }
    }
    
    @objc func deleteButtonAction(sender:UIButton) {
        var v:UIView = sender
        repeat { v = v.superview! } while !(v is UITableViewCell)
        let cell = v as! SpecialNewOffersTableViewCell
        let indexPath = offersTableView.indexPath(for:cell)!
        showAlert(indexpath: indexPath.section)
        
    }
    
    
    func showAlert(indexpath:Int) {
        
        let alertController = PMAlertController(textForegroundColor:UIColor.darkGray, viewBackgroundColor: UIColor.white, title: "" , description:localizedTextFor(key: ListServiceSceneText.listServiceSceneDeleteServiceLabel.rawValue), image: nil , style: .alert)
        
        let yesButton = PMAlertAction(title: localizedTextFor(key: GeneralText.yes.rawValue), style: .default, action: {
            
            self.specialOfferArray.remove(at: indexpath)
            self.offersTableView.reloadData()
            self.tableHeightConstraints.constant = self.offersTableView.contentSize.height
            
            printToConsole(item: self.specialOfferArray)
            
            var calulatedTotalPrice:Float = 0.0
            for obj in self.specialOfferArray {
                
                if self.isHomeTrue {
                    let stringHome = NSString(string: obj.homePrice)
                    let homeprice = stringHome.floatValue
    
                    calulatedTotalPrice = calulatedTotalPrice + homeprice
                }
                else {
                    let stringSalon = NSString(string: obj.salonPrice)
                    let salonPrice = stringSalon.floatValue
                    calulatedTotalPrice = calulatedTotalPrice + salonPrice
                }
            }
            
            
            printToConsole(item: calulatedTotalPrice)
            self.totalPriceTextField.text = calulatedTotalPrice.description + " " +  localizedTextFor(key: GeneralText.bhd.rawValue)
            
        })
        
        let noButton = PMAlertAction(title: localizedTextFor(key: GeneralText.no.rawValue), style: .default, action: {
            alertController.dismiss(animated: true, completion: nil)
        })
        
        alertController.addAction(noButton)
        alertController.addAction(yesButton)
        
        present(alertController, animated: true, completion: nil)
    }
    
    // MARK: Display Response
    func displayCreateOfferApiResponse() {
        CustomAlertController.sharedInstance.showAlert(subTitle: localizedTextFor(key: SpecialNewOffersSceneText.SpecialNewOffersSceneOfferCreatedText.rawValue), type: .success)
        
        popThreeViewControllers()
    }
    
    func popThreeViewControllers() {
        let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController]
        self.navigationController!.popToViewController(viewControllers[viewControllers.count - 4], animated: true)
    }
    
    func displayResponse(viewModel: SpecialNewOffers.ViewModel, isHome: Bool?)
    {
        specialOfferArray = viewModel.selectedServicesArray
        totalPriceTextField.text = viewModel.TotalPrice.description + " " +  localizedTextFor(key: GeneralText.bhd.rawValue)
        
        isHomeTrue = isHome!
        
        if viewModel.offerObj != nil {
            
            bhdLabel.isHidden = false
            CommonFunctions.sharedInstance.setNavigationTitleView(titleStr:   localizedTextFor(key: AddSpecialOfferSceneText.AddSpecialOfferSceneEditOfferTitle.rawValue), onVC: self)
            let dataDict = viewModel.offerObj as! NSDictionary
            printToConsole(item: dataDict)
            
            offerId = dataDict["_id"] as! String
            let serviceType = dataDict["serviceType"] as! String
            
            printToConsole(item: serviceType)
            
            if serviceType == "salon" {
                let salonPrice = dataDict["offerSalonPrice"] as? NSNumber
                setPriceTextField.text = (salonPrice?.floatValue.description)!
                
            }
            else {
                let homePrice = dataDict["offerHomePrice"] as? NSNumber
                setPriceTextField.text = (homePrice?.floatValue.description)!
            }
            
            let offerImage = dataDict["offerImage"] as? String
            if offerImage != "" {
                let imageUrl = Configurator().imageBaseUrl + offerImage!
                topImageView.sd_setImage(with: URL(string: imageUrl), completed: nil)
            }
            else {
                
                topImageView.image = defaultSaloonImage
            }
            
            let expiryDate = dataDict["expiryDate"] as! Int
            let date = Date(milliseconds: expiryDate)
            let dateFormatter = DateFormatter()
            dateFormatter.timeZone = UaeTimeZone
            dateFormatter.dateFormat = dateFormats.format5
            let day = dateFormatter.string(from: date)
            printToConsole(item: day)
            expireDateTextField.text = day
            
            let activeExpiry  = dataDict["activeExpiryDate"] as! Bool
            expirationSwitchButton.setOn(activeExpiry, animated: false)
            
        }
        else {
            printToConsole(item: viewModel.TotalPrice)
            bhdLabel.isHidden = true
            CommonFunctions.sharedInstance.setNavigationTitleView(titleStr:   localizedTextFor(key: AddSpecialOfferSceneText.AddSpecialOfferSceneAddOfferTitle.rawValue), onVC: self)
            
            if viewModel.offerImage  != nil {
                topImageView.image = viewModel.offerImage
            }
            else {
                topImageView.image = defaultSaloonImage
            }
        }
    }
    // MARK: Picker Fuction
    @objc func dismissPicker() {
        self.view.endEditing(true)
    }
    
    @objc func handleDateTimePicker(sender: UIDatePicker){
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = UaeTimeZone
        dateFormatter.dateFormat = dateFormats.format5
        expireDateTextField.text = dateFormatter.string(from: sender.date)
    }
}

// MARK: UITableViewDelegate
extension SpecialNewOffersViewController : UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return specialOfferArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 15
    }
    
    func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        let footerView = view as! UITableViewHeaderFooterView
        footerView.tintColor = UIColor.clear
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReUseIdentifier, for: indexPath) as! SpecialNewOffersTableViewCell
        
        cell.layer.cornerRadius = 5
        
        let currentObj = specialOfferArray[indexPath.section]
        
        cell.titleLabel.text = currentObj.name
        cell.priceLabel.text = currentObj.salonPrice + " " +  localizedTextFor(key: GeneralText.bhd.rawValue)
        cell.timeLabel.text = currentObj.duration
        
        cell.deleteButton.addTarget(self, action: #selector(self.deleteButtonAction(sender:)), for: .touchUpInside)
        
        return cell
    }
    
}

// MARK: UITextFieldDelegate

extension SpecialNewOffersViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        if textField == expireDateTextField{
            
            expireDateTextField.inputAccessoryView = UIToolbar().ToolbarPiker(mySelect: #selector(SpecialNewOffersViewController.dismissPicker))
            
            let datePickerView = UIDatePicker()
            datePickerView.timeZone = UaeTimeZone
            datePickerView.datePickerMode = .dateAndTime
            datePickerView.minimumDate = Date()
            textField.inputView = datePickerView
            datePickerView.addTarget(self, action: #selector(handleDateTimePicker(sender:)), for: .valueChanged)
            
        }
        return true
        
    }
    
    func textField(_ textField: UITextField,shouldChangeCharactersIn range: NSRange,replacementString string: String) -> Bool
    {
        if textField == setPriceTextField  {
            
            let newString = (textField.text as NSString?)?.replacingCharacters(in: range, with: string)
            
            if newString?.count == 0 {
                bhdLabel.isHidden = true
            } else {
                bhdLabel.isHidden = false
            }
            
            let numberOfDecimalPoints = (textField.text?.components(separatedBy: ".").count)! - 1
            
            let sep = newString?.components(separatedBy: ".")
            if (sep?.count ?? 0) >= 2 {
                if  numberOfDecimalPoints > 1 {
                    textField.deleteBackward()
                }
                let sepStr = "\(sep?[1] ?? "")"
                return !(sepStr.count > 1)
                
            }
            else {
                return true
            }
        }
        else {
            return true
        }
        
    }
}

