
import UIKit
import GoogleMaps
import MapKit

class PreferredLocationViewController: UIViewController {
    
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var currentLocationButton: UIButton!
    @IBOutlet weak var mapPin: UIImageView!
    @IBOutlet weak var findSalonsButton: UIButtonCustomClass!
    
    var updateListingWithCoordinate: ((Double, Double) -> Void)?
    override func viewDidLoad() {
        super.viewDidLoad()
        currentLocationButton.setTitle("  " + localizedTextFor(key: GeneralText.useMyCurrentLocation.rawValue), for: .normal)
        
        currentLocationButton.setTitle("  " + localizedTextFor(key: GeneralText.useMyCurrentLocation.rawValue), for: .selected)
        DispatchQueue.main.async {
            if LocationWrapper.sharedInstance.latitude != 0.0 {
                self.setMapPosition()
            }
            else {
                LocationWrapper.sharedInstance.fetchLocation()
            }
        }
        self.navigationController?.isNavigationBarHidden = true
    }
    func setMapPosition() {
        let camera: GMSCameraPosition = GMSCameraPosition.camera(withLatitude: LocationWrapper.sharedInstance.latitude, longitude: LocationWrapper.sharedInstance.longitude, zoom: 18.0)
        self.mapView.camera = camera
        self.mapView.mapType = .normal
        updateListingWithCoordinate?(LocationWrapper.sharedInstance.latitude, LocationWrapper.sharedInstance.longitude)
    }

    
    @IBAction func onClickedCurrentLocationButton(_ sender: Any) {
        self.navigationController?.isNavigationBarHidden = false
        updateListingWithCoordinate?(LocationWrapper.sharedInstance.latitude, LocationWrapper.sharedInstance.longitude)
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func onClickedFindSalonsButton(_ sender: Any) {
        self.navigationController?.isNavigationBarHidden = false
        let centerPosition = mapView.center
        let coordinates = mapView.projection.coordinate(for: centerPosition)
        updateListingWithCoordinate?(coordinates.latitude, coordinates.longitude)
        self.navigationController?.popViewController(animated: true)
    }
}
// MARK: GMSMapViewDelegate
extension PreferredLocationViewController: GMSMapViewDelegate {
    
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        
    }
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        let centerPosition = mapView.center
        let coordinates = mapView.projection.coordinate(for: centerPosition)
        printToConsole(item: coordinates)
    }
    
}
