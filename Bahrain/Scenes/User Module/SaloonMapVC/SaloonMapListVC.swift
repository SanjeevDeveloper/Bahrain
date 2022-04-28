
import UIKit
import GoogleMaps
import MapKit

class SaloonMapListVC: UIViewController {
    
    @IBOutlet var mapView: GMSMapView!
    @IBOutlet var directionButton: UIButton!
    
    var currentLat:Double!
    var currentLong:Double!
    var saloonsArray = [FavoriteList.ApiViewModel.tableCellData]()
    var selectedId = ""
    
    var markers = [GMSMarker]()
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mapView.delegate = self
        updateMap()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        CommonFunctions.sharedInstance.setNavigationTitleView(titleStr:  localizedTextFor(key: MapSceneText.MapSceneTitle.rawValue), onVC: self)
    }
    
    // MARK: UIButton Actions
    
    @IBAction func directionButtonAction(_ sender: Any) {
        if LocationWrapper.sharedInstance.latitude != 0.0 {
            CommonFunctions.sharedInstance.openGoogleMap(destinationLatitude: currentLat, destinationLongitude: currentLong)
        }
        else {
            LocationWrapper.sharedInstance.fetchLocation()
        }
    }
    
    // MARK: Custom methods
    
    func updateMap() {
        if saloonsArray.count != 0 {
            
            let firstObj = saloonsArray[0]
            if let latitude = firstObj.latitude {
                if let longitude = firstObj.longitude {
                    let camera: GMSCameraPosition = GMSCameraPosition.camera(withLatitude: latitude, longitude: longitude, zoom: 18.0)
                    self.mapView.camera = camera
                    self.mapView.mapType = .normal
                }
            }
            
            
            for obj in saloonsArray {
                if let latitude = obj.latitude {
                    if let longitude = obj.longitude {
                        let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                        let locationMarker = GMSMarker(position: location)
                        locationMarker.icon = #imageLiteral(resourceName: "MapMarker")
                        locationMarker.title = obj.name
                        locationMarker.map = self.mapView
                        locationMarker.userData = obj
                        markers.append(locationMarker)
                    }
                }
            }
            
            let bounds = markers.reduce(GMSCoordinateBounds()) {
                $0.includingCoordinate($1.position)
            }
            mapView.animate(with: .fit(bounds, withPadding: 70.0))
        }
    }
}

// MARK: GMSMapViewDelegate

extension SaloonMapListVC: GMSMapViewDelegate {
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        directionButton.isHidden = false
        self.currentLat = marker.position.latitude
        self.currentLong = marker.position.longitude
        return false
    }
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        directionButton.isHidden = true
    }
    
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        let storyBoard = AppStoryboard.Main.instance
        let salonDetailVC = storyBoard.instantiateViewController(withIdentifier: "SalonDetailViewControllerID") as! SalonDetailViewController
        var destinationDS = salonDetailVC.router?.dataStore!
        destinationDS?.saloonId = self.selectedId
        self.hideBackButtonTitle()
        self.navigationController?.pushViewController(salonDetailVC, animated: true)
    }
    
    /* set a custom Info Window */
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        let view = infoView()
        if let markerData = marker.userData as? FavoriteList.ApiViewModel.tableCellData {
            view.frame = CGRect.init(x: 0, y: 0, width: 150, height: 40)
            view.firstLabel.text = markerData.name
            view.firstLabel.textColor = UIColor.black
            self.selectedId = markerData.saloonId
        }
        return view
    }
}
