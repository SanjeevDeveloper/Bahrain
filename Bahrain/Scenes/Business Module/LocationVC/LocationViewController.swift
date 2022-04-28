
import UIKit
import MobileCoreServices

protocol LocationDisplayLogic: class
{
    func displaySelectedAreaText(ResponseMsg: String?)
    func gotBusinessInfo(viewModel:Location.ViewModel)
    func locationUpdated()
}

class LocationViewController: UIViewController, LocationDisplayLogic
{
    var interactor: LocationBusinessLogic?
    var router: (NSObjectProtocol & LocationRoutingLogic & LocationDataPassing)?
    
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
        let interactor = LocationInteractor()
        let presenter = LocationPresenter()
        let router = LocationRouter()
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
    
    @IBOutlet weak var selectAreaTextField:UITextField!
    @IBOutlet weak var txtfBlock: UITextFieldCustomClass!
    @IBOutlet weak var address2TextField:UITextField!
    @IBOutlet weak var buildingFloorTextField:UITextField!
    @IBOutlet weak var specialLocationTextField:UITextField!
    @IBOutlet weak var continueButton:UIButton!
    @IBOutlet weak var txtfCrNumber: UITextFieldCustomClass!
    @IBOutlet weak var imgCr: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var btnUploadCr: UIButton!
    
    var delegate:movePageController!
    var isImageCr = Bool()
    var documentUrl: URL?
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialFunction()
        applyLocalizedText()
        applyFontAndColor()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if appDelegateObj.isPageControlActive {
            
            if appDelegateObj.selectedArea != nil {
                  selectAreaTextField.text = appDelegateObj.selectedArea
            }
            if appDelegateObj.selectBlock != nil {
                 txtfBlock.text = appDelegateObj.selectBlock
            }
           
        }
        else {
            if let blockData = router?.dataStore?.selectedBlock {
                txtfBlock.text = blockData
            }
            //interactor?.showSelectedArea()
        }
    }
    
    // MARK: Apply Font And Color
    func applyFontAndColor() {
        selectAreaTextField.backgroundColor = apptxtfBackGroundColor
        txtfBlock.backgroundColor = apptxtfBackGroundColor
        address2TextField.backgroundColor = apptxtfBackGroundColor
        buildingFloorTextField.backgroundColor = apptxtfBackGroundColor
        specialLocationTextField.backgroundColor = apptxtfBackGroundColor
        txtfCrNumber.backgroundColor = apptxtfBackGroundColor
        continueButton.backgroundColor = appBarThemeColor
        selectAreaTextField.textColor = appTxtfDarkColor
        address2TextField.textColor = appTxtfDarkColor
        txtfBlock.textColor = appTxtfDarkColor
        txtfCrNumber.textColor = appTxtfDarkColor
        buildingFloorTextField.textColor = appTxtfDarkColor
        continueButton.setTitleColor(appBtnWhiteColor, for: .normal)
    }
    
    // MARK: Apply LocalizedText
    func applyLocalizedText() {
        CommonFunctions.sharedInstance.setNavigationTitleView(titleStr:   localizedTextFor(key: LocationSceneText.locationSceneTitle.rawValue), onVC: self)
        
        let colorAttribute = [NSAttributedStringKey.foregroundColor: UIColor.darkGray]
        let selectAreaTextFieldPlaceholder = NSMutableAttributedString(string: localizedTextFor(key: LocationSceneText.locationSceneAreaTextFieldPlaceholder.rawValue), attributes: colorAttribute)
        selectAreaTextFieldPlaceholder.append(asterik)
        selectAreaTextField.attributedPlaceholder = selectAreaTextFieldPlaceholder
        
        let blockTextFieldPlaceholder = NSMutableAttributedString(string: localizedTextFor(key: LocationSceneText.selectBlock.rawValue), attributes: colorAttribute)
        blockTextFieldPlaceholder.append(asterik)
        txtfBlock.attributedPlaceholder = blockTextFieldPlaceholder
        
        
        let address2TextFieldPlaceholder = NSMutableAttributedString(string: localizedTextFor(key: LocationSceneText.locationSceneAddress2TextFieldPlaceholder.rawValue), attributes: colorAttribute)
        address2TextFieldPlaceholder.append(asterik)
        address2TextField.attributedPlaceholder = address2TextFieldPlaceholder
        
    
        let buildingFloorTextFieldPlaceholder = NSAttributedString(string: localizedTextFor(key: LocationSceneText.locationSceneBuildingTextFieldPlaceholder.rawValue), attributes: colorAttribute)
        buildingFloorTextField.attributedPlaceholder = buildingFloorTextFieldPlaceholder
        
        
        let specialLocationTextFieldPlaceholder = NSAttributedString(string: localizedTextFor(key: LocationSceneText.locationSceneSpecialTextFieldPlaceholder.rawValue), attributes: colorAttribute)
        specialLocationTextField.attributedPlaceholder = specialLocationTextFieldPlaceholder
        
        let txtfCrNumberPlaceholder = NSAttributedString(string: localizedTextFor(key: LocationSceneText.crNumber.rawValue), attributes: colorAttribute)
        txtfCrNumber.attributedPlaceholder = txtfCrNumberPlaceholder
        
        continueButton.setTitle(localizedTextFor(key: LocationSceneText.locationSceneContinueButton.rawValue), for: .normal)
        btnUploadCr.setTitle(localizedTextFor(key: LocationSceneText.uploadCr.rawValue), for: .normal)
    }
    
    // MARK: Button Actions
    
    @IBAction func doneButtonAction(_ sender:AnyObject) {
        let selectArea = selectAreaTextField.text_Trimmed()
        let address1 = "dsfdsf"
        let address2 = address2TextField.text_Trimmed()
        let avenue = ""
        let buildingFloor = buildingFloorTextField.text_Trimmed()
        let specialLocation = specialLocationTextField.text_Trimmed()
        let crNumber = txtfCrNumber.text_Trimmed()
        
        let request = Location.Request(area: selectArea, block: txtfBlock.text_Trimmed(), address1Block: address1, address1Street: address2, avenue: avenue, buildingFloor: buildingFloor, specialLocation: specialLocation, crNumber: crNumber, crImage: imgCr.image ?? nil, crDocument: documentUrl ?? nil)
        interactor?.updateLocation(request:request)
    }
    
    // MARK: Display Response
    
    func displaySelectedAreaText(ResponseMsg: String?) {
        if ResponseMsg != nil {
            selectAreaTextField.text = ResponseMsg
        }
    }
    
    // MARK: Other Function
    
    func initialFunction() {
        scrollView.manageKeyboard()
//        if !appDelegateObj.isPageControlActive {
            interactor?.getBusinessInfo()
//        }
    }
    
    func locationUpdated() {
         CustomAlertController.sharedInstance.showAlert(subTitle: localizedTextFor(key: GeneralText.locationFetched.rawValue), type: .success)
        if appDelegateObj.isPageControlActive {
            delegate.moveToNextPage()
        }
        else {
            router?.routeToAreaPinPoint()
        }
    }
    
    func gotBusinessInfo(viewModel:Location.ViewModel) {
        txtfBlock.text = viewModel.address1Block
        selectAreaTextField.text = viewModel.area
        address2TextField.text = viewModel.address1Street
        buildingFloorTextField.text = viewModel.buildingFloor
        specialLocationTextField.text = viewModel.specialLocation
        txtfCrNumber.text = viewModel.crNumberText
        
        if let docUrl = URL(string:Configurator().imageBaseUrl + viewModel.crDocument) {
            imgCr.sd_setImage(with: docUrl, placeholderImage: #imageLiteral(resourceName: "PlaceHolderIcon"), options: .retryFailed, completed: nil)
        }
    }

    @IBAction func btnUploadCrAction(_ sender: Any) {
        let alert = UIAlertController(title: localizedTextFor(key: LocationSceneText.crNumber.rawValue), message: localizedTextFor(key: LocationSceneText.pleaseSelect.rawValue), preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: localizedTextFor(key: GeneralText.image.rawValue), style: .default , handler:{ (UIAlertAction)in
            self.pickImage(sender)
        }))
        
        alert.addAction(UIAlertAction(title: localizedTextFor(key: GeneralText.document.rawValue), style: .default , handler:{ (UIAlertAction)in
            self.pickDocument(sender)
        }))
        
        alert.addAction(UIAlertAction(title: localizedTextFor(key: GeneralText.cancel.rawValue), style: .cancel, handler:{ (UIAlertAction)in
        }))
        
        
        
        if let popoverPresentationController = alert.popoverPresentationController {
            popoverPresentationController.sourceView = btnUploadCr
            popoverPresentationController.sourceRect = btnUploadCr.bounds
        }
        
        
        self.present(alert, animated: true, completion: {
            print("completion block")
        })
    }
    
    func pickImage(_ sender: Any) {
        isImageCr = true
        let customPicker = CustomImagePicker()
        customPicker.delegate = self
        customPicker.openImagePicker(controller: self, source: (sender as! UIButton))
    }
    
    func pickDocument(_ sender: Any) {
        isImageCr = false
        let importMenu = UIDocumentPickerViewController(documentTypes: [String(kUTTypePDF)], in: .import)
        importMenu.delegate = self
        importMenu.modalPresentationStyle = .popover
        if let popoverPresentationController = importMenu.popoverPresentationController {
            popoverPresentationController.sourceView = btnUploadCr
            popoverPresentationController.sourceRect = btnUploadCr.bounds
        }
        self.present(importMenu, animated: true, completion: nil)
    }
}

// MARK: UITextFieldDelegate

extension LocationViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == selectAreaTextField {
            performSegue(withIdentifier: RegisterLocationPaths.Identifiers.SelectArea, sender: nil)
            return false
        } else if textField == txtfBlock {
            performSegue(withIdentifier: RegisterLocationPaths.Identifiers.selectBlock, sender: nil)
            return true
        } else {
            return true
        }
    }
}

extension LocationViewController: UIDocumentMenuDelegate, UIDocumentPickerDelegate, UINavigationControllerDelegate {
    func documentMenu(_ documentMenu: UIDocumentMenuViewController, didPickDocumentPicker documentPicker: UIDocumentPickerViewController) {
        documentPicker.delegate = self
        self.present(documentPicker, animated: true, completion: nil)
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
        imgCr.image = #imageLiteral(resourceName: "map")
        documentUrl = url
    }
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        printToConsole(item: "view was cancelled")
    }
}

extension LocationViewController: CustomImagePickerProtocol{
    func didFinishPickingImage(image:UIImage) {
            imgCr.image = image
    }
    
    func didCancelPickingImage() {
        
    }
}
