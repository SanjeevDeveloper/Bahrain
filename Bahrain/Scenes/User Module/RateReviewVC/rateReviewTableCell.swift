//
//  rateReviewTableCell.swift
//  Bahrain
//
//  Created by Nitesh Chauhan on 11/20/18.
//  Copyright © 2018 Kashish Verma. All rights reserved.
//

import UIKit
import Cosmos

class rateReviewTableCell: UITableViewCell {
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var discriptionLabel: UILabel!
    @IBOutlet weak var cosmoView: CosmosView!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var mainStackView: UIStackView!
    @IBOutlet weak var stackHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var qualityLabel: UILabel!
    @IBOutlet weak var qualityRating: CosmosView!
    @IBOutlet weak var moneyLabel: UILabel!
    @IBOutlet weak var moneyRating: CosmosView!
    @IBOutlet weak var serviceLabel: UILabel!
    @IBOutlet weak var serviceRating: CosmosView!
    @IBOutlet weak var timingLabel: UILabel!
    @IBOutlet weak var timingRating: CosmosView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        qualityLabel.text = localizedTextFor(key: rateReviewSceneText.Quality.rawValue) + "\n "
        
        moneyLabel.text = localizedTextFor(key: rateReviewSceneText.Money.rawValue)
        
        serviceLabel.text = localizedTextFor(key: rateReviewSceneText.Services.rawValue)
        
        timingLabel.text = localizedTextFor(key: rateReviewSceneText.Timing.rawValue) + "\n "
        
        userImage.layer.cornerRadius = userImage.frame.size.height/2;
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
