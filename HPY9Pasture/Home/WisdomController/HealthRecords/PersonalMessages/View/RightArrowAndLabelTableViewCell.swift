//
//  RightArrowAndLabelTableViewCell.swift
//  HPY9Pasture
//
//  Created by purepure on 16/12/21.
//  Copyright © 2016年 xiaocool. All rights reserved.
//

import UIKit

class RightArrowAndLabelTableViewCell: UITableViewCell {
    
    @IBOutlet weak var mainLabel: AutoScrollLabel!
    
    @IBOutlet weak var lastLabel: AutoScrollLabel!

    let lineView = UIView()
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setUIWithDic(dic:NSDictionary){
        mainLabel.font = MainFont
        lastLabel.font = MainFont
        lastLabel.textColor = MainTextBackColor
        lastLabel.textAlignment = .Right
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
