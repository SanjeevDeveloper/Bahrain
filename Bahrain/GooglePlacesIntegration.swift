
import UIKit
import GooglePlaces

class GooglePlacesIntegration {
  
  typealias placesResponse = (_ predictions: [GMSAutocompletePrediction]?, _ error: String?) ->()
  typealias detailResponse = (_ placeDetail: GMSPlace?, _ status: String?) ->()
  
  // MARK: google places autocomplete predictions
  
  static func googlePlacesAutoComplete(searchText: String, placesResponse: @escaping(placesResponse)) {
    let filter = GMSAutocompleteFilter()
    filter.type = .region
    filter.country = "BH"
    let placesClient = GMSPlacesClient()
    
    let bounds = GMSCoordinateBounds(coordinate: CLLocationCoordinate2D(latitude: -29.1457057, longitude: 137.3508090), coordinate: CLLocationCoordinate2D(latitude: -9.299398, longitude: 152.165501))
    
    placesClient.autocompleteQuery(searchText, bounds: bounds, boundsMode: GMSAutocompleteBoundsMode.bias, filter: filter) { (predictions: [GMSAutocompletePrediction]?, error) in
      
      DispatchQueue.main.async {
        if error != nil {
          if let error = error as NSError? {
            printToConsole(item: error)
            if error.code == -1 {
              placesResponse(nil, localizedTextFor(key: GeneralText.generalTextNoInternetError.rawValue))
            } else {
              placesResponse(nil, error.localizedDescription)
            }
          } else {
            placesResponse(nil, String(describing: error))
          }
        } else {
          placesResponse(predictions, nil)
        }
      }
    }
  }
  
  // MARK: google place detail
  
  static func getPlaceDetail(placeID: String, placeDetailResponse: @escaping(detailResponse)) {
    ManageHudder.sharedInstance.startActivityIndicator()
    let placesClient = GMSPlacesClient()
    placesClient.lookUpPlaceID(placeID) { (place, error) in
      DispatchQueue.main.async {
        ManageHudder.sharedInstance.stopActivityIndicator()
        let errorString = error?.localizedDescription
        
        guard let place = place else {
          placeDetailResponse(nil, errorString)
          return
        }
        
        placeDetailResponse(place, errorString)
      }
    }
  }
}
