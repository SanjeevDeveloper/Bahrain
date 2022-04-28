
import UIKit

protocol BusinessSlideMenuDelegate {
    func slideMenuItemSelectedAtIndex(_ index : Int32)
}

class MenuViewControllerBusiness: UIViewController {
    
    //  Array to display menu options
    @IBOutlet var tblMenuOptions : UITableView!
    
    //  Transparent button to hide menu
    @IBOutlet var btnCloseMenuOverlay : UIButton!
    
    //  Switch button
    @IBOutlet var switchClientButton: UIButton!
    
    @IBOutlet weak var businessProfileImageView: UIImageViewCustomClass!
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var businessNameLabel: UILabelFontSize!
    @IBOutlet var businessProfileImageButton: UIButton!
    @IBOutlet var coverImageButton: UIButton!
    @IBOutlet weak var approvedLabel: UILabelFontSize!
    //  Array containing menu options
    var arrayMenuOptions = [
//        ["title":localizedTextFor(key: BusinessSideMenuText.todayMenuTitle.rawValue), "icon":#imageLiteral(resourceName: "today")],
//        ["title":localizedTextFor(key: BusinessSideMenuText.calendarMenuTitle.rawValue), "icon":#imageLiteral(resourceName: "calender")],
//        ["title":localizedTextFor(key: BusinessSideMenuText.bookingMenuTitle.rawValue), "icon":#imageLiteral(resourceName: "booking")],
        ["title":localizedTextFor(key: BusinessSideMenuText.settingsMenuTitle.rawValue), "icon":#imageLiteral(resourceName: "setting")]
        ]
    
    //  Menu button which was tapped to display the menu
    var btnMenu : UIButton!
    
    //  Delegate of the MenuVC
    var delegate : BusinessSlideMenuDelegate?
    
    var isCoverImageView = false

    override func viewDidLoad() {
        super.viewDidLoad()
        addSwipe()
        tblMenuOptions.tableFooterView = UIView()
        getBusinessById()
    }
    
    func addSwipe() {
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.closeSideMenu))
        swipeLeft.direction = UISwipeGestureRecognizerDirection.left
        self.view.addGestureRecognizer(swipeLeft)
    }
    
    @objc func closeSideMenu() {
        btnMenu.tag = 0
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            self.view.frame = CGRect(x: -UIScreen.main.bounds.size.width, y: 0, width: UIScreen.main.bounds.size.width,height: UIScreen.main.bounds.size.height)
            self.view.layoutIfNeeded()
            self.view.backgroundColor = UIColor.clear
        }, completion: { (finished) -> Void in
            self.navigationController?.setNavigationBarHidden(false, animated: true)
            self.view.removeFromSuperview()
            self.removeFromParentViewController()
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        coverImageButton.isHidden = true
        businessProfileImageButton.isHidden = true
        applyLocalizedText()
        applyFontAndColor()
        updateImages()
       
    }
    
    // MARK: Apply Font And Color
    func applyFontAndColor() {
       switchClientButton.setTitleColor(appBtnWhiteColor, for: .normal)
       switchClientButton.backgroundColor = appBarThemeColor
       businessNameLabel.textColor = appBarThemeColor
    }
    
    // MARK: Apply LocalizedText
    func applyLocalizedText() {
        switchClientButton.setTitle(localizedTextFor(key: BusinessSideMenuText.switchUser.rawValue), for: .normal)

       
    }
    
    func updateImages() {
        let saloonProfileImageUrl = userDefault.value(forKey: userDefualtKeys.saloonProfileImage.rawValue) as? String ?? ""
        printToConsole(item: saloonProfileImageUrl)
//        let saloonCoverImageUrl = userDefault.value(forKey: userDefualtKeys.saloonCoverImage.rawValue) as? String ?? ""
     //   if !saloonProfileImageUrl.isEmptyString() {
            businessNameLabel.text = getUserData(.saloonName).uppercased()
        
        let isapprove = userDefault.value(forKey: "isApproved") as? Bool

        if isapprove != nil {
            if isapprove == true {
                approvedLabel.text = "(" + "Approved" + ")"
            }
            else {
                approvedLabel.text = "(" + "Disapproved" + ")"
            }
            
        }

            if let businessProfileImageUrl = URL(string:Configurator().imageBaseUrl + saloonProfileImageUrl) {
                businessProfileImageView.sd_setImage(with: businessProfileImageUrl, placeholderImage: #imageLiteral(resourceName: "userIcon"), options: .retryFailed, completed: nil)
                
                
          //  }
            
//            if let coverImageUrl = URL(string:Configurator().imageBaseUrl + saloonCoverImageUrl) {
//              //  coverImageView.sd_setImage(with: coverImageUrl, placeholderImage: nil, options: .retryFailed, completed: nil)
//            }
        }
        else {
            //getBusinessById()
        }
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
       // self.dismiss(animated: true, completion: nil)
    
        let storyboard = AppStoryboard.Main.instance
        let tabBarController = storyboard.instantiateViewController(withIdentifier: AppDelegatePaths.Identifiers.UserModuleNavigationControllerID)
        appDelegateObj.window?.rootViewController = tabBarController
        appDelegateObj.window?.makeKeyAndVisible()
    }
    
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
            self.view.frame = CGRect(x: -UIScreen.main.bounds.size.width, y: 0, width: UIScreen.main.bounds.size.width,height: UIScreen.main.bounds.size.height)
            self.view.layoutIfNeeded()
            self.view.backgroundColor = UIColor.clear
        }, completion: { (finished) -> Void in
            self.view.removeFromSuperview()
            self.removeFromParentViewController()
        })
    }
    
    // Api Hit
    
    func updateBusinessImage(image:UIImage, imageName:String) {
        NetworkingWrapper.sharedInstance.connectWithMultiPart(urlEndPoint: ApiEndPoints.Business.updateBusinessProfileImage + "/" + getUserData(.businessId), httpMethod: .put, headers: ApiHeaders.sharedInstance.headerWithAuth(), images: [image], imageName: imageName) { (response) in
            if response.code == 200 {
                CustomAlertController.sharedInstance.showAlert(subTitle: localizedTextFor(key: GeneralText.imageUploadedSuccess.rawValue), type: .success)
                let resultObj = response.result as! NSDictionary
             
                self.updateSalonImageInUserDefault(resultDict:resultObj)
                if self.isCoverImageView {
                    //self.coverImageView.image = image
                }
                else {
                    self.businessProfileImageView.image = image
                }
            }
            else {
                CustomAlertController.sharedInstance.showErrorAlert(error: response.error!)
            }
        }
    }
    
    func getBusinessById() {
        let url = ApiEndPoints.userModule.getBusinessById + "/" + getUserData(.businessId) + "/" + getUserData(._id)
        NetworkingWrapper.sharedInstance.connect(urlEndPoint: url, httpMethod: .get) { (response) in
            if response.code == 200 {
                let resultDict = response.result as! NSDictionary
                printToConsole(item: resultDict)
                let isApproved = resultDict["isApproved"] as? Bool
                userDefault.set(isApproved, forKey:"isApproved")
                self.updateSalonImageInUserDefault(resultDict:resultDict)
                self.updateImages()
            }
            else {
                CustomAlertController.sharedInstance.showErrorAlert(error: response.error!)
            }
        }
    }
    
    func updateSalonImageInUserDefault(resultDict:NSDictionary) {
        let profileImageUrl = resultDict[PhotoType.profileImage] as? String ?? ""
        let coverImageUrl = resultDict[PhotoType.coverPhoto] as? String ?? ""
        
        userDefault.set(profileImageUrl, forKey: userDefualtKeys.saloonProfileImage.rawValue)
        userDefault.set(coverImageUrl, forKey: userDefualtKeys.saloonCoverImage.rawValue)
    }
}

extension MenuViewControllerBusiness: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayMenuOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReUseIdentifier) as! SideMenuTableViewCell
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

extension MenuViewControllerBusiness: CustomImagePickerProtocol{
    func didFinishPickingImage(image:UIImage) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        if self.isCoverImageView {
            updateBusinessImage(image: image, imageName: PhotoType.coverPhoto)
        }
        else {
            updateBusinessImage(image: image, imageName: PhotoType.profileImage)
        }
    }
    
    func didCancelPickingImage() {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
}


