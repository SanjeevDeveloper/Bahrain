
import UIKit

protocol SlideMenuDelegate {
    func slideMenuItemSelectedAtIndex(_ index : Int32)
}

class MenuViewControllerUser: UIViewController {
    
    //  Array to display menu options
    @IBOutlet var tblMenuOptions : UITableView!
    
    //  Transparent button to hide menu
    @IBOutlet var btnCloseMenuOverlay : UIButton!
    
    //  Switch button
    @IBOutlet var switchBusinessButton: UIButton!
    
    @IBOutlet weak var userImageView: UIImageViewCustomClass!
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabelFontSize!
    @IBOutlet weak var registeredDateLabel: UILabelFontSize!
    
    @IBOutlet var userImageButton: UIButton!
    @IBOutlet var coverImageButton: UIButton!
    
    @IBOutlet weak var viewTopConstraint: NSLayoutConstraint!
    
    @IBOutlet var topView : UIView!
    
    
    //  Array containing menu options
    var arrayMenuOptions = [
        ["title":localizedTextFor(key: UserSideMenuText.homeMenuTitle.rawValue), "icon":#imageLiteral(resourceName: "HomeSideMenuIcon")],
        ["title":localizedTextFor(key: UserSideMenuText.searchMenuTitle.rawValue), "icon":#imageLiteral(resourceName: "SearchSideMenuIcon")],
        ["title":localizedTextFor(key: UserSideMenuText.appointmentsTitle.rawValue), "icon":#imageLiteral(resourceName: "calender-1")],
        ["title":localizedTextFor(key: UserSideMenuText.WalletTitle.rawValue), "icon":#imageLiteral(resourceName: "wallet")],
        ["title":localizedTextFor(key: UserSideMenuText.favoritesMenuTitle.rawValue), "icon":#imageLiteral(resourceName: "favoritesSideMenuIcon")],
        ["title":localizedTextFor(key: UserSideMenuText.messageTitle.rawValue), "icon":#imageLiteral(resourceName: "message_icon")],
        ["title":localizedTextFor(key: UserSideMenuText.notificationTitle.rawValue), "icon":UIImage(named: "bell")!],
        ["title":localizedTextFor(key: UserSideMenuText.sendFeedbackMenuTitle.rawValue), "icon":#imageLiteral(resourceName: "sendFeedbackSideMenuIcon")],
        ["title":localizedTextFor(key: UserSideMenuText.privacyPolicy.rawValue), "icon":UIImage(named: "privacyPolicy")!],
        ["title":localizedTextFor(key: UserSideMenuText.settingTitile.rawValue), "icon":#imageLiteral(resourceName: "settings-work-tool")],
        ["title":localizedTextFor(key: UserSideMenuText.logoutTitle.rawValue), "icon":#imageLiteral(resourceName: "logoutSideMenuIcon")]
    ]
    
    
    //  Menu button which was tapped to display the menu
    var btnMenu : UIButton!
    
    //  Delegate of the MenuVC
    var delegate : SlideMenuDelegate?
    
    var isCoverImageView = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let unreadNotifications = userDefault.value(forKey: userDefualtKeys.unreadNotifications.rawValue) as? NSNumber ?? 0
        printToConsole(item: unreadNotifications)
        if unreadNotifications != 0 {
            arrayMenuOptions[6]["title"] = localizedTextFor(key: UserSideMenuText.notificationTitle.rawValue) + " (" + unreadNotifications.description + ") "
        }
        coverImageButton.isHidden = true
        userImageButton.isHidden = true
        addSwipe()
        tblMenuOptions.tableFooterView = UIView()
        if (UIScreen.main.bounds.height == 812){
            viewTopConstraint.constant = 0
        }
        topView.backgroundColor = appBarThemeColor
        registeredDateLabel.backgroundColor = appBarThemeColor
        userNameLabel.backgroundColor = appBarThemeColor
        tblMenuOptions.backgroundColor = appBarThemeColor
        switchBusinessButton.backgroundColor = switchToBussinessBtnColor
        userImageView.layer.borderColor = statusBarColor.cgColor
    }
    
    func isComingFromSkip() {
        arrayMenuOptions[10] = ["title":localizedTextFor(key: UserSideMenuText.loginTitle.rawValue), "icon":#imageLiteral(resourceName: "logoutSideMenuIcon")]
        userNameLabel.text = "BS"
        
       // coverImageButton.isHidden = true
        userImageButton.isHidden = true
    }
    
    func addSwipe() {
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.closeSideMenu))
        swipeLeft.direction = UISwipeGestureRecognizerDirection.left
        self.view.addGestureRecognizer(swipeLeft)
    }
    
    
    @objc func closeSideMenu() {
        let isBusinessDelete = userDefault.bool(forKey: userDefualtKeys.isBusinessDelete.rawValue)
        if isUserLoggedIn() {
            if isBusinessDelete {
                showAlert()
            }
            else {
                let isApprovedString = getUserData(.isApproved)
                let isApproved = isApprovedString.boolValue()
                if isApproved {
                    CustomAlertController.sharedInstance.showErrorAlert(error: localizedTextFor(key: GeneralText.businessAlreadyApproved.rawValue))
                } else {
                    animateUI ()
                }
            }
        }
        else {
            CommonFunctions.sharedInstance.showLoginAlert(referenceController:self)
        }
    }
    
      func animateUI () {
        
        btnMenu.tag = 0
        
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            self.view.frame = CGRect(x: -UIScreen.main.bounds.size.width, y: 0, width: UIScreen.main.bounds.size.width,height: UIScreen.main.bounds.size.height)
            self.view.layoutIfNeeded()
            self.view.backgroundColor = UIColor.clear
        }, completion: { (finished) -> Void in
            self.view.removeFromSuperview()
            self.navigationController?.setNavigationBarHidden(false, animated: true)
            self.removeFromParentViewController()
        })
        
         self.performSegue(withIdentifier: "BusinessStoryBoard", sender: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if isUserLoggedIn() {
            userNameLabel.text = getUserData(.name).uppercased()
            
            let date = userDefault.value(forKey: userDefualtKeys.registeredDate.rawValue) as? String
            
            
            let tt = localizedTextFor(key: GeneralText.registeredOn.rawValue)
            registeredDateLabel.text = tt + "\n" + date!
            
            if let profileImageUrl = URL(string:Configurator().imageBaseUrl + getUserData(.profileImage)) {
                printToConsole(item: profileImageUrl)
                userImageView.sd_setImage(with: profileImageUrl, placeholderImage: #imageLiteral(resourceName: "userIcon"), options: .retryFailed, completed: nil)
            }
            
//            if let coverImageUrl = URL(string:Configurator().imageBaseUrl + getUserData(.coverPhoto)) {
////                coverImageView.sd_setImage(with: coverImageUrl, placeholderImage: nil, options: .retryFailed, completed: nil)
//            }
        }
        else {
            userImageView?.image = #imageLiteral(resourceName: "userIcon")
             registeredDateLabel.text = ""
            isComingFromSkip()
        }
        
        switchBusinessButton.setTitle(localizedTextFor(key: UserSideMenuText.switchBusiness.rawValue), for: .normal)
        
    }
    
    @IBAction func userImageButtonAction(_ sender: Any) {
        self.isCoverImageView = false
        let customPicker = CustomImagePicker()
        customPicker.delegate = self
        customPicker.openImagePicker(controller: self, source: (sender as! UIButton))
    }
    
    @IBAction func coverImageButtonAction(_ sender: Any) {
        self.isCoverImageView = true
        let customPicker = CustomImagePicker()
        customPicker.delegate = self
        customPicker.openImagePicker(controller: self, source: (sender as! UIButton))
    }
    
    @IBAction func switchButtontAction(_ button:UIButton!){
        closeSideMenu()
    }
    
//    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
//        if identifier == "BusinessStoryBoard" {
//
//          if isUserLoggedIn() {
//
//          let isBusinessDelete = userDefault.bool(forKey: userDefualtKeys.isBusinessDelete.rawValue)
//
//                if isBusinessDelete {
//                    showAlert()
//                    return false
//                }
//                else {
//                    return true
//                }
//            }
//            else {
//                CommonFunctions.sharedInstance.showLoginAlert(referenceController:self)
//                return false
//            }
//        }
//        return true
//    }
    //Space Click to hide
    @IBAction func onCloseMenuClick(_ button:UIButton!){
        btnMenu.tag = 0
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        if (self.delegate != nil) {
            var index = Int32(button.tag)
            if(button == self.btnCloseMenuOverlay){
                index = -1
            }
            delegate?.slideMenuItemSelectedAtIndex(index)
        }
        
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            
            let languageIdentifier = UserDefaults.standard.value(forKey: userDefualtKeys.currentLanguage.rawValue) as! String
            if languageIdentifier == Languages.Arabic {
              self.view.frame = CGRect(x: UIScreen.main.bounds.size.width*2, y: 0, width: UIScreen.main.bounds.size.width,height: UIScreen.main.bounds.size.height)
            }
            else {
             self.view.frame = CGRect(x: -UIScreen.main.bounds.size.width, y: 0, width: UIScreen.main.bounds.size.width,height: UIScreen.main.bounds.size.height)
            }
            
            self.view.layoutIfNeeded()
            self.view.backgroundColor = UIColor.clear
        }, completion: { (finished) -> Void in
            self.view.removeFromSuperview()
            self.removeFromParentViewController()
        })
    }
    
    
    func showAlert() {
        
        let alertController = PMAlertController(textForegroundColor:UIColor.darkGray, viewBackgroundColor: UIColor.white, title: "" , description: localizedTextFor(key: GeneralText.businessAlreadyExist.rawValue), image: nil , style: .alert)
        
        let yesButton = PMAlertAction(title: localizedTextFor(key: GeneralText.yes.rawValue), style: .default, action: {
            
            self.hitReconnectExistingBusinessApi()
        })
        
        let noButton = PMAlertAction(title: localizedTextFor(key: GeneralText.no.rawValue), style: .default, action: {
            alertController.dismiss(animated: true, completion: nil)
        })
        
        alertController.addAction(noButton)
        alertController.addAction(yesButton)
        
        present(alertController, animated: true, completion: nil)
    }
    
    // Api Hit
    
    func hitReconnectExistingBusinessApi() {
        let url = ApiEndPoints.userModule.reconnectExistingBusiness + "/" + getUserData(._id)
        
        NetworkingWrapper.sharedInstance.connect(urlEndPoint: url, httpMethod: .get, headers: ApiHeaders.sharedInstance.headerWithAuth()) { (response) in
            
            if response.code == 200 {
                
                let resultObj = response.result as! NSDictionary
                CommonFunctions.sharedInstance.updateUserData(.businessId, value: resultObj["businessId"] as! String)
                CommonFunctions.sharedInstance.updateUserData(.saloonName, value: resultObj["saloonName"] as! String)
                userDefault.set(false, forKey: userDefualtKeys.isBusinessDelete.rawValue)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
                     self.animateUI ()
                })
            }
            else {
                CustomAlertController.sharedInstance.showErrorAlert(error: response.error!)
            }
        }
    }
    
    func hitUpdateProfileImageApi(image:UIImage, imageName:String) {
        let url = ApiEndPoints.userModule.updateProfileImage + "/" + getUserData(._id)
        NetworkingWrapper.sharedInstance.connectWithMultiPart(urlEndPoint: url, httpMethod: .put,  headers: ApiHeaders.sharedInstance.headerWithAuth(), images: [image], imageName: imageName) { (response) in
            if response.code == 200 {
                CustomAlertController.sharedInstance.showAlert(subTitle: localizedTextFor(key: GeneralText.imageUploadedSuccess.rawValue), type: .success)
                let resultObj = response.result as! NSDictionary
                CommonFunctions.sharedInstance.updateUserData(.profileImage, value: resultObj[PhotoType.profileImage] as! String)
                CommonFunctions.sharedInstance.updateUserData(.coverPhoto, value: resultObj[PhotoType.coverPhoto] as! String)
                
                if self.isCoverImageView {
                    self.coverImageView.image = image
                }
                else {
                    self.userImageView.image = image
                    
                }
            }
            else {
                CustomAlertController.sharedInstance.showErrorAlert(error: response.error!)
            }
        }
    }
}

extension MenuViewControllerUser: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayMenuOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReUseIdentifier) as! SideMenuTableViewCell
        cell.backgroundColor = appBarThemeColor
        let object = arrayMenuOptions[indexPath.row]
        cell.setData(dict:object as [String : AnyObject])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let btn = UIButton(type: UIButtonType.custom)
        btn.tag = indexPath.row
        self.onCloseMenuClick(btn)
    }
}

extension MenuViewControllerUser: CustomImagePickerProtocol{
    func didFinishPickingImage(image:UIImage) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        if self.isCoverImageView {
            hitUpdateProfileImageApi(image: image, imageName: PhotoType.coverPhoto)
        }
        else {
            hitUpdateProfileImageApi(image: image, imageName: PhotoType.profileImage)
        }
    }
    
    func didCancelPickingImage() {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
}


