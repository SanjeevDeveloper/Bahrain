
import UIKit

protocol BusinessBookingDisplayLogic: class
{
    func displayServiceResponse(viewModel: BusinessBooking.ListService.ViewModel, ishome:Bool, isSalon:Bool)
    func displayResponse(viewModel: BusinessBooking.Booking.ViewModel)
    func displayClientData(response: ClientList.ViewModel.tableCellData?)
    func bookingConfirmed()
}

class BusinessBookingViewController: BaseViewControllerBusiness, BusinessBookingDisplayLogic
{
    var interactor: BusinessBookingBusinessLogic?
    var router: (NSObjectProtocol & BusinessBookingRoutingLogic & BusinessBookingDataPassing)?
    
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
        let interactor = BusinessBookingInteractor()
        let presenter = BusinessBookingPresenter()
        let router = BusinessBookingRouter()
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
    
    //////////////////////////////////////////////////////////////////
    @IBOutlet weak var calenderFrameView: UIView!
    @IBOutlet weak var selectServiceLocationLabel: UILabel!
    @IBOutlet weak var selectService: UILabel!
    @IBOutlet weak var serviceDetailLabel: UILabelFontSize!
    @IBOutlet weak var servicesNameLabel: UILabelFontSize!
    @IBOutlet weak var priceLabel: UILabelFontSize!
    @IBOutlet weak var bookingTableView: UITableView!
    @IBOutlet weak var clientLabel: UILabel!
    @IBOutlet weak var tableHeightConstraints: NSLayoutConstraint!
    @IBOutlet weak var bookServiceButton: UIButtonCustomClass!
    @IBOutlet weak var cancelBtn: UIButtonFontSize!
    
    @IBOutlet weak var selectServiceView: UIView!
    @IBOutlet weak var listServiceTableView: UITableView!
    @IBOutlet weak var doneButton: UIButtonFontSize!
    
    //pick location
    @IBOutlet weak var pickLocationView: UIView!
    @IBOutlet weak var pickServiceLabel: UILabelFontSize!
    @IBOutlet weak var salonButton: UIButtonCustomClass!
    @IBOutlet weak var homeButton: UIButtonCustomClass!
    @IBOutlet weak var pickDoneButton: UIButtonFontSize!
    
    var bookingDetailArray = [BusinessBooking.Booking.ViewModel.tableCellData]()
    var listServiceArray = [BusinessBooking.ListService.ViewModel.tableCellData]()
    var selectedServiceArray = [BusinessBooking.ListService.ViewModel.tableCellData]()
    var salonServiceListArray = [BusinessBooking.ListService.ViewModel.tableCellData]()
    var homeServiceListArray = [BusinessBooking.ListService.ViewModel.tableCellData]()
    var selectedTherapistArray  = [Booking.selectedTherapistModel]()
    
    var timeSlotArray = [BusinessBooking.ConfirmBooking.ViewModel.timeArrayData]()
    
    var ClientId = ""
    var calculatedTotalPrice : Float = 0
    var servicesIdsArray = [String]()
    var dateTimestamp = Int64()
    var layoutBool = true
    
    
    var calenderView: CalenderView = {
        let calenderView = CalenderView(theme: MyTheme.dark)
        return calenderView
    }()
    
    
    // MARK: View lifecycle
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        hideBackButtonTitle()
        addSlideMenuButton()
        listServiceTableView.tableFooterView = UIView()
        bookingTableView.tableFooterView = UIView()
        addObserverOnTableViewReload()
        clientLabel.text = localizedTextFor(key: BusinessBookingSceneText.BusinessBookingSceneClientLabel.rawValue)
        
        let todayDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = UaeTimeZone
        dateFormatter.dateFormat = dateFormats.format3
        let dateMilliseconds = todayDate.millisecondsSince1970
        dateTimestamp = dateMilliseconds
        initialFunction()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        interactor?.getClientData()
        applyLocalizedText()
    }
    
    // MARK: Apply LocalizedText
    func applyLocalizedText() {
        CommonFunctions.sharedInstance.setNavigationTitleView(titleStr:   localizedTextFor(key: BusinessBookingSceneText.BusinessBookingSceneTitle.rawValue), onVC: self)
        selectServiceLocationLabel.text = localizedTextFor(key: BusinessBookingSceneText.BusinessBookingSceneSelectServiceLocationLabel.rawValue)
        selectService.text = localizedTextFor(key: BusinessBookingSceneText.BusinessBookingSceneSelectServiceLabel.rawValue)
        serviceDetailLabel.text = localizedTextFor(key: BusinessBookingSceneText.BusinessBookingSceneServiceDetailLabel.rawValue)
        pickServiceLabel.text = localizedTextFor(key: BusinessBookingSceneText.BusinessBookingScenePickYourServiceLabel.rawValue)
        salonButton.setTitle(localizedTextFor(key: BusinessBookingSceneText.BusinessBookingSceneAtSalonButton.rawValue), for: .normal)
        homeButton.setTitle(localizedTextFor(key: BusinessBookingSceneText.BusinessBookingSceneAtHomeButton.rawValue), for: .normal)
        pickDoneButton.setTitle(localizedTextFor(key: BusinessBookingSceneText.BusinessBookingScenePickDoneButton.rawValue), for: .normal)
        cancelBtn.setTitle(localizedTextFor(key: BusinessBookingSceneText.BusinessBookingScenePickCancelButton.rawValue), for: .normal)
        bookServiceButton.setTitle(localizedTextFor(key: BusinessBookingSceneText.BusinessBookingSceneBookServiceButton.rawValue), for: .normal)
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
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        if layoutBool{
            calenderView.myCollectionView.collectionViewLayout.invalidateLayout()
        }
        
    }
    
    override func viewDidLayoutSubviews() {
        if layoutBool{
            calenderView.frame = CGRect(x: 0, y: 0, width: calenderFrameView.bounds.size.width, height: calenderFrameView.bounds.size.height)
            calenderView.changeTheme()
        }
        layoutBool = true
        
    }
    
    
    // MARK: Button Actions
    @IBAction func salonButtonAction(_ sender: Any) {
        salonButton.isSelected = true
        homeButton.isSelected = false
        homeButton.backgroundColor = UIColor.lightGray
        salonButton.backgroundColor = appBarThemeColor
        
        selectedServiceArray.removeAll()
        bookingDetailArray.removeAll()
        bookingTableView.reloadData()
        listServiceTableView.reloadData()
        servicesNameLabel.text = ""
        selectService.text = localizedTextFor(key: BusinessBookingSceneText.BusinessBookingSceneSelectServiceLabel.rawValue)
        priceLabel.text = ""
    }
    @IBAction func homeButtonAction(_ sender: Any) {
        homeButton.isSelected = true
        salonButton.isSelected = false
        salonButton.backgroundColor = UIColor.lightGray
        homeButton.backgroundColor = appBarThemeColor
        
        selectedServiceArray.removeAll()
        bookingDetailArray.removeAll()
        bookingTableView.reloadData()
        servicesNameLabel.text = ""
        selectService.text = localizedTextFor(key: BusinessBookingSceneText.BusinessBookingSceneSelectServiceLabel.rawValue)
        priceLabel.text = ""
        listServiceTableView.reloadData()
        
    }
    
    @IBAction func pickDoneButtonAction(_ sender: Any) {
        
        if salonButton.isSelected {
            //            selectServiceLocationLabel.text = localizedTextFor(key: BusinessBookingSceneText.BusinessBookingSceneSalonSelectedText.rawValue)
        }
        else if homeButton.isSelected {
        }
        pickLocationView.isHidden = true
    }
    
    
    @IBAction func serviceDoneButtonAction(_ sender: Any) {
        
        layoutBool = false
        
        servicesIdsArray.removeAll()
        
        //calculatedTotalPrice = 0 as NSNumber
        var serviceName = String()
        var price: NSNumber = 0
        
        for obj in selectedServiceArray {
            for item in obj.businessServices {
                //ServiceID
                
                servicesIdsArray.append(item.businessServiceId)
                
                //Price
                if salonButton.isSelected {
                    price = item.salonPrice
                }
                else if homeButton.isSelected {
                    price = item.homePrice
                }
                
                let floatPrice = price.floatValue
                
                calculatedTotalPrice =  calculatedTotalPrice + floatPrice
                
                //services name
                let name = item.serviceName
                if serviceName.isEmptyString() {
                    serviceName.append(name)
                }
                else {
                    serviceName.append(", \(name)")
                }
            }
        }
        
        servicesNameLabel.text = serviceName
        selectService.text = localizedTextFor(key: BusinessBookingSceneText.BusinessBookingSceneServiceSelectedText.rawValue)
        
        priceLabel.text = calculatedTotalPrice.description + " " +  localizedTextFor(key: GeneralText.bhd.rawValue)
        selectServiceView.isHidden = true
        
        if servicesIdsArray.count == 0 {
            CustomAlertController.sharedInstance.showErrorAlert(error: localizedTextFor(key: BusinessBookingSceneText.BusinessBookingSceneSelectServiceErrorAlert.rawValue))
            
        }
        else {
            
            let req = BusinessBooking.Booking.Request(timeStamp: dateTimestamp, serviceId: servicesIdsArray, totalPrice: calculatedTotalPrice as NSNumber)
            
            interactor?.listTherapistTimeSlots(request: req)
        }
    }
    
    @IBAction func actionCancelBtn(_ sender: Any) {
        selectServiceView.isHidden = true
    }
    
    @IBAction func serviceLocationButtonAction(_ sender: Any) {
        pickLocationView.isHidden = false
    }
    
    @IBAction func selectServiceButtonAction(_ sender: Any) {
        selectServiceView.isHidden = false
    }
    
    @IBAction func clientButtonAction(_ sender: Any) {
        
        router?.routeToClientList()
    }
    
    @IBAction func bookServiceButtonAction(_ sender: Any) {
        bookinfConfromshowAlert()
    }
    
    // MARK: InitialFunction
    func initialFunction() {
        calenderView.delegate = self
        calenderFrameView.addSubview(calenderView)
        interactor?.hitGetListServicesByBusinessIdApi()
    }
    
    // MARK: Display Response
    func displayServiceResponse(viewModel: BusinessBooking.ListService.ViewModel, ishome:Bool, isSalon:Bool)
    {
        if ishome{
            homeButton.isHidden = false
        }
        else {
            homeButton.isHidden = true
        }
        
        if isSalon{
            salonButton.isHidden = false
        }
        else {
            salonButton.isHidden = true
        }
        
        listServiceArray = viewModel.tableArray
        listServiceTableView.reloadData()
    }
    
    func displayResponse(viewModel: BusinessBooking.Booking.ViewModel)
    {
        timeSlotArray.removeAll()
        bookingDetailArray.removeAll()
        bookingDetailArray = viewModel.tableArray
        bookingTableView.reloadData()
        
        if bookingDetailArray.count == 0 {
            CustomAlertController.sharedInstance.showErrorAlert(error: "does not have any therapist, Please remove this service.")
        }
    }
    
    
    func displayClientData(response: ClientList.ViewModel.tableCellData?) {
        
        if response?.ClientId != nil {
            ClientId = (response?.ClientId)!
            clientLabel.text = response?.firstName
        }
        layoutBool = false
    }
    
    func bookingConfirmed() {
        
        CustomAlertController.sharedInstance.showAlert(subTitle: localizedTextFor(key: BusinessBookingSceneText.BusinessBookingSceneBookingConfirmedMessage.rawValue), type: .success)
        router?.routeToTodayList()
    }
    
    // MARK: Booking Confrom Alert
    func bookinfConfromshowAlert() {
        let datefrmt = dateTimestamp
        let date = Date(milliseconds: Int(datefrmt))
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = UaeTimeZone
        dateFormatter.dateFormat = dateFormats.format4
        let day = dateFormatter.string(from: date)
        printToConsole(item: day)
        let alertMessage = localizedTextFor(key: BusinessBookingSceneText.BusinessBookingConfirmAlertMessage.rawValue) + " " + day
        let alertController = PMAlertController(textForegroundColor:UIColor.darkGray, viewBackgroundColor: UIColor.white, title: localizedTextFor(key: BusinessBookingSceneText.BusinessBookingSceneBookingConfirmedMessage.rawValue), description: alertMessage, image: nil, style: .alert)
        alertController.addAction(PMAlertAction(title: localizedTextFor(key: GeneralText.cancelButton.rawValue), style: .default, action: {
            alertController.dismiss(animated: true, completion: nil)
            
        }))
        
        alertController.addAction(PMAlertAction(title: localizedTextFor(key: GeneralText.doneButton.rawValue), style: .default, action: {
            var place = ""
            if self.salonButton.isSelected {
                place = "salon"
            }
            else if self.homeButton.isSelected {
                place = "home"
            }
            
            if self.servicesIdsArray.count == 0 {
                CustomAlertController.sharedInstance.showErrorAlert(error: localizedTextFor(key: BusinessBookingSceneText.BusinessBookingSceneSelectServiceFirstAlert.rawValue))
            }
            else {
                
                let calculatedNumberPrice =  self.calculatedTotalPrice as NSNumber
                
                self.interactor?.confirmBooking(request: self.selectedTherapistArray, ClientId: self.ClientId, paymentPlace: place, paymentType: "cash", totalAmount:calculatedNumberPrice)
            }
        }))
        
        present(alertController, animated: true, completion: nil)
    }
    
    
    @objc func categoryCheckBoxButtonAction(sender:UIButton) {
        
        var v:UIView = sender
        repeat { v = v.superview! } while !(v is UITableViewCell)
        let cell = v as! AddTherapistRowTableViewCell
        let indexPath = listServiceTableView.indexPath(for:cell)!
        
        if listServiceArray[indexPath.section].businessServices[indexPath.row].isSelected {
            let object = listServiceArray[indexPath.section]
            let categorId = object.header.businessCategoryId
            let servicesArrayObj = object.businessServices[indexPath.row]
            for (indexx, dataObj) in selectedServiceArray.enumerated() {
                
                if dataObj.header.businessCategoryId == categorId {
                    if dataObj.businessServices.count == 1 {
                        selectedServiceArray.remove(at: indexx)
                    }
                    else {
                        for (index, data) in dataObj.businessServices.enumerated() {
                            if data.businessServiceId == servicesArrayObj.businessServiceId {
                                selectedServiceArray[indexx].businessServices.remove(at: index)
                            }
                        }
                    }
                }
            }
        }
        else {
            let object = listServiceArray[indexPath.section]
            let servicesArrayObj = object.businessServices[indexPath.row]
            
            let title = object.header.areaHeaderTitle
            
            let dataObj = BusinessBooking.ListService.ViewModel.tableCellData(header: object.header , businessServices: [servicesArrayObj])
            
            var isObjFound = false
            for (index, dataObj) in selectedServiceArray.enumerated() {
                if dataObj.header.areaHeaderTitle == title {
                    selectedServiceArray[index].businessServices.append(servicesArrayObj)
                    isObjFound = true
                }
            }
            
            if !isObjFound {
                selectedServiceArray.append(dataObj)
            }
        }
        listServiceArray[indexPath.section].businessServices[indexPath.row].isSelected = !listServiceArray[indexPath.section].businessServices[indexPath.row].isSelected
        listServiceTableView.reloadData()
    }
}


// MARK: CalenderDelegate
extension BusinessBookingViewController : CalenderDelegate {
    
    func didTapDate(date: String, available: Bool) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = UaeTimeZone
        dateFormatter.dateFormat = dateFormats.format3
        let selectedDate = dateFormatter.date(from: date)
        let selectedDateMilliseconds = selectedDate?.millisecondsSince1970
        dateTimestamp = selectedDateMilliseconds!
        
    
        if servicesIdsArray.count != 0 {
            let req = BusinessBooking.Booking.Request(timeStamp: dateTimestamp, serviceId: servicesIdsArray, totalPrice: calculatedTotalPrice as NSNumber)
            
            interactor?.listTherapistTimeSlots(request: req)
        }
    }
}

// MARK: UITableViewDelegate
extension BusinessBookingViewController : UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        if tableView == bookingTableView {
            return 1
        }
        else {
            return listServiceArray.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if tableView == bookingTableView {
            return UIView()
        }
        else {
            let headerCell = tableView.dequeueReusableCell(withIdentifier: "HeaderCell") as! AddTherapistSectionTableViewCell
            let sectionObject = listServiceArray[section]
            headerCell.serviceTitleNameLabel.text = sectionObject.header.areaHeaderTitle
            return headerCell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if tableView == bookingTableView {
            return 0
        }
        else {
            return 40
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == bookingTableView {
            return bookingDetailArray.count
        }
        else {
            let sectionObject = listServiceArray[section]
            let rowsObject = sectionObject.businessServices
            return rowsObject.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if tableView == bookingTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellReUseIdentifier, for: indexPath) as! BusinessBookingTableViewCell
            
            let obj = bookingDetailArray[indexPath.row]
            cell.servicesDetailLabel.text = obj.theraPistName + " ( " + obj.serviceName + " ) "
            cell.timeLabel.text = obj.serviceDuration.description + localizedTextFor(key: BookingSceneText.BookingSceneMinLabelText.rawValue)
            
            if obj.isSameSerice{
                cell.bottomLabel.isHidden = false
            }
            else {
                cell.bottomLabel.isHidden = true
            }
            
            
            cell.bookingCollectionView.tag = indexPath.row
            cell.bookingCollectionView.reloadData()
            
            return cell
            
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellReUseIdentifier, for: indexPath) as! AddTherapistRowTableViewCell
            
            let sectionObject = listServiceArray[indexPath.section]
            let rowsObject = sectionObject.businessServices
            
            let type = rowsObject[indexPath.row].salonType
            if salonButton.isSelected {
                if type == "home" {
                    cell.isHidden = true
                }
                else {
                    cell.isHidden = false
                }
            }
            else if homeButton.isSelected {
                if type == "salon" {
                    cell.isHidden = true
                }
                else {
                    cell.isHidden = false
                }
            }
            
            cell.serviceNameLabel.text = rowsObject[indexPath.row].serviceName
            cell.selectedButton.isSelected = rowsObject[indexPath.row].isSelected
            cell.selectedButton.addTarget(self, action: #selector(self.categoryCheckBoxButtonAction(sender:)), for: .touchUpInside)
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        
        if tableView == bookingTableView {
            return UITableViewAutomaticDimension
        }
        else {
            
            let sectionObject = listServiceArray[indexPath.section]
            let rowsObject = sectionObject.businessServices
            let type = rowsObject[indexPath.row].salonType
            if salonButton.isSelected {
                if type == "home" {
                    return 0
                }
                else {
                    return UITableViewAutomaticDimension
                }
            }
            else  {
                if type == "salon" {
                    return 0
                }
                else {
                    return UITableViewAutomaticDimension
                }
            }
        }
    }
}

// MARK: UICollectionViewDataSource
extension BusinessBookingViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let collectionViewArry = bookingDetailArray[collectionView.tag].therapistTimeSlots
        return collectionViewArry.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReUseIdentifier, for: indexPath) as! BusinessBookingCollectionViewCell
        let collectionViewArry = bookingDetailArray[collectionView.tag].therapistTimeSlots
        
        let obj = collectionViewArry[indexPath.item]
        
        let date = Date(largeMilliseconds: obj.startTimeStampDate)
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = UaeTimeZone
        dateFormatter.dateFormat = dateFormats.format2
        let fromTime = dateFormatter.string(from: date)
        
        
        cell.collectionTimeLabel.text = " " + fromTime + " "
        
        if obj.isSelected {
            cell.collectionTimeLabel.textColor = UIColor.white
            cell.collectionTimeLabel.backgroundColor = appBarThemeColor
        }
        else {
            if obj.isDisabled{
                cell.collectionTimeLabel.textColor = UIColor.white
                cell.collectionTimeLabel.backgroundColor = UIColor(red: 228/256, green: 228/256, blue: 228/256, alpha: 1.0)
                
            }
            else {
                cell.collectionTimeLabel.textColor = UIColor.gray
                cell.collectionTimeLabel.backgroundColor = UIColor.white
            }
           
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        
        let cell = collectionView.cellForItem(at: indexPath) as! BusinessBookingCollectionViewCell
        let collectionViewArry = bookingDetailArray[collectionView.tag].therapistTimeSlots
        let obj = collectionViewArry[indexPath.item]
        
        printToConsole(item: bookingDetailArray)
        
        if obj.isSelected {
            bookingDetailArray[collectionView.tag].therapistTimeSlots[indexPath.item].isSelected = false
            cell.collectionTimeLabel.textColor = UIColor.darkGray
            cell.collectionTimeLabel.backgroundColor = UIColor.white
            
            let currentTherapistObj = bookingDetailArray[collectionView.tag]
           // let currentTherapistId = currentTherapistObj.therapistId
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
        }
        else {
            
            let currentTherapistObj = bookingDetailArray[collectionView.tag]
            let currentSlotObject = bookingDetailArray[collectionView.tag].therapistTimeSlots[indexPath.item]
            let currentDate = Date()
            
            if (currentSlotObject.startTimeStampDate > currentDate.millisecondsSince1970) {
                
                let selectedObj = BusinessBooking.ConfirmBooking.ViewModel.timeArrayData(startTimeStamp: obj.startTimeStampDate, endTimeStamp: obj.endTimeStampDate, minusTimeStamp: obj.minusTimeStampDate, therapistId: currentTherapistObj.therapistId, therapistServiceId: currentTherapistObj.therapistServiceId)
                
                
                var timeSlotCount = false
                var timeAddBool = false
                
                
                if timeSlotArray.count == 0 {
                    //timeSlotArray.append(selectedObj)
                    timeAddBool = true
                    timeSlotCount = true
                }
                else {
                    
                    var isFound = true
                    
                    ///
                    for (index, item) in timeSlotArray.enumerated() {
                        
                        // new
                        if item.therapistServiceId == selectedObj.therapistServiceId {
                            timeSlotArray.remove(at: index)
                            timeSlotArray.insert(selectedObj, at: index)
                            timeAddBool = false
                            timeSlotCount = true
                        }//
                        else {
                            if !((obj.startTimeStampDate < item.startTimeStamp && obj.endTimeStampDate <= item.startTimeStamp) || item.endTimeStamp <= obj.startTimeStampDate)
                                
                                
                            {
                                
                                printToConsole(item: "Error")
                                
                                CustomAlertController.sharedInstance.showErrorAlert(error: "Please select another slot")
                                timeSlotCount = false
                                isFound = false
                                break
                            }
                            else {
                                
                                if isFound {
                                    
                                    printToConsole(item: "success")
                                    let objFound = false
                                    
                                    timeAddBool = true
                                    timeSlotCount = true
                                    //break
                                    
                                }
                            }
                            
                        }
                        
                    }
                    
                }
                
                if timeSlotCount {
                    
                    if timeAddBool{
                        timeSlotArray.append(selectedObj)
                    }
                    
                    
                    let slotsDict:NSDictionary = [
                        "end": currentSlotObject.endTimeStampDate,
                        "start": currentSlotObject.startTimeStampDate,
                        "formatString": currentSlotObject.formatTime
                    ]
                    let selectedObj = Booking.selectedTherapistModel(
                        businessServiceId: currentTherapistObj.servicesIds,
                        isServiceCancel: false, therapistImage: currentTherapistObj.theraPistImage,
                        therapistId: currentTherapistObj.therapistId, therapistName: currentTherapistObj.theraPistName, therapistServiceId: currentTherapistObj.therapistServiceId,
                        therapistSlots: slotsDict, collectionTag: collectionView.tag
                    )
                    
                    var objFound = false
                    for (index, obj) in selectedTherapistArray.enumerated() {
                        
                        if  obj.therapistServiceId == selectedObj.therapistServiceId{
                            
                            objFound = true
                            selectedTherapistArray.remove(at: index)
                            selectedTherapistArray.insert(selectedObj, at: index)
                            
                            for (indexx,_) in bookingDetailArray[obj.collectionTag].therapistTimeSlots.enumerated() {
                                bookingDetailArray[obj.collectionTag].therapistTimeSlots[indexx].isSelected = false
                            }
                            
                        }
                    }
                    if !objFound {
                        selectedTherapistArray.append(selectedObj)
                    }
                    
                    for (index,_) in bookingDetailArray[collectionView.tag].therapistTimeSlots.enumerated() {
                        bookingDetailArray[collectionView.tag].therapistTimeSlots[index].isSelected = false
                    }
                    bookingDetailArray[collectionView.tag].therapistTimeSlots[indexPath.item].isSelected = true
                    
                    cell.collectionTimeLabel.textColor = UIColor.white
                    cell.collectionTimeLabel.backgroundColor = appBarThemeColor
                    
                }
                
            }
            else {
                printToConsole(item: "CurrentTimeError")
                CustomAlertController.sharedInstance.showErrorAlert(error: "Please select another slot")
            }
            
        }
        
        // change color of unselectable slot
        
        for (index,obj) in bookingDetailArray.enumerated(){
            
            for (ind,item) in obj.therapistTimeSlots.enumerated(){
                
                if bookingDetailArray[index].therapistTimeSlots[ind].isSelected == false {
                  
                    if timeSlotArray.count == 0 {
                        bookingDetailArray[index].therapistTimeSlots[ind].isDisabled = false
                    }
                    
                    for data in timeSlotArray{
                        
                        if !((item.startTimeStampDate < data.startTimeStamp && item.endTimeStampDate <= data.startTimeStamp) || data.endTimeStamp <= item.startTimeStampDate)
                        {
                            bookingDetailArray[index].therapistTimeSlots[ind].isDisabled = true
                            
                        }
                        else {
                            bookingDetailArray[index].therapistTimeSlots[ind].isDisabled = false
                        }
                        
                    }
                    
                }
                
            }
            
        }
        
        
        bookingTableView.reloadData()
        collectionView.reloadData()
    }
}
