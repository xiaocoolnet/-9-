//
//  PropertyTableViewCell.swift
//  HPY9Pasture
//
//  Created by purepure on 17/1/3.
//  Copyright © 2017年 xiaocool. All rights reserved.
//

import UIKit

class PropertyTableViewCell: UITableViewCell {

    @IBOutlet weak var upTextLabel: AutoScrollLabel!
    
    @IBOutlet weak var downTextLabel: AutoScrollLabel!
    
    @IBOutlet weak var rightTextLabel: AutoScrollLabel!
    
    
    
    let lineView = UIView()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setUI(){
        upTextLabel.font = MainFont
        downTextLabel.font = UIFont.systemFontOfSize(12)
        downTextLabel.textColor = MainTextBackColor
        rightTextLabel.textColor = MainTextBackColor
        rightTextLabel.font = MainFont
        
        self.sd_addSubviews([lineView])
        self.lineView.backgroundColor = LGBackColor
        lineView.sd_layout()//添加约束
            .widthIs(WIDTH)
            .heightIs(1)
            .leftSpaceToView(self,0)
            .bottomSpaceToView(self,0)
        self.addSubview(lineView)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
