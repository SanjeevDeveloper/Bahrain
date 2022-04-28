
import UIKit

class BusinessTodayTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var durationTimeLabel: UILabelFontSize!
    @IBOutlet weak var timeLabel: UILabelFontSize!
    @IBOutlet weak var serviceNameLabel: UILabelFontSize!
    @IBOutlet weak var therapistNameLabel: UILabelFontSize!
    @IBOutlet weak var clientName: UILabelFontSize!
    @IBOutlet weak var amLabel: UILabelFontSize!
    @IBOutlet weak var cancelLabel: UILabelFontSize!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setData(currentObj:BusinessToday.ViewModel.tableCellData){
        
        serviceNameLabel.text = currentObj.serviceName.uppercased()
        therapistNameLabel.text = localizedTextFor(key: BusinessTodaySceneText.BusinessTodayTherapistText.rawValue) + "- " + currentObj.therapistName
        clientName.text = localizedTextFor(key: BusinessTodaySceneText.BusinessTodayClientNameText.rawValue) + "- " + currentObj.clientName
        durationTimeLabel.text = localizedTextFor(key: BusinessTodaySceneText.BusinessTodayTimeText.rawValue) + "- " + currentObj.durationTime.description + " " + localizedTextFor(key: BusinessCalenderSceneText.BusinessCalenderSceneServiceDurationMinuteText.rawValue)
        timeLabel.text = currentObj.appointmentTime
        amLabel.text = currentObj.am
        
        if currentObj.isCancelled  {
            cancelLabel.isHidden = false
            cancelLabel.text = localizedTextFor(key: BusinessTodaySceneText.BusinessTodayCancelText.rawValue)
        }
        else{
            cancelLabel.isHidden = true
        }
    }
    
}
