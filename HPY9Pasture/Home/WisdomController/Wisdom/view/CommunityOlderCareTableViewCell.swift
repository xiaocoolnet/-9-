//
//  CommunityOlderCareTableViewCell.swift
//  HPY9Pasture
//
//  Created by purepure on 16/12/19.
//  Copyright © 2016年 xiaocool. All rights reserved.
//

import UIKit

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
    
    func setValueWithInfo(info:NSDictionary){
        self.backgroundColor = RGBACOLOR(240, g: 245, b: 248, a: 1)
        self.imageButton.layer.masksToBounds = true
        self.imageButton.layer.cornerRadius = 10
        
        self.nowLabel.layer.masksToBounds = true
        self.nowLabel.layer.cornerRadius = self.nowLabel.height/2
        
        self.lookButton.layer.masksToBounds = true
        self.lookButton.layer.cornerRadius = self.lookButton.height/2
        self.lookButton.layer.borderColor = UIColor.whiteColor().CGColor
        self.lookButton.layer.borderWidth = 1.5
        
        self.adresslabel.text = "中小路老年日间照料中心"
        self.adresslabel.font = UIFont.systemFontOfSize(13)
        self.nameButton.setTitle("负责人：王淳淳", forState:.Normal)
        self.nameButton.setTitleColor(RGBACOLOR(149, g: 149, b: 149, a: 1), forState: .Normal)
        self.nameButton.contentHorizontalAlignment = .Left
        
        self.adressButton.setTitle("芝罘区白石路", forState:.Normal)
        self.adressButton.setTitleColor(RGBACOLOR(149, g: 149, b: 149, a: 1), forState: .Normal)
        self.adressButton.contentHorizontalAlignment = .Left
        
        self.phoneButton.setTitle("13000000000", forState:.Normal)
        self.phoneButton.setTitleColor(RGBACOLOR(149, g: 149, b: 149, a: 1), forState: .Normal)
        self.phoneButton.contentHorizontalAlignment = .Left
        
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
