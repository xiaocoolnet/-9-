//
//  KindVCTableViewCell.swift
//  HPY9Pasture
//
//  Created by purepure on 16/12/20.
//  Copyright © 2016年 xiaocool. All rights reserved.
//

import UIKit

class KindVCTableViewCell: UITableViewCell {

    @IBOutlet weak var comeInButton: UIButton!
    @IBOutlet weak var mainlabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func setUI(){
        comeInButton.layer.masksToBounds = true
        comeInButton.setTitleColor(NavColor, forState: .Normal)
        comeInButton.layer.cornerRadius = (self.height-14)/2
        comeInButton.layer.borderColor = NavColor.CGColor
        comeInButton.layer.borderWidth = 1*px
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
