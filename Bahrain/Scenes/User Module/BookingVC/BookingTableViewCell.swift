

import UIKit
import AVFoundation

class BookingTableViewCell: UITableViewCell {

    
    @IBOutlet weak var upperLabel: UILabel!
    @IBOutlet weak var bookingCollectionView: UICollectionView!
    @IBOutlet weak var therapistCollectionView: TherapistCollVw!
    
    var therapistArray = [Booking.NewTherapistModel]()
    var selectedTherapistIndex = 0
    var selectedTherapistArray  = [Booking.selectedTherapistModel]()
    var timeSlotArray = [BusinessBooking.ConfirmBooking.ViewModel.timeArrayData]()
    var selfVC = UIViewController()
    
    var audioPlayer : AVPlayer!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let collectionViewBackgroundView = UIView()
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame.size = bookingCollectionView.frame.size
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.3)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.3)
        gradientLayer.colors = [UIColor.groupTableViewBackground.cgColor, UIColor.white.cgColor]
        bookingCollectionView.backgroundView = collectionViewBackgroundView
        bookingCollectionView.backgroundView?.layer.addSublayer(gradientLayer)
    }
    
    func displayCellData(cellObj: [Booking.NewTherapistModel], vc: UIViewController) {
        therapistArray = cellObj
         selfVC = vc
        therapistCollectionView.reloadData()
        bookingCollectionView.reloadData()
    }
    
    func currentVC() -> BookingViewController {
        if selfVC.isKind(of: BookingViewController.self) {
            let vc = selfVC as! BookingViewController
            return vc
        }
        return selfVC as! BookingViewController
    }
    
}
extension BookingTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func playAudioFromURL() {
        // need to declare local path as url
        let url = Bundle.main.url(forResource: "tapTune", withExtension: "wav")
        // now use declared path 'url' to initialize the player
        audioPlayer = AVPlayer.init(url: url!)
        // after initialization play audio its just like click on play button
        audioPlayer.play()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == therapistCollectionView {
            return therapistArray.count
        } else {
            let collectionViewArry = therapistArray[selectedTherapistIndex].timeSlots
            return collectionViewArry.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == therapistCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TherapistInfoCollectionViewCell", for: indexPath) as! TherapistInfoCollectionViewCell
            cell.therapistNameLbl.text = therapistArray[indexPath.item].theraPistName
            if therapistArray[indexPath.item].therapistImage != "" {
                cell.therapistImageVw.contentMode = .scaleAspectFill
                DispatchQueue.main.async {
                    cell.therapistImageVw.sd_setImage(with: URL(string: Configurator().imageBaseUrl + self.therapistArray[indexPath.item].therapistImage), completed: nil)
                }
            } else {
                cell.therapistImageVw.contentMode = .center
                cell.therapistImageVw.backgroundColor = selectedImageGrayColor.withAlphaComponent(0.4)
            }
            
            if therapistArray[indexPath.item].isTherapistSelected {
                cell.therapistImageVw.layer.borderWidth = 1
                cell.therapistImageVw.layer.borderColor = appBarThemeColor.cgColor
                cell.therapistNameLbl.textColor = appBarThemeColor
                //bookingCollectionView.isHidden = false
            } else {
                cell.therapistImageVw.backgroundColor = selectedImageGrayColor.withAlphaComponent(0.4)
                cell.therapistImageVw.layer.borderWidth = 0
                cell.therapistImageVw.layer.borderColor = UIColor.clear.cgColor
                cell.therapistNameLbl.textColor = .darkGray
                //bookingCollectionView.isHidden = true
            }
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReUseIdentifier, for: indexPath) as! BookingCollectionViewCell
            
            let collectionViewArry = therapistArray[selectedTherapistIndex].timeSlots
            
            let obj = collectionViewArry[indexPath.item]
            
            let date = Date(largeMilliseconds: obj.startTimeStampDate)
            let dateFormatter = DateFormatter()
            //dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
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
        
        if collectionView == therapistCollectionView {
            selectedTherapistIndex = indexPath.item
            for (index, _) in therapistArray.enumerated() {
                therapistArray[index].isTherapistSelected = false
            }
            therapistArray[indexPath.item].isTherapistSelected = true
            therapistCollectionView.reloadData()
            bookingCollectionView.reloadData()
            
        } else {
            
            self.playAudioFromURL()
            
            let cell = collectionView.cellForItem(at: indexPath) as! BookingCollectionViewCell
            
            let collectionViewArry = therapistArray[selectedTherapistIndex].timeSlots
            let obj = collectionViewArry[indexPath.item]
            
            if obj.isSelected {
                therapistArray[selectedTherapistIndex].timeSlots[indexPath.item].isSelected = false
                
                cell.collectionTimeLabel.textColor = UIColor.gray
                //cell.collectionTimeLabel.backgroundColor = UIColor.lightGray
                let currentTherapistObj = therapistArray[selectedTherapistIndex]
                let currentTherapistServiceId = currentTherapistObj.therapistServiceId
                
                for (index, item) in currentVC().timeSlotArray.enumerated() {
                    if item.therapistServiceId == currentTherapistServiceId {
                        if(currentVC().timeSlotArray.count > index) {
                            currentVC().timeSlotArray.remove(at: index)
                        }
                    }
                }
                
                for (index, obj) in currentVC().selectedTherapistArray.enumerated() {
                    if obj.therapistServiceId == currentTherapistServiceId {
                        currentVC().selectedTherapistArray.remove(at: index)
                    }
                }
                
            } else {
                
                //let filteredArray = therapistArray.filter{$0.isTherapistSelected == true}
                
                let currentTherapistObj = therapistArray[selectedTherapistIndex]
                let currentSlotObject = therapistArray[selectedTherapistIndex].timeSlots[indexPath.item]
                let currentDate = Date()
                if (currentSlotObject.startTimeStampDate > currentDate.millisecondsSince1970) {
                    
                    let selectedObj = BusinessBooking.ConfirmBooking.ViewModel.timeArrayData(startTimeStamp: obj.startTimeStampDate, endTimeStamp: obj.endTimeStampDate, minusTimeStamp: obj.minusTimeStampDate, therapistId: currentTherapistObj.therapistId, therapistServiceId: currentTherapistObj.therapistServiceId)
                    
                    var timeSlotCount = false
                    var timeAddBool = false
                    
                    if currentVC().timeSlotArray.count == 0 {
                        timeAddBool = true
                        timeSlotCount = true
                    } else {
                        var isFound = true
                        for (index, item) in currentVC().timeSlotArray.enumerated() {
                            if item.therapistServiceId == selectedObj.therapistServiceId {
                                let filteredArr = currentVC().timeSlotArray.filter{$0.therapistServiceId == selectedObj.therapistServiceId && $0.startTimeStamp == selectedObj.startTimeStamp}
                                if filteredArr.count > 0 {
                                printToConsole(item: "Error")
                                CustomAlertController.sharedInstance.showErrorAlert(error: localizedTextFor(key: GeneralText.selectAnotherSlot.rawValue))
                                timeSlotCount = false
                                isFound = false
                                    break
                                } else {
                                    currentVC().timeSlotArray.remove(at: index)
                                    currentVC().timeSlotArray.insert(selectedObj, at: index)
                                    timeAddBool = false
                                    timeSlotCount = true
                                    break
                                }
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
                            currentVC().timeSlotArray.append(selectedObj)
                        }
                        
                        let slotsDict:NSDictionary = [
                            "end": currentSlotObject.endTimeStampDate,
                            "start": currentSlotObject.startTimeStampDate,
                            "formatString": currentSlotObject.formatTime
                        ]
                        let selectedObj = Booking.selectedTherapistModel(
                            businessServiceId: currentTherapistObj.servicesIds,
                            isServiceCancel: false, therapistImage: currentTherapistObj.therapistImage,
                            therapistId: currentTherapistObj.therapistId, therapistName: currentTherapistObj.theraPistName, therapistServiceId: currentTherapistObj.therapistServiceId,
                            therapistSlots: slotsDict, collectionTag: collectionView.tag
                        )
                        
                        var objFound = false
                        for (index, obj) in currentVC().selectedTherapistArray.enumerated() {
                            
                            if obj.therapistServiceId == selectedObj.therapistServiceId {
                                objFound = true
                                currentVC().selectedTherapistArray.remove(at: index)
                                currentVC().selectedTherapistArray.insert(selectedObj, at: index)
                                
                                for (indexx,_) in therapistArray[selectedTherapistIndex].timeSlots.enumerated() {
                                    therapistArray[selectedTherapistIndex].timeSlots[indexx].isSelected = false
                                }
                            }
                        }
                        
                        if !objFound {
                            currentVC().selectedTherapistArray.append(selectedObj)
                        }
                        
                        for (index,_) in therapistArray[selectedTherapistIndex].timeSlots.enumerated() {
                            therapistArray[selectedTherapistIndex].timeSlots[index].isSelected = false
                        }
                        
                        therapistArray[selectedTherapistIndex].timeSlots[indexPath.item].isSelected = true
                        
                        cell.collectionTimeLabel.textColor = UIColor.white
                        cell.collectionTimeLabel.backgroundColor = appBarThemeColor
                    }
                } else {
                    CustomAlertController.sharedInstance.showErrorAlert(error: localizedTextFor(key: localizedTextFor(key: BookingSceneText.BookingSceneTimeSelectionAlert.rawValue)))
                }
            }
            
            printToConsole(item: therapistArray)
            printToConsole(item: currentVC().timeSlotArray)
            printToConsole(item: currentVC().selectedTherapistArray)
            
            for (index,obj) in therapistArray.enumerated(){
                for (ind,item) in obj.timeSlots.enumerated(){
                    
                    if therapistArray[index].timeSlots[ind].isSelected == false {
                        if currentVC().timeSlotArray.count == 0 {
                            therapistArray[index].timeSlots[ind].isDisabled = false
                        }
                        for data in currentVC().timeSlotArray{
                            
                            if !((item.startTimeStampDate < data.startTimeStamp && item.endTimeStampDate <= data.startTimeStamp) || data.endTimeStamp <= item.startTimeStampDate) {
                                therapistArray[index].timeSlots[ind].isDisabled = true
                                break
                            } else {
                                therapistArray[index].timeSlots[ind].isDisabled = false
                            }
                            
                        }
                    }
                }
            }
            
            printToConsole(item: therapistArray)
            //therapistCollectionView.reloadData()
            bookingCollectionView.reloadData()
            currentVC().updateProceedButtonHeight()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == therapistCollectionView {
            return CGSize(width: 100, height: 105)
        } else {
            let collectionViewArry = therapistArray[selectedTherapistIndex].timeSlots
            let obj = collectionViewArry[indexPath.item]
            if obj.isDisabled {
                return CGSize(width: 0, height: 25)
            } else {
                return CGSize(width: 75, height: 25)
            }
        }
    }
}

