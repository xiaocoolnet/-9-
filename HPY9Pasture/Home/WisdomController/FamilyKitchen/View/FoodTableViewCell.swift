//
//  FoodTableViewCell.swift
//  HPY9Pasture
//
//  Created by purepure on 17/1/16.
//  Copyright © 2017年 xiaocool. All rights reserved.
//

import UIKit

class FoodTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var foodImage: UIImageView!
    
    @IBOutlet weak var foodName: AutoScrollLabel!
    
    @IBOutlet weak var moneyLabel: UILabel!
    
    @IBOutlet weak var fooddescribe: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func setUI(){
        foodName.font = MainFont
        foodName.textColor = RGBACOLOR(83, g: 83, b: 83, a: 1)
        fooddescribe.font = UIFont.systemFontOfSize(12)
        fooddescribe.textColor = RGBACOLOR(201, g: 201, b: 201, a: 1)
        fooddescribe.userInteractionEnabled = false
        fooddescribe.textAlignment = .Left
        fooddescribe.numberOfLines = 0
        fooddescribe.lineBreakMode = .ByWordWrapping
        moneyLabel.font = UIFont.systemFontOfSize(15)
        moneyLabel.textAlignment = .Right
        moneyLabel.textColor = RGBACOLOR(255, g: 172, b: 49, a: 1)
        
        let lineView = UIView()
        self.sd_addSubviews([lineView])
        lineView.backgroundColor = LGBackColor
        //        lineView.frame = CGRectMake(0, 1, Screen_W, 1)
        lineView.sd_layout()//添加约束
            .widthIs(WIDTH)
            .heightIs(1)
            .leftSpaceToView(self,0)
            .bottomSpaceToView(self,0)
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
