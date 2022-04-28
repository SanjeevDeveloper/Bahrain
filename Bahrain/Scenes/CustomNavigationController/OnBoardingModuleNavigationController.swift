
import UIKit

class OnBoardingModuleNavigationController: UINavigationController {
    
    override func viewDidLoad() {
        self.edgesForExtendedLayout = UIRectEdge.init(rawValue: 0)
        self.view.tintColor = UIColor.white
        self.navigationBar.barTintColor = appBarThemeColor
        
       updateTitleFont()
        
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
