//
//  infoView.swift
//  mapDemo
//
//  Created by Nitesh Chauhan on 5/23/18.
//  Copyright © 2018 Nitesh Chauhan. All rights reserved.
//

import Foundation
class infoView: UIView {
    
    @IBOutlet var mainView: UIView!
    //@IBOutlet weak var infoImageView: UIImageView!
    @IBOutlet weak var firstLabel: UILabelFontSize!
    //@IBOutlet weak var secondLabel: UILabelFontSize!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        // fatalError("init(coder:) has not been implemented")
        super.init(coder: aDecoder)
        commonInit()
    }
    
    
    private func commonInit() {
        // do stuff here
        Bundle.main.loadNibNamed("infoWindowView", owner: self, options: nil)
        addSubview(mainView)
        mainView.frame = self.bounds
        mainView.layer.cornerRadius = 3
    }
}
