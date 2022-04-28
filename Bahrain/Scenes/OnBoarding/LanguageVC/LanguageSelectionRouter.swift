

import UIKit

@objc protocol LanguageSelectionRoutingLogic
{
    func routeToLogin(segue: UIStoryboardSegue?, languageIdentifier:String)
}

protocol LanguageSelectionDataPassing
{
  var dataStore: LanguageSelectionDataStore? { get }
}

class LanguageSelectionRouter: NSObject, LanguageSelectionRoutingLogic, LanguageSelectionDataPassing
{
  weak var viewController: LanguageSelectionViewController?
  var dataStore: LanguageSelectionDataStore?
  
  // MARK: Routing
  
  func routeToLogin(segue: UIStoryboardSegue?, languageIdentifier:String) {
    userDefault.set(languageIdentifier, forKey: userDefualtKeys.currentLanguage.rawValue)
    if languageIdentifier == Languages.Arabic {
        userDefault.set([appleLanguages.Arabic], forKey: appleLanguagesKey)
        UIView.appearance().semanticContentAttribute = .forceRightToLeft
    }
    else {
        userDefault.set([appleLanguages.english], forKey: appleLanguagesKey)
        UIView.appearance().semanticContentAttribute = .forceLeftToRight
    }
  }

  // MARK: Navigation
  
  //func navigateToSomewhere(source: LanguageSelectionViewController, destination: SomewhereViewController)
  //{
  //  viewController?.navigationController?.pushViewController(destination, animated: true)
  //}
  
  // MARK: Passing data
  
  //func passDataToSomewhere(source: LanguageSelectionDataStore, destination: inout SomewhereDataStore)
  //{
  //  destination.name = source.name
  //}
}
