//
//  SpiritualComfortChildVCTableViewCell.swift
//  HPY9Pasture
//
//  Created by purepure on 17/3/1.
//  Copyright © 2017年 xiaocool. All rights reserved.
//

import UIKit

class SpiritualComfortChildVCTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var HeaderImageView: UIImageView!
    
    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var socreBackView: UIView!

    @IBOutlet weak var goButton: UIButton!
    @IBOutlet weak var money: UILabel!
    @IBOutlet weak var desLabel: AutoScrollLabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        HeaderImageView.layer.masksToBounds = true
        HeaderImageView.layer.cornerRadius = 27
        desLabel.font = UIFont.systemFontOfSize(12)
        desLabel.textColor = MainTextBackColor
        goButton.layer.masksToBounds = true
        goButton.layer.cornerRadius = 22
        goButton.layer.borderColor = UIColor.orangeColor().CGColor
        goButton.layer.borderWidth = 1
        goButton.setTitleColor(UIColor.orangeColor(), forState: .Normal)
        goButton.setTitle("预约", forState: .Normal)
        money.textColor = UIColor.orangeColor()
        
        let lineView = UIView()
        self.sd_addSubviews([lineView])
        lineView.backgroundColor = LGBackColor
        lineView.sd_layout()//添加约束
            .widthIs(WIDTH)
            .heightIs(1)
            .leftSpaceToView(self,0)
            .bottomSpaceToView(self,0)

        
        // Initialization code
    }
    
    func CreatUI(count:Int){
        for indexs in 1...count{
            let xingImageView = UIImageView.init(frame: CGRectMake(CGFloat(indexs*15), 0, 13, 13))
            xingImageView.image = UIImage(named: "ic_xing")
            self.socreBackView.addSubview(xingImageView)
        }
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
