//
//  DetailsTableViewCell.swift
//  HPY9Pasture
//
//  Created by purepure on 17/1/3.
//  Copyright © 2017年 xiaocool. All rights reserved.
//

import UIKit

class DetailsTableViewCell: UITableViewCell {

    
    @IBOutlet weak var leftTextLabel: AutoScrollLabel!
    
    @IBOutlet weak var rightTextLabel: AutoScrollLabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setUI(){
        leftTextLabel.font = MainFont
        rightTextLabel.font = MainFont
        leftTextLabel.textColor = MainTextBackColor
        rightTextLabel.textColor = MainTextBackColor
        rightTextLabel.textAlignment = .Right
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
