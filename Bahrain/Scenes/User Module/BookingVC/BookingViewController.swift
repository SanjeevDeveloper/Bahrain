
import UIKit
import JTAppleCalendar
import FSCalendar
import AVFoundation

protocol BookingDisplayLogic: class
{
    func displayResponse(viewModel: Booking.ViewModel)
    func displaySelectedData(saloonName: String, serviceName: String, totalPrice: NSNumber, servicesIdsArray: [String],offerId:String?, totalSalonPrice:String)
    func AdvanceBookingDays(days: Int)
}

enum MyTheme {
    case light
    case dark
}

class BookingViewController: UIViewController, BookingDisplayLogic {
    
    var audioPlayer : AVPlayer!
    
    var interactor: BookingBusinessLogic?
    var router: (NSObjectProtocol & BookingRoutingLogic & BookingDataPassing)?
    
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
        let interactor = BookingInteractor()
        let presenter = BookingPresenter()
        let router = BookingRouter()
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
    
    /////////////////////////////////////////////////////////////
    
    @IBOutlet weak var scrollContentView: UIView!
    @IBOutlet weak var serviceDetailLabel: UILabelFontSize!
    @IBOutlet weak var servicesNameLabel: UILabelFontSize!
    @IBOutlet weak var salonNameLabel: UILabelFontSize!
    @IBOutlet weak var priceLabel: UILabelFontSize!
    @IBOutlet weak var bookingTableView: UITableView!
    @IBOutlet weak var tableHeightConstraints: NSLayoutConstraint!
    @IBOutlet weak var instructionTextView: UITextViewFontSize!
    @IBOutlet weak var proceedButton: UIButtonFontSize!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var proceedButtonHieghtConstraints: NSLayoutConstraint!
    @IBOutlet weak var vwCalendar: FSCalendar!
    @IBOutlet weak var vwCalendarHeight: NSLayoutConstraint!
    @IBOutlet weak var noTimeslotsfound: UILabelFontSize!
    @IBOutlet weak var toggleBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var backButton: UIButton!
    
    var selectedTherapistIndex = 0
    var bookingDetailArray = [Booking.ViewModel.tableCellData]()
    var bookingTimeStamp = ""
    var calculatedTotalPrice = 0 as NSNumber
    var selectedTherapistArray  = [Booking.selectedTherapistModel]()
    var bookingDate:String!
    var layoutBool = true
    var servicesIdsArray = [String]()
    var specialofferId:String?
    var totalPriceStr = ""
    var advanceBookingDays = 60
    var aajKiTareek = Date()
    var timeSlotArray: [BusinessBooking.ConfirmBooking.ViewModel.timeArrayData] = []
    
    var bookingInfoArr = [Booking.NewBookingModel]()
    
    var calendarTimeStamp:Int64 = 0
    var isInitial = true
    
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideBackButtonTitle()
        applyLocalizedText()
        applyFontAndColor()
        toggleBarButtonItem.title = localizedTextFor(key: GeneralText.monthView.rawValue)
        vwCalendar.scope = .week
        
        self.edgesForExtendedLayout = UIRectEdge.init(rawValue: 0)
        addObserverOnTableViewReload()
        initialFunction()
        addKeyboardObservers()
        interactor?.getData()
        
        proceedButton.backgroundColor = appBarThemeColor
    }
    
    func AdvanceBookingDays(days: Int) {
        self.advanceBookingDays = days
        vwCalendar.reloadData()
    }
    
    // MARK: Apply Font And Color
    func applyFontAndColor() {
        
        if isCurrentLanguageArabic() {
            backButton.contentHorizontalAlignment = .right
            backButton.setImage(UIImage(named: "whiteRightArrow"), for: .normal)
        } else {
            backButton.contentHorizontalAlignment = .left
            backButton.setImage(UIImage(named: "whiteBackIcon"), for: .normal)
        }
        
        vwCalendar.layer.cornerRadius = 5
        vwCalendar.appearance.headerTitleFont = UIFont(name: appFont, size: 20)
        vwCalendar.appearance.titleFont = UIFont(name: appFont, size: 17)
        vwCalendar.appearance.weekdayFont = UIFont(name: appFont, size: 17)
        vwCalendar.appearance.subtitleFont = UIFont(name: appFont, size: 17)
        let borderColor : UIColor = UIColor(red: 0.85, green: 0.85, blue: 0.85, alpha: 1.0)
        instructionTextView.layer.borderWidth = 0.5
        instructionTextView.layer.borderColor = borderColor.cgColor
        //instructionTextView.tintColor = appBarThemeColor
        instructionTextView.tintColor = UIColor.red
    }
    
    // MARK: Apply LocalizedText
    func applyLocalizedText() {
        
        CommonFunctions.sharedInstance.setNavigationTitleView(titleStr: localizedTextFor(key: BookingSceneText.BookingSceneTitle.rawValue), onVC: self)
        instructionTextView.placeholder = localizedTextFor(key: BookingSceneText.BookingSceneInstructionTextViewText.rawValue)
        serviceDetailLabel.text = localizedTextFor(key: BookingSceneText.BookingSceneServiceDetailLabelText.rawValue)
        noTimeslotsfound.text = localizedTextFor(key: BookingSceneText.BookingSceneNoSlot.rawValue)
        proceedButton.setTitle(localizedTextFor(key: BookingSceneText.BookingSceneProceedButtonTitle.rawValue), for: .normal)
        
    }
    
    // MARK: Keyboard Hide Show Pop Up
    
    func addKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(notification:)), name:NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(notification:)), name:NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    @objc func keyboardWillShow(notification:NSNotification){
        var userInfo = notification.userInfo!
        let keyboardFrame:CGRect = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
        var contentInset:UIEdgeInsets = self.scrollView.contentInset
        contentInset.bottom = keyboardFrame.size.height
        self.scrollView.contentInset = contentInset
    }
    
    @objc func keyboardWillHide(notification:NSNotification){
        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        self.scrollView.contentInset = contentInset
    }
    
    func addObserverOnTableViewReload() {
        bookingTableView.addObserver(self, forKeyPath: tableContentSize, options: .new, context: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let obj = object as? UITableView {
            if obj == bookingTableView && keyPath == tableContentSize {
                if (change?[NSKeyValueChangeKey.newKey] as? CGSize) != nil {
                    tableHeightConstraints.constant = bookingTableView.contentSize.height
                }
            }
        }
    }
    
    deinit {
        bookingTableView.removeObserver(self, forKeyPath: tableContentSize)
        
    }
    
    
    func isCurrentDay(date: Date) -> Bool {
        let calendar = getCalendar()
        let currentDay = calendar.component(.day, from: Date())
        let currentMonth = calendar.component(.month, from: Date())
        let currentYear = calendar.component(.year, from: Date())
        
        let day = calendar.component(.day, from: date)
        let month = calendar.component(.month, from: date)
        let year = calendar.component(.year, from: date)
        
        return currentDay == day && currentMonth == month && currentYear == year
    }
    
    func playAudioFromURL() {
        // need to declare local path as url
        let url = Bundle.main.url(forResource: "tapTune", withExtension: "wav")
        // now use declared path 'url' to initialize the player
        audioPlayer = AVPlayer.init(url: url!)
        // after initialization play audio its just like click on play button
        audioPlayer.play()
    }
    
    func getTimeSlots(selectedDate: Date) {
        if isInitial{
            isInitial = false
        } else {
            self.playAudioFromURL()
        }
        
        var selectedDateMilliseconds = selectedDate.millisecondsSince1970
        let currentDate = Date()
        let calendar = getCalendar()
        let comp = calendar.dateComponents([.hour, .minute], from: currentDate)
        let hours = comp.hour ?? 0
        print(hours)
        if hours < 3 {
            // Adding 3 hours
            selectedDateMilliseconds += 10800000
        } else {
            selectedDateMilliseconds += Int64(hours * 3600000)
        }
        self.calendarTimeStamp = selectedDateMilliseconds
        interactor?.listTherapistTimeSlots(timeStamp: selectedDateMilliseconds)
    }
    
    @IBAction func backBarButtonItem(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func toggle(_ sender: UIBarButtonItem) {
        if self.vwCalendar.scope == .month {
            toggleBarButtonItem.title = localizedTextFor(key: GeneralText.monthView.rawValue)
            self.vwCalendar.setScope(.week, animated: true)
        } else {
            toggleBarButtonItem.title = localizedTextFor(key: GeneralText.weekView.rawValue)
            self.vwCalendar.setScope(.month, animated: true)
        }
    }
    
    
    // MARK: InitialFunction
    
    func initialFunction() {
        let todayDate = Date()
        let dateFormatter = getDateFormatter()
        dateFormatter.dateFormat = dateFormats.format3
        let todayDateString = dateFormatter.string(from: todayDate)
        dateFormatter.dateFormat = dateFormats.format3
        aajKiTareek = dateFormatter.date(from: todayDateString)!
        vwCalendar.select(aajKiTareek, scrollToDate: true)
        getTimeSlots(selectedDate: aajKiTareek)
        self.bookingDate = todayDateString
        interactor?.getAdvanceBookingDays()
    }
    
    // MARK: Button Action
    
    @IBAction func proceedButtonAction(_ sender: Any) {
        var isAllServicesIncluded = true
        
        proceedButton.isSelected = true
        
        if selectedTherapistArray.count == servicesIdsArray.count {
            isAllServicesIncluded = true
        }
        else {
            isAllServicesIncluded = false
        }
        
        
        if isAllServicesIncluded{
            
            printToConsole(item: self.selectedTherapistArray)
            
            router?.routeToBookingSummary(segue: nil, specialInstructions: instructionTextView.text_Trimmed(), bookingDate: bookingDate, bookingData: self.selectedTherapistArray, offerId: specialofferId, totalPrice: totalPriceStr, calendarTimeStamp: calendarTimeStamp)
        }
        else {
            CustomAlertController.sharedInstance.showErrorAlert(error: localizedTextFor(key: localizedTextFor(key: BookingSceneText.BookingSceneAllServiceSelectionAlert.rawValue)))
            bookingTableView.reloadData()
        }
    }
    
    // MARK: DisplayResponse
    func displayResponse(viewModel: Booking.ViewModel)
    {
        bookingInfoArr.removeAll()
        timeSlotArray.removeAll()
        bookingDetailArray.removeAll()
        selectedTherapistArray.removeAll()
        printToConsole(item: viewModel.tableArray)
        bookingDetailArray = viewModel.tableArray
        
        
        if bookingDetailArray.count == 0 {
            let slotAlert = servicesNameLabel.text! + " " + localizedTextFor(key: BookingSceneText.BookingSceneNoSlotAvailableAlert.rawValue)
            noTimeslotsfound.isHidden = false
            instructionTextView.isHidden = true
            CustomAlertController.sharedInstance.showErrorAlert(error: localizedTextFor(key: slotAlert))
        } else {
            noTimeslotsfound.isHidden = true
            instructionTextView.isHidden = false
            for bookingDetailObj in bookingDetailArray {
                if bookingInfoArr.count == 0 {
                    let bookingInfoObj = Booking.NewBookingModel(headerServiceName: bookingDetailObj.serviceName, serviceDuration: bookingDetailObj.serviceDuration, therapists: [Booking.NewTherapistModel(serviceName: bookingDetailObj.serviceName, theraPistName: bookingDetailObj.theraPistName, serviceDuration: bookingDetailObj.serviceDuration, servicesIds: bookingDetailObj.servicesIds, therapistId: bookingDetailObj.therapistId, therapistImage: bookingDetailObj.therapistImage, therapistServiceId: bookingDetailObj.therapistServiceId, timeSlots: bookingDetailObj.therapistTimeSlots, isTherapistSelected: true)])
                    bookingInfoArr.append(bookingInfoObj)
                } else {
                    var isServiceSame = false
                    for (index, _) in bookingInfoArr.enumerated() {
                        if bookingInfoArr[index].headerServiceName == bookingDetailObj.serviceName {
                            isServiceSame = true
                            bookingInfoArr[index].therapists.append(Booking.NewTherapistModel(serviceName: bookingDetailObj.serviceName, theraPistName: bookingDetailObj.theraPistName, serviceDuration: bookingDetailObj.serviceDuration, servicesIds: bookingDetailObj.servicesIds, therapistId: bookingDetailObj.therapistId, therapistImage: bookingDetailObj.therapistImage, therapistServiceId: bookingDetailObj.therapistServiceId, timeSlots: bookingDetailObj.therapistTimeSlots, isTherapistSelected: false))
                        }
                    }
                    if !isServiceSame {
                        let bookingInfoObj = Booking.NewBookingModel(headerServiceName: bookingDetailObj.serviceName, serviceDuration: bookingDetailObj.serviceDuration, therapists: [Booking.NewTherapistModel(serviceName: bookingDetailObj.serviceName, theraPistName: bookingDetailObj.theraPistName, serviceDuration: bookingDetailObj.serviceDuration, servicesIds: bookingDetailObj.servicesIds, therapistId: bookingDetailObj.therapistId, therapistImage: bookingDetailObj.therapistImage, therapistServiceId: bookingDetailObj.therapistServiceId, timeSlots: bookingDetailObj.therapistTimeSlots, isTherapistSelected: true)])
                        bookingInfoArr.append(bookingInfoObj)
                    }
                }
            }
        }
        
        print("NEW BOOKING MODEL >>>>>>>>>>>>>>>>>>", bookingInfoArr)
        
        bookingTableView.reloadData()
    }
    
    func displaySelectedData(saloonName: String, serviceName: String, totalPrice: NSNumber, servicesIdsArray: [String],offerId:String?,totalSalonPrice:String) {
        servicesNameLabel.text = serviceName
        salonNameLabel.text = saloonName
        specialofferId = offerId
        priceLabel.text = totalPrice.description + " " + localizedTextFor(key: GeneralText.bhd.rawValue)
        printToConsole(item: totalPrice)
        calculatedTotalPrice = totalPrice
        self.servicesIdsArray = servicesIdsArray
        totalPriceStr = totalSalonPrice
    }
    
    func updateProceedButtonHeight() {
        
        layoutBool = false
        if selectedTherapistArray.count == 0 {
            proceedButton.isUserInteractionEnabled = false
            //proceedButtonHieghtConstraints.constant = 50
        }
        else {
            proceedButton.isUserInteractionEnabled = true
            //proceedButtonHieghtConstraints.constant = 50
        }
    }
}

// MARK: UITableViewDelegate

extension BookingViewController : UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return bookingInfoArr.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReUseIdentifier, for: indexPath) as! BookingTableViewCell
        if bookingInfoArr.count > 0 {
            cell.displayCellData(cellObj: bookingInfoArr[indexPath.section].therapists, vc: self)
        }
        //        let obj = bookingInfoArr[indexPath.section].therapists[indexPath.row]
        //        cell.bookingCollectionView.backgroundColor = .clear
        //cell.servicesDetailLabel.text = obj.theraPistName + " ( " + obj.serviceName + " ) "
        //cell.timeLabel.text = obj.serviceDuration.description + localizedTextFor(key: BookingSceneText.BookingSceneMinLabelText.rawValue)
        
        //        if proceedButton.isSelected {
        //            if selectedTherapistArray.count > 0 {
        //                for thp in selectedTherapistArray {
        //                    if obj.therapistServiceId == thp.therapistServiceId {
        //                        cell.contentView.backgroundColor = UIColor.white
        //                        break
        //                    } else {
        //                        cell.contentView.backgroundColor = UIColor.red.withAlphaComponent(0.2)
        //                    }
        //                }
        //            } else {
        //                cell.contentView.backgroundColor = UIColor.red.withAlphaComponent(0.2)
        //            }
        //        } else {
        //            cell.contentView.backgroundColor = UIColor.white
        //        }
        
        //        if obj.isSameSerice {
        //            cell.upperLabel.isHidden = false
        //        }
        //        else {
        //            cell.upperLabel.isHidden = true
        //        }
        
        //        cell.bookingCollectionView.tag = 0
        //        cell.therapistCollectionView.tag = 0
        //cell.bookingCollectionView.reloadData()
        //cell.therapistCollectionView.reloadData()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let vw = tableView.dequeueReusableCell(withIdentifier: "ServiceHeaderViewCell") as! ServiceHeaderViewCell
        let text = bookingInfoArr[section].serviceDuration.description + localizedTextFor(key: BookingSceneText.BookingSceneMinLabelText.rawValue)
        vw.serviceNameLbl.text = bookingInfoArr[section].headerServiceName.uppercased() + " - " + text
        return vw
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if bookingInfoArr.count > 0 {
            return 60
        } else {
            return 0
        }
    }
}
/*
 // MARK: UICollectionViewDelegate
 
 extension BookingViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
 
 func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
 if collectionView.isKind(of: TherapistCollVw.self) {
 let collectionViewArry = bookingInfoArr[section].therapists
 return collectionViewArry.count
 } else {
 let collectionViewArry = bookingInfoArr[section].therapists[selectedTherapistIndex].timeSlots
 return collectionViewArry.count
 }
 }
 
 func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
 
 if collectionView.isKind(of: TherapistCollVw.self) {
 let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TherapistInfoCollectionViewCell", for: indexPath) as! TherapistInfoCollectionViewCell
 cell.therapistNameLbl.text = bookingInfoArr[indexPath.section].therapists[indexPath.item].theraPistName
 if bookingInfoArr[indexPath.section].therapists[indexPath.item].isTherapistSelected {
 cell.therapistImageVw.tintColor = .white
 cell.therapistImageVw.backgroundColor = appBarThemeColor
 cell.therapistNameLbl.textColor = appBarThemeColor
 } else {
 cell.therapistImageVw.tintColor = .darkGray
 cell.therapistImageVw.backgroundColor = selectedImageGrayColor.withAlphaComponent(0.5)
 cell.therapistNameLbl.textColor = .darkGray
 }
 return cell
 } else {
 let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReUseIdentifier, for: indexPath) as! BookingCollectionViewCell
 
 let collectionViewArry = bookingInfoArr[indexPath.section].therapists[selectedTherapistIndex].timeSlots
 
 let obj = collectionViewArry[indexPath.item]
 
 let date = Date(largeMilliseconds: obj.startTimeStampDate)
 let dateFormatter = DateFormatter()
 dateFormatter.timeZone = UaeTimeZone
 dateFormatter.dateFormat = dateFormats.format2
 let fromTime = dateFormatter.string(from: date)
 cell.collectionTimeLabel.backgroundColor = .clear
 
 cell.collectionTimeLabel.text = " " + fromTime + " "
 
 if obj.isSelected {
 cell.collectionTimeLabel.textColor = appBarThemeColor
 //cell.collectionTimeLabel.backgroundColor = appBarThemeColor
 cell.isUserInteractionEnabled = true
 } else {
 
 if obj.isDisabled{
 cell.collectionTimeLabel.textColor = UIColor.gray
 //cell.collectionTimeLabel.backgroundColor = UIColor(red: 228/256, green: 228/256, blue: 228/256, alpha: 1.0)
 cell.isUserInteractionEnabled = false
 }
 else{
 cell.collectionTimeLabel.textColor = UIColor.gray
 //cell.collectionTimeLabel.backgroundColor = UIColor(red: 219/256, green: 219/256, blue: 219/256, alpha: 1.0)
 cell.isUserInteractionEnabled = true
 }
 }
 
 return cell
 }
 }
 
 func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
 
 if collectionView.isKind(of: TherapistCollVw.self) {
 selectedTherapistIndex = indexPath.item
 for (index, _) in bookingInfoArr[indexPath.section].therapists.enumerated() {
 bookingInfoArr[indexPath.section].therapists[index].isTherapistSelected = false
 }
 bookingInfoArr[indexPath.section].therapists[indexPath.item].isTherapistSelected = true
 //bookingTableView.reloadData()
 collectionView.reloadData()
 
 } else {
 
 let cell = collectionView.cellForItem(at: indexPath) as! BookingCollectionViewCell
 
 let collectionViewArry = bookingInfoArr[indexPath.section].therapists[selectedTherapistIndex].timeSlots
 
 let obj = collectionViewArry[indexPath.item]
 
 if obj.isSelected {
 bookingInfoArr[indexPath.section].therapists[selectedTherapistIndex].timeSlots[indexPath.item].isSelected = false
 
 cell.collectionTimeLabel.textColor = UIColor.gray
 //cell.collectionTimeLabel.backgroundColor = UIColor.lightGray
 let currentTherapistObj = bookingDetailArray[collectionView.tag]
 let currentTherapistServiceId = currentTherapistObj.therapistServiceId
 
 for (index, item) in timeSlotArray.enumerated() {
 if item.therapistServiceId == currentTherapistServiceId {
 if(timeSlotArray.count > index) {
 timeSlotArray.remove(at: index)
 }
 }
 }
 
 for (index, obj) in selectedTherapistArray.enumerated() {
 if obj.therapistServiceId == currentTherapistServiceId {
 selectedTherapistArray.remove(at: index)
 }
 }
 
 } else {
 
 let currentTherapistObj = bookingInfoArr[indexPath.section].therapists[selectedTherapistIndex]
 let currentSlotObject = bookingInfoArr[indexPath.section].therapists[selectedTherapistIndex].timeSlots[indexPath.item]
 let currentDate = Date()
 if (currentSlotObject.startTimeStampDate > currentDate.millisecondsSince1970) {
 
 let selectedObj = BusinessBooking.ConfirmBooking.ViewModel.timeArrayData(startTimeStamp: obj.startTimeStampDate, endTimeStamp: obj.endTimeStampDate, minusTimeStamp: obj.minusTimeStampDate, therapistId: currentTherapistObj.therapistId, therapistServiceId: currentTherapistObj.therapistServiceId)
 
 var timeSlotCount = false
 var timeAddBool = false
 
 if timeSlotArray.count == 0 {
 timeAddBool = true
 timeSlotCount = true
 } else {
 var isFound = true
 for (index, item) in timeSlotArray.enumerated() {
 if item.therapistServiceId == selectedObj.therapistServiceId {
 timeSlotArray.remove(at: index)
 timeSlotArray.insert(selectedObj, at: index)
 timeAddBool = false
 timeSlotCount = true
 break
 } else {
 if !((obj.startTimeStampDate < item.startTimeStamp && obj.endTimeStampDate <= item.startTimeStamp) || item.endTimeStamp <= obj.startTimeStampDate) {
 printToConsole(item: "Error")
 CustomAlertController.sharedInstance.showErrorAlert(error: localizedTextFor(key: GeneralText.selectAnotherSlot.rawValue))
 timeSlotCount = false
 isFound = false
 break
 } else {
 if isFound {
 printToConsole(item: "success")
 timeAddBool = true
 timeSlotCount = true
 }
 }
 }
 }
 }
 
 if timeSlotCount {
 if timeAddBool {
 timeSlotArray.append(selectedObj)
 }
 
 let slotsDict:NSDictionary = [
 "end": currentSlotObject.endTimeStampDate,
 "start": currentSlotObject.startTimeStampDate,
 "formatString": currentSlotObject.formatTime
 ]
 let selectedObj = Booking.selectedTherapistModel(
 businessServiceId: currentTherapistObj.servicesIds,
 isServiceCancel: false,
 therapistId: currentTherapistObj.therapistId, therapistName: currentTherapistObj.theraPistName, therapistServiceId: currentTherapistObj.therapistServiceId,
 therapistSlots: slotsDict, collectionTag: collectionView.tag
 )
 
 var objFound = false
 for (index, obj) in selectedTherapistArray.enumerated() {
 
 if obj.therapistServiceId == selectedObj.therapistServiceId {
 objFound = true
 selectedTherapistArray.remove(at: index)
 selectedTherapistArray.insert(selectedObj, at: index)
 
 for (indexx,_) in bookingInfoArr[indexPath.section].therapists[selectedTherapistIndex].timeSlots.enumerated() {
 bookingInfoArr[indexPath.section].therapists[selectedTherapistIndex].timeSlots[indexx].isSelected = false
 }
 }
 }
 
 if !objFound {
 selectedTherapistArray.append(selectedObj)
 }
 
 for (index,_) in bookingInfoArr[indexPath.section].therapists[selectedTherapistIndex].timeSlots.enumerated() {
 bookingInfoArr[indexPath.section].therapists[selectedTherapistIndex].timeSlots[index].isSelected = false
 }
 
 bookingInfoArr[indexPath.section].therapists[selectedTherapistIndex].timeSlots[indexPath.item].isSelected = true
 
 cell.collectionTimeLabel.textColor = UIColor.white
 cell.collectionTimeLabel.backgroundColor = appBarThemeColor
 }
 } else {
 CustomAlertController.sharedInstance.showErrorAlert(error: localizedTextFor(key: localizedTextFor(key: BookingSceneText.BookingSceneTimeSelectionAlert.rawValue)))
 }
 }
 
 printToConsole(item: bookingDetailArray)
 printToConsole(item: timeSlotArray)
 printToConsole(item: selectedTherapistArray)
 
 for (index,obj) in bookingInfoArr[indexPath.section].therapists.enumerated(){
 for (ind,item) in obj.timeSlots.enumerated(){
 
 if bookingInfoArr[indexPath.section].therapists[index].timeSlots[ind].isSelected == false {
 if timeSlotArray.count == 0 {
 bookingInfoArr[indexPath.section].therapists[index].timeSlots[ind].isDisabled = false
 }
 for data in timeSlotArray{
 
 if !((item.startTimeStampDate < data.startTimeStamp && item.endTimeStampDate <= data.startTimeStamp) || data.endTimeStamp <= item.startTimeStampDate) {
 bookingInfoArr[indexPath.section].therapists[index].timeSlots[ind].isDisabled = true
 break
 } else {
 bookingInfoArr[indexPath.section].therapists[index].timeSlots[ind].isDisabled = false
 }
 
 }
 }
 }
 }
 
 printToConsole(item: bookingDetailArray)
 bookingTableView.reloadData()
 collectionView.reloadData()
 updateProceedButtonHeight()
 }
 }
 
 func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
 
 if collectionView.isKind(of: TherapistCollVw.self) {
 return CGSize(width: 100, height: 105)
 } else {
 let collectionViewArry = bookingInfoArr[indexPath.section].therapists[selectedTherapistIndex].timeSlots
 let obj = collectionViewArry[indexPath.item]
 if obj.isDisabled {
 return CGSize(width: 0, height: 25)
 } else {
 return CGSize(width: 75, height: 25)
 }
 }
 }
 }*/

// MARK: - FSCalendar Methods

extension BookingViewController: FSCalendarDataSource, FSCalendarDelegate, FSCalendarDelegateAppearance {
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        proceedButton.isSelected = false
        if monthPosition == .next || monthPosition == .previous {
            calendar.setCurrentPage(date, animated: true)
        }
        self.getTimeSlots(selectedDate: date)
    }
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        self.vwCalendarHeight.constant = bounds.height
        self.view.layoutIfNeeded()
    }
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        calendar.setCurrentPage(vwCalendar.currentPage, animated: true)
    }
    
    func maximumDate(for calendar: FSCalendar) -> Date {
        
        if calendarTimeStamp == 0 {
            calendarTimeStamp = Date().millisecondsSince1970
        }
        
        return Calendar.current.date(byAdding: .day, value: advanceBookingDays, to: Date(largeMilliseconds: calendarTimeStamp))!
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        
        if date >= calendar.today! && date <= calendar.maximumDate {
            return .darkGray
        } else {
            return .lightGray
        }
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillSelectionColorFor date: Date) -> UIColor? {
        return appBarThemeColor
    }
    
    func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        
        if date >= calendar.today! && date <= calendar.maximumDate {
            return true
        } else {
            return false
        }
    }
}

extension Date {
    func startOfMonth() -> Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Calendar.current.startOfDay(for: self)))!
    }
    
    func endOfMonth() -> Date {
        return Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: self.startOfMonth())!
    }
}
