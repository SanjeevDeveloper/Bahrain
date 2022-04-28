
import UIKit

class IBeautyTabBarController: UITabBarController, UITabBarControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabs()
        self.delegate = self
    }
    
    func setupTabs() {
        let firstTab:UITabBarItem = self.tabBar.items![0]
        firstTab.title = localizedTextFor(key: TabBarText.homeTabTitle.rawValue)
        firstTab.image = #imageLiteral(resourceName: "homeTabIcon")
        
        let secondTab:UITabBarItem = self.tabBar.items![1]
        secondTab.title = localizedTextFor(key: TabBarText.appointmentTabTitle.rawValue)
        secondTab.image = #imageLiteral(resourceName: "appointmentTabIcon")
        
        let thirdTab:UITabBarItem = self.tabBar.items![2]
        thirdTab.title = localizedTextFor(key: TabBarText.messagesTabTitle.rawValue)
        thirdTab.image = #imageLiteral(resourceName: "messagesTabIcon")
        
        let fourthTab:UITabBarItem = self.tabBar.items![3]
        fourthTab.title = localizedTextFor(key: TabBarText.profileTabTitle.rawValue)
        fourthTab.image = #imageLiteral(resourceName: "profileTabIcon")
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if !isUserLoggedIn() {
            CommonFunctions.sharedInstance.showLoginAlert(referenceController: self)
            return false
        }
        return true
    }
    
}
