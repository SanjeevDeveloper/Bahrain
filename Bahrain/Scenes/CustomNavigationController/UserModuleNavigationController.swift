
import UIKit

class UserModuleNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        updateTitleFont()
        //self.edgesForExtendedLayout = UIRectEdge.init(rawValue: 0)
//      navImageAndTitleSet(TitleStr: "Login")
        self.navigationBar.barTintColor = appBarThemeColor
        self.view.tintColor = UIColor.white
        
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
    
    func setNavigationTitleView(titleStr:String, onVC: UIViewController){
        let navView = UIView()
        // Create the label
        let navTitleLabel = UILabel()
        navTitleLabel.text = localizedTextFor(key: LoginSceneText.loginSceneTitle.rawValue)
        navTitleLabel.text = "home"
        navTitleLabel.sizeToFit()
        navTitleLabel.textColor = UIColor.white
        navTitleLabel.center = navView.center
        navTitleLabel.textAlignment = NSTextAlignment.center
        
        // Create the image view
        let navImageView = UIImageView()
        navImageView.image = UIImage(named: "logo_icon")
        let imageAspect = navImageView.image!.size.width/navImageView.image!.size.height
        navImageView.frame = CGRect(x: navTitleLabel.frame.origin.x-navTitleLabel.frame.size.height*imageAspect, y: navTitleLabel.frame.origin.y, width: navTitleLabel.frame.size.height*imageAspect, height: navTitleLabel.frame.size.height)
        navImageView.contentMode = UIViewContentMode.scaleAspectFit
        
        // Add both the label and image view to the navView
        navView.addSubview(navTitleLabel)
        navView.addSubview(navImageView)
        onVC.navigationItem.titleView = navView

    }
}
