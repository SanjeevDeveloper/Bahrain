

import UIKit

protocol BookingSettingDisplayLogic: class
{
    func displayResponse(Time: Int, Note: String)
    func displayUpdatedResponse()
    
}

class BookingSettingViewController: UIViewController, BookingSettingDisplayLogic
{
    
    
  var interactor: BookingSettingBusinessLogic?
  var router: (NSObjectProtocol & BookingSettingRoutingLogic & BookingSettingDataPassing)?

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
    let interactor = BookingSettingInteractor()
    let presenter = BookingSettingPresenter()
    let router = BookingSettingRouter()
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
    
    ///////////////////////////////////////////////////////////////
    
    @IBOutlet weak var leadTimeLabel: UILabelFontSize!
    @IBOutlet weak var leadTimeDiscriptionLabel: UILabelFontSize!
    @IBOutlet weak var leadTimeTextView: UITextViewFontSize!
    @IBOutlet weak var minuteLabel: UILabelFontSize!
    @IBOutlet weak var noteLabel: UILabelFontSize!
    @IBOutlet weak var noteDiscriptionLabel: UILabelFontSize!
    @IBOutlet weak var noteTextView: UITextViewFontSize!
    @IBOutlet weak var doneButton: UIButtonCustomClass!
    @IBOutlet weak var scrollView: UIScrollView!
    
   
    // MARK: View lifecycle
  
  override func viewDidLoad()
  {
    super.viewDidLoad()
    scrollView.manageKeyboard()
    interactor?.hitGetBusinessById()
  }
  
    override func viewWillAppear(_ animated: Bool) {
       applyLocalizedText()
    }
    
    // MARK: Apply LocalizedText
    func applyLocalizedText() {
        CommonFunctions.sharedInstance.setNavigationTitleView(titleStr:   localizedTextFor(key: BookingSettingsSceneText.bookingSettingsSceneTitle.rawValue), onVC: self)
        
        leadTimeLabel.text = localizedTextFor(key: BookingSettingsSceneText.bookingSettingsSceneTimeTitleLabel.rawValue)
        
        leadTimeDiscriptionLabel.text = localizedTextFor(key: BookingSettingsSceneText.bookingSettingsSceneTimeDescriptionLabel.rawValue)
        
        minuteLabel.text = localizedTextFor(key: BookingSettingsSceneText.bookingSettingsSceneMinuteLabel.rawValue)
        
        noteLabel.text = localizedTextFor(key: BookingSettingsSceneText.bookingSettingsSceneNoteTitleLabel.rawValue)
        
        noteDiscriptionLabel.text = localizedTextFor(key: BookingSettingsSceneText.bookingSettingsSceneNoteDescriptionLabel.rawValue)
        
        leadTimeTextView.placeholder = localizedTextFor(key: BookingSettingsSceneText.bookingSettingsSceneLeadTimeTextView.rawValue)
        
        noteTextView.placeholder = localizedTextFor(key: BookingSettingsSceneText.bookingSettingsSceneNoteTextView.rawValue)
        
        doneButton.setTitle(localizedTextFor(key: BookingSettingsSceneText.bookingSettingsSceneDoneButton.rawValue), for: .normal)
    }

  // MARK: Button Actions
  
    @IBAction func doneButtonAction(_ sender: Any) {
        
        let req = BookingSetting.Request(time: leadTimeTextView.text, note: noteTextView.text)
        interactor?.hitUpdateBusinessApi(request: req)
        
    }
    
  // MARK: Display Response
  func displayResponse(Time: Int, Note: String)
  {
    leadTimeTextView.text = Time.description
    noteTextView.text = Note
  }
    
    func displayUpdatedResponse() {
        
       CustomAlertController.sharedInstance.showAlert(subTitle: localizedTextFor(key: BookingSettingsSceneText.bookingSettingsSceneSuccessMessage.rawValue), type: .success)
        
    }
}
