//
//  DoctorInfoForMedicalCareVCCell.swift
//  HPY9Pasture
//
//  Created by purepure on 17/2/9.
//  Copyright © 2017年 xiaocool. All rights reserved.
//

import UIKit

class DoctorInfoForMedicalCareVCCell: UITableViewCell {
    
    @IBOutlet weak var headerImageView: UIImageView!
    
    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var level: UILabel!

    @IBOutlet weak var hospital: UILabel!
    
    @IBOutlet weak var skilled: UILabel!
    
    func setUI(){
        headerImageView.layer.masksToBounds = true
        headerImageView.layer.cornerRadius = 30
        name.font = MainFont
        
        level.font = UIFont.systemFontOfSize(12)
        level.textColor = MainTextBackColor
        hospital.font = UIFont.systemFontOfSize(12)
        hospital.textColor = MainTextBackColor
        skilled.font = UIFont.systemFontOfSize(12)
        skilled.textColor = MainTextBackColor
        
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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
