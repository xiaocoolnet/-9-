//
//  SecurityAndOlderCareChildVCTableViewCell.swift
//  HPY9Pasture
//
//  Created by purepure on 17/2/13.
//  Copyright © 2017年 xiaocool. All rights reserved.
//

import UIKit

class SecurityAndOlderCareChildVCTableViewCell: UITableViewCell {

    @IBOutlet weak var adress: UILabel!
    
    @IBOutlet weak var time: UILabel!
    
    @IBOutlet weak var backImage: UIImageView!
    
    @IBOutlet weak var playButton: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func creatUI(){
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
