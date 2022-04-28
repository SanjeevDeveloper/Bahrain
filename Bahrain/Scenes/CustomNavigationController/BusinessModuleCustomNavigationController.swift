
import UIKit

class BusinessModuleCustomNavigationController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateTitleFont()
        self.edgesForExtendedLayout = UIRectEdge.init(rawValue: 0)
        self.navigationBar.barTintColor = appBarThemeColor
        self.view.tintColor = UIColor.white
        
        if getUserData(.businessId) == "" {
            appDelegateObj.isPageControlActive = true
            let listYourServiceObj = storyboard?.instantiateViewController(withIdentifier: ViewControllersIds.ListYourServiceViewControllerID)
            self.setViewControllers([listYourServiceObj!], animated: false)
        }
        else {
            appDelegateObj.isPageControlActive = true
            let businessPageViewControllerObj = storyboard?.instantiateViewController(withIdentifier: ViewControllersIds.BusinessPageViewControllerID)
            self.setViewControllers([businessPageViewControllerObj!], animated: false)
        }
        
        if #available(iOS 13.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = appBarThemeColor
            self.navigationBar.tintColor = .white
            self.navigationBar.standardAppearance = appearance
            self.navigationBar.scrollEdgeAppearance = appearance
        } else {
            // Fallback on earlier versions
        }
    }
    
    func updateTitleFont() {
        let attributes = [
            NSAttributedStringKey.font: UIFont(name: appFont, size: 19)!,
            NSAttributedStringKey.foregroundColor: UIColor.white]
        self.navigationBar.titleTextAttributes = attributes
    }

}
