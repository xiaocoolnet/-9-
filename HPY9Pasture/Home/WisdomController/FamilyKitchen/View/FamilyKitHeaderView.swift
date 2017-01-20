//
//  FamilyKitHeaderView.swift
//  HPY9Pasture
//
//  Created by purepure on 17/1/13.
//  Copyright © 2017年 xiaocool. All rights reserved.
//

import UIKit

class FamilyKitHeaderView: UITableViewCell {
    
    
    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var headerImageview: UIImageView!
    
    @IBOutlet weak var name: AutoScrollLabel!

    @IBOutlet weak var money: AutoScrollLabel!
    
    @IBOutlet weak var advertiseMentLabel: AutoScrollLabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setUI(){
        name.font = UIFont.systemFontOfSize(15)
        name.textColor = UIColor.whiteColor()
        name.textAlignment = .Left
        money.font = UIFont.systemFontOfSize(13)
        money.textAlignment = .Left
        money.textColor = UIColor.whiteColor()
        advertiseMentLabel.font = UIFont.systemFontOfSize(12)
        advertiseMentLabel.textAlignment = .Left
        advertiseMentLabel.textColor = UIColor.whiteColor()
        headerImageview.layer.masksToBounds = true
        headerImageview.layer.borderWidth = 4*px
        headerImageview.layer.borderColor = RGBACOLOR(255, g: 255, b: 255, a: 0.4).CGColor
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
