
import UIKit

protocol StaffDisplayLogic: class
{
    func displayResponse(viewModel: Staff.ViewModel)
}

class StaffViewController: UIViewController, StaffDisplayLogic
{
    var interactor: StaffBusinessLogic?
    var router: (NSObjectProtocol & StaffRoutingLogic & StaffDataPassing)?
    
    
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
        let interactor = StaffInteractor()
        let presenter = StaffPresenter()
        let router = StaffRouter()
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
    
    /////////////////////////////////////////////////////////////////
    
    @IBOutlet weak var staffTableView: UITableView!
    @IBOutlet weak var backButton: UIButton!
  
    @IBOutlet weak var noStaffLabel: UILabelFontSize!
    var staffListArray = [Staff.ViewModel.tableCellData]()
    var offset = 0
    
    // MARK: View lifecycle
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        initialFunction()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        CommonFunctions.sharedInstance.setNavigationTitleView(titleStr:   localizedTextFor(key: StaffSceneText.StaffSceneTitle.rawValue), onVC: self)
        noStaffLabel.text = localizedTextFor(key: StaffSceneText.StaffSceneNoStaffLabel.rawValue)
    }
    
    // MARK: Other Functions
    
    func initialFunction() {
        
         if isCurrentLanguageArabic() {
                   backButton.contentHorizontalAlignment = .right
                   backButton.setImage(UIImage(named: "whiteRightArrow"), for: .normal)
               } else {
                   backButton.contentHorizontalAlignment = .left
                   backButton.setImage(UIImage(named: "whiteBackIcon"), for: .normal)
               }
        
        interactor?.hitlistTherapistByBusinessIdApi(offset: offset)
    }
    
    @IBAction func backBarButtonItem(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: Display Response
    
    func displayResponse(viewModel: Staff.ViewModel)
    {
        if let errorString = viewModel.errorString {
            CustomAlertController.sharedInstance.showErrorAlert(error: errorString)
        }
        else {
            
            staffListArray.append(contentsOf: viewModel.tableArray)
            staffTableView.reloadData()
            if staffListArray.count == 0 {
                noStaffLabel.isHidden = false
            }
            else {
                noStaffLabel.isHidden = true
            }
        }
    }
    
}

// MARK: UITableViewDelegate

extension StaffViewController : UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return staffListArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        let footerView = view as! UITableViewHeaderFooterView
        footerView.tintColor = UIColor.clear
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReUseIdentifier, for: indexPath) as! StaffTableViewCell
        
        
    
        let currentObj = staffListArray[indexPath.section]
        
        
        
        let userImage = currentObj.image
        let imageUrl = Configurator().imageBaseUrl + userImage
        cell.userImageView.sd_setImage(with: URL(string: imageUrl), placeholderImage: #imageLiteral(resourceName: "userIcon"), options: .retryFailed, completed: nil)
        cell.userNameLabel.text = currentObj.name
        cell.userServiceLabel.text = currentObj.jobTitle
        cell.therapistRatingView.rating = currentObj.therapistRating
        
        
        //////////////////////
        
        
        
        var displayText = NSMutableAttributedString()
        
        for item in currentObj.servicesArray {
            let mutuableString = NSMutableAttributedString(string: item.category, attributes: [NSAttributedStringKey.font:UIFont.systemFont(ofSize: 14, weight: .bold),NSAttributedStringKey.foregroundColor:UIColor.black])
            
            mutuableString.append(NSAttributedString(string: ": " + item.subCategory))
            
            displayText.append(mutuableString)
            let newLine:NSAttributedString = NSAttributedString(string: "\n")
            displayText.append(newLine)
        }
        
        cell.servicesLabel.attributedText = displayText
        
        /////////////////////
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.section == (((self.offset + 1)*10) - 1) {
            self.offset += 1
//            initialFunction()
        }
    }
}


