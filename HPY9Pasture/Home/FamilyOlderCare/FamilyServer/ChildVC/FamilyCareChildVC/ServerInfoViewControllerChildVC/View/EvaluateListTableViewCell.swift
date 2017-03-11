//
//  EvaluateListTableViewCell.swift
//  HPY9Pasture
//
//  Created by purepure on 17/2/22.
//  Copyright © 2017年 xiaocool. All rights reserved.
//

import UIKit

class EvaluateListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var headerImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!

    @IBOutlet weak var descriptionLabel: UILabel!
    
    func creatUI(){
        self.headerImageView.layer.masksToBounds = true
        self.headerImageView.layer.cornerRadius = 22
        
        self.nameLabel.textColor = MainTextColor
        self.timeLabel.textColor = MainTextBackColor
        self.descriptionLabel.textColor = MainTextBackColor
        self.descriptionLabel.numberOfLines = 0
        self.descriptionLabel.lineBreakMode = .ByWordWrapping
        
        let lineView = UIView()
        self.sd_addSubviews([lineView])
        lineView.backgroundColor = LGBackColor
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
