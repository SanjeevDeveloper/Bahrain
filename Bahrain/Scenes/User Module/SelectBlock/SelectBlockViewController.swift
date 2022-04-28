

import UIKit

protocol SelectBlockDisplayLogic: class {
    func displayData(_ response: SelectBlock.ViewModel)
    func displayScreenName(ResponseMsg:String?)
}

class SelectBlockViewController: UIViewController, SelectBlockDisplayLogic
{
    var interactor: SelectBlockBusinessLogic?
    var router: (NSObjectProtocol & SelectBlockRoutingLogic & SelectBlockDataPassing)?
    
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
        let interactor = SelectBlockInteractor()
        let presenter = SelectBlockPresenter()
        let router = SelectBlockRouter()
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
    
    @IBOutlet weak var tblList: UITableView!
    var list = [SelectBlock.Response]()
    
    var screenName: String?
    
    
    // MARK: View lifecycle
    // MARK: Do something
    override func viewDidLoad()
    {
        super.viewDidLoad()
        initialFunction()
        CommonFunctions.sharedInstance.setNavigationTitleView(titleStr:  localizedTextFor(key: SelectAreaSceneText.SelectAreaSceneSelectBlockTitle.rawValue), onVC: self)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "whiteBackIcon"), style: .done, target: self, action: #selector(self.backButtonAction(sender:)))
        let languageIdentifier = UserDefaults.standard.value(forKey: userDefualtKeys.currentLanguage.rawValue) as! String
        if languageIdentifier == Languages.Arabic {
            self.navigationItem.leftBarButtonItem?.image = #imageLiteral(resourceName: "whiteRightArrow")
        }
        else {
            self.navigationItem.leftBarButtonItem?.image = #imageLiteral(resourceName: "whiteBackIcon")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        interactor?.showScreenName()
        
    }
    
    func initialFunction() {
        self.navigationItem.setHidesBackButton(true, animated: false)
        interactor?.getBlockList()
    }
    @objc func backButtonAction(sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    func displayData(_ response: SelectBlock.ViewModel) {
        list = response.list
        tblList.reloadData()
    }
    
    func displayScreenName(ResponseMsg: String?) {
        screenName = ResponseMsg
    }
}
extension SelectBlockViewController : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReUseIdentifier, for: indexPath)
        cell.textLabel?.text = list[indexPath.row].block!
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if screenName == "BusinessLocation" {
            router?.routeToBusinessLocation(selectBlockText: list[indexPath.row].block!)
        }
        else {
            router?.routeToRegisterLocationScreen(selectBlockText: list[indexPath.row].block!)
        }
        
    }
}
