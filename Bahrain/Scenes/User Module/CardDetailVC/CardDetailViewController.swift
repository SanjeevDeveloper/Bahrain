
import UIKit

protocol CardDetailDisplayLogic: class
{
    func displayVerifyCardResponse()
    func displayData(paymentMethodName:String,amount:Double)
}

class CardDetailViewController: UIViewController, CardDetailDisplayLogic
{
    
    
    var interactor: CardDetailBusinessLogic?
    var router: (NSObjectProtocol & CardDetailRoutingLogic & CardDetailDataPassing)?
    
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
        let interactor = CardDetailInteractor()
        let presenter = CardDetailPresenter()
        let router = CardDetailRouter()
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
    
    /////////////////////////////////////////////////////////////////////
    
    
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var subcontentView: UIView!
    @IBOutlet weak var methodNameLbl: UILabel!
    @IBOutlet weak var cardDetailLbl: UILabel!
    @IBOutlet weak var expiryLabel: UILabel!
    @IBOutlet weak var cardNumberTxtF: TKFormTextField!
    @IBOutlet weak var monthTxtF: TKFormTextField!
    @IBOutlet weak var yearTxtF: TKFormTextField!
    @IBOutlet weak var cvvTxtF: TKFormTextField!
    @IBOutlet weak var payBtn: UIButtonCustomClass!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var infoStackView: UIStackView!
    @IBOutlet weak var firstInfoLbl: UILabel!
    @IBOutlet weak var secondInfoLbl: UILabel!
 
    
    let picker = UIPickerView()
    var monthArr = ["01","02","03","04", "05", "06","07","08","09","10","11","12"]
    var yearArr = [String]()
    
    
    // MARK: View lifecycle
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        intialFunction()
        scrollView.manageKeyboard()
    }
    

    // MARK: Intial Function
    func intialFunction()  {
        subcontentView.layer.cornerRadius = 8
        applyLocalizedText()
        
        for view in infoStackView.subviews {
            view.isHidden = true
        }
        
        var currentYear = getCalendar().component(.year, from: Date())
        yearArr.append(currentYear.description)
        for _ in 0...18 {
            currentYear += 1
            yearArr.append(currentYear.description)
        }
        
        interactor?.getData()
    }

    
    // MARK: Apply LocalizedText
    func applyLocalizedText() {
        CommonFunctions.sharedInstance.setNavigationTitleView(titleStr: localizedTextFor(key: CardDetailSceneText.CardDetailSceneTitle.rawValue), onVC: self)
        methodNameLbl.text = localizedTextFor(key: CardDetailSceneText.CardDetailMethodNameLbl.rawValue)
        cardDetailLbl.text = localizedTextFor(key: CardDetailSceneText.CardDetailEnterDetailLbl.rawValue)
        cardNumberTxtF.placeholder = localizedTextFor(key: CardDetailSceneText.CardDetailCardNumberTxtFldPlaceholder.rawValue)
        monthTxtF.placeholder = localizedTextFor(key: CardDetailSceneText.CardDetailMonthTxtFldPlaceholder.rawValue)
        yearTxtF.placeholder = localizedTextFor(key: CardDetailSceneText.CardDetailYearTxtFldPlaceholder.rawValue)
        cvvTxtF.placeholder = localizedTextFor(key: CardDetailSceneText.CardDetailCvvTxtFldPlaceholder.rawValue)
        expiryLabel.text = localizedTextFor(key: CardDetailSceneText.CardDetailExpiryLbl.rawValue)
        payBtn.setTitle(localizedTextFor(key: CardDetailSceneText.CardDetailPaymentBtnTitle.rawValue), for: .normal)
        
        firstInfoLbl.text = localizedTextFor(key: CardDetailSceneText.CardDetailFirstInfoText.rawValue)
        secondInfoLbl.text = localizedTextFor(key: CardDetailSceneText.CardDetailSecondInfoText.rawValue)

        
        let imageView = UIImageView(image: UIImage(named: "paymentArrow"))
        imageView.frame.size.width += 15
        imageView.contentMode = .right
        monthTxtF.rightViewMode = .always
        monthTxtF.rightView = imageView
        
        let imageV = UIImageView(image: UIImage(named: "paymentArrow"))
        imageV.frame.size.width += 15
        imageV.contentMode = .right
        yearTxtF.rightViewMode = .always
        yearTxtF.rightView = imageV
        
        let imageMark = UIImageView(image: UIImage(named: "questionMark"))
        imageMark.frame.size.width += 15
        imageMark.contentMode = .right
        cvvTxtF.rightViewMode = .always
        cvvTxtF.rightView = imageMark
        
        addAttributedString(info: localizedTextFor(key: CardDetailSceneText.CardDetailMoreInfoText.rawValue))
    }
    
    
    func addAttributedString(info:String) {
        
        let mutuableString = NSMutableAttributedString(string: localizedTextFor(key: CardDetailSceneText.CardDetailInfoLbl.rawValue))
        mutuableString.append(NSAttributedString(string: info, attributes: [NSAttributedStringKey.font:UIFont.systemFont(ofSize: 16, weight: .bold),NSAttributedStringKey.foregroundColor:appBarThemeColor,NSAttributedStringKey.underlineStyle:1]))
        
        infoLabel.attributedText = mutuableString
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(CardDetailViewController.tapLabel))
        infoLabel.addGestureRecognizer(tap)
  
    }
    
     // MARK: Button Actions
    
    @IBAction func payBtn(_ sender: Any) {
        
        let request = CardDetail.Request(cardNumber: cardNumberTxtF.text_Trimmed(), expiryMonth: monthTxtF.text_Trimmed(), expiryYear: yearTxtF.text_Trimmed(), cvv: cvvTxtF.text_Trimmed())
        
        interactor?.hitVerifyCardApi(request: request)
        
    }
    
    
    @IBAction func tapLabel(gesture: UITapGestureRecognizer) {
        let text = (infoLabel.text)!
        let moreInfoRange = (text as NSString).range(of: localizedTextFor(key: CardDetailSceneText.CardDetailMoreInfoText.rawValue))
        let lessInforange = (text as NSString).range(of: localizedTextFor(key: CardDetailSceneText.CardDetailLessInfoText.rawValue))
        
    
        if gesture.didTapAttributedTextInLabel(label: infoLabel, inRange: moreInfoRange) {
            print("Tapped info")
            for view in infoStackView.subviews {
                    view.isHidden = false
                    addAttributedString(info: localizedTextFor(key: CardDetailSceneText.CardDetailLessInfoText.rawValue))
            }
        } else if gesture.didTapAttributedTextInLabel(label: infoLabel, inRange: lessInforange) {
            for view in infoStackView.subviews {
                view.isHidden = true
                addAttributedString(info: localizedTextFor(key: CardDetailSceneText.CardDetailMoreInfoText.rawValue))
            }
        }
        else {
            print("Tapped none")
        }
    }
    
    
    
    func displayVerifyCardResponse()
    {
        CustomAlertController.sharedInstance.showAlert(subTitle: localizedTextFor(key: FilterSceneText.FilterSceneBookingConfirmed.rawValue), type: .success)
        router?.routeToHomeVC()
        
    }
    
    func displayData(paymentMethodName:String,amount:Double) {
        
     methodNameLbl.text = localizedTextFor(key: CardDetailSceneText.CardDetailMethodNameLbl.rawValue) + "- " + paymentMethodName
      
        
      let payText = localizedTextFor(key: CardDetailSceneText.CardDetailPaymentBtnTitle.rawValue) + " (" + String(format: "%.3f",amount) + localizedTextFor(key: GeneralText.bhd.rawValue) + ")"
        payBtn.setTitle(payText, for: .normal)
        
    }
    
    @objc func dismissPicker() {
      self.view.endEditing(true)
    }
    
}

extension CardDetailViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool  {
        
        if textField == monthTxtF {
            textField.inputAccessoryView = UIToolbar().toolbarPikerWithTitle(mySelect: #selector(CardDetailViewController.dismissPicker), title: "        " + localizedTextFor(key: GeneralText.expiaryMonth.rawValue))
            picker.dataSource = self
            picker.delegate = self
            picker.tag = 100
            monthTxtF.inputView = picker
        }
        else if textField == yearTxtF {
            textField.inputAccessoryView = UIToolbar().toolbarPikerWithTitle(mySelect: #selector(CardDetailViewController.dismissPicker), title: "          " + localizedTextFor(key: GeneralText.expiaryYear.rawValue))
            picker.dataSource = self
            picker.delegate = self
            picker.tag = 200
            yearTxtF.inputView = picker
        }
        
        return true
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == cardNumberTxtF {
            guard let text = textField.text else { return true }
            let newLength = text.count + string.count - range.length
            return newLength <= 20
        }
       else if textField == cvvTxtF {
            guard let text = textField.text else { return true }
            let newLength = text.count + string.count - range.length
            return newLength <= 4
        }
        else {
            return true
        }
        
    }
}

//MARK:- UIPickerViewDelegate
extension CardDetailViewController : UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if picker.tag == 100{
            return monthArr.count
        }
        else if picker.tag == 200{
            return yearArr.count
        }
        else {
            return 0
        }
        
    }
    
     
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if picker.tag == 100{
            return monthArr[row]
        }
        else if picker.tag == 200{
            return yearArr[row]
        }
        else {
            return ""
        }
        
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        if pickerView.tag == 100{
            let obj = monthArr[row]
            monthTxtF.text = obj
        }
        else if picker.tag == 200{
            let obj = yearArr[row]
             yearTxtF.text = obj
        }
        
        return
    }
}

extension UITapGestureRecognizer {
    
    func didTapAttributedTextInLabel(label: UILabel, inRange targetRange: NSRange) -> Bool {
        // Create instances of NSLayoutManager, NSTextContainer and NSTextStorage
        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: CGSize.zero)
        let textStorage = NSTextStorage(attributedString: label.attributedText!)
        
        // Configure layoutManager and textStorage
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)
        
        // Configure textContainer
        textContainer.lineFragmentPadding = 0.0
        textContainer.lineBreakMode = label.lineBreakMode
        textContainer.maximumNumberOfLines = label.numberOfLines
        let labelSize = label.bounds.size
        textContainer.size = labelSize
        
        // Find the tapped character location and compare it to the specified range
        let locationOfTouchInLabel = self.location(in: label)
        let textBoundingBox = layoutManager.usedRect(for: textContainer)
        let textContainerOffset = CGPoint(x: (labelSize.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x, y: (labelSize.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y)

        let locationOfTouchInTextContainer = CGPoint(x: locationOfTouchInLabel.x - textContainerOffset.x, y: locationOfTouchInLabel.y - textContainerOffset.y)
        
        let indexOfCharacter = layoutManager.characterIndex(for: locationOfTouchInTextContainer, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        
        return NSLocationInRange(indexOfCharacter, targetRange)
    }
    
}



