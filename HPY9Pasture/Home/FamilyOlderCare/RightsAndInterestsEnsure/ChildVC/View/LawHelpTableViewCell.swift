//
//  LawHelpTableViewCell.swift
//  HPY9Pasture
//
//  Created by purepure on 17/3/6.
//  Copyright © 2017年 xiaocool. All rights reserved.
//

import UIKit

class LawHelpTableViewCell: UITableViewCell {
    
    @IBOutlet weak var headerImage: UIImageView!
    
    @IBOutlet weak var name: UILabel!
    
    
    @IBOutlet weak var adress: UILabel!
    
    @IBOutlet weak var disLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = LGBackColor
        headerImage.layer.masksToBounds = true
        headerImage.layer.cornerRadius = 25
        name.textColor = UIColor.blackColor()
        adress.textColor = MainTextBackColor
        disLabel.textColor = MainTextBackColor
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
