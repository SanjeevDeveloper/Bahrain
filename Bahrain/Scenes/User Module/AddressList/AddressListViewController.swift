
import UIKit

protocol AddressListDisplayLogic: class {
    func displayAddressList(viewModel: [AddressList.ViewModel])
    func displayUsedAddressResponse(defaultAddress: AddressList.ViewModel)
    func displayDeleteResponse(index: Int)
    func bookingConfirmed(bookingId:String)
}

class AddressListViewController: UIViewController, AddressListDisplayLogic {
    var interactor: AddressListBusinessLogic?
    var router: (NSObjectProtocol & AddressListRoutingLogic & AddressListDataPassing)?
    
    // MARK: Object lifecycle
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK: Setup
    
    private func setup() {
        let viewController = self
        let interactor = AddressListInteractor()
        let presenter = AddressListPresenter()
        let router = AddressListRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
    
    // MARK: Routing
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let scene = segue.identifier {
            let selector = NSSelectorFromString("routeTo\(scene)WithSegue:")
            if let router = router, router.responds(to: selector) {
                router.perform(selector, with: segue)
            }
        }
    }
    
    // MARK: View lifecycle
    
    @IBOutlet weak var addressListTableView: UITableView!
    @IBOutlet weak var addView: UIView!
    @IBOutlet weak var addViewLabel: UILabel!
    
    @IBOutlet weak var addLabel: UILabel!
    
    var addressListArray = [AddressList.ViewModel]()
    var addressId = ""
    var selectedIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
      self.title = localizedTextFor(key: AddressListString.addressListSceneText.rawValue)
      addViewLabel.text = localizedTextFor(key: AddressListString.addAddressTitle.rawValue)
      addLabel.text = localizedTextFor(key: AddressListString.addAddressTitle.rawValue)
      addViewLabel.textColor = appBarThemeColor
      addLabel.textColor = appBarThemeColor
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "whiteBackIcon"), style: .done, target: self, action: #selector(self.backToInitial(sender:)))
        hideBackButtonTitle()
    }
    
    @objc func backToInitial(sender: AnyObject) {
        router?.goBack()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        interactor?.getAddressList()
    }
    
    func displayAddressList(viewModel: [AddressList.ViewModel]) {
        addressListArray = viewModel
        if addressListArray.count > 0 {
            self.addView.isHidden = true
        } else {
            self.addView.isHidden = false
        }
        addressListTableView.reloadData()
    }
    
    func bookingConfirmed(bookingId:String) {
        router?.routeToPaymentSelectionScreen(bookingId: bookingId)
    }
    
    func displayUsedAddressResponse(defaultAddress: AddressList.ViewModel) {
        addressListTableView.reloadData()
        interactor?.confirmBooking(defaultAddress)
    }
    
    func displayDeleteResponse(index: Int) {
        CustomAlertController.sharedInstance.showAlert(subTitle: localizedTextFor(key: AddressListString.deletedAddress.rawValue), type: .success)
        let obj = addressListArray[index]
        if obj.isDefault {
            NotificationCenter.default.post(name: NSNotification.Name("allAddressDeleted"), object: nil)
        }
        addressListArray.remove(at: index)
        if addressListArray.count > 0 {
            addView.isHidden = true
        } else {
            addView.isHidden = false
        }
        addressListTableView.reloadData()
    }
    
    @IBAction func addButtonAction(sender: UIBarButtonItem) {
        router?.routeToAdd()
    }
    
    @IBAction func backButtonAction(sender: UIBarButtonItem) {
        
        var text = ""
        for arrObj in addressListArray {
            if arrObj.isDefault {
                text = arrObj.title
                break
            }
        }
        
        let vcArray = self.navigationController?.viewControllers
        for vc in vcArray! {
            if vc.isKind(of: BookingSummaryViewController.self) {
                let destinationVC = vc as! BookingSummaryViewController
                var destinationDS = destinationVC.router?.dataStore
                //destinationDS?.title = text
                //destinationDS?.isFromBack = true
                self.navigationController?.popViewController(animated: true)
                break
            }
        }
    }
    
    @objc func editButtonPressed(sender: UIButton) {
        var v:UIView = sender
        repeat { v = v.superview! } while !(v is UITableViewCell)
        let cell = v as! AddressListTableViewCell
        let indexPath = addressListTableView.indexPath(for:cell)!
        let currentRow = addressListArray[indexPath.row]
        self.router?.routeToAddAddressVc(editObj: currentRow)
    }
    
    @objc func useAddressButtonPressed(sender: UIButton) {
        var v:UIView = sender
        repeat { v = v.superview! } while !(v is UITableViewCell)
        let cell = v as! AddressListTableViewCell
        let indexPath = addressListTableView.indexPath(for:cell)!
        let currentRow = addressListArray[indexPath.row]
        interactor?.setDefaultAddressList(defaultAddress: currentRow)
    }
    
    @objc func deleteButtonPressed(sender: UIButton) {
        var v:UIView = sender
        repeat { v = v.superview! } while !(v is UITableViewCell)
        let cell = v as! AddressListTableViewCell
        let indexPath = addressListTableView.indexPath(for:cell)!
        
        let currentRow = addressListArray[indexPath.row]
        addressId = currentRow.addressID
        selectedIndex = indexPath.row
        self.showAlert()
    }
    
    func showAlert() {
            let alertController = PMAlertController(textForegroundColor:UIColor.darkGray, viewBackgroundColor: UIColor.white, title: localizedTextFor(key: AddressListString.deleteAddress.rawValue), description: localizedTextFor(key: AddressListString.deleteConfirmation.rawValue), image: nil, style: .alert)
            alertController.addAction(PMAlertAction(title: localizedTextFor(key: GeneralText.no.rawValue), style: .default, action: {
                alertController.dismiss(animated: true, completion: nil)
            }))
            
            alertController.addAction(PMAlertAction(title: localizedTextFor(key: GeneralText.yes.rawValue), style: .default, action: {
                self.interactor?.deleteAddress(addressID: self.addressId, index: self.selectedIndex)
                alertController.dismiss(animated: true, completion: nil)
            }))
            
            present(alertController, animated: true, completion: nil)
    }
}

extension AddressListViewController : UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return addressListArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReUseIdentifier, for: indexPath) as! AddressListTableViewCell
        let currentRow = addressListArray[indexPath.row]
        if currentRow.isDefault {
            cell.radioButton.isSelected = true
        } else {
            cell.radioButton.isSelected = false
        }
        cell.editButton.addTarget(self, action: #selector(editButtonPressed(sender:)), for: .touchUpInside)
        cell.deleteButton.addTarget(self, action: #selector(deleteButtonPressed(sender:)), for: .touchUpInside)
        cell.useAddressButton.addTarget(self, action: #selector(useAddressButtonPressed(sender:)), for: .touchUpInside)
        cell.setCellData(addressListObj: currentRow)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}

