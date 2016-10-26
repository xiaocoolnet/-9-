//
//  ImageAndTextTableViewCell.swift
//  HPY9Pasture
//
//  Created by purepure on 16/10/21.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import UIKit

class ImageAndTextTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }
    init(){
        super.init(style: .Default, reuseIdentifier: "ImageAndTextTableViewCell")
        let lineView = UIView()
        lineView.backgroundColor = LGBackColor
        lineView.frame = CGRectMake(0, self.frame.height-1, Screen_W, 1)
        self.addSubview(lineView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
