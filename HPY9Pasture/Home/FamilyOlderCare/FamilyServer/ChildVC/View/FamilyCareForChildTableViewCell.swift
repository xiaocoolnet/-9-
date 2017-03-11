//
//  FamilyCareForChildTableViewCell.swift
//  HPY9Pasture
//
//  Created by purepure on 17/2/10.
//  Copyright © 2017年 xiaocool. All rights reserved.
//

import UIKit

class FamilyCareForChildTableViewCell: UITableViewCell {
    
    @IBOutlet weak var headerimageView: UIImageView!
    
    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var serverTime: UILabel!

    @IBOutlet weak var prestige: UILabel!//信誉
    
    @IBOutlet weak var scoreBackView: UIView!
    
    @IBOutlet weak var timesForServer: UILabel!
    
    @IBOutlet weak var moneyLabel: UILabel!

    
    @IBOutlet weak var appointmentButton: UIButton!//预约Button
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func creatUI(index:Int){
        
        headerimageView.layer.masksToBounds = true
        headerimageView.layer.cornerRadius = 21
        headerimageView.layer.borderColor = NavColor.CGColor
        headerimageView.layer.borderWidth = 1
        
        appointmentButton.layer.masksToBounds = true
        appointmentButton.layer.cornerRadius = 12
        
        for indexs in 1...index{
            let xingImageView = UIImageView.init(frame: CGRectMake(CGFloat(indexs*15), 0, 13, 13))
            xingImageView.image = UIImage(named: "ic_xing")
            self.scoreBackView.addSubview(xingImageView)
        }
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
