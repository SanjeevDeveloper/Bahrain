

import UIKit

@objc protocol ViewProfileRoutingLogic
{
    func routeToAnotherScreen(identifier:String)
    func routeToAboutScreen(identifier:String)
    func routeToChat()
}

protocol ViewProfileDataPassing
{
  var dataStore: ViewProfileDataStore? { get }
}

class ViewProfileRouter: NSObject, ViewProfileRoutingLogic, ViewProfileDataPassing
{
  weak var viewController: ViewProfileViewController?
  var dataStore: ViewProfileDataStore?
  
  // MARK: Routing
    
    func routeToAnotherScreen(identifier:String)
    {
        let storyboard = AppStoryboard.Business.instance
        let destinationVC = storyboard.instantiateViewController(withIdentifier: identifier)
        viewController?.navigationController?.pushViewController(destinationVC, animated: true)
    }
    
    func routeToAboutScreen(identifier:String)
    {
        let destinationVC = viewController?.storyboard?.instantiateViewController(withIdentifier: identifier) as! AboutSalonViewController
        var ds = destinationVC.router?.dataStore
        passDataToAbout(destination: &ds!)
        viewController?.navigationController?.pushViewController(destinationVC, animated: true)
    }
    
    
    func routeToChat()
    {
        let destinationVC = AppStoryboard.Chat.instance.instantiateViewController(withIdentifier: ViewControllersIds.BusinessMessageViewControllerID) as! BusinessMessageViewController
//        var ds = destinationVC.router?.dataStore
//        passDataToChat(destination: ds! as! BusinessChatDataStore)
        viewController?.navigationController?.pushViewController(destinationVC, animated: true)
    }
    
    
    func passDataToAbout( destination: inout AboutSalonDataStore)
    {
        destination.resultDict = self.dataStore?.aboutResultDict
    }
  
    
//    func passDataToChat( destination: inout BusinessChatDataStore)
//    {
//        destination.salonName = self.dataStore?.saloonName
//        destination.salonImage = self.dataStore?.profileImage
//        destination.buisnessId = self.dataStore?.saloonId
//        destination.isFromMessage = "false"
//    }
    
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
  
  //func navigateToSomewhere(source: ViewProfileViewController, destination: SomewhereViewController)
  //{
  //  viewController?.navigationController?.pushViewController(destination, animated: true)
  //}
  
  // MARK: Passing data
  
  //func passDataToSomewhere(source: ViewProfileDataStore, destination: inout SomewhereDataStore)
  //{
  //  destination.name = source.name
  //}
}
