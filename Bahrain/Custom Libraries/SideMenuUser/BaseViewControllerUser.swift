/** This is customized version of the side menu for the user module.
 The original one is available at
 URL :- http://ashishkakkad.com/2015/09/create-your-own-slider-menu-drawer-in-swift/
 */
import UIKit

class BaseViewControllerUser: UIViewController, SlideMenuDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func slideMenuItemSelectedAtIndex(_ index: Int32) {
        switch(index){
        case 0:
            self.navigationController?.setNavigationBarHidden(false, animated: true)
            //            openViewControllerBasedOnIdentifier(ViewControllersIds.HomeViewControllerIds)

           // CustomAlertController.sharedInstance.showComingSoonAlert()
            
        case 1:
            openViewControllerBasedOnIdentifier(ViewControllersIds.SearchViewControllerID)
           // CustomAlertController.sharedInstance.showComingSoonAlert()
            
        case 2:
            
            if !isUserLoggedIn() {
               CommonFunctions.sharedInstance.showLoginAlert(referenceController: self)
            }
            else {
                openViewControllerBasedOnIdentifier(ViewControllersIds.MyAppointmentsViewControllerID)
              //  CustomAlertController.sharedInstance.showComingSoonAlert()
            }
            
        case 3:
            
            if !isUserLoggedIn() {
                CommonFunctions.sharedInstance.showLoginAlert(referenceController: self)
            }
            else {
                openViewControllerBasedOnIdentifier(ViewControllersIds.WalletViewControllerID)
                //  CustomAlertController.sharedInstance.showComingSoonAlert()
            }
            
            
        case 4:
            if !isUserLoggedIn() {
                CommonFunctions.sharedInstance.showLoginAlert(referenceController: self)
            }
            else {
                openViewControllerBasedOnIdentifier(ViewControllersIds.FavoriteListViewControllerID)
                // CustomAlertController.sharedInstance.showComingSoonAlert()
            }
        case 5 :
            if !isUserLoggedIn() {
                CommonFunctions.sharedInstance.showLoginAlert(referenceController: self)
            }
            else {
                openViewControllerBasedOnIdentifier(ViewControllersIds.messageViewController)
                // CustomAlertController.sharedInstance.showComingSoonAlert()
            }
        case 6 :
            if !isUserLoggedIn() {
                CommonFunctions.sharedInstance.showLoginAlert(referenceController: self)
            }
            else {
                openViewControllerBasedOnIdentifier(ViewControllersIds.NotifyViewControllerID)
                //   CustomAlertController.sharedInstance.showComingSoonAlert()
            }
        case 7 :
            if !isUserLoggedIn() {
                CommonFunctions.sharedInstance.showLoginAlert(referenceController: self)
            }
            else {
                openViewControllerBasedOnIdentifier(ViewControllersIds.SendFeedBackViewControllerID)
             //   CustomAlertController.sharedInstance.showComingSoonAlert()
            }
        case 8 :
                openViewControllerBasedOnIdentifier(ViewControllersIds.privacyPolicyViewControllerID)
        case 9 :
            if !isUserLoggedIn() {
                CommonFunctions.sharedInstance.showLoginAlert(referenceController: self)
            }
            else {
                openViewControllerBasedOnIdentifier(ViewControllersIds.ProfileSettingViewControllerID)
              
            }
        case 10:
            if !isUserLoggedIn() {
                moveToLoginScreen()
            }
            else {
                showLogoutAlert()
            }
            
        default:
            break
        }
    }
    
    func openViewControllerBasedOnIdentifier(_ strIdentifier:String){
        let destViewController : UIViewController = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: strIdentifier)
        
        let topViewController : UIViewController = self.navigationController!.visibleViewController!
        
        if (topViewController.restorationIdentifier! == destViewController.restorationIdentifier!){
        }
        else {
            self.navigationController!.pushViewController(destViewController, animated: true)
        }
    }
    
    func addSlideMenuButton(){
        let customBarButton = UIBarButtonItem(image: #imageLiteral(resourceName: "sideMenu"), style: .plain, target: self, action: #selector(onSlideMenuButtonPressed(_:)))
        customBarButton.tintColor = UIColor.white
        self.navigationItem.leftBarButtonItem = customBarButton
    }
    
    @objc func onSlideMenuButtonPressed(_ sender : UIButton){
        if (sender.tag == 10)
        {
            // To Hide Menu If it already there
            self.slideMenuItemSelectedAtIndex(-1);
            
            sender.tag = 0;
            
            let viewMenuBack : UIView = view.subviews.last!
            
            UIView.animate(withDuration: 0.3, animations: { () -> Void in
                var frameMenu : CGRect = viewMenuBack.frame
                frameMenu.origin.x = -1 * UIScreen.main.bounds.size.width
                viewMenuBack.frame = frameMenu
                viewMenuBack.layoutIfNeeded()
                viewMenuBack.backgroundColor = UIColor.clear
            }, completion: { (finished) -> Void in
                viewMenuBack.removeFromSuperview()
                self.navigationController?.isNavigationBarHidden = false
            })
            
            return
        }
        
        sender.isEnabled = false
        sender.tag = 10
        
        let menuVC : MenuViewControllerUser = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: "MenuViewControllerUserID") as! MenuViewControllerUser
        menuVC.btnMenu = sender
        menuVC.delegate = self
        self.view.addSubview(menuVC.view)
        self.addChildViewController(menuVC)
        menuVC.view.layoutIfNeeded()
        
        
        let languageIdentifier = UserDefaults.standard.value(forKey: userDefualtKeys.currentLanguage.rawValue) as! String
        if languageIdentifier == Languages.Arabic {
           menuVC.view.frame=CGRect(x: UIScreen.main.bounds.size.width*2, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height);
        }
        else {
            menuVC.view.frame=CGRect(x: 0 - UIScreen.main.bounds.size.width, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height);
        }
        
        printToConsole(item: menuVC.view.frame)

        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            menuVC.view.frame=CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height);
            self.navigationController?.setNavigationBarHidden(true, animated: true)
            
            if menuVC.view.frame.size.height > UIScreen.main.bounds.size.height + 49 {
                menuVC.view.frame.size.height = UIScreen.main.bounds.size.height + 49
            }
            sender.isEnabled = true
        }){ (bool) in
            printToConsole(item: menuVC.view.frame)
        }
    }
    
    //localizedTextFor(key: UserSideMenuText.logoutMessage.rawValue)
    
    func showLogoutAlert() {
        let alertController = PMAlertController(textForegroundColor:UIColor.darkGray, viewBackgroundColor: UIColor.white, title: localizedTextFor(key: UserSideMenuText.logoutAlert.rawValue), description: "", image: nil, style: .alert)
        alertController.addAction(PMAlertAction(title: localizedTextFor(key: GeneralText.no.rawValue), style: .default, action: {
            alertController.dismiss(animated: true, completion: nil)
            self.navigationController?.setNavigationBarHidden(false, animated: true)
        }))
        
        alertController.addAction(PMAlertAction(title: localizedTextFor(key: GeneralText.yes.rawValue), style: .default, action: {
            alertController.dismiss(animated: true, completion: nil)

            self.hitLogoutApi()
            
         CoreDataWrapper.sharedInstance.dropAllData()
            
        }))
        
        present(alertController, animated: true, completion: nil)
    }
    
    func hitLogoutApi() {
        NetworkingWrapper.sharedInstance.connect(urlEndPoint: ApiEndPoints.userModule.logout + "/" + getUserData(._id), httpMethod: .put, headers:ApiHeaders.sharedInstance.headerWithAuth()) { (response) in
            //if response.code == 200 {
                
                // updating user log in status in user default
                userDefault.set(false, forKey: userDefualtKeys.userLoggedIn.rawValue)
                
                // updating user data in user default
                userDefault.removeObject(forKey: userDefualtKeys.UserObject.rawValue)
            
            userDefault.removeObject(forKey: userDefualtKeys.saloonProfileImage.rawValue)
            userDefault.removeObject(forKey: userDefualtKeys.saloonCoverImage.rawValue)
            userDefault.removeObject(forKey: userDefualtKeys.registeredDate.rawValue)
            
            
            userDefault.set(false, forKey: userDefualtKeys.isBusinessDelete.rawValue)
            
                
                // Clears app delegate user object dictioary
                appDelegateObj.userDataDictionary.removeAllObjects()
                
                self.moveToLoginScreen()
//            }
//            else {
//                CustomAlertController.sharedInstance.showErrorAlert(error: response.error!)
//            }
        }
    }
    
    func moveToLoginScreen() {
       let initialNavigationController = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: ViewControllersIds.LoginViewControllerID)
        let navCtrl = OnBoardingModuleNavigationController(rootViewController: initialNavigationController)
        appDelegateObj.window?.rootViewController = navCtrl
        appDelegateObj.window?.makeKeyAndVisible()
        
    }
}
