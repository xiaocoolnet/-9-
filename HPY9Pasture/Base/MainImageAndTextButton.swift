//
//  MainImageAndTextButton.swift
//  HPY9Pasture
//
//  Created by purepure on 16/10/21.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import UIKit
//import UIBounceButton

class MainImageAndTextButton: UIBounceButton {

    
    let headerImageView = UIImageView()
    let downTextLable = UILabel()
    
    
    
    init(frame:CGRect,imageFrame: CGRect,textFrame:CGRect,imageName:String,labelText:String) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.whiteColor()
        self.headerImageView.frame = imageFrame
        self.downTextLable.frame = textFrame
        self.headerImageView.image = UIImage(named: imageName)
        self.downTextLable.text = labelText
        self.downTextLable.textAlignment = .Center
        self.downTextLable.textColor = UIColor.blackColor()
        self.addSubview(headerImageView)
        self.addSubview(downTextLable)
        
    }
    init(frame:CGRect,image:UIImageView,label:UILabel){
        super.init(frame: frame)
        self.addSubview(image)
        self.addSubview(label)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
