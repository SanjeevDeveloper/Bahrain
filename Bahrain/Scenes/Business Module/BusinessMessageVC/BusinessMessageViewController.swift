

import UIKit
import CoreData

protocol BusinessMessageDisplayLogic: class
{
    func presentBusinessMessageResponse(viewModelArray: [BusinessMessage.Something.ViewModel.showMessage])
}

class BusinessMessageViewController: UIViewController, BusinessMessageDisplayLogic
{
  var interactor: BusinessMessageBusinessLogic?
  var router: (NSObjectProtocol & BusinessMessageRoutingLogic & BusinessMessageDataPassing)?
    
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
    let interactor = BusinessMessageInteractor()
    let presenter = BusinessMessagePresenter()
    let router = BusinessMessageRouter()
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
  
    
    /////////////////////////////////////////////////////////////////////////////
    
    
    var messageListArray = [BusinessMessage.Something.ViewModel.showMessage]()
    var isGoChat          = false
    
    @IBOutlet weak var businessTblView: UITableView!
    @IBOutlet weak var noMsgLbl: UILabel!
    
    
    
  // MARK: View lifecycle
  
  override func viewDidLoad()
  {
    super.viewDidLoad()
    noMsgLbl.isHidden = true
  }
  
    override func viewWillAppear(_ animated: Bool) {
        
        appDelegateObj.currentScreen = "BusinessMessageScreen"
         CommonFunctions.sharedInstance.setNavigationTitleView(titleStr: localizedTextFor(key: BusinessChatMessageSceneText.BusinessChatMessageSceneTitle.rawValue), onVC: self)
        
         //*-- Observe Notification --*
        interactor?.observeNotification()
        
        isGoChat = false
        
        //**-- Emit Init socket --**
        interactor?.emitSocketInit()
        
        //**-- Emit Pending Messages socket --**
        interactor?.emitPendingMessagesSocket()

        //**-- Fetch BusinessMessage  --**
        interactor?.fetchBusinessMessage()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if(isGoChat == false){
            //**-- Emit User Offline socket --**
            interactor?.emitUserOfflineSocket()
        }
        
         //**-- Remove all notification observation --**
        interactor?.removeObserveNotification()
    }
    
    func presentBusinessMessageResponse(viewModelArray: [BusinessMessage.Something.ViewModel.showMessage]) {
        self.messageListArray = viewModelArray
        businessTblView.reloadData()
    }
}

extension BusinessMessageViewController: UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if(messageListArray.count == 0){
            noMsgLbl.isHidden = false
            
        }else{
            noMsgLbl.isHidden = true
        }
        
        return messageListArray.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReUseIdentifier, for: indexPath) as! BusinessMessageTableViewCell

        let currentObj = messageListArray[indexPath.row]
        cell.setData(obj: currentObj)
        
        return cell
    }
}

extension BusinessMessageViewController: UITableViewDelegate
{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentObj = messageListArray[indexPath.row]
        self.setDataDidSelect(index:indexPath.row,obj:currentObj)
    }
    
    func setDataDidSelect(index:Int,obj:BusinessMessage.Something.ViewModel.showMessage){
        if let router = router{
          isGoChat = true;
          router.businessRouteToChat(indexPath:index,id:obj._id,friendName:obj.name,ProfileImage:obj.profileImage)
        }
    }
}




