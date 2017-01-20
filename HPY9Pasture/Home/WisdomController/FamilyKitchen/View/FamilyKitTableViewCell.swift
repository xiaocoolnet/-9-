//
//  FamilyKitTableViewCell.swift
//  HPY9Pasture
//
//  Created by purepure on 17/1/13.
//  Copyright © 2017年 xiaocool. All rights reserved.
//

import UIKit

class FamilyKitTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBOutlet weak var name: AutoScrollLabel!
    
    @IBOutlet weak var money: UILabel!
    
    @IBOutlet weak var adress: AutoScrollLabel!
    
    @IBOutlet weak var phone: AutoScrollLabel!
    
    
    @IBOutlet weak var headerImage: UIImageView!
    func setUI(){
        name.font = MainFont
        name.textColor = RGBACOLOR(50, g: 50, b: 50, a: 1)
        name.textAlignment = .Left
        money.textColor = RGBACOLOR(49, g: 132, b: 219, a: 1)
        money.textAlignment = .Right
        adress.font = UIFont.systemFontOfSize(12)
        adress.textAlignment = .Left
        adress.textColor = MainTextBackColor
        phone.font = UIFont.systemFontOfSize(12)
        phone.textAlignment = .Left
        phone.textColor = MainTextBackColor
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
