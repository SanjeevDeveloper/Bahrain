

import UIKit
import WebKit
import BenefitInAppSDK
protocol PaymentMethodDisplayLogic: class
{
    func displayBookingDate(bookingDate: String)
    func displayResponse(viewModel: PaymentMethod.ViewModel)
    func displayUserBookingResponse()
    func redirectUrl(_ redirectUrl: String)
    func displayVerifyCardResponse(_ response: [String: Any])
    func timeoutSeconds(seconds: TimeInterval)
}

class PaymentMethodViewController: UIViewController, PaymentMethodDisplayLogic, BPInAppButtonDelegate
{
    
    
    
    
    var interactor: PaymentMethodBusinessLogic?
    var router: (NSObjectProtocol & PaymentMethodRoutingLogic & PaymentMethodDataPassing)?
    
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
        let interactor = PaymentMethodInteractor()
        let presenter = PaymentMethodPresenter()
        let router = PaymentMethodRouter()
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
    
    ////////////////////////////////////////////////////////////////////////
    
    
    
    @IBOutlet var benifitInAppButton: BPInAppButton!
    @IBOutlet var stackBenefitButton: UILabel!
    @IBOutlet var stackBenefit: UIStackView!
    @IBOutlet var heightConstraint: NSLayoutConstraint!
    @IBOutlet var viewBenefit: UIView!
    @IBOutlet var lbllineBenefit: UILabel!
    @IBOutlet var imgArrowBenefit: UIImageView!
    
    //DebitCreditCard
    @IBOutlet var stackCreditCard: UIStackView!
    @IBOutlet var heightCreditCardConstraint: NSLayoutConstraint!
    @IBOutlet var viewCreditCard: UIView!
    @IBOutlet var lbllineCreditCard: UILabel!
    @IBOutlet var imgArrowCreditCard: UIImageView!
    
    @IBOutlet weak var paymentTypeLbl: UILabel!
    @IBOutlet weak var fullPayBtn: UIButton!
    @IBOutlet weak var fullPayLbl: UILabel!
    @IBOutlet weak var partialPayBtn: UIButton!
    @IBOutlet weak var partialPayLbl: UILabel!
    @IBOutlet weak var tickImageView: UIImageView!
    @IBOutlet weak var walletStackView: UIStackView!
    @IBOutlet weak var walletAmtTitleLbl: UILabel!
    @IBOutlet weak var walletAmountLbl: UILabel!
    @IBOutlet weak var deductedTitleLbl: UILabel!
    @IBOutlet weak var deductedAmtLbl: UILabel!
    @IBOutlet weak var remainingBalanceTitleLbl: UILabel!
    @IBOutlet weak var remainingBalanceAmtLbl: UILabel!
    @IBOutlet weak var totalAmtLbl: UILabel!
    @IBOutlet weak var totalCashLbl: UILabel!
    @IBOutlet weak var advancePaymentLbl: UILabel!
    @IBOutlet weak var advanceCashLbl: UILabel!
    @IBOutlet weak var paymentAtSalonLbl: UILabel!
    @IBOutlet weak var cashAtSalonLbl: UILabel!
    @IBOutlet weak var paymentMethodLbl: UILabel!
    @IBOutlet weak var benefitBtn: UIButtonCustomClass!
    @IBOutlet weak var mpgsBtn: UIButtonCustomClass!
    @IBOutlet weak var contentView: UIViewCustomClass!
    @IBOutlet weak var topStackView: UIStackView!
    @IBOutlet weak var contentStackView: UIStackView!
    @IBOutlet weak var continueBtn: UIButton!
    @IBOutlet weak var backcolorLabel: UILabel!
    @IBOutlet weak var remainingPayableStackView: UIStackView!
    @IBOutlet weak var remainPayableAmtTitleLbl: UILabel!
    @IBOutlet weak var payableAmountLbl: UILabel!
    @IBOutlet weak var paymentTypeBackgroundLbl: UILabel!
    @IBOutlet weak var webViewContainer: UIView!
    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var lblBenefitPayTitle: UILabel!
    @IBOutlet weak var lblCreditCardTitle: UILabel!
    
    @IBOutlet weak var benefitStackView: UIStackView!
    @IBOutlet weak var mpgsStackView: UIStackView!
    
    var webView: WKWebView!
    var bookingDate = ""
    var paymentMethodViewModel: PaymentMethod.ViewModel!
    var btnTitle = ""
    var isExpandBenefit = true
    var isExpandCreditCard = false
    
    private var timer = Timer()
    
    // MARK: View lifecycle
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
//        heightConstraint.constant = 50
        heightCreditCardConstraint.constant = 50
//        lbllineBenefit.isHidden = true
        lbllineCreditCard.isHidden = true
        stackCreditCard.isHidden = true
        viewCreditCard.layer.borderWidth = 1.0
        viewCreditCard.layer.borderColor = UIColor.lightGray.cgColor
        viewCreditCard.layer.cornerRadius = 10.0
        heightConstraint.constant = 110
        benifitInAppButton.isHidden = false
        stackBenefitButton.isHidden = false
        imgArrowBenefit.isHighlighted = true
        lbllineBenefit.isHidden = false
        if !appDelegateObj.benefitPayDetail.isEmpty {
            if (appDelegateObj.benefitPayDetail["isActive"] as! Bool) {
                stackBenefit.isHidden = false
                viewBenefit.layer.borderWidth = 1.0
                viewBenefit.layer.borderColor = UIColor.lightGray.cgColor
                viewBenefit.layer.cornerRadius = 10.0
            }else{
                isExpandCreditCard = true
                stackBenefit.isHidden = true
            }
        }else{
            isExpandCreditCard = true
            stackBenefit.isHidden = true
        }
        
        
        if isExpandCreditCard {
            heightCreditCardConstraint.constant = 150
            stackCreditCard.isHidden = false
            imgArrowCreditCard.isHighlighted = true
            lbllineCreditCard.isHidden = false
        }
        
        
//        benifitInAppButton.isHidden = true
        paymentTypeBackgroundLbl.backgroundColor = appBarThemeColor
        backcolorLabel.backgroundColor = appBarThemeColor
        continueBtn.backgroundColor = appBarThemeColor
       
        benefitStackView.isHidden = true
        mpgsStackView.isHidden = true
        interactor?.getTimeoutSeconds()
        configureWebView()
        applyLocalizedText()
        hideBackButtonTitle()
        benefitBtn.isSelected = false
        mpgsBtn.isSelected = false
        
        if isCurrentLanguageArabic() {
            remainPayableAmtTitleLbl.textAlignment = .right
            payableAmountLbl.textAlignment = .left
            backButton.contentHorizontalAlignment = .right
            backButton.setImage(UIImage(named: "whiteRightArrow"), for: .normal)
            benefitBtn.contentHorizontalAlignment = .right
            mpgsBtn.contentHorizontalAlignment = .right
            benefitBtn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
            mpgsBtn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
        } else {
            backButton.contentHorizontalAlignment = .left
            payableAmountLbl.textAlignment = .right
            remainPayableAmtTitleLbl.textAlignment = .left
            benefitBtn.contentHorizontalAlignment = .left
            mpgsBtn.contentHorizontalAlignment = .left
            backButton.setImage(UIImage(named: "whiteBackIcon"), for: .normal)
            benefitBtn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
            mpgsBtn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        }
        for view in remainingPayableStackView.subviews {
            view.isHidden = true
        }
        interactor?.getBookingDate()
        interactor?.hitCheckBusinessPaymentTypeApi()
        
        NotificationCenter.default.addObserver(self, selector: #selector(benefitPayCallBackDetail(notification:)), name: Notification.Name("benefitPayCallBack"), object: nil)
//        benifitInAppButton
        
        //self.benifitInAppButton.delegate = self
        
    }
    
    @objc func benefitPayCallBackDetail(notification:Notification) {
        let paymentDetail:BPDLPaymentCallBackItem = notification.object as! BPDLPaymentCallBackItem
        print(paymentDetail)
        print(paymentDetail.status)
        //if paymentDetail.status.rawValue == 1 {
            let advanceAmt = NSString(string: advanceCashLbl.text!)
            let amtPayable = advanceAmt.floatValue
            
            let cashAtSalonAmt = NSString(string: cashAtSalonLbl.text!)
            let remainingAmt = cashAtSalonAmt.floatValue
            
            var payType = ""
            
            if partialPayBtn.isSelected {
                payType = "partial"
            }
            else {
                payType = "full"
            }
            
            var walletPayment: Float = 0.0
            var cardPaidAmount: Float = 0.0
            var isWalletUsed = false
            
            if paymentMethodViewModel.walletAmount.floatValue > 0 {
                isWalletUsed = true
                walletPayment = paymentMethodViewModel.walletAmount.floatValue
                if amtPayable > walletPayment {
                    cardPaidAmount = amtPayable - walletPayment
                } else {
                    cardPaidAmount = walletPayment - amtPayable
                }
            } else {
                isWalletUsed = false
                walletPayment = 0.0
                cardPaidAmount = amtPayable
            }
            let merchantId:String = appDelegateObj.benefitPayDetail["merchantId"] as? String ?? ""
            interactor?.sendBenefitPayDetail(result: "", isPaymentPartial: partialPayBtn.isSelected, isMpgs: mpgsBtn.isSelected, isWalletUsed: isWalletUsed, walletPaidAmount: Double(walletPayment), cardPaidAmount: Double(cardPaidAmount), advanceAmount: Double(amtPayable), remainingAmount: Double(remainingAmt), transactionId: "", paymentDetail: paymentDetail, merchantId: merchantId)
//        }else{
//            CustomAlertController.sharedInstance.showErrorAlert(error: localizedTextFor(key: PaymentMethodSceneText.PaymentMethodSelectPaymentMethodErrorMsg.rawValue))
//        }
        
    }
    
    @IBAction func backBarButtonItem(sender: UIButton) {
         if webViewContainer.isHidden {
                   navigationController?.popViewController(animated: true)
               } else {
                   webViewContainer.isHidden = true
               }
    }
    
    @IBAction func tappedToExpandBenefit(sender: UIControl) {
        if isExpandBenefit {
            isExpandBenefit = false
            benifitInAppButton.isHidden = true
            stackBenefitButton.isHidden = true
            imgArrowBenefit.isHighlighted = false
            lbllineBenefit.isHidden = true
            heightConstraint.constant = 50
        } else {
            isExpandBenefit = true
            benifitInAppButton.isHidden = false
            stackBenefitButton.isHidden = false
            imgArrowBenefit.isHighlighted = true
            lbllineBenefit.isHidden = false
            heightConstraint.constant = 110
        }
    }
    
    @IBAction func tappedToExpandCreditCard(_ sender: UIControl) {
        if isExpandCreditCard {
            isExpandCreditCard = false
            heightCreditCardConstraint.constant = 50
            stackCreditCard.isHidden = true
            imgArrowCreditCard.isHighlighted = false
            lbllineCreditCard.isHidden = true
        } else {
            isExpandCreditCard = true
            heightCreditCardConstraint.constant = 150
            stackCreditCard.isHidden = false
            imgArrowCreditCard.isHighlighted = true
            lbllineCreditCard.isHidden = false
        }
    }
    
    func timeoutSeconds(seconds: TimeInterval) {
//        timer = Timer.scheduledTimer(timeInterval: seconds,
//                                     target: self,
//                                     selector: #selector(self.timeHasExceeded),
//                                     userInfo: nil,
//                                     repeats: false
//        )
    }
    
    @objc private func timeHasExceeded() {
        timer.invalidate()
        CustomAlertController.sharedInstance.showAlertWith(subTitle: localizedTextFor(key: GeneralText.paymentSsnTimedOut.rawValue) , theme: .error) {
            self.router?.routeToSalonDetailVC()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        timer.invalidate()
    }
    
    // MARK:- BPInAppButtonDelegate
    func bpInAppConfiguration() -> BPInAppConfiguration! {
        if !fullPayBtn.isSelected && !partialPayBtn.isSelected {
            CustomAlertController.sharedInstance.showErrorAlert(error: localizedTextFor(key: PaymentMethodSceneText.PaymentMethodSelectPaymenttypeErrorMsg.rawValue))
            return nil
        }
        
        let advanceAmt = NSString(string: advanceCashLbl.text!)
        let amtPayable = advanceAmt.floatValue
        
        let cashAtSalonAmt = NSString(string: cashAtSalonLbl.text!)
        let remainingAmt = cashAtSalonAmt.floatValue
        
        var payType = ""
        
        if partialPayBtn.isSelected {
            payType = "partial"
        }
        else {
            payType = "full"
        }
        
        var walletPayment: Float = 0.0
        var cardPaidAmount: Float = 0.0
        var isWalletUsed = false
        
        if paymentMethodViewModel.walletAmount.floatValue > 0 {
            isWalletUsed = true
            walletPayment = paymentMethodViewModel.walletAmount.floatValue
            if amtPayable > walletPayment {
                cardPaidAmount = amtPayable - walletPayment
            } else {
                cardPaidAmount = walletPayment - amtPayable
            }
        } else {
            isWalletUsed = false
            walletPayment = 0.0
            cardPaidAmount = amtPayable
        }
        
        let appID:String = appDelegateObj.benefitPayDetail["appId"] as? String ?? ""
        let secretKey:String = appDelegateObj.benefitPayDetail["secret"] as? String ?? ""
        let currencyCode:String = appDelegateObj.benefitPayDetail["currency"] as? String ?? ""
        let merchantId:String = appDelegateObj.benefitPayDetail["merchantId"] as? String ?? ""
        let merchantName:String = appDelegateObj.benefitPayDetail["merchantName"] as? String ?? ""
        let merchantCity:String = appDelegateObj.benefitPayDetail["merchantCity"] as? String ?? ""
        let countryCode:String = appDelegateObj.benefitPayDetail["country"] as? String ?? ""
        let merchantCategoryId:String = appDelegateObj.benefitPayDetail["merchantCategoryCode"] as? String ?? ""
        
        let referenceID = randomString(length: 10)
//        referenceID = String(referenceID.dropLast(5))10
        let bpInAppConfiguration:BPInAppConfiguration = BPInAppConfiguration(appId: appID, andSecretKey: secretKey, andAmount: "\(cardPaidAmount)", andCurrencyCode: currencyCode, andMerchantId: merchantId, andMerchantName: merchantName, andMerchantCity: merchantCity, andCountryCode: countryCode, andMerchantCategoryId: merchantCategoryId, andReferenceId: referenceID, andCallBackTag: "bahrainuser")
        
       
       /* let bpInAppConfiguration:BPInAppConfiguration = BPInAppConfiguration(appId: "6646864704", andSecretKey: "gdmxxjdn2wc8yl4v10ldt0mxthmg1746d7zp0srym4m2d", andAmount: "2.000", andCurrencyCode: "048", andMerchantId: "008577502", andMerchantName: "Bahrain Salons Booking", andMerchantCity: "BH", andCountryCode: "BH", andMerchantCategoryId: "7230", andReferenceId: referenceID, andCallBackTag: "bahrainuser")*/
        return bpInAppConfiguration
    }
    
    func randomString(length: Int) -> String {
      let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
      return String((0..<length).map{ _ in letters.randomElement()! })
    }
    
    // MARK: Apply LocalizedText
    func applyLocalizedText() {
        
        let currentLanguage = userDefault.value(forKey: userDefualtKeys.currentLanguage.rawValue) as! String
        
        if currentLanguage == Languages.english {
            advanceCashLbl.textAlignment = .right
            cashAtSalonLbl.textAlignment = .right
            walletAmtTitleLbl.textAlignment = .left
            deductedTitleLbl.textAlignment = .left
            remainingBalanceTitleLbl.textAlignment = .left
            walletAmountLbl.textAlignment = .right
            deductedAmtLbl.textAlignment = .right
            remainingBalanceAmtLbl.textAlignment = .right
        }else {
            advanceCashLbl.textAlignment = .left
            cashAtSalonLbl.textAlignment = .left
            walletAmtTitleLbl.textAlignment = .right
            deductedTitleLbl.textAlignment = .right
            remainingBalanceTitleLbl.textAlignment = .right
            walletAmountLbl.textAlignment = .left
            deductedAmtLbl.textAlignment = .left
            remainingBalanceAmtLbl.textAlignment = .left
        }
        
        
        CommonFunctions.sharedInstance.setNavigationTitleView(titleStr: localizedTextFor(key: PaymentMethodSceneText.PaymentMethodSceneTitle.rawValue), onVC: self)
        paymentMethodLbl.text = localizedTextFor(key: PaymentMethodSceneText.PaymentMethodLabelTitle.rawValue)
        partialPayLbl.text = localizedTextFor(key: PaymentMethodSceneText.PaymentPartialPayLabelTitle.rawValue)
        fullPayLbl.text = localizedTextFor(key: PaymentMethodSceneText.PaymentFullPayLabelTitle.rawValue)
        walletAmtTitleLbl.text = localizedTextFor(key: PaymentMethodSceneText.PaymentMethodWalletAmtLblTitle.rawValue)
        deductedTitleLbl.text = localizedTextFor(key: PaymentMethodSceneText.PaymentMethodDeductedLblTitle.rawValue)
        remainingBalanceTitleLbl.text = localizedTextFor(key: PaymentMethodSceneText.PaymentMethodRemainingBalanceLblTitle.rawValue)
        remainPayableAmtTitleLbl.text = localizedTextFor(key: PaymentMethodSceneText.PaymentMethodRemainPayableTitleLbl.rawValue)
        paymentTypeLbl.text = localizedTextFor(key: PaymentMethodSceneText.PaymentMethodTypeLabelTitle.rawValue)
        totalAmtLbl.text = localizedTextFor(key: PaymentMethodSceneText.PaymentMethodTotalAmtLabelTitle.rawValue)
        advancePaymentLbl.text = localizedTextFor(key: PaymentMethodSceneText.PaymentMethodAdvanceAmtTitle.rawValue)
        paymentAtSalonLbl.text = localizedTextFor(key: PaymentMethodSceneText.PaymentMethodSalonAmtTitle.rawValue)
        
        continueBtn.setTitle(localizedTextFor(key: PaymentMethodSceneText.PaymentMethodContinueBtnTitle.rawValue), for: .normal)
        
        lblBenefitPayTitle.text = localizedTextFor(key: PaymentMethodSceneText.PaymentMethodBenefitTitle.rawValue)
        lblCreditCardTitle.text = localizedTextFor(key: PaymentMethodSceneText.PaymentMethodCreditTitle.rawValue)
        
        benefitBtn.layer.borderColor = UIColor.clear.cgColor
        mpgsBtn.layer.borderColor = UIColor.clear.cgColor
        
    }
    
    func redirectUrl(_ redirectUrl: String) {
        if let validUrlString = redirectUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
            if let url = URL(string: validUrlString) {
                ManageHudder.sharedInstance.startActivityIndicator()
                webView.navigationDelegate = self
                webView.load(URLRequest(url:url))
            }
        }
    }
    
    func displayVerifyCardResponse(_ response: [String: Any]) {
        let message = response["msg"] as? String ?? ""
        CustomAlertController.sharedInstance.showAlertWith(subTitle: message, theme: .success) {
            self.router?.routeToOrderDetail()
        }
    }
    
    func configureWebView() {
        let contentController = WKUserContentController();
        contentController.add(self, name: "myOwnJSHandler")
        
        let config = WKWebViewConfiguration()
        config.userContentController = contentController
        
        webView = WKWebView(frame: webViewContainer.bounds, configuration: config)
        
        webView.translatesAutoresizingMaskIntoConstraints = false
        webViewContainer.addSubview(webView)
        
        webView.leadingAnchor.constraint(equalTo: webViewContainer.leadingAnchor, constant: 0).isActive = true
        webView.trailingAnchor.constraint(equalTo: webViewContainer.trailingAnchor, constant: 0).isActive = true
        webView.topAnchor.constraint(equalTo: webViewContainer.topAnchor, constant: 0).isActive = true
        webView.bottomAnchor.constraint(equalTo: webViewContainer.bottomAnchor, constant: 0).isActive = true
    }
    
    
    // MARK: Button Actions
    
    @IBAction func fullPayBtn(_ sender: Any) {
        fullPayBtn.isSelected = true
        partialPayBtn.isSelected = false
        updateUI()
    }
    
    @IBAction func partialPayBtn(_ sender: Any) {
        partialPayBtn.isSelected = true
        fullPayBtn.isSelected = false
        updateUI()
    }
    
    
    
    @IBAction func benefitBtn(_ sender: UIButton) {
        btnTitle = sender.titleLabel?.text ?? ""
        benefitBtn.isSelected = true
        benefitBtn.backgroundColor = appBarThemeColor
        benefitBtn.layer.borderColor = UIColor.clear.cgColor
        mpgsBtn.layer.borderColor = UIColor.clear.cgColor
        mpgsBtn.isSelected = false
        mpgsBtn.backgroundColor = UIColor(red: 243.0/256, green: 243.0/256, blue: 243.0/256, alpha: 1.0)
        
        
        
    }
    
    @IBAction func mpgsBtn(_ sender: UIButton) {
        btnTitle = sender.titleLabel?.text ?? ""
        benefitBtn.isSelected = false
        benefitBtn.backgroundColor = UIColor(red: 243.0/256, green: 243.0/256, blue: 243.0/256, alpha: 1.0)
        benefitBtn.layer.borderColor = UIColor.clear.cgColor
        mpgsBtn.layer.borderColor = UIColor.clear.cgColor
        mpgsBtn.isSelected = true
        mpgsBtn.backgroundColor = appBarThemeColor
    }
    
    func showAlert(request: PaymentMethod.Request) {
        let alertController = PMAlertController(textForegroundColor:UIColor.darkGray, viewBackgroundColor: UIColor.white, title: "" , description: localizedTextFor(key: GeneralText.paymentMsg.rawValue) + self.bookingDate, image: nil , style: .alert)
        
        let doneButton = PMAlertAction(title: localizedTextFor(key: GeneralText.doneButton.rawValue).uppercased(), style: .default, action: {
            self.timer.invalidate()
            self.interactor?.hitVerifyCardApi(request: request)
        })
        
        let cancelButton = PMAlertAction(title: localizedTextFor(key: GeneralText.cancel.rawValue).uppercased(), style: .default, action: {
            alertController.dismiss(animated: true, completion: nil)
        })
        
        alertController.addAction(cancelButton)
        alertController.addAction(doneButton)
        
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func continueBtn(_ sender: Any) {
        let advanceAmt = NSString(string: advanceCashLbl.text!)
        let amtPayable = advanceAmt.floatValue
        
        let cashAtSalonAmt = NSString(string: cashAtSalonLbl.text!)
        let remainingAmt = cashAtSalonAmt.floatValue
        
        var payType = ""
        
        if partialPayBtn.isSelected {
            payType = "partial"
        }
        else {
            payType = "full"
        }
        
        var walletPayment: Float = 0.0
        var cardPaidAmount: Float = 0.0
        var isWalletUsed = false
        
        if paymentMethodViewModel.walletAmount.floatValue > 0 {
            isWalletUsed = true
            walletPayment = paymentMethodViewModel.walletAmount.floatValue
            if amtPayable > walletPayment {
                cardPaidAmount = amtPayable - walletPayment
            } else {
                cardPaidAmount = walletPayment - amtPayable
            }
        } else {
            isWalletUsed = false
            walletPayment = 0.0
            cardPaidAmount = amtPayable
        }
        
        if continueBtn.isSelected{
            let req = PaymentMethod.Request(
                paymentType: payType,
                isWalletUsed:true ,
                paidAmount: amtPayable,
                remainingAmount: remainingAmt,
                walletPaidAmount: amtPayable,
                cardPaidAmount: 0.0
            )
            showAlert(request: req)
        }
        else {
            
            if !fullPayBtn.isSelected && !partialPayBtn.isSelected {
                CustomAlertController.sharedInstance.showErrorAlert(error: localizedTextFor(key: PaymentMethodSceneText.PaymentMethodSelectPaymenttypeErrorMsg.rawValue))
            } else if  !benefitBtn.isSelected && !mpgsBtn.isSelected {
                CustomAlertController.sharedInstance.showErrorAlert(error: localizedTextFor(key: PaymentMethodSceneText.PaymentMethodSelectPaymentMethodErrorMsg.rawValue))
                benefitBtn.layer.borderColor = appBarThemeColor.cgColor
                mpgsBtn.layer.borderColor = appBarThemeColor.cgColor
            } else {
                timer.invalidate()
                // Api
                interactor?.openGatewayUrl(result: "", isPaymentPartial: partialPayBtn.isSelected, isMpgs: mpgsBtn.isSelected, isWalletUsed: isWalletUsed, walletPaidAmount: Double(walletPayment), cardPaidAmount: Double(cardPaidAmount), advanceAmount: Double(amtPayable), remainingAmount: Double(remainingAmt), transactionId: "")
            }
        }
    }
    
    func displayBookingDate(bookingDate: String) {
        self.bookingDate = bookingDate
    }
    
    func displayResponse(viewModel: PaymentMethod.ViewModel)
    {
        printToConsole(item: viewModel.paymenttype)
        paymentMethodViewModel = viewModel
        
        
        
        for btnText in viewModel.paymentMethods {
            print(btnText.cardType)
            if btnText.cardType == "credit card" {
                if viewModel.paymentMethods.count == 1 {
                    benefitStackView.isHidden = true
                    mpgsStackView.isHidden = false
                } else {
                    benefitStackView.isHidden = false
                }
                
                mpgsBtn.setTitle(btnText.cardName.capitalized, for: .normal)
            } else if btnText.cardType == "debit card"{
                
                if viewModel.paymentMethods.count == 1 {
                    mpgsStackView.isHidden = true
                    benefitStackView.isHidden = false
                } else {
                    mpgsStackView.isHidden = false
                }
                
                benefitBtn.setTitle(btnText.cardName.capitalized, for: .normal)
            }
        }
        
        
        walletAmountLbl.text = String(format: "%.3f",viewModel.walletAmount.floatValue) + " " + localizedTextFor(key: GeneralText.bhd.rawValue)
        
        
        if viewModel.walletAmount.floatValue > 0 {
            walletStackView.subviews[0].isHidden = false
            walletStackView.subviews[1].isHidden = true
            walletStackView.subviews[2].isHidden = true
            tickImageView.isHidden = false
        }
        else {
            for view in walletStackView.subviews {
                view.isHidden = true
            }
            tickImageView.isHidden = true
        }
        
        
        if viewModel.paymenttype == "partial"{
            
            fullPayBtn.isSelected = false
            partialPayBtn.isSelected = false
            
            for view in topStackView.subviews {
                view.isHidden = false
            }
            
            for view in contentStackView.subviews {
                view.isHidden = true
            }
            contentView.isHidden = true
        }
        else {
            fullPayBtn.isSelected = true
            partialPayBtn.isSelected = false
            topStackView.subviews[1].isHidden = true
            topStackView.subviews[2].isHidden = true
            updateUI()
        }
    }
    
    func displayUserBookingResponse() {
        router?.routeToOrderDetail()
    }
    
    
    func updateUI() {
        
        var remainingAmt = paymentMethodViewModel.totalAmount.floatValue
        var amtToBePaid: Float = 0.0
        
        if partialPayBtn.isSelected{
            advanceCashLbl.text = String(format: "%.3f",paymentMethodViewModel.partialAmountToBePaid.floatValue) + " " + localizedTextFor(key: GeneralText.bhd.rawValue)
            remainingAmt = remainingAmt - paymentMethodViewModel.partialAmountToBePaid.floatValue
            amtToBePaid = paymentMethodViewModel.partialAmountToBePaid.floatValue
        }
        else {
            advanceCashLbl.text = String(format: "%.3f",paymentMethodViewModel.fullAmountToBePaid.floatValue) + " " + localizedTextFor(key: GeneralText.bhd.rawValue)
            amtToBePaid = paymentMethodViewModel.fullAmountToBePaid.floatValue
            remainingAmt = remainingAmt - paymentMethodViewModel.fullAmountToBePaid.floatValue
        }
        
        
        let walletCash = paymentMethodViewModel.walletAmount.floatValue
        
        if amtToBePaid <= walletCash{
            deductedAmtLbl.text = "- " + String(format: "%.3f",amtToBePaid) + " " + localizedTextFor(key: GeneralText.bhd.rawValue)
            let remainedDeductAmt = walletCash - amtToBePaid
            remainingBalanceAmtLbl.text = String(format: "%.3f",remainedDeductAmt) + " " + localizedTextFor(key: GeneralText.bhd.rawValue)
            
            if paymentMethodViewModel.walletAmount.floatValue > 0 {
                walletStackView.subviews[1].isHidden = false
                walletStackView.subviews[2].isHidden = false
                viewCreditCard.isHidden = false
                viewBenefit.isHidden = false
            }
            
            for view in remainingPayableStackView.subviews {
                view.isHidden = true
            }
            
            continueBtn.isSelected = true
            
            let payText = localizedTextFor(key: PaymentMethodSceneText.PaymentMethodContinueBtnPayTitle.rawValue) + "(" + String(format: "%.3f",amtToBePaid) + " " + localizedTextFor(key: GeneralText.bhd.rawValue) + ")"
            continueBtn.setTitle(payText, for: .selected)
            benefitStackView.isHidden = true
            mpgsStackView.isHidden = true
            viewBenefit.isHidden = true
            backcolorLabel.isHidden = true
            paymentMethodLbl.isHidden = true
            viewCreditCard.isHidden = true
        }
        else {
            deductedAmtLbl.text = "- " + String(format: "%.3f",walletCash) + " " + localizedTextFor(key: GeneralText.bhd.rawValue)
            let remainedDeductAmt = walletCash - walletCash
            remainingBalanceAmtLbl.text = String(format: "%.3f",remainedDeductAmt) + " " + localizedTextFor(key: GeneralText.bhd.rawValue)
            if paymentMethodViewModel.walletAmount.floatValue > 0 {
                walletStackView.subviews[1].isHidden = false
                walletStackView.subviews[2].isHidden = false
                viewCreditCard.isHidden = false
                viewBenefit.isHidden = false
                //                if amtToBePaid > walletCash {
                let cardPaidAmount = amtToBePaid - walletCash
                payableAmountLbl.text = String(format: "%.3f",cardPaidAmount) + " " + localizedTextFor(key: GeneralText.bhd.rawValue)
                //                }
                
                for view in remainingPayableStackView.subviews {
                    view.isHidden = false
                }
                
            }
            
            continueBtn.isSelected = false
            continueBtn.setTitle(localizedTextFor(key: PaymentMethodSceneText.PaymentMethodContinueBtnTitle.rawValue), for: .normal)
            benefitStackView.isHidden = false
            mpgsStackView.isHidden = false
            viewBenefit.isHidden = false
            viewCreditCard.isHidden = false
            backcolorLabel.isHidden = false
            paymentMethodLbl.isHidden = false
        }
        
        
        totalCashLbl.text = String(format: "%.3f",paymentMethodViewModel.totalAmount) + " " + localizedTextFor(key: GeneralText.bhd.rawValue)
        cashAtSalonLbl.text = String(format: "%.3f",remainingAmt) + " " + localizedTextFor(key: GeneralText.bhd.rawValue)
        for view in contentStackView.subviews {
            view.isHidden = false
            contentStackView.subviews[0].isHidden = true
            contentStackView.subviews[1].isHidden = true
            viewCreditCard.isHidden = true
            viewBenefit.isHidden = true
        }
        
        contentView.isHidden = false
        
        
        if amtToBePaid > walletCash{
            if paymentMethodViewModel.paymentMethods.count > 0 {
                for btnText in paymentMethodViewModel.paymentMethods {
                    print(btnText.cardType)
                    if btnText.cardType == "credit card" {
                        if paymentMethodViewModel.paymentMethods.count == 1 {
                            benefitStackView.isHidden = true
                            mpgsStackView.isHidden = false
                        } else {
                            benefitStackView.isHidden = false
                        }
                        
                        mpgsBtn.setTitle(btnText.cardName.capitalized, for: .normal)
                    } else if btnText.cardType == "debit card"{
                        
                        if paymentMethodViewModel.paymentMethods.count == 1 {
                            mpgsStackView.isHidden = true
                            benefitStackView.isHidden = false
                        } else {
                            mpgsStackView.isHidden = false
                        }
                        
                        benefitBtn.setTitle(btnText.cardName.capitalized, for: .normal)
                    }
                }
                viewCreditCard.isHidden = false
                viewBenefit.isHidden = false
            } else {
                benefitStackView.isHidden = true
                mpgsStackView.isHidden = true
                viewCreditCard.isHidden = true
                viewBenefit.isHidden = true
            }
        }
    }
}

extension PaymentMethodViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        ManageHudder.sharedInstance.stopActivityIndicator()
        webViewContainer.isHidden = false
    }
}

extension PaymentMethodViewController: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        print(message.name)
        print(message.body)
        webViewContainer.isHidden = true
        webView.navigationDelegate = nil
        webView.stopLoading()

        if let json = message.body as? [String: Any] {
            let code = json["code"] as? NSNumber ?? 0
            if code == 200 {
                let resultObj = json["results"] as? [String: Any] ?? [:]
                let msg = resultObj["msg"] as? String ?? ""
                CustomAlertController.sharedInstance.showAlertWith(subTitle: msg, theme: .success) {
                    self.router?.routeToOrderDetail()
                }
            } else if code == 404 {
                CommonFunctions.sharedInstance.showSessionExpireAlert()
            } else if code == 425 {
                let error = json["errors"] as? String ?? ""
                CustomAlertController.sharedInstance.showAlertWith(subTitle: error , theme: .error) {
                    self.router?.routeToSalonDetailVC()
                }
            } else {
                let error = json["errors"] as? String ?? ""
                CustomAlertController.sharedInstance.showAlertWith(subTitle: error , theme: .error)
            }
        }
    }
}


