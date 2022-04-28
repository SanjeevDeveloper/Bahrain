
import UIKit
import MapKit

protocol UserPinLocationRoutingLogic {
    func routeToAddAddress(location: LocationData)
    func routeToProfileOrRegister(location: LocationData)
    func goBack()
}

protocol UserPinLocationDataPassing
{
  var dataStore: UserPinLocationDataStore? { get }
}

class UserPinLocationRouter: NSObject, UserPinLocationRoutingLogic, UserPinLocationDataPassing
{
  weak var viewController: UserPinLocationViewController?
  var dataStore: UserPinLocationDataStore?
  
  // MARK: Routing
    
    func routeToAddAddress(location: LocationData) {
        let destinationVC = viewController?.storyboard?.instantiateViewController(withIdentifier: "AddAddressViewControllerID") as! AddAddressViewController
        var destinationDS = destinationVC.router!.dataStore!
        destinationDS.bookingObject = dataStore?.bookingObject
        destinationDS.bookingId = dataStore?.bookingId
        destinationDS.location = location
        destinationDS.editObject = dataStore?.editObject
        viewController?.navigationController?.pushViewController(destinationVC, animated: true)
    }
    
    func routeToProfileOrRegister(location: LocationData) {
        if let vcArray = viewController?.navigationController?.viewControllers {
            let vc = vcArray[vcArray.count-2]
            if vc.isKind(of: ProfileSettingViewController.self) {
                let destinationVC = vc as! ProfileSettingViewController
                var destinationDS = destinationVC.router!.dataStore!
                passDataToProfileScreen( destination: &destinationDS, address: location)
            } else if vc.isKind(of: RegisterLocationViewController.self) {
                let destinationVC = vc as! RegisterLocationViewController
                var destinationDS = destinationVC.router!.dataStore!
                passDataToRegisterLocationScreen( destination: &destinationDS, address: location)
            }
        }
        viewController?.navigationController?.popViewController(animated: true)
    }
    
    func goBack() {
        if let vcArray = viewController?.navigationController?.viewControllers {
            let vc = vcArray[vcArray.count-2]
            if vc.isKind(of: AddressListViewController.self) {
                let destinationVC = vc as! AddressListViewController
                var destinationDS = destinationVC.router!.dataStore!
                destinationDS.bookingId = dataStore?.bookingId
            } else if vc.isKind(of: BookingSummaryViewController.self) {
                let destinationVC = vc as! BookingSummaryViewController
                var destinationDS = destinationVC.router!.dataStore!
                destinationDS.bookingId = dataStore?.bookingId
            }
        }
        viewController?.navigationController?.popViewController(animated: true)
    }
    
    // MARK: Passing data
    func passDataToRegisterLocationScreen(destination: inout RegisterLocationDataStore, address: LocationData) {
        let coordinate = CLLocationCoordinate2D(latitude: address.latitude.doubleValue(), longitude: address.longitude.doubleValue())
        destination.pinAddress = address.addressText
        destination.coordinate = coordinate
    }
    func passDataToProfileScreen(destination: inout ProfileSettingDataStore, address: LocationData) {
        let coordinate = CLLocationCoordinate2D(latitude: address.latitude.doubleValue(), longitude: address.longitude.doubleValue())
        destination.pinAddress = address.addressText
        destination.coordinate = coordinate
    }
}
