

import UIKit

protocol LanguageSelectionBusinessLogic
{
}

protocol LanguageSelectionDataStore
{
}

class LanguageSelectionInteractor: LanguageSelectionBusinessLogic, LanguageSelectionDataStore
{
  var presenter: LanguageSelectionPresentationLogic?
  var worker: LanguageSelectionWorker?
  
}
