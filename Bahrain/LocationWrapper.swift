/**
 This class contains functions related to Core location framework
 */
import UIKit
import CoreLocation

class LocationWrapper: NSObject {
    
    static let sharedInstance = LocationWrapper()
    
    let locationManager = CLLocationManager()
    var latitude:Double = 0.0
    var longitude:Double = 0.0
    
    /**
     Call this function to fetch current location
     */

    func fetchLocation() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() && CLLocationManager.authorizationStatus() != .denied {
            locationManager.startUpdatingLocation()
        }
        else {
            showPermissionAlert()
        }
    }
    
    func updateLocation() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() && CLLocationManager.authorizationStatus() != .denied {
            locationManager.startUpdatingLocation()
        }
    }
    
    func showPermissionAlert() {
        var alertWindow:UIWindow?
        alertWindow = UIWindow(frame: UIScreen.main.bounds)
        alertWindow?.rootViewController = UIViewController()
        alertWindow?.windowLevel = (appDelegateObj.window?.windowLevel)! + 1
        alertWindow?.makeKeyAndVisible()
        
        
        let alertController = PMAlertController(textForegroundColor:UIColor.darkGray, viewBackgroundColor: UIColor.white, title: localizedTextFor(key: GeneralText.permissionHeading.rawValue), description: localizedTextFor(key: GeneralText.gpsPermission.rawValue), image: nil, style: .alert)
        alertController.addAction(PMAlertAction(title: localizedTextFor(key: GeneralText.ok.rawValue), style: .default, action: {
            alertController.dismiss(animated: true, completion: nil)
            
            alertWindow?.resignKey()
            alertWindow = nil
            appDelegateObj.window?.makeKeyAndVisible()
        }))
        
        alertWindow?.rootViewController?.present(alertController, animated: true, completion: nil)
    }
}

extension LocationWrapper:CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let locationCoordinate = locations.last?.coordinate {
            manager.delegate = nil
            manager.stopUpdatingLocation()
            self.longitude = locationCoordinate.longitude
            self.latitude = locationCoordinate.latitude
        }
        locationManager.stopUpdatingLocation()
    }
}
