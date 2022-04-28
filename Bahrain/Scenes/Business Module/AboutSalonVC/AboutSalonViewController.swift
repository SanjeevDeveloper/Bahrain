
import UIKit

protocol AboutSalonDisplayLogic: class
{
    func displayScreenData(viewModel: AboutSalon.ViewModel)
}

class AboutSalonViewController: UIViewController, AboutSalonDisplayLogic
{
    
    var interactor: AboutSalonBusinessLogic?
    var router: (NSObjectProtocol & AboutSalonRoutingLogic & AboutSalonDataPassing)?
    
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
        let interactor = AboutSalonInteractor()
        let presenter = AboutSalonPresenter()
        let router = AboutSalonRouter()
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
    
    @IBOutlet weak var backgroudImage: UIImageView!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var nameTitleLabel: UILabelFontSize!
    @IBOutlet weak var addressLabel: UILabelFontSize!
    @IBOutlet weak var availabilityTitleLabel: UILabelFontSize!
    @IBOutlet weak var homeLabel: UILabelFontSize!
    @IBOutlet weak var salonLabel: UILabelFontSize!
    @IBOutlet weak var homeAvailabilityLabel: UILabelFontSize!
    @IBOutlet weak var salonAvailabilityLabel: UILabelFontSize!
    @IBOutlet weak var instaTitleLabel: UILabelFontSize!
    @IBOutlet weak var instaIDLabel: UILabelFontSize!
    @IBOutlet weak var discriptionTitleLabel: UILabelFontSize!
    @IBOutlet weak var discriptionLabel: UILabelFontSize!
    @IBOutlet weak var backButton: UIButton!
    
    
    // MARK: View lifecycle
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
         if isCurrentLanguageArabic() {
                   backButton.contentHorizontalAlignment = .right
                   backButton.setImage(UIImage(named: "whiteRightArrow"), for: .normal)
               } else {
                   backButton.contentHorizontalAlignment = .left
                   backButton.setImage(UIImage(named: "whiteBackIcon"), for: .normal)
               }
        
        interactor?.showAboutScreenData()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        applyLocalizedText()
        applyFontAndColor()
    }
    
    // MARK: Apply Font And Color
    func applyFontAndColor() {
        nameTitleLabel.textColor = UIColor.white
        addressLabel.textColor = UIColor.white
        availabilityTitleLabel.textColor = appBarThemeColor
        homeLabel.textColor = appTxtfDarkColor
        salonLabel.textColor = appTxtfDarkColor
        instaTitleLabel.textColor = appBarThemeColor
        instaIDLabel.textColor = appTxtfDarkColor
        discriptionTitleLabel.textColor = appBarThemeColor
        discriptionLabel.textColor = appTxtfDarkColor
    }
    
    // MARK: Apply LocalizedText
    func applyLocalizedText() {
        availabilityTitleLabel.text = localizedTextFor(key: AboutSalonSceneText.AboutSalonSceneAvailabilityTitleLabel.rawValue)
        homeLabel.text = localizedTextFor(key: AboutSalonSceneText.AboutSalonSceneHomeLabel.rawValue)
        salonLabel.text = localizedTextFor(key: AboutSalonSceneText.AboutSalonSceneSalonLabel.rawValue)
        instaTitleLabel.text = localizedTextFor(key: AboutSalonSceneText.AboutSalonSceneInstaTitleLabel.rawValue)
        discriptionTitleLabel.text = localizedTextFor(key: AboutSalonSceneText.AboutSalonSceneDiscriptionTitleLabel.rawValue)
    }
    
    @IBAction func backBarButtonItem(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: Display Response
    
    func displayScreenData(viewModel: AboutSalon.ViewModel) {
        printToConsole(item: viewModel)
        CommonFunctions.sharedInstance.setNavigationTitleView(titleStr:   viewModel.salonName, onVC: self)
        
        if viewModel.profileImage != "" {
            let image = viewModel.profileImage
            let imageUrl = Configurator().imageBaseUrl +  image!
            logoImageView.sd_setImage(with: URL(string: imageUrl)) { (image, error, cacheType, url) in
                if error != nil {
                    self.logoImageView.image = defaultSaloonImage
                }
            }
        }
        else {
            logoImageView.image = defaultSaloonImage
        }
        
        if let coverImageUrl = URL(string:Configurator().imageBaseUrl + viewModel.coverPhoto!) {
            backgroudImage.sd_setImage(with: coverImageUrl, placeholderImage: #imageLiteral(resourceName: "PlaceHolderIcon"), options: .retryFailed, completed: nil)
        }
        
//        let coverImageUrl = Configurator().imageBaseUrl + viewModel.coverPhoto!
//        backgroudImage.sd_setImage(with: URL(string: coverImageUrl), completed: nil)
        
        nameTitleLabel.text = viewModel.salonName
        addressLabel.text = viewModel.address + "," + "\n" + viewModel.address2
        
        if viewModel.instaAccount != "" {
            instaIDLabel.text = viewModel.instaAccount
        }
        else {
            instaIDLabel.text = localizedTextFor(key: AboutSalonSceneText.AboutSalonSceneNonAvailableLabel.rawValue)
        }
        
        if viewModel.about != "" {
            discriptionLabel.text = viewModel.about
        }
        else {
            discriptionLabel.text = localizedTextFor(key: AboutSalonSceneText.AboutSalonSceneNonAvailableLabel.rawValue)
        }
        
        if viewModel.serviceType == salonTypes.both.rawValue {
            homeAvailabilityLabel.text = localizedTextFor(key: AboutSalonSceneText.AboutSalonSceneAvailableLabel.rawValue)
            salonAvailabilityLabel.text = localizedTextFor(key: AboutSalonSceneText.AboutSalonSceneAvailableLabel.rawValue)
        }
        else {
            
            if viewModel.serviceType == salonTypes.home.rawValue {
                homeAvailabilityLabel.text = localizedTextFor(key: AboutSalonSceneText.AboutSalonSceneAvailableLabel.rawValue)
            }
            else {
                homeAvailabilityLabel.text = localizedTextFor(key: AboutSalonSceneText.AboutSalonSceneNonAvailableLabel.rawValue)
            }
            
            if viewModel.serviceType == salonTypes.salon.rawValue {
                salonAvailabilityLabel.text = localizedTextFor(key: AboutSalonSceneText.AboutSalonSceneAvailableLabel.rawValue)
            }
            else {
                salonAvailabilityLabel.text = localizedTextFor(key: AboutSalonSceneText.AboutSalonSceneNonAvailableLabel.rawValue)
            }
        }
    }
}
