/** This is custom made class to show and hide activity indicator
 */
import UIKit
public class ManageHudder {
    
    public static let sharedInstance = ManageHudder()
    
    var alertWindow: UIWindow?
    
    /**
     This function will show the activity indicator in centre of the screen.
     
     ### Usage Example: ###
     ````
     ManageHudder.sharedInstance.startActivityIndicator()
     ````
     */
    
    public func startActivityIndicator() {
        alertWindow = UIWindow(frame: UIScreen.main.bounds)
        alertWindow?.rootViewController = UIViewController()
        alertWindow?.windowLevel = UIWindow.Level.alert + 1
        alertWindow?.makeKeyAndVisible()
        
        let sourceView = alertWindow?.rootViewController!.view!
        let spinnerView = makeActivityIndicatorView()
        sourceView?.addSubview(spinnerView)
        spinnerView.center = (sourceView?.center)!
        spinnerView.layer.cornerRadius = 14
        
    }
    
    func makeActivityIndicatorView() -> UIView {
        let requiredFrame = CGRect(origin: CGPoint.zero, size: CGSize(width: 134.0, height: 120.0))
        let spinnerView = UIView(frame: requiredFrame)
        spinnerView.backgroundColor = UIColor(white: 0.0, alpha: 0.8)
        
        let av = UIActivityIndicatorView()
        av.style = .whiteLarge
        av.color = UIColor.white
        av.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        
        spinnerView.addSubview(av)
        av.center = spinnerView.center
        av.startAnimating()
        
        return spinnerView
    }
    
    
    /**
     This function will hide the currently showing activity indicator.
     
     ### Usage Example: ###
     ````
     ManageHudder.sharedInstance.stopActivityIndicator()
     ````
     */
    
    public func stopActivityIndicator() {
        if let sourceView = alertWindow?.rootViewController!.view! {
            sourceView.subviews[0].removeFromSuperview()
            alertWindow?.resignKey()
        }
        alertWindow = nil
    }
    
}
