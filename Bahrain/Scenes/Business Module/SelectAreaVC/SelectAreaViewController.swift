
import UIKit

protocol SelectAreaDisplayLogic: class
{
  func displaySomething(viewModel: SelectArea.ViewModel)
}

class SelectAreaViewController: UIViewController, SelectAreaDisplayLogic
{
  var interactor: SelectAreaBusinessLogic?
  var router: (NSObjectProtocol & SelectAreaRoutingLogic & SelectAreaDataPassing)?

 var selectAreaArray = [SelectArea.ViewModel.tableCellData]()
  // MARK: Object lifecycle
  
  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?)
  {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    setup()
  }
  
  required init?(coder aDecoder: NSCoder)
  {
    super.init(coder: aDecoder)
    setup()
  }
  
  // MARK: Setup
  
  private func setup()
  {
    let viewController = self
    let interactor = SelectAreaInteractor()
    let presenter = SelectAreaPresenter()
    let router = SelectAreaRouter()
    viewController.interactor = interactor
    viewController.router = router
    interactor.presenter = presenter
    presenter.viewController = viewController
    router.viewController = viewController
    router.dataStore = interactor
  }
  
  // MARK: Routing
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?)
  {
    if let scene = segue.identifier {
      let selector = NSSelectorFromString("routeTo\(scene)WithSegue:")
      if let router = router, router.responds(to: selector) {
        router.perform(selector, with: segue)
      }
    }
  }
  
  // MARK: View lifecycle
  
  override func viewDidLoad()
  {
    super.viewDidLoad()
    doSomething()
    applyLocalizedText()
    applyFontAndColor()
    let headerObject1 = SelectArea.ViewModel.tableSectionData(areaHeaderTitle: "Section A")
    let headerObject2 = SelectArea.ViewModel.tableSectionData(areaHeaderTitle: "Section B")
    let headerObject3 = SelectArea.ViewModel.tableSectionData(areaHeaderTitle: "Section C")
    
   let rowObject1 = SelectArea.ViewModel.tableRowData(areaListTitle: "Data One")
   let rowObject2 = SelectArea.ViewModel.tableRowData(areaListTitle: "Data TWo")
   let rowObject3 = SelectArea.ViewModel.tableRowData(areaListTitle: "Data Three")
   let rowObject4 = SelectArea.ViewModel.tableRowData(areaListTitle: "Data Four")
    
    let obj1 = SelectArea.ViewModel.tableCellData(header: headerObject1, row: [rowObject1,rowObject2,rowObject3])
    let obj2 = SelectArea.ViewModel.tableCellData(header: headerObject2, row: [rowObject1,rowObject2,rowObject3,rowObject4])
    let obj3 = SelectArea.ViewModel.tableCellData(header: headerObject3, row: [rowObject1,rowObject2,rowObject3,rowObject4])
    
    selectAreaArray.append(obj1)
    selectAreaArray.append(obj2)
    selectAreaArray.append(obj3)
  }
    
    // MARK: Apply Font And Color
    func applyFontAndColor() {
     searchTextField.textColor = appTxtfDarkColor
    }
    
    // MARK: Apply LocalizedText
    func applyLocalizedText() {
        CommonFunctions.sharedInstance.setNavigationTitleView(titleStr:   localizedTextFor(key: SelectAreaSceneText.SelectAreaSceneTitle.rawValue), onVC: self)
        
        let colorAttribute = [NSAttributedStringKey.foregroundColor: UIColor.white]
        let  searchTextFieldPlaceholder = NSMutableAttributedString(string: localizedTextFor(key: SelectAreaSceneText.SelectAreaSceneSelectAreaTextField.rawValue), attributes: colorAttribute)
        searchTextField.attributedPlaceholder = searchTextFieldPlaceholder
    }

    @IBOutlet weak var searchTextField: UITextFieldFontSize!
    @IBOutlet weak var searchAreaTableView: UITableView!
    
  
  func doSomething()
  {
    let request = SelectArea.Request()
    interactor?.doSomething(request: request)
  }
  
  func displaySomething(viewModel: SelectArea.ViewModel)
  {
    //nameTextField.text = viewModel.name
  }
}

extension SelectAreaViewController : UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return selectAreaArray.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerCell = tableView.dequeueReusableCell(withIdentifier: "HeaderCell")
        headerCell?.backgroundColor = appBarThemeColor
        headerCell?.contentView.backgroundColor = appBarThemeColor
        let sectionObject = selectAreaArray[section]
        headerCell?.textLabel?.text = sectionObject.header.areaHeaderTitle
        return headerCell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let sectionObject = selectAreaArray[section]
        let rowsObject = sectionObject.row
        return rowsObject.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReUseIdentifier, for: indexPath)
        let sectionObject = selectAreaArray[indexPath.section]
        let rowsObject = sectionObject.row
        
        cell.textLabel?.text = rowsObject[indexPath.row].areaListTitle
        return cell
    }
    
}
