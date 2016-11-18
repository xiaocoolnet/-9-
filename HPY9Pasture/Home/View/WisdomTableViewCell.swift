//
//  WisdomTableViewCell.swift
//  HPY9Pasture
//
//  Created by purepure on 16/11/18.
//  Copyright © 2016年 xiaocool. All rights reserved.
//

import UIKit

class WisdomTableViewCell: UITableViewCell {
    
    let mainTitle = UILabel()
    let classifyButtonBackView = UIView()
    let lookMoreButton = UIButton()
    var targets:UIViewController!
    var lookAllButton = UIButton()
    let lineView = UIView()
    let footView = UIView()
    var isAll = Bool()
    
    
    
    
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    init(myDIC:NSDictionary,isAlll:Bool){
        super.init(style: UITableViewCellStyle.Default , reuseIdentifier: "WisdomTableViewCell")
        self.backgroundColor = UIColor.whiteColor()
        self.sd_addSubviews([mainTitle,classifyButtonBackView,lookAllButton,footView])
        mainTitle.frame = CGRectMake(10, 0, width, 88*px)
        mainTitle.backgroundColor = UIColor.whiteColor()
        mainTitle.text = myDIC.objectForKey("mainTitle") as? String
        mainTitle.font = MainFont
        mainTitle.textColor = UIColor.blackColor()
        mainTitle.textAlignment = .Left
        
        footView.backgroundColor = LGBackColor
        footView.sd_layout()
            .heightIs(10)
            .widthIs(WIDTH)
            .leftSpaceToView(self,0)
            .bottomSpaceToView(self,0)
        
        var classifyArray = NSArray()
        
        if myDIC.objectForKey("classify") != nil {
            classifyArray = (myDIC.objectForKey("classify") as? NSArray)!
        }
        var counts = Int()
        
        if  isAlll {
            counts = classifyArray.count
        }else{
            if classifyArray.count<9 {
                counts = classifyArray.count
            }else{
                counts = 8
                
            }
        }
        
        
        
        classifyButtonBackView.frame = CGRectMake(0, mainTitle.height, WIDTH, WIDTH/4*CGFloat((classifyArray.count-1)/4)+1)
        if classifyArray.count > 8 {
            
            lineView.backgroundColor = UIColor.grayColor()
            lineView.frame = CGRectMake(10, classifyButtonBackView.height-1, WIDTH-20, 1)
            classifyButtonBackView.addSubview(lineView)
            
            lookAllButton.sd_layout()
                .heightIs(44*px)
                .widthIs(WIDTH)
                .leftSpaceToView(self,0)
                .bottomSpaceToView(self,10)
            
            lookAllButton.backgroundColor = UIColor.whiteColor()
            lookAllButton.setTitleColor(NavColor, forState: .Normal)
            lookAllButton.setTitle("查看全部", forState: .Normal)
            lookAllButton.contentHorizontalAlignment = .Center
            lookAllButton.titleLabel?.font = MainFont
//            lookAllButton.addTarget(self, action: #selector(self.lookAllButtonAction(_:)), forControlEvents: .TouchUpInside)
            
//            self.addSubview(lookAllButton)
        }
        
        for indexs in 0...counts-1 {
            
            let classifyButton = MainImageAndTextButton.init(frame: CGRectMake(WIDTH/4*CGFloat((indexs)%4), WIDTH/4*CGFloat((indexs)/4), WIDTH/4, WIDTH/4), imageFrame: CGRectMake((WIDTH/4-38*px)/2, 5*px, 38*px, 38*px), textFrame: CGRectMake(0, 43*px, WIDTH/4, WIDTH/4-43*px), imageName: classifyArray[indexs].objectForKey("image") as! String, labelText: classifyArray[indexs].objectForKey("text") as! String)
            classifyButton.downTextLable.font = UIFont.systemFontOfSize(13)
            
            classifyButton.addTarget(self, action: #selector(self.classifyButtonAction(_:)), forControlEvents: .TouchUpInside)
            classifyButtonBackView.addSubview(classifyButton)
            
        }
        
    }
    
    
    func classifyButtonAction(sender:UIButton){
        
    }
    
    func lookAllButtonAction(sender:UIButton){
        self.height = 500
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


}
