
import UIKit

class PrivacyPolicyViewController: UIViewController {
    
    @IBOutlet weak var textViewPrivacyPolicy: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        CommonFunctions.sharedInstance.setNavigationTitleView(titleStr: localizedTextFor(key: UserSideMenuText.privacyPolicy.rawValue), onVC: self)
        getPrivacyPolicy()
    }
    
    func getPrivacyPolicy() {
        NetworkingWrapper.sharedInstance.connect(urlEndPoint: ApiEndPoints.userModule.privacyPolicy, httpMethod: .get) { (response) in
            if response.code == 200 {
                if let dataDict = response.result as? [String: Any] {
                    self.textViewPrivacyPolicy.text = dataDict["privacyPolicy"] as? String
                }
            } else {
                CustomAlertController.sharedInstance.showErrorAlert(error: response.error!)
            }
        }
    }

}
