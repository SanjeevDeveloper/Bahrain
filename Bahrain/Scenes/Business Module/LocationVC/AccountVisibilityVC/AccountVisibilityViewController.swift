

import UIKit

protocol AccountVisibilityDisplayLogic: class
{
    func displayVisibilityResponse(viewModel: AccountVisibility.ViewModel)
}

class AccountVisibilityViewController: UIViewController, AccountVisibilityDisplayLogic
{
    var interactor: AccountVisibilityBusinessLogic?
    var router: (NSObjectProtocol & AccountVisibilityRoutingLogic & AccountVisibilityDataPassing)?
    
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
        let interactor = AccountVisibilityInteractor()
        let presenter = AccountVisibilityPresenter()
        let router = AccountVisibilityRouter()
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
    
///////////////////////////////////////////////////////////////////////////
    
    @IBOutlet weak var visibilityClientLabel:UILabel!
    @IBOutlet weak var deleteButton:UIButton!
    @IBOutlet weak var visibilitySwitch:UISwitch!
    
    // MARK: View lifecycle
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        initialFunction()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.title = localizedTextFor(key: AccountVisibilitySceneText.accountVisibilitySceneTitle.rawValue)
        visibilityClientLabel.text = localizedTextFor(key: AccountVisibilitySceneText.accountVisibilitySceneSwitchButtonTitle.rawValue)
        deleteButton.setTitle(localizedTextFor(key: AccountVisibilitySceneText.accountVisibilitySceneDeleteButtonTitle.rawValue), for: .normal)
    }
    
    @IBAction func SwitchButtonAction(_ sender: UISwitch) {
        interactor?.hitUpdateBusinessApi(visibility: sender.isOn)
    }
    
    
    @IBAction func deleteButtonAction(_ sender: Any) {
        
        //interactor?.hitDeleteBusinessAccountApi()
    }
    
    func showAlert() {
        
        let alertController = PMAlertController(textForegroundColor:UIColor.white, viewBackgroundColor: UIColor.darkGray, title:localizedTextFor(key: AccountVisibilitySceneText.accountVisibilityScenePopupTitle.rawValue) , description:localizedTextFor(key: AccountVisibilitySceneText.accountVisibilityScenePopupSubTitle.rawValue), image: nil , style: .alert)
        
        let yesButton = PMAlertAction(title: localizedTextFor(key: GeneralText.yes.rawValue), style: .default, action: {
            alertController.dismiss(animated: true, completion: nil)
        })
        
        let noButton = PMAlertAction(title: localizedTextFor(key: GeneralText.no.rawValue), style: .default, action: {
            alertController.dismiss(animated: true, completion: nil)
        })
        
        alertController.addAction(yesButton)
        alertController.addAction(noButton)
        
        present(alertController, animated: true, completion: nil)
    }
    
    // MARK: Other Functions
    
    func initialFunction() {
        interactor?.hitGetBusinessByIdApi()
    }
    
    
    func displayVisibilityResponse(viewModel: AccountVisibility.ViewModel)
    {
        visibilitySwitch.isOn = viewModel.visibility
    }
}
