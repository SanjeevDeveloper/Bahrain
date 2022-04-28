
import UIKit
import SwiftyGif

class AnimatedSplashViewController: UIViewController {
    
    @IBOutlet weak var gifImageView:UIImageView!
    @IBOutlet weak var labelVersion: UILabel!
    
    // MARK: life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        let info = Bundle.main.infoDictionary ?? [:]
        let currentVersion = info["CFBundleShortVersionString"] as? String ?? ""
        labelVersion.text = "Version " + currentVersion
        self.hitSpalshApi()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    func checkForUpdate() {
        isUpdateAvailable { (bool) in
            if bool {
                self.popupUpdateDialogue()
            } else {
                self.checkUserLoginStatus()
            }
        }
    }
    
    func popupUpdateDialogue() {
        let alertMessage = "A new version of Application is available, Please update"
        let alert = UIAlertController(title: "New Version Available", message: alertMessage, preferredStyle: UIAlertControllerStyle.alert)

        let appUrlString = "itms-apps://itunes.apple.com/bh/app/id1472497719"

        let okBtn = UIAlertAction(title: "Update", style: .default, handler: {(_ action: UIAlertAction) -> Void in
            if let url = URL(string: appUrlString),
                UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        })
        alert.addAction(okBtn)
        present(alert, animated: true, completion: nil)
    }
    
    func isUpdateAvailable(completion: @escaping((Bool) ->())) {
        guard let info = Bundle.main.infoDictionary,
            let currentVersion = info["CFBundleShortVersionString"] as? String,
            let identifier = info["CFBundleIdentifier"] as? String,
            let url = URL(string: "http://itunes.apple.com/lookup?bundleId=\(identifier)") else {
                print("invalid bundle info")
                completion(false)
                return
        }
        do { let data = try Data(contentsOf: url)
            do { guard let json = try JSONSerialization.jsonObject(with: data, options: [.allowFragments]) as? [String: Any] else {
                print("invalid response")
                completion(false)
                return
                }
                if let result = (json["results"] as? [Any])?.first as? [String: Any], let version = result["version"] as? String {
                    print("version in app store", version,currentVersion);
                    completion(version.doubleValue() > currentVersion.doubleValue())
                } else {
                    print("incomplete data")
                    completion(false)
                }
            } catch {
                print("exception")
                completion(false)
            }
        } catch {
            print("exception")
            completion(false)
        }
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
    }
    
    func hitSpalshApi() {
        NetworkingWrapper.sharedInstance.connectSp(urlEndPoint: ApiEndPoints.userModule.splashData, httpMethod: .get, parameters: nil) { (response) in
            
            if response.code == 200 {
                let apiResponseDict = response.result as! NSDictionary
                let resultArr = apiResponseDict["listSplash"] as! [[String: Any]]
                let obj = resultArr[0]
                let imgStr = obj["splashImage"] as! String
                let fileUrl = URL(string: imgStr)
               // self.gifImageView.downloaded(from: imgStr!)
                self.gifImageView.sd_setImage(with: fileUrl, completed: nil)
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    self.checkForUpdate()
                }
            }
            else {
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    self.checkForUpdate()
                }
                CustomAlertController.sharedInstance.showErrorAlert(error: response.error!)
            }
            
            //let imgUrl = response.results.listSplash[0].splashImage as String
//            let imgUrl = response
//
//            print(imgUrl)
            
            
            
           // self.gifImageView.downloaded(from: "https://cdn.arstechnica.net/wp-content/uploads/2018/06/macOS-Mojave-Dynamic-Wallpaper-transition.jpg")
        }
    }
    
    // MARK: CheckUserLoginStatus
    func checkUserLoginStatus() {
        if userDefault.bool(forKey: userDefualtKeys.userLoggedIn.rawValue) {
             let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
               let destinationVc = mainStoryBoard.instantiateViewController(withIdentifier: ViewControllersIds.HomeViewControllerIds) as! HomeViewController
               let navCtrl = UserModuleNavigationController(rootViewController: destinationVc)
               let appDelegate = UIApplication.shared.delegate as! AppDelegate
               appDelegate.window?.rootViewController = navCtrl
        }else {
            
            if let _ = UserDefaults.standard.value(forKey: userDefualtKeys.currentLanguage.rawValue) as? String {
                let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
                let destinationVc = mainStoryBoard.instantiateViewController(withIdentifier: ViewControllersIds.LoginViewControllerID) as! LoginViewController
                let navCtrl = OnBoardingModuleNavigationController(rootViewController: destinationVc)
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.window?.rootViewController = navCtrl
            } else {
                let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
                let destinationVc = mainStoryBoard.instantiateViewController(withIdentifier: ViewControllersIds.LanguageSelectionViewControllerID) as! LanguageSelectionViewController
                let navCtrl = OnBoardingModuleNavigationController(rootViewController: destinationVc)
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.window?.rootViewController = navCtrl
            }
            
//            let initialNavigationController = storyboard?.instantiateViewController(withIdentifier: ViewControllersIds.InitialControllerID)
//            setRootControllerWithAnimation(controller:initialNavigationController!, destinationView:(initialNavigationController?.view)!)
        }
    }
    
    // MARK: SetRootControllerWithAnimation
    func setRootControllerWithAnimation(controller:UIViewController, destinationView:UIView) {
        let firstClassView = self.view
        let secondClassView = destinationView
        
        let screenWidth = UIScreen.main.bounds.size.width
        let screenHeight = UIScreen.main.bounds.size.height
        
        secondClassView.frame = CGRect(x: screenWidth, y: 0, width: screenWidth, height: screenHeight)
        
        if let window = UIApplication.shared.keyWindow {
            
            window.insertSubview(secondClassView, aboveSubview: firstClassView!)
            
            UIView.animate(withDuration: 0.4, animations: { () -> Void in
                
                firstClassView?.frame = (firstClassView?.frame.offsetBy(dx: -screenWidth, dy: 0))!
                secondClassView.frame = (secondClassView.frame.offsetBy(dx: -screenWidth, dy: 0))
                
            }, completion: {(Finished) -> Void in
                appDelegateObj.window?.rootViewController = controller
                appDelegateObj.window?.makeKeyAndVisible()
            })
        }
    }
}

// MARK: SwiftyGifDelegate
extension AnimatedSplashViewController : SwiftyGifDelegate {
    func gifDidLoop(sender: UIImageView) {
    }
}

extension String {
    func doubleValue() -> Double {
        let nsString = self as NSString
        return nsString.doubleValue
    }
}
