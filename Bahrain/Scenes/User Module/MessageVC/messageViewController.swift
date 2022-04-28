

import UIKit
import CoreData
import SystemConfiguration

protocol messageDisplayLogic: class
{
     func presentMessageResponse(viewModelArray: [message.Something.ViewModel.showMessage])
}

class messageViewController: BaseViewControllerUser, messageDisplayLogic
{

    var interactor: messageBusinessLogic?
    var router: (NSObjectProtocol & messageRoutingLogic & messageDataPassing)?
    
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
        let interactor = messageInteractor()
        let presenter = messagePresenter()
        let router = messageRouter()
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
    
    
    /////////////////////////////////////////////////////////////////////////////////////
    
    
    var messageListArray = [message.Something.ViewModel.showMessage]()
    var isGoChat = false
    
    @IBOutlet weak var msgTblView: UITableView!
    @IBOutlet weak var noMsgLbl: UILabel!
    @IBOutlet weak var backButton: UIButton!
    
  // MARK: View lifecycle
  
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        noMsgLbl.isHidden = true
        self.navigationController?.isNavigationBarHidden = false
        applyLocalizedText()
        noMsgLbl.textColor = appBarThemeColor
    }
    
    override func viewWillAppear(_ animated: Bool) {
        appDelegateObj.currentScreen = "UserChatScreen"
        
      self.tabBarController?.tabBar.isHidden = false
        
        isGoChat = false
        
        //**-- Observe Notifiaction --**
        interactor?.observeNotification()
        
        //**-- Init socket --**
        interactor?.emitSocketInit()
        interactor?.emitUserOnlineSocket()
        
        //**-- Pending Messages socket --**
        interactor?.emitPendingMessageSocket()
        
         self.initialFunction()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
         //**-- Remove all notifications --**
       interactor?.removeObserveNotification()
        if(isGoChat == false){
            
        //**-- User offline socket --**
           interactor?.emitUserOfflineSocket()
        }
    }
    
    // MARK: Do something

    func initialFunction()
    {
        if isCurrentLanguageArabic() {
                   backButton.contentHorizontalAlignment = .right
                   backButton.setImage(UIImage(named: "whiteRightArrow"), for: .normal)
               } else {
                   backButton.contentHorizontalAlignment = .left
                   backButton.setImage(UIImage(named: "whiteBackIcon"), for: .normal)
               }
        interactor?.fetchChatMessage()
    }
    
    // MARK: Apply LocalizedText
    func applyLocalizedText() {

        CommonFunctions.sharedInstance.setNavigationTitleView(titleStr: localizedTextFor(key: ChatMessageSceneText.ChatMessageSceneTitle.rawValue), onVC: self)
    }
    
    func presentMessageResponse(viewModelArray: [message.Something.ViewModel.showMessage]) {
        self.messageListArray = viewModelArray
        msgTblView.reloadData()
    }
    
    @IBAction func backBarButtonItem(sender: UIButton) {
           self.navigationController?.popViewController(animated: true)
       }
}

extension messageViewController: UITableViewDataSource
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
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReUseIdentifier, for: indexPath) as! messageTableViewCell
        
        let currentObj = messageListArray[indexPath.row]
        cell.setData(obj: currentObj)
        return cell
    }
}

extension messageViewController: UITableViewDelegate
{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentObj = messageListArray[indexPath.row]
            self.setDataDidSelect(index:indexPath.row,obj:currentObj)
    }
    
    func setDataDidSelect(index:Int,obj:message.Something.ViewModel.showMessage){
        if let router = router{
                isGoChat = true;
                router.routeToChat(indexPath:index,id:obj._id,friendName:obj.name,ProfileImage:obj.profileImage)
            }
    }
}



