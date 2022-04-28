

import UIKit

@objc protocol BookingSettingRoutingLogic
{
  //func routeToSomewhere(segue: UIStoryboardSegue?)
}

protocol BookingSettingDataPassing
{
  var dataStore: BookingSettingDataStore? { get }
}

class BookingSettingRouter: NSObject, BookingSettingRoutingLogic, BookingSettingDataPassing
{
  weak var viewController: BookingSettingViewController?
  var dataStore: BookingSettingDataStore?
  
  // MARK: Routing
  
  //func routeToSomewhere(segue: UIStoryboardSegue?)
  //{
  //  if let segue = segue {
  //    let destinationVC = segue.destination as! SomewhereViewController
  //    var destinationDS = destinationVC.router!.dataStore!
  //    passDataToSomewhere(source: dataStore!, destination: &destinationDS)
  //  } else {
  //    let storyboard = UIStoryboard(name: "Main", bundle: nil)
  //    let destinationVC = storyboard.instantiateViewController(withIdentifier: "SomewhereViewController") as! SomewhereViewController
  //    var destinationDS = destinationVC.router!.dataStore!
  //    passDataToSomewhere(source: dataStore!, destination: &destinationDS)
  //    navigateToSomewhere(source: viewController!, destination: destinationVC)
  //  }
  //}

  // MARK: Navigation
  
  //func navigateToSomewhere(source: BookingSettingViewController, destination: SomewhereViewController)
  //{
  //  viewController?.navigationController?.pushViewController(destination, animated: true)
  //}
  
  // MARK: Passing data
  
  //func passDataToSomewhere(source: BookingSettingDataStore, destination: inout SomewhereDataStore)
  //{
  //  destination.name = source.name
  //}
}
