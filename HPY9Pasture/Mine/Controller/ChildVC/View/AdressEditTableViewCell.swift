//
//  AdressEditTableViewCell.swift
//  HPY9Pasture
//
//  Created by purepure on 17/3/6.
//  Copyright © 2017年 xiaocool. All rights reserved.
//

import UIKit

class AdressEditTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var adress: UILabel!
    
    @IBOutlet weak var name: UILabel!
    
    
    @IBOutlet weak var phoneLabel: UILabel!
    
    @IBOutlet weak var delButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        adress.textColor = MainTextColor
        name.textColor = MainTextBackColor
        phoneLabel.textColor = MainTextBackColor
        delButton.layer.masksToBounds = true
        delButton.setTitleColor(NavColor, forState: .Normal)
        delButton.layer.cornerRadius = 5
        delButton.layer.borderColor = NavColor.CGColor
        delButton.layer.borderWidth = 1
        let lineView = UIView()
        self.sd_addSubviews([lineView])
        lineView.backgroundColor = LGBackColor
        lineView.sd_layout()//添加约束
            .widthIs(WIDTH)
            .heightIs(1)
            .leftSpaceToView(self,0)
            .bottomSpaceToView(self,0)
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
