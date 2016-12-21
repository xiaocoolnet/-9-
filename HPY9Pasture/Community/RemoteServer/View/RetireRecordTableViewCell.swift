//
//  RetireRecordTableViewCell.swift
//  HPY9Pasture
//
//  Created by purepure on 16/10/28.
//  Copyright © 2016年 xiaocool. All rights reserved.
//

import UIKit

class RetireRecordTableViewCell: UITableViewCell {

    var headerView = RetireTableViewCell()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func setValueWithInfo(info:NSDictionary){
        
        self.headerView =  NSBundle.mainBundle().loadNibNamed("RetireTableViewCell", owner: nil, options: nil).first as! RetireTableViewCell
        self.headerView.appointmentButton.hidden = true
        self.headerView.certificationLabel.text = "已认证"
        self.headerView.certificationLabel.backgroundColor = UIColor.greenColor()
        for index in 0...1 {
            let imageView = UIImageView.init(frame: CGRectMake(CGFloat(index)*((WIDTH-25*px)/2+5*px)+10*px, headerView.frame.height, (WIDTH-25*px)/2, 100*px))
            imageView.backgroundColor = UIColor.redColor()
            self.addSubview(imageView)
            
        }
        let videoImageView = UIImageView.init(frame: CGRectMake(5*px, headerView.frame.height+105*px, WIDTH-10*px, 177*px))
        videoImageView.backgroundColor = UIColor.blueColor()
        let playButton = UIButton.init(frame: CGRectMake((WIDTH-100*px)/2, (videoImageView.frame.height-100*px)/2, 100*px, 100*px))
        
        playButton.backgroundColor = UIColor.clearColor()
        playButton.setImage(UIImage(named: "yiyuanpeihu_bofang"), forState: .Normal)
        videoImageView.addSubview(playButton)
        self.addSubview(self.headerView)
        self.addSubview(videoImageView)
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
