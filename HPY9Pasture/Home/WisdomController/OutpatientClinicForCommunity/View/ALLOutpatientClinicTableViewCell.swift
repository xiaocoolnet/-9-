//
//  ALLOutpatientClinicTableViewCell.swift
//  HPY9Pasture
//
//  Created by purepure on 17/2/8.
//  Copyright © 2017年 xiaocool. All rights reserved.
//

import UIKit

class ALLOutpatientClinicTableViewCell: UITableViewCell {

    @IBOutlet weak var headerImageView: UIImageView!
    
    @IBOutlet weak var name: AutoScrollLabel!
    
    @IBOutlet weak var personName: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var lineView: UIView!
    @IBOutlet weak var adress: AutoScrollLabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setUI(){
        name.font = MainFont
        name.font = UIFont.boldSystemFontOfSize(15)
        name.textColor = MainTextColor
        name.textAlignment = .Left
        
        personName.font = MainFont
        personName.textColor = MainTextColor
        personName.textAlignment = .Left
        
        descriptionLabel.textAlignment = .Left
        descriptionLabel.font = UIFont.systemFontOfSize(12)
        descriptionLabel.textColor = MainTextBackColor
        descriptionLabel.userInteractionEnabled = false
        descriptionLabel.numberOfLines = 0
        descriptionLabel.lineBreakMode = .ByWordWrapping
        
        self.lineView.backgroundColor = LGBackColor
        
        adress.font = MainFont
        adress.textColor = MainTextColor
        adress.textAlignment = .Left
        
        
        let lineView = UIView()
        self.sd_addSubviews([lineView])
        lineView.backgroundColor = LGBackColor
        //        lineView.frame = CGRectMake(0, 1, Screen_W, 1)
        lineView.sd_layout()//添加约束
            .widthIs(WIDTH)
            .heightIs(4.5)
            .leftSpaceToView(self,0)
            .bottomSpaceToView(self,0)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
