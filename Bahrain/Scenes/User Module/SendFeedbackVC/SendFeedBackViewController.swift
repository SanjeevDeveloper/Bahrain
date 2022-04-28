
import UIKit

protocol SendFeedBackDisplayLogic: class
{
  func displaySendFeedBackResponse(viewModel: SendFeedBack.ViewModel)
}

class SendFeedBackViewController: BaseViewControllerUser, SendFeedBackDisplayLogic
{
  var interactor: SendFeedBackBusinessLogic?
  var router: (NSObjectProtocol & SendFeedBackRoutingLogic & SendFeedBackDataPassing)?

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
    let interactor = SendFeedBackInteractor()
    let presenter = SendFeedBackPresenter()
    let router = SendFeedBackRouter()
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
  
 //////////////////////////////////////////////////////////////////////////////////////
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var feedBackTextView: UITextViewFontSize!
    @IBOutlet weak var sendButton: UIButtonFontSize!
    
  // MARK: View lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    initialFunction()
    applyLocalizedText()
    applyFontAndColor()
  }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }
    
    // MARK: Apply Font And Color
    func applyFontAndColor() {
        sendButton.backgroundColor = appBarThemeColor
        feedBackTextView.tintColor = appBarThemeColor
        feedBackTextView.layer.borderWidth = 1
        feedBackTextView.layer.borderColor = appBarThemeColor.cgColor
    }
    
    // MARK: Apply LocalizedText
    func applyLocalizedText() {
        CommonFunctions.sharedInstance.setNavigationTitleView(titleStr:   localizedTextFor(key: SendFeedBackSceneText.SendFeedBackSceneTitle.rawValue), onVC: self)
        
        feedBackTextView.placeholder = localizedTextFor(key: SendFeedBackSceneText.SendFeedBackSceneFeedBackTextViewPlaceholder.rawValue)
        sendButton.setTitle(localizedTextFor(key: SendFeedBackSceneText.SendFeedBackSceneSendButtonTitle.rawValue), for: .normal)
    }
  
    // MARK: UIButton Actions
    
    @IBAction func sendButtonAction(_ sender: Any) {
        let text = feedBackTextView.text
        let trimmedText = text?.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmedText?.isEmpty ?? true {
          CustomAlertController.sharedInstance.showErrorAlert(error:localizedTextFor(key:SendFeedBackSceneText.sendfeedbackTextEmptyMsg.rawValue))
        }else{
            let request = SendFeedBack.Request(feedBackText: feedBackTextView.text)
            interactor?.hitSendFeedBackApi(request: request)
        }
    }
    // MARK: Other Functions
    
    func initialFunction() {
       scrollView.manageKeyboard()
    }

 // MARK: Display Response
  func displaySendFeedBackResponse(viewModel: SendFeedBack.ViewModel)
  {
    if let errorString = viewModel.error {
        CustomAlertController.sharedInstance.showErrorAlert(error: errorString)
    }
    else {
    CustomAlertController.sharedInstance.showAlert(subTitle: viewModel.message!, type: .success)
        feedBackTextView.text = ""
    }
  }
}
