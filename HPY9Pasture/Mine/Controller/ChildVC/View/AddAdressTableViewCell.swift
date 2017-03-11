//
//  AddAdressTableViewCell.swift
//  HPY9Pasture
//
//  Created by purepure on 17/3/7.
//  Copyright © 2017年 xiaocool. All rights reserved.
//

import UIKit

class AddAdressTableViewCell: UITableViewCell {
    
    @IBOutlet weak var mytextField: UITextField!
    let lebel = UILabel()
    

    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.whiteColor()
        self.mytextField.leftViewMode = .Always
        lebel.frame =  CGRectMake(0, 0, 80*px, 44)
        lebel.textColor = MainTextColor
        lebel.font = MainFont
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
    func creatUI(isMap:Bool){
        if isMap{
            let backView = UIView.init(frame: CGRectMake(0, 0, 100*px, 44))
            let imageView = UIImageView.init(frame: CGRectMake(80*px, 15, 11, 14))
            imageView.image = UIImage(named: "ic_dingwei")
            backView.backgroundColor = UIColor.whiteColor()
            backView.addSubview(self.lebel)
            backView.addSubview(imageView)
            self.mytextField.leftView = backView
            self.mytextField.userInteractionEnabled = false
        }else{
            self.mytextField.userInteractionEnabled = true
            self.mytextField.leftView = self.lebel
        }
    }
    

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
