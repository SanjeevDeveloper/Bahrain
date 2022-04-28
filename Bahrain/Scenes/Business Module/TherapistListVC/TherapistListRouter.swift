
import UIKit

 protocol TherapistListRoutingLogic
{
   func routeToEditTherapist(segue: UIStoryboardSegue?, dict: TherapistList.ViewModel.tableCellData)
}

protocol TherapistListDataPassing
{
  var dataStore: TherapistListDataStore? { get }
}

class TherapistListRouter: NSObject, TherapistListRoutingLogic, TherapistListDataPassing
{
  weak var viewController: TherapistListViewController?
  var dataStore: TherapistListDataStore?
  
  // MARK: Routing
  
    func routeToEditTherapist(segue: UIStoryboardSegue?, dict: TherapistList.ViewModel.tableCellData)
    {
        let destinationVC = viewController?.storyboard?.instantiateViewController(withIdentifier: ViewControllersIds.AddTherapistViewControllerID) as! AddTherapistViewController
        var destinationDS = destinationVC.router!.dataStore!
        passDataToSomewhere(source: dataStore!, destination: &destinationDS, dict: dict)
        navigateToSomewhere(source: viewController!, destination: destinationVC)

    }

  // MARK: Navigation
  
  func navigateToSomewhere(source: TherapistListViewController, destination: AddTherapistViewController)
  {
    viewController?.navigationController?.pushViewController(destination, animated: true)
  }
  
  // MARK: Passing data
  
  func passDataToSomewhere(source: TherapistListDataStore, destination: inout AddTherapistDataStore, dict:TherapistList.ViewModel.tableCellData)
  {
      destination.therapistData = dict
       destination.screenName = "editTherapist"
  }
}
