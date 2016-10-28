//
//  OutpatientTableViewCell.swift
//  HPY9Pasture
//
//  Created by purepure on 16/10/27.
//  Copyright © 2016年 xiaocool. All rights reserved.
//

import UIKit
import SDWebImage

class OutpatientTableViewCell: UITableViewCell {
    @IBOutlet weak var headerImageView: UIImageView!

    @IBOutlet weak var nameForOutpatient: AutoScrollLabel!
    
    @IBOutlet weak var nameForpeople: AutoScrollLabel!
    
    @IBOutlet weak var departments: UITextView!
    
    @IBOutlet weak var adressForOut: AutoScrollLabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func setValueWithInfo(info:NSDictionary){
        
        self.headerImageView.sd_setImageWithURL(NSURL(string:"http://photo.enterdesk.com/2010-10-24/enterdesk.com-3B11711A460036C51C19F87E7064FE9D.jpg"), placeholderImage: UIImage(named: "ic_moren-da"))
//        self.headerImageView.image = UIImage(named: "my拷贝")
        self.adressForOut.text = "测试地址在这里呀呀呀呀呀呀呀呀呀呀呀呀呀呀呀就看见哦加"
        self.adressForOut.font = MainFont
//        let str1 = NSMutableAttributedString(string: "测试门诊名称昌邑县看看字体的滚动")
//        let range1 = NSRange(location: 0, length: str1.length)
//        let number = NSNumber(integer:NSUnderlineStyle.StyleSingle.rawValue)//此处需要转换为NSNumber 不然不对,rawValue转换为integer
//        str1.addAttribute(NSUnderlineStyleAttributeName, value: number, range: range1)
//        str1.addAttribute(NSForegroundColorAttributeName, value: UIColor.blueColor(), range: range1)

        self.nameForOutpatient.text = "测试门诊名称昌邑县看看字体的滚动"
        self.nameForOutpatient.font = UIFont.boldSystemFontOfSize(15)
//        self.nameForOutpatient.
        self.nameForpeople.text = "测试负责人名称昌邑县看看字体的滚动"
        self.nameForpeople.font = MainFont
//        self.departments.textColor = UIColor.
        self
    }
    

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
