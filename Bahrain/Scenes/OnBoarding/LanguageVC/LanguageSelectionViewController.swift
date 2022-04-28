
import UIKit

protocol LanguageSelectionDisplayLogic: class
{
}

class LanguageSelectionViewController: UIViewController, LanguageSelectionDisplayLogic
{
    var interactor: LanguageSelectionBusinessLogic?
    var router: (NSObjectProtocol & LanguageSelectionRoutingLogic & LanguageSelectionDataPassing)?
    
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
        let interactor = LanguageSelectionInteractor()
        let presenter = LanguageSelectionPresenter()
        let router = LanguageSelectionRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
    
    /////////////////////////////////////////////////////
    
    // MARK: Routing
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        let senderButton = sender as! UIButton
        if let router = router {
            if senderButton == englishButton {
                router.routeToLogin(segue: segue, languageIdentifier: Languages.english)
            }
            else {
               
                router.routeToLogin(segue: segue, languageIdentifier: Languages.Arabic)
            }
        }
    }
    
    // MARK: View lifecycle
    
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var englishButton: UIButton!
    @IBOutlet weak var arabicButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        applyLocalizedText()
        applyFontAndColor()
    }
    
    override func viewWillAppear(_ animated: Bool) {
    }
    
    // MARK: Apply Font And Color
    func applyFontAndColor() {
        subtitleLabel.textColor = appTxtfDarkColor
        englishButton.backgroundColor = appBarThemeColor
        arabicButton.backgroundColor = appBarThemeColor
        englishButton.setTitleColor(appBtnWhiteColor, for: .normal)
        subtitleLabel.textColor = appTxtfDarkColor
        arabicButton.setTitleColor(appBtnWhiteColor, for: .normal)
    }
    
    // MARK: Apply LocalizedText
    func applyLocalizedText() {
        CommonFunctions.sharedInstance.setNavigationTitleView(titleStr: localizedTextFor(key: LanguageSceneText.languageSceneTitle.rawValue), onVC: self)
        subtitleLabel.text = localizedTextFor(key: LanguageSceneText.languageSceneSubtitle.rawValue)
        englishButton.setTitle(localizedTextFor(key:LanguageSceneText.languageSceneEnglishButton.rawValue), for: .normal)
        arabicButton.setTitle(localizedTextFor(key:LanguageSceneText.languageSceneArabicButton.rawValue), for: .normal)
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        return true
    }
}
