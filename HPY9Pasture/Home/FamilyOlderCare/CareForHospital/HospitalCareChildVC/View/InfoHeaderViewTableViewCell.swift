//
//  InfoHeaderViewTableViewCell.swift
//  HPY9Pasture
//
//  Created by purepure on 17/2/27.
//  Copyright © 2017年 xiaocool. All rights reserved.
//

import UIKit

class InfoHeaderViewTableViewCell: UITableViewCell {
    

    @IBOutlet weak var headerImageView: UIButton!
    
    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var hospital: UILabel!
    
    @IBOutlet weak var roomName: UILabel!
    
    @IBOutlet weak var phone: AutoScrollLabel!
    
    @IBOutlet weak var addressForHos: AutoScrollLabel!
   
    
    @IBOutlet weak var adress: AutoScrollLabel!
    
    @IBOutlet weak var time: AutoScrollLabel!
    
    @IBOutlet weak var changeButton: UIButton!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        self.headerImageView.layer.masksToBounds = true
        self.headerImageView.layer.cornerRadius = 22.5
        self.headerImageView.layer.borderColor = RGBACOLOR(255, g: 152, b: 0, a: 1).CGColor
        self.headerImageView.layer.borderWidth = 1
        self.phone.textColor = UIColor.whiteColor()
        self.phone.font = UIFont.systemFontOfSize(12)
        self.addressForHos.textColor = UIColor.whiteColor()
        self.addressForHos.font = UIFont.systemFontOfSize(12)
        self.adress.textColor = UIColor.whiteColor()
        self.adress.font = UIFont.systemFontOfSize(12)
        self.time.textColor = UIColor.whiteColor()
        self.time.font = UIFont.systemFontOfSize(12)
        
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
