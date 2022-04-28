
import UIKit
import CoreData

protocol ChatDisplayLogic: class
{
    func displayTitle(title:String , imageName:String,chatId:String,chatMsgs:NSArray,isFromMsg:Bool)
    func broadcastMessages(charMsgArr:MessageEntity)
    func displayTypingStatus(typingStatusStr:String)
    func showKeyboard(displayKeyboardHeight:CGFloat)
    func hideKeyboard()
}

class ChatViewController: UIViewController, ChatDisplayLogic,GrowingTextViewDelegate,UITextViewDelegate
{
    
    var interactor: ChatBusinessLogic?
    var router: (NSObjectProtocol & ChatRoutingLogic & ChatDataPassing)?
    
    
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
        let interactor = ChatInteractor()
        let presenter = ChatPresenter()
        let router = ChatRouter()
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
    
    //////////////////////////////////////////////////////////////////////////
    
    
    
    var chatReciverId        = ""
    var isFromMessage        = false
    var receiverProfileImage = ""
    var localChatArr: [MessageEntity] = []
    
    @IBOutlet var textviewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var chatTblView: UITableView!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var chatTextView: GrowingTextView!
    @IBOutlet weak var salonNameLbl: UILabel!
    @IBOutlet weak var salonImageView: UIImageView!
    @IBOutlet weak var offlineStatusLbl: UILabel!
    
    @IBOutlet weak var navBarTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var navigationBarView: UIView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        chatTextView.trimWhiteSpaceWhenEndEditing = false
        chatTextView.placeholder = localizedTextFor(key: ChatSceneText.ChatSceneTextViewText.rawValue)
        chatTextView.delegate = self
        chatTextView.minHeight = 30.0
        chatTextView.maxHeight = 150.0
        navigationBarView.backgroundColor = appBarThemeColor
        chatTextView.tintColor = appBarThemeColor
        
        let languageIdentifier = UserDefaults.standard.value(forKey: userDefualtKeys.currentLanguage.rawValue) as! String
        if languageIdentifier == Languages.Arabic {
            backBtn.setImage(UIImage(named:"whiteRightArrow"), for: UIControlState.normal)
            chatTextView.textAlignment = .right
        }
        else {
            backBtn.setImage(UIImage(named:"whiteBackIcon"), for: UIControlState.normal)
            chatTextView.textAlignment = .left
        }
        if (UIScreen.main.bounds.height > 736){
            navBarTopConstraint.constant = 88
        }
        navigationBarView.backgroundColor = appBarThemeColor
        doSomething()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        appDelegateObj.currentScreen = "UserMessageScreen"
        
        //*-- Observe all Notifications --*
        interactor?.observeNotification()
        
        if !isMessageScreenExistInStack() {
            
            //*-- Socket Initialize --*
            interactor?.SocketInit()
            interactor?.emitUserOnlineSocket()
            interactor?.emitPendingMessageSocket()
        }
        
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    func isMessageScreenExistInStack() -> Bool {
        var isExist = false
        if let controllers = navigationController?.viewControllers {
            for controller in controllers {
                if controller.isKind(of: messageViewController.self) {
                    isExist = true
                }
            }
        }
        return isExist
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Show the navigation bar on other view controllers
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        
        /*
         Here not using isFromMessage because of ambugities. check its value when coming from appdelegate.
         */
        if !isMessageScreenExistInStack() {
            //*-- Emit user offline --*
            interactor?.emitUserOfflineSocket()
        }
        
        //*-- Remove all notification observations --*
        interactor?.removeObserveNotification()
    }
    
    func doSomething(){
        let request = Chat.Something.Request()
        interactor?.doSomething(request: request)
    }
    
    func displayTitle(title:String , imageName:String,chatId:String,chatMsgs:NSArray,isFromMsg:Bool) {
        salonNameLbl.text = title
        chatReciverId = chatId
        localChatArr = chatMsgs as! [MessageEntity]
        isFromMessage = isFromMsg
        receiverProfileImage = imageName
        
        if let chatProfileImageUrl = URL(string:Configurator().imageBaseUrl + imageName) {
            salonImageView.sd_setImage(with: chatProfileImageUrl, placeholderImage: #imageLiteral(resourceName: "userIcon"), options: .retryFailed, completed: nil)
        }
        chatTblView.reloadData()
        printToConsole(item: localChatArr)
        //  if localChatArr.count != 0 {
        self.scrollToLastRow()
        // }
    }
    
    @objc func scrollToLastRow() {
        
        let arrCount: Int = localChatArr.count;
        if (arrCount >= 1) {
            
            DispatchQueue.main.async {
                let indexPath = IndexPath(row: self.localChatArr.count-1, section: 0)
                self.chatTblView.scrollToRow(at: indexPath, at: .bottom, animated: false)
            }
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
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        //*-- Emit Typing Socket --*
        interactor?.emitTyping()
        
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.count
        
        if(numberOfChars == 0){
            //**-- Emit Stop Typing Socket--**
            interactor?.stopTyping()
        }
        
        return true
    }
    
    @IBAction func backAction(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func msgSendAction(_ sender: Any) {
        
        let text = chatTextView.text
        let trimmedText = text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if trimmedText?.isEmpty ?? true {
        } else {
            
            let currentTime = Date().toMillis()
            
            //*-- Emit Stop Typing Socket --*
            interactor?.stopTyping()
            
            //*-- Emit Send Message Socket --*
            interactor?.emitSendMessage(message: chatTextView.text, randomId: random(10),stampTime:currentTime!)
            
            //**-- Save data in core database --**
            let FromStr = "user"
            let MessageStr = chatTextView.text as String
            let MessageIDStr = random(10)
            let MessageTimestampStr = currentTime! as NSNumber
            let ReceiverIDStr = chatReciverId
            let ReceiverNameStr = salonNameLbl.text
            let ReceiverProfileImageStr = receiverProfileImage
            let SenderIDStr = getUserData(._id)
            let SenderNameStr = getUserData(.name)
            let SenderProfileImageStr = getUserData(.profileImage)
            
            let ChatMsg = CoreDataWrapper.sharedInstance.saveUserChat(From:FromStr,Message:MessageStr,MessageID:MessageIDStr,MessageTimestamp:MessageTimestampStr,ReceiverID:ReceiverIDStr,ReceiverName:ReceiverNameStr!,ReceiverProfileImage:ReceiverProfileImageStr,SenderID:SenderIDStr,SenderName:SenderNameStr,SenderProfileImage:SenderProfileImageStr,EntityName:"MessageEntity", isRead: true)
            localChatArr.append(ChatMsg as! MessageEntity)
            chatTblView.reloadData()
            //if localChatArr.count != 0 {
            self.scrollToLastRow()
            //  }
            chatTextView.text = ""
        }
    }
    
    func broadcastMessages(charMsgArr:MessageEntity){
        localChatArr.append(charMsgArr)
        chatTblView.reloadData()
        printToConsole(item: localChatArr)
        //  if localChatArr.count != 0 {
        self.scrollToLastRow()
        // }
    }
    
    func displayTypingStatus(typingStatusStr:String){
        offlineStatusLbl.text = typingStatusStr
    }
    
    func showKeyboard(displayKeyboardHeight:CGFloat){
        textviewBottomConstraint.constant = displayKeyboardHeight
        //if localChatArr.count != 0 {
        self.scrollToLastRow()
        // }
    }
    
    func hideKeyboard(){
        textviewBottomConstraint.constant = 0
    }
}

extension Date {
    func toMillis() -> Int64! {
        return Int64(self.timeIntervalSince1970 * 1000)
    }
}

extension ChatViewController: UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return localChatArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReUseIdentifier, for: indexPath) as! chatTableViewCell
        
        
        cell.outgoingBottomView.isHidden = false
        cell.incomingBaseView.isHidden = false
        
        
        let allChatdict  = localChatArr[indexPath.row]
        let recverId     =  allChatdict.receiverId
        let TimestampStr =  allChatdict.messageTimeStamp
        
        let messageTimestampStr = String(TimestampStr)
        let truncateTimeStamp = messageTimestampStr.dropLast(5)
        
        let TimeStamp = Double(truncateTimeStamp)
        
        let date = Date(timeIntervalSince1970: TimeStamp!)
        //let dateFormatter = DateFormatter()
        // dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        //dateFormatter.locale = NSLocale.current
        //dateFormatter.dateFormat = dateFormats.format7
        let date2 = Date()
        
        let timeAgo:String = timeStamp.sharedInstance.timeAgoSinceDate(date, currentDate: date2, numericDates: true)
        
        if(recverId == getUserData(._id)){
            cell.outgoingBottomView.isHidden = true
            cell.incomingMsgLbl?.text =  allChatdict.message
            cell.outgoingMsgLbl?.text = ""
            cell.receiverTimeLbl.text = timeAgo
            
        }else{
            cell.incomingBaseView.isHidden = true
            cell.outgoingMsgLbl?.text =  allChatdict.message
            cell.incomingMsgLbl?.text = ""
            cell.senderTimeLbl.text = timeAgo
        }
        return cell
    }
}


