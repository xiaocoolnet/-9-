//
//  RetireTableViewCell.swift
//  HPY9Pasture
//
//  Created by purepure on 16/10/28.
//  Copyright © 2016年 xiaocool. All rights reserved.
//

import UIKit

class RetireTableViewCell: UITableViewCell {

    @IBOutlet weak var certificationLabel: UILabel!
    @IBOutlet weak var appointmentButton: UIButton!
    @IBOutlet weak var deadlineLabel: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        appointmentButton.layer.masksToBounds = true
        appointmentButton.layer.cornerRadius = appointmentButton.frame.height/2
        appointmentButton.layer.borderWidth = 1
        appointmentButton.layer.borderColor = UIColor.orangeColor().CGColor
        // Initialization code
    }
    func setValueWithInfo(info:NSDictionary){
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
