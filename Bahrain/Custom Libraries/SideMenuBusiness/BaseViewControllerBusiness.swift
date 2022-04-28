/** This is customized version of the side menu for the business module.
 The original one is available at
 URL :- http://ashishkakkad.com/2015/09/create-your-own-slider-menu-drawer-in-swift/
 */
import UIKit

class BaseViewControllerBusiness: UIViewController, BusinessSlideMenuDelegate {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        printToConsole(item: "kjncjsdn")
    }
    
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func slideMenuItemSelectedAtIndex(_ index: Int32) {
        switch(index){
//        case 0:
//
//            getapproveddata()
//
//            if isApprove{
//                self.openViewControllerBasedOnIdentifier(ViewControllersIds.BusinessTodayViewControllerID)
//            }
//            else {
//                CustomAlertController.sharedInstance.showErrorAlert(error: localizedTextFor(key: BusinessSideMenuText.NotApproved.rawValue))
//            }
//        case 1:
//            getapproveddata()
//
//            if isApprove{
//                self.openViewControllerBasedOnIdentifier(ViewControllersIds.BusinessCalenderViewControllerID)
//            }
//            else {
//                CustomAlertController.sharedInstance.showErrorAlert(error: localizedTextFor(key: BusinessSideMenuText.NotApproved.rawValue))
//            }
//
//        case 2:
//            getapproveddata()
//
//            if isApprove{
//                self.openViewControllerBasedOnIdentifier(ViewControllersIds.BusinessBookingViewControllerID)
//            }else {
//                CustomAlertController.sharedInstance.showErrorAlert(error: localizedTextFor(key: BusinessSideMenuText.NotApproved.rawValue))
//            }
//
        case 0:
            // CustomAlertController.sharedInstance.showComingSoonAlert()
            self.openViewControllerBasedOnIdentifier(ViewControllersIds.SettingViewControllerID)
            
        default:
            break
        }
    }
    
    func openViewControllerBasedOnIdentifier(_ strIdentifier:String){
        let destViewController : UIViewController = self.storyboard!.instantiateViewController(withIdentifier: strIdentifier)
        
        let topViewController : UIViewController = self.navigationController!.topViewController!
        
        self.navigationController?.isNavigationBarHidden = false
        
        if (topViewController.restorationIdentifier! == destViewController.restorationIdentifier!){
        }
        else {
            self.navigationController!.setViewControllers([destViewController], animated: true)
        }
    }
    
    
    func addSlideMenuButton(){
        let customBarButton = UIBarButtonItem(image: #imageLiteral(resourceName: "sideMenu"), style: .plain, target: self, action: #selector(BaseViewControllerUser.onSlideMenuButtonPressed(_:)))
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
        
        let menuVC : MenuViewControllerBusiness = self.storyboard!.instantiateViewController(withIdentifier: "MenuViewControllerBusinessID") as! MenuViewControllerBusiness
        menuVC.btnMenu = sender
        menuVC.delegate = self
        self.view.addSubview(menuVC.view)
        self.addChildViewController(menuVC)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        menuVC.view.layoutIfNeeded()
        
        
        menuVC.view.frame=CGRect(x: 0 - UIScreen.main.bounds.size.width, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height);
        
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            menuVC.view.frame=CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height);
            
            sender.isEnabled = true
        }, completion:nil)
    }
}
