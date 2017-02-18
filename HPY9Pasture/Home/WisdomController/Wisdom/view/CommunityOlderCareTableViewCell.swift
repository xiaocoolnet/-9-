//
//  CommunityOlderCareTableViewCell.swift
//  HPY9Pasture
//
//  Created by purepure on 16/12/19.
//  Copyright © 2016年 xiaocool. All rights reserved.
//

import UIKit
import SwiftyJSON

class CommunityOlderCareTableViewCell: UITableViewCell {
    
    @IBOutlet weak var imageButton: UIButton!
    
    @IBOutlet weak var nowLabel: UILabel!

    @IBOutlet weak var lookButton: UIButton!
    
    @IBOutlet weak var adresslabel: AutoScrollLabel!
    
    @IBOutlet weak var nameButton: UIButton!
    @IBOutlet weak var adressButton: UIButton!
    
    @IBOutlet weak var phoneButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setValueWithInfo(info:JSON){
        self.backgroundColor = RGBACOLOR(240, g: 245, b: 248, a: 1)
        self.imageButton.layer.masksToBounds = true
        self.imageButton.layer.cornerRadius = 10
        
        self.nowLabel.layer.masksToBounds = true
        self.nowLabel.layer.cornerRadius = self.nowLabel.height/2
        
        self.lookButton.layer.masksToBounds = true
        self.lookButton.layer.cornerRadius = self.lookButton.height/2
        self.lookButton.layer.borderColor = UIColor.whiteColor().CGColor
        self.lookButton.layer.borderWidth = 1.5
        if info["name"].string != nil {
            self.adresslabel.text = info["name"].string
        }
        
        
        self.adresslabel.font = UIFont.systemFontOfSize(13)
        if info["principalname"].string != nil {
            self.nameButton.setTitle(info["principalname"].string, forState:.Normal)
        }
        
        self.nameButton.setTitleColor(RGBACOLOR(149, g: 149, b: 149, a: 1), forState: .Normal)
        self.nameButton.contentHorizontalAlignment = .Left
        
        if info["address"].string != nil {
            self.adressButton.setTitle(info["address"].string, forState:.Normal)
        }
        self.adressButton.setTitleColor(RGBACOLOR(149, g: 149, b: 149, a: 1), forState: .Normal)
        self.adressButton.contentHorizontalAlignment = .Left
        
        if info["phone"].string != nil {
            self.phoneButton.setTitle(info["phone"].string, forState:.Normal)
        }
        self.phoneButton.setTitleColor(RGBACOLOR(149, g: 149, b: 149, a: 1), forState: .Normal)
        self.phoneButton.contentHorizontalAlignment = .Left
        
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
