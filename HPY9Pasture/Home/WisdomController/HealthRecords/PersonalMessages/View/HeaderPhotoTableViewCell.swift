//
//  HeaderPhotoTableViewCell.swift
//  HPY9Pasture
//
//  Created by purepure on 16/12/21.
//  Copyright © 2016年 xiaocool. All rights reserved.
//

import UIKit

class HeaderPhotoTableViewCell: UITableViewCell {

    @IBOutlet weak var mainLabel: UILabel!
    
    @IBOutlet weak var headerImageView: UIImageView!
    
    let lineView = UIView()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setUIWithDic(dic:NSDictionary){
        
        self.sd_addSubviews([lineView])
        self.lineView.backgroundColor = LGBackColor
        lineView.sd_layout()//添加约束
            .widthIs(WIDTH)
            .heightIs(1)
            .leftSpaceToView(self,0)
            .bottomSpaceToView(self,0)
        self.addSubview(lineView)
        
        self.headerImageView.layer.masksToBounds = true
        self.headerImageView.layer.cornerRadius = 38/2
        
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
