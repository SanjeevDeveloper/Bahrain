//
//  BusinessCalenderTableViewCell.swift
//  iBeauty
//
//  Created by Nitesh Chauhan on 4/4/18.
//  Copyright © 2018 Kashish Verma. All rights reserved.
//

import UIKit

class BusinessCalenderTableViewCell: UITableViewCell {

  
    @IBOutlet weak var timeLabel: UILabelFontSize!
  //  @IBOutlet weak var amLabel: UILabelFontSize!
    @IBOutlet weak var serviceNameLabel: UILabelFontSize!
    @IBOutlet weak var clientNameLabel: UILabelFontSize!
    @IBOutlet weak var totalPriceLabel: UILabelFontSize!
   
    @IBOutlet weak var depositPriceLbl: UILabelFontSize!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setData(currentObj:BusinessToday.ViewModel.tableCellData){
        
        //timeLabel.text = currentObj.appointmentTime
        //amLabel.text = currentObj.am
        
        serviceNameLabel.text = currentObj.clientName.uppercased()
        
      //  durationTimeLabel.text = localizedTextFor(key: BusinessCalenderSceneText.BusinessCalenderSceneServiceDurationLabel.rawValue) + ": " + currentObj.durationTime.description + " " + localizedTextFor(key: BusinessCalenderSceneText.BusinessCalenderSceneServiceDurationMinuteText.rawValue)
        
        clientNameLabel.text = currentObj.serviceName + ": " + currentObj.therapistName
        
        totalPriceLabel.text = localizedTextFor(key: BusinessCalenderSceneText.BusinessCalenderSceneTotalPriceLabel.rawValue) + ": " + currentObj.totalAmount.description + " " +  localizedTextFor(key: GeneralText.bhd.rawValue)
        
          timeLabel.text = localizedTextFor(key: BusinessCalenderSceneText.BusinessCalenderSceneTimeLabel.rawValue) + ": " + currentObj.appointmentTime.description +  " " + currentObj.am
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
