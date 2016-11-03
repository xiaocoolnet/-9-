//
//  HPYMineController.swift
//  HPY9Pasture
//
//  Created by xiaocool on 16/10/10.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import UIKit

class HPYMineController: UIViewController {
    
    let myScrollView = UIScrollView()//底部滑动试图
    var myHeaderImageView = ColorfulNameLabel()
    let myHeaderImageButton = UIButton()
    let loginButton = UIButton()
    
    let orderStateTextArray = ["待付款","待发货","待收货","待评价","售后"]
    let orderStateImageArray = ["wode_daifukuan","wode_daifahuo","wode_daishouhuo","wode_daipingjia","wode_shouhou"]
    let toolTextArray = ["机票","收藏","关注","足迹","快递","通信","卡卷","其他"]
    let toolImageArray = ["wode_jipiao","wode_shoucang","wode_guanzhu","wode_zuji","wode_kuaidi","wode_tongxin","wode_kaquan","wode_qita"]
    
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = LGBackColor
        
        myScrollView.frame = CGRectMake(0, 0, WIDTH, HEIGHT-46)
        myScrollView.backgroundColor = LGBackColor
        
        self.view.addSubview(myScrollView)
        
        configureUI()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }

    
    func configureUI(){
        
        let headerBackView = UIView()
        headerBackView.backgroundColor = NavColor
        headerBackView.frame = CGRectMake(0, 0, WIDTH, 120*px)
        self.myScrollView.addSubview(headerBackView)
        self.myHeaderImageView = ColorfulNameLabel.init(frame: CGRectMake(15*px, 40*px, 55*px, 55*px)) 
        self.myHeaderImageView.text = "未知"
        headerBackView.addSubview(myHeaderImageView)
        myHeaderImageButton.frame = CGRectMake(15*px, 40*px, 55*px, 55*px)
        myHeaderImageButton.backgroundColor = UIColor.clearColor()
        myHeaderImageButton.setImage(UIImage(named: "wode_touxinag"), forState: .Normal)
        myHeaderImageButton.layer.masksToBounds = true
        myHeaderImageButton.layer.cornerRadius = myHeaderImageButton.frame.height/2
        myHeaderImageButton.addTarget(self, action: #selector(self.clickedLogBtn(_:)), forControlEvents: .TouchUpInside)
        headerBackView.addSubview(myHeaderImageButton)
        
        loginButton.frame = CGRectMake(75*px, (40+25/2)*px, 90*px, 30*px)
        loginButton.setTitle("点击登录", forState: .Normal)
        loginButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        loginButton.contentHorizontalAlignment = .Left
        loginButton.titleLabel?.font = MainFont
        loginButton.backgroundColor = UIColor.clearColor()
        loginButton.addTarget(self, action: #selector(self.clickedLogBtn(_:)), forControlEvents: .TouchUpInside)
        headerBackView.addSubview(loginButton)
        
        let goRightImageView = UIImageView()
        goRightImageView.backgroundColor = UIColor.clearColor()
        goRightImageView.image = UIImage(named: "wode_jiantou")
        goRightImageView.frame = CGRectMake(WIDTH-23*px, (40+(55-13)/2)*px, 7*px, 13*px)
        headerBackView.addSubview(goRightImageView)
        
        let myOrderLabel = UILabel()
        myOrderLabel.frame = CGRectMake(0, headerBackView.frame.height, WIDTH/2, 44*px)
        myOrderLabel.backgroundColor = UIColor.whiteColor()
        myOrderLabel.text = "  我的订单"
        myOrderLabel.font = MainFont
        self.myScrollView.addSubview(myOrderLabel)
        
        let allOrderButton = UIButton()
        
        allOrderButton.frame = CGRectMake(WIDTH/2, headerBackView.frame.height, WIDTH/2, 44*px)
        allOrderButton.backgroundColor = UIColor.whiteColor()
        allOrderButton.setTitleColor(UIColor.grayColor(), forState: .Normal)
        allOrderButton.setTitle("查看全部订单", forState: .Normal)
        allOrderButton.addTarget(self, action: #selector(self.allOrderButtonAction), forControlEvents: .TouchUpInside)
        allOrderButton.titleLabel?.font = MainFont
        allOrderButton.contentHorizontalAlignment = .Center
        self.myScrollView.addSubview(allOrderButton)
        let rightGrayImageView = UIImageView()
        rightGrayImageView.frame = CGRectMake(WIDTH-23*px, headerBackView.frame.height+(44-13)/2*px, 7*px, 13*px)
        rightGrayImageView.image = UIImage(named:"wode_jiantouhuise")
        self.myScrollView.addSubview(rightGrayImageView)
        
        for index in 0...orderStateTextArray.count-1 {//订单状态按钮
            let myOrderStateButton = MainImageAndTextButton.init(frame: CGRectMake(CGFloat(index)*WIDTH/5, allOrderButton.frame.height+allOrderButton.frame.origin.y+1, WIDTH/5, 56*px), imageFrame: CGRectMake((WIDTH/5-20*px)/2, 8*px, 20*px, 18*px), textFrame: CGRectMake(0, 26*px, WIDTH/5, 30*px), imageName: self.orderStateImageArray[index], labelText: self.orderStateTextArray[index])
            myOrderStateButton.backgroundColor = UIColor.whiteColor()
            myOrderStateButton.downTextLable.textColor = UIColor.grayColor()
            myOrderStateButton.downTextLable.font = MainFont
            myOrderStateButton.tag = index
            myOrderStateButton.addTarget(self, action: #selector(self.myOrderStateButtonAction(_:)), forControlEvents: .TouchUpInside)
            self.myScrollView.addSubview(myOrderStateButton)
            
        }
        
        let toolAboutLabel = UILabel()
        toolAboutLabel.text = "   必备工具"
        toolAboutLabel.backgroundColor = UIColor.whiteColor()
        toolAboutLabel.font = MainFont
        toolAboutLabel.frame = CGRectMake(0, allOrderButton.frame.origin.y+116*px, WIDTH, 44*px)
        self.myScrollView.addSubview(toolAboutLabel)
        
        let toolBackView = UIView()
        toolBackView.backgroundColor = LGBackColor
        toolBackView.frame = CGRectMake(0, toolAboutLabel.frame.origin.y+toolAboutLabel.frame.height, WIDTH, CGFloat(self.toolTextArray.count/3+1)*81*px)
        
        var count = toolTextArray.count
        if toolTextArray.count%3 == 1 {
            count = toolTextArray.count + 2
        }else if toolTextArray.count%3 == 2{
            count = toolTextArray.count + 1
        }
        
        for index in 0...count-1 {
            var imageStr = String()
            var textStr = String()
            if index > toolTextArray.count-1{
                imageStr = ""
                textStr = ""
            }else{
                imageStr = self.toolImageArray[index]
                textStr = self.toolTextArray[index]
            }
            
            let toolButton = MainImageAndTextButton.init(frame: CGRectMake(CGFloat(index%3)*((WIDTH-2)/3+1), CGFloat(index/3)*80*px+(CGFloat(index/3+1)), (WIDTH-2)/3, 80*px), imageFrame: CGRectMake(((WIDTH-2)/3-23*px)/2, 12*px, 23*px, 24*px), textFrame: CGRectMake(0, 40*px, (WIDTH-2)/3, 40*px), imageName:imageStr , labelText:textStr )
            toolButton.downTextLable.font = MainFont
            toolButton.tag = index + 100
            toolButton.addTarget(self, action: #selector(self.toolButtonAction(_:)), forControlEvents: .TouchUpInside)
            toolButton.downTextLable.textColor = UIColor.grayColor()
            toolButton.backgroundColor = UIColor.whiteColor()
            toolBackView.addSubview(toolButton)
            
        }
        
        self.myScrollView.addSubview(toolBackView)
//
//        
//        let homeCareButton = UIButton.init(frame: CGRectMake(50, 200, 60, 30))
//        homeCareButton.setTitle("居家养老", forState: .Normal)
//        homeCareButton.addTarget(self, action: #selector(self.homeCareButtonAction), forControlEvents: .TouchUpInside)
//        homeCareButton.backgroundColor = UIColor.brownColor()
//        
//        let logBtn = UIButton(type: .Custom)
//        let registerBtn = UIButton(type: .Custom)
//        logBtn.setTitle("登陆", forState: .Normal)
//        registerBtn.setTitle("注册", forState: .Normal)
//        logBtn.frame = CGRectMake(50, 300, 60, 30)
//        registerBtn.frame = CGRectMake(180, 300, 60, 30)
//        logBtn.layer.borderColor = UIColor.whiteColor().CGColor
//        registerBtn.layer.borderColor = UIColor.whiteColor().CGColor
//        logBtn.layer.borderWidth = 0.5
//        registerBtn.layer.borderWidth = 0.5
//        
//        logBtn.addTarget(self, action: #selector(clickedLogBtn), forControlEvents: .TouchUpInside)
//        registerBtn.addTarget(self, action: #selector(clickedRegister), forControlEvents: .TouchUpInside)
//        view.addSubview(homeCareButton)
//        view.addSubview(logBtn)
//        view.addSubview(registerBtn)
    }
    //MARK:------Action
    func homeCareButtonAction(){
        let homeCareViewController = HPYHomeCareViewController()
        homeCareViewController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(homeCareViewController, animated: true)
    }
    
    func clickedLogBtn(btn:UIButton){
        let logVC = HPYLoginController()
        
        logVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(logVC, animated: true)
    }
    func clickedRegister(btn:UIButton){
        let registerVC = HPYRegisterController()
        registerVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(registerVC, animated: true)
    }
    func allOrderButtonAction(){
        
    }
    func myOrderStateButtonAction(sender:UIButton){
        
    }
    func toolButtonAction(sender:UIButton){
        print(sender.tag)
    }
}
