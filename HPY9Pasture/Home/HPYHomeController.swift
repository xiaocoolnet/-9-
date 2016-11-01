//
//  HPYHomeController.swift
//  HPY9Pasture
//
//  Created by xiaocool on 16/10/10.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import UIKit

class HPYHomeController: UIViewController {
    
    let textArray = ["智慧养老","医疗保健","预约服务","便民商城","政府采购","第三方评估"]
    let imageArray = ["shouye_zhihuiyanglao","shouye_yiliaopbaojian","shouye_yuyuefuwu","shouye_bianmingshangcheng","shouye_zhengfucaigou","shouye_disanfang"]
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = LGBackColor
        self.title = "快乐9号"
        self.tabBarItem.title = "首页"
        createUI()
        // Do any additional setup after loading the view.
    }
    func createUI(){
        let backImageView = UIImageView()
        backImageView.frame = self.view.frame
        backImageView.image = UIImage(named:"shouye_beijing")
        self.view.addSubview(backImageView)
        for index in 0...5 {
            let myButton = UIBounceButton.init(frame: CGRectMake(WIDTH/2, -300, 150*px, 110*px))
            myButton.tag = index
            myButton.addTarget(self, action: #selector(self.myButtonAction(_:)), forControlEvents: .TouchUpInside)
            myButton.backgroundColor = UIColor.clearColor()
            let backView = UIView.init(frame:myButton.frame)
            backView.backgroundColor = UIColor.whiteColor()
            backView.alpha = 0
            backView.layer.masksToBounds = true
            backView.layer.cornerRadius = 5
            self.view.addSubview(backView)
            let imageViews = UIImageView.init(frame: CGRectMake(45*px, 10*px, 60*px, 60*px))
            imageViews.image = UIImage(named: imageArray[index])
            myButton.addSubview(imageViews)
            
            let textLabel = FXLabel.init(frame: CGRectMake(0, 75*px, 150*px, 35*px))
            textLabel.text = textArray[index]
            textLabel.textAlignment = .Center
            textLabel.font = MainFont
            textLabel.textColor = UIColor.whiteColor()
            textLabel.shadowColor = nil
            textLabel.shadowOffset = CGSizeMake(0.0, 2.0)
            textLabel.shadowColor = RGBACOLOR(0, g: 0, b: 0, a: 0.75)
            textLabel.shadowBlur = 5.0
            myButton.addSubview(textLabel)
            myButton.alpha = 0
            self.view.addSubview(myButton)
            
            UIView.beginAnimations(nil, context: nil)
            UIView.setAnimationDuration(1)
            //
            myButton.frame = CGRectMake(20*px + CGFloat((index)%2)*(WIDTH/2-10*px), 40*px+CGFloat(index/2)*140*px, 150*px, 110*px)
            backView.frame = myButton.frame
            myButton.alpha = 1
            backView.alpha = 0.65
            UIView.commitAnimations()
        }
        
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
//        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    
    func myButtonAction(sender:UIButton){
        switch sender.tag {
        case 0:
            let vc = WisdomControllerViewController()
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
            break
        case 1:
            break
        case 2:
            break
        case 3:
            break
        case 4:
            break
        case 5:
            break
        default:
            break
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
//        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
}
