

import UIKit
import CoreData

protocol BusinessChatDisplayLogic: class
{
    func displayTitle(title:String , imageName:String,chatId:String,chatMsgs:NSArray,isFromMsg:Bool)
    func broadcastMessages(charMsgArr:BusinessChatEntity)
    func displayTypingStatus(typingStatusStr:String)
    func showKeyboard(displayKeyboardHeight:CGFloat)
    func hideKeyboard()
}

class BusinessChatViewController: UIViewController, BusinessChatDisplayLogic,GrowingTextViewDelegate,UITextViewDelegate
{
    var interactor: BusinessChatBusinessLogic?
    var router: (NSObjectProtocol & BusinessChatRoutingLogic & BusinessChatDataPassing)?
    
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
    let interactor = BusinessChatInteractor()
    let presenter = BusinessChatPresenter()
    let router = BusinessChatRouter()
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
    
    
    ///////////////////////////////////////////////////////////////////
    
    
    @IBOutlet weak var BusinessChatTblView: UITableView!
    @IBOutlet weak var userProfileImage: UIImageView!
    @IBOutlet weak var friendNameLbl: UILabel!
    @IBOutlet weak var offlineStatusLbl: UILabel!
    @IBOutlet weak var footerView: UIView!
    @IBOutlet weak var chatTextView: GrowingTextView!
    @IBOutlet weak var textViewBottomConstraint: NSLayoutConstraint!
    
    var chatArr: [BusinessChatEntity] = []
    var receiverProfileImage = ""
    var chatReciverId = ""
    
    
  
  // MARK: View lifecycle
  
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        chatTextView.trimWhiteSpaceWhenEndEditing = false
        chatTextView.placeholder = localizedTextFor(key: BusinessChatSceneText.BusinessChatSceneTextViewText.rawValue)
        chatTextView.delegate = self
        chatTextView.minHeight = 30.0
        chatTextView.maxHeight = 150.0

    }
    
    override func viewWillAppear(_ animated: Bool) {
        initialFunction()
        applyFontAndColor()
        appDelegateObj.currentScreen = "BusinessChatScreen"
        
        //*-- Observe Notification --*
        interactor?.observeNotification()
        
        //**-- Emit Socket Initialization --**
        interactor?.emitSocketInit()
        interactor?.emitPendingMessagesSocket()
        
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        interactor?.emitUserOfflineSocket()
        
        // Show the navigation bar on other view controllers
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        
        
        //**-- Remove all notification observations --**
         interactor?.removeObserveNotification()
    }
    
    func initialFunction()
    {
        let request = BusinessChat.Something.Request()
        interactor?.doSomething(request: request)
    }
    
    // MARK: Apply Font And Color
    func applyFontAndColor() {
        chatTextView.tintColor = appBarThemeColor
    }


    func displayTitle(title:String , imageName:String,chatId:String,chatMsgs:NSArray,isFromMsg:Bool) {
        friendNameLbl.text = title
        chatReciverId = chatId
        chatArr = chatMsgs as! [BusinessChatEntity]

        receiverProfileImage = imageName
        
        if let chatProfileImageUrl = URL(string:Configurator().imageBaseUrl + imageName) {
            userProfileImage.sd_setImage(with: chatProfileImageUrl, placeholderImage: #imageLiteral(resourceName: "userIcon"), options: .retryFailed, completed: nil)
        }
        BusinessChatTblView.reloadData()
        printToConsole(item: chatArr)
        if chatArr.count != 0 {
            self.scrollToLastRow()
        }
        
    }
    
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        //**-- Emit Typing Socket --**
        interactor?.emitTyping()
        
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.count
        
        if(numberOfChars == 0){
            //**-- Emit Stop Typing Socket--**
            interactor?.stopTyping()
        }
        
        return true
    }
    
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        //**-- Emit Stop Typing Socket--**
        interactor?.stopTyping()
    }
    
    
    @objc func scrollToLastRow() {
        DispatchQueue.main.async {
            let indexPath = IndexPath(row: self.chatArr.count-1, section: 0)
            self.BusinessChatTblView.scrollToRow(at: indexPath, at: .bottom, animated: false)
        }
   }
    
    
    @IBAction func backToMessageAction(_ sender: Any) {
       self.navigationController?.popViewController(animated: true)
//        for viewcontroller in (navigationController?.viewControllers)! {
//            if viewcontroller.isKind(of: BusinessMessageViewController.self) {
//                self.navigationController?.popToViewController(viewcontroller, animated: true)
//            }
//        }
        
    }
    
    @IBAction func chatsSendBtn(_ sender: Any) {
        
        let text = chatTextView.text
        let trimmedText = text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if trimmedText?.isEmpty ?? true {
            } else {
                
                let currentTime = Date().toMillis()
            
            //**-- Emit Stop Typing Socket--**
                interactor?.stopTyping()
            
            //**-- Emit Send Message Socket --**
                interactor?.emitSendMessage(message: chatTextView.text, randomId: random(10),stampTime:currentTime!)
            
            
            //**-- Save data in core database --**
            
            let fromStr = "business"
            let messageStr = chatTextView.text
            let messageIDStr = random(10)
            let messageTimestampStr = currentTime! as NSNumber
            let receiverIDStr = chatReciverId
            let receiverNameStr = friendNameLbl.text
            let receiverProfileImageStr = receiverProfileImage
            let senderIDStr = getUserData(.businessId)
            let senderNameStr = getUserData(.name)
            let senderProfileImageStr = getUserData(.profileImage)
            
            
            let chatMsg = CoreDataWrapper.sharedInstance.saveUserChat(From:fromStr,Message:messageStr!,MessageID:messageIDStr,MessageTimestamp:messageTimestampStr,ReceiverID:receiverIDStr,ReceiverName:receiverNameStr!,ReceiverProfileImage:receiverProfileImageStr,SenderID:senderIDStr,SenderName:senderNameStr,SenderProfileImage:senderProfileImageStr,EntityName:"BusinessChatEntity",isRead: true)
            
            chatArr.append(chatMsg as! BusinessChatEntity)
                BusinessChatTblView.reloadData()
            if chatArr.count != 0 {
                self.scrollToLastRow()
            }
                chatTextView.text = ""
            }
        
    }
    
    
    func random(_ n: Int) -> String
    {
        let a = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890"
        
        var s = ""
        
        for _ in 0..<n
        {
            let r = Int(arc4random_uniform(UInt32(a.count)))
            
            s += String(a[a.index(a.startIndex, offsetBy: r)])
        }
        
        return s
    }
    
    func broadcastMessages(charMsgArr:BusinessChatEntity){
        printToConsole(item: charMsgArr)
        chatArr.append(charMsgArr)
        BusinessChatTblView.reloadData()
        if chatArr.count != 0 {
            self.scrollToLastRow()
        }
    }
    
    func displayTypingStatus(typingStatusStr:String){
        offlineStatusLbl.text = typingStatusStr
    }
    
    func showKeyboard(displayKeyboardHeight:CGFloat){
        textViewBottomConstraint.constant = displayKeyboardHeight
        if chatArr.count != 0 {
            self.scrollToLastRow()
        }
    }
    
    func hideKeyboard(){
        textViewBottomConstraint.constant = 0
    }
    
}

extension BusinessChatViewController: UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return chatArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
       let cell = tableView.dequeueReusableCell(withIdentifier: cellReUseIdentifier, for: indexPath) as! BusinessChatTableViewCell
        
        cell.receiveBottomView.isHidden = false
        cell.senderBottomView.isHidden = false
        
        let allChatdict = chatArr[indexPath.row]
        
        let receiverId = allChatdict.receiverId
        let TimestampStr = allChatdict.messageTimeStamp
        
        let messageTimestampStr = String(TimestampStr)
        let truncateTimeStamp = messageTimestampStr.dropLast(5)
        
        let TimeStamp = Double(truncateTimeStamp)
        let date = Date(timeIntervalSince1970: TimeStamp!)
        
        //let dateFormatter = DateFormatter()
        //dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        //dateFormatter.locale = NSLocale.current
        //dateFormatter.dateFormat = dateFormats.format7
        
        let date2 = Date()
        let timeAgo:String = timeStamp.sharedInstance.timeAgoSinceDate(date, currentDate: date2, numericDates: true)
        
        if(receiverId == getUserData(.businessId)){
            cell.senderBottomView.isHidden = true
            cell.receiveMsgLbl?.text =  allChatdict.message
            cell.senderMsgLbl?.text = ""
            cell.receiveTimeLbl.text = timeAgo
            
        }else{
            cell.receiveBottomView.isHidden = true
            cell.senderMsgLbl?.text =  allChatdict.message
            cell.receiveMsgLbl?.text = ""
            cell.senderTimeLbl.text = timeAgo
            
        }
        return cell
    }
}


