//
//  HPYMineController.swift
//  HPY9Pasture
//
//  Created by xiaocool on 16/10/10.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import UIKit
import SwiftyJSON

class HPYMineController: UIViewController {
    
    let myScrollView = UIScrollView()//底部滑动试图
    var myHeaderImageView = ColorfulNameLabel()
    let myHeaderImageButton = UIButton()
    let loginButton = UIButton()
    let toolBackView = UIView()//九宫格背景图
    
    let orderStateTextArray = ["待付款","待发货","待收货","待评价","售后"]
    let orderStateImageArray = ["wode_daifahuo","wode_daifahuo","wode_daishouhuo","wode_daipingjia","wode_shouhou"]
    let toolTextArray = ["健康档案","收藏","关注","足迹","政府采购","通信","卡卷","账单","其他"]
    let toolImageArray = ["wode_dangan","wode_shoucang","wode_guanzhu","wode_zuji","wode_zhegnfucaigou","wode_tongxin","wode_qinqingquan","wode_zhangdan","wode_qita"]
    
    var userLocationCenter = NSUserDefaults.standardUserDefaults()
    
    var userInfor:JSON?
    
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = LGBackColor
        
        myScrollView.frame = CGRectMake(0, -23, WIDTH, HEIGHT-27)
        myScrollView.backgroundColor = LGBackColor
        
        
        self.view.addSubview(myScrollView)
        
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        if userLocationCenter.objectForKey("UserInfo") != nil{
            let userInfo = userLocationCenter.objectForKey("UserInfo") as! NSDictionary
            if userInfo["userid"] != nil {
                AppRequestManager.shareManager.getUserinfoWithUserId(userInfo["userid"] as! String, handle: { (success, response) in
                    if success{
                        let userInfo1 = JSON(data: response as! NSData)
                        if userInfo1["data"] != nil{
                            self.userInfor = userInfo1["data"]
                        }
                        
                        self.configureUI()
                    }else{
                        self.configureUI()
                    }
                })
            }else{
                self.configureUI()
            }
            
        }
        
        self.navigationController?.navigationBar.hidden = true
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        self.navigationController?.navigationBar.hidden = true
    }

    
    func configureUI(){
        
        let headerBackView = UIImageView()
        headerBackView.image = UIImage(named: "wode_beijing")
        headerBackView.frame = CGRectMake(0, 0, WIDTH, 133*px)
        headerBackView.userInteractionEnabled = true
        self.myScrollView.addSubview(headerBackView)
        self.myHeaderImageView = ColorfulNameLabel.init(frame: CGRectMake(15*px, 40*px, 55*px, 55*px))
        if self.userInfor != nil&&self.userInfor!["name"].string != nil {
            self.myHeaderImageView.text = self.userInfor!["name"].string
        }else{
            self.myHeaderImageView.text = "未知"
        }
        
        headerBackView.addSubview(myHeaderImageView)
        myHeaderImageButton.frame = CGRectMake(15*px, 40*px, 55*px, 55*px)
        myHeaderImageButton.backgroundColor = UIColor.clearColor()
//        myHeaderImageButton.setImage(UIImage(named: "wode_touxinag"), forState: .Normal)
//        let domeImageView = UIImageView()
        if self.userInfor != nil&&self.userInfor!["photo"].string != nil {
            myHeaderImageButton.sd_setImageWithURL(NSURL(string:Happy_ImageUrl+self.userInfor!["photo"].string!), forState: .Normal)
//            domeImageView.sd_setImageWithURL(NSURL(string:Happy_ImageUrl+self.userInfor!["photo"].string!), placeholderImage: UIImage(named: ""), completed: { (image, error, type, url) in
//                self.myHeaderImageButton.setImage(image, forState: .Normal)
//            })
        }else if self.userInfor != nil && self.userInfor!["sex"].string != nil{
            if self.userInfor!["sex"].string == "1"{
                self.myHeaderImageButton.setImage(UIImage(named:"ic_touxi" ) , forState: .Normal)
            }else{
                self.myHeaderImageButton.setImage(UIImage(named:"ic_toux" ), forState: .Normal)
            }
            
        }
        
        myHeaderImageButton.layer.masksToBounds = true
        myHeaderImageButton.layer.cornerRadius = myHeaderImageButton.frame.height/2
        myHeaderImageButton.addTarget(self, action: #selector(self.clickedLogBtn(_:)), forControlEvents: .TouchUpInside)
        headerBackView.addSubview(myHeaderImageButton)
        
        loginButton.frame = CGRectMake(75*px, (40+25/2)*px, 90*px, 30*px)
        if self.userInfor != nil&&self.userInfor!["name"].string != nil{
            loginButton.setTitle(self.userInfor!["name"].string, forState: .Normal)
        }else{
            loginButton.setTitle("点击登录", forState: .Normal)
        }
        
        loginButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        loginButton.contentHorizontalAlignment = .Left
        loginButton.titleLabel?.font = MainFont
        loginButton.backgroundColor = UIColor.clearColor()
        loginButton.addTarget(self, action: #selector(self.clickedLogBtn(_:)), forControlEvents: .TouchUpInside)
        headerBackView.addSubview(loginButton)
        
        let setButton = UIButton.init(frame: CGRectMake(WIDTH-80*px, 23, 19*px, 19*px))
        setButton.backgroundColor = UIColor.clearColor()
        setButton.setImage(UIImage(named: "wode_shezhi"), forState: .Normal)
        setButton.addTarget(self, action: #selector(self.setButtonAction), forControlEvents: .TouchUpInside)
        
        
        let messageButton = UIButton.init(frame: CGRectMake(WIDTH-40*px, 23, 22*px, 17*px))
        messageButton.backgroundColor = UIColor.clearColor()
        messageButton.setImage(UIImage(named: "email"), forState: .Normal)
        messageButton.addTarget(self, action: #selector(self.messageButtonAction), forControlEvents: .TouchUpInside)
        
        headerBackView.addSubview(setButton)
        headerBackView.addSubview(messageButton)
        
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
//        allOrderButton.addTarget(self, action: #selector(self.allOrderButtonAction), forControlEvents: .TouchUpInside)
        allOrderButton.titleLabel?.font = UIFont.systemFontOfSize(13)
        allOrderButton.contentHorizontalAlignment = .Center
        self.myScrollView.addSubview(allOrderButton)
        let rightGrayImageView = UIImageView()
        rightGrayImageView.frame = CGRectMake(WIDTH-23*px, headerBackView.frame.height+(44-13)/2*px, 7*px, 13*px)
        rightGrayImageView.image = UIImage(named:"wode_jiantouhuise")
        self.myScrollView.addSubview(rightGrayImageView)
        
        let lookMyAllOrderButton = UIButton.init(frame: CGRectMake(0, headerBackView.frame.height, WIDTH, 44*px))
        lookMyAllOrderButton.backgroundColor = UIColor.clearColor()
        lookMyAllOrderButton.addTarget(self, action: #selector(self.lookMyAllOrderButtonAction), forControlEvents: .TouchUpInside)
        
        
        for index in 0...orderStateTextArray.count-1 {//订单状态按钮
            let myOrderStateButton = MainImageAndTextButton.init(frame: CGRectMake(CGFloat(index)*WIDTH/5, allOrderButton.frame.height+allOrderButton.frame.origin.y+1, WIDTH/5, 56*px), imageFrame: CGRectMake((WIDTH/5-23*px)/2, 8*px, 23*px, 18*px), textFrame: CGRectMake(0, 26*px, WIDTH/5, 30*px), imageName: self.orderStateImageArray[index], labelText: self.orderStateTextArray[index])
            myOrderStateButton.backgroundColor = UIColor.whiteColor()
            myOrderStateButton.downTextLable.textColor = UIColor.grayColor()
            myOrderStateButton.downTextLable.font = MainFont
            myOrderStateButton.tag = index
            myOrderStateButton.addTarget(self, action: #selector(self.myOrderStateButtonAction(_:)), forControlEvents: .TouchUpInside)
            self.myScrollView.addSubview(myOrderStateButton)
            
        }
        
        
        let chaperonageOfHospital = UILabel()
        chaperonageOfHospital.frame = CGRectMake(0, allOrderButton.frame.origin.y+110*px, WIDTH/2, 44*px)
        chaperonageOfHospital.backgroundColor = UIColor.whiteColor()
        chaperonageOfHospital.text = "  医院陪护"
        chaperonageOfHospital.font = MainFont
        self.myScrollView.addSubview(chaperonageOfHospital)
        
        let watchCCTV = UILabel()
        
        watchCCTV.frame = CGRectMake(WIDTH/2, headerBackView.frame.height+110*px, WIDTH/2, 44*px)
        watchCCTV.backgroundColor = UIColor.whiteColor()
        watchCCTV.textColor = UIColor.grayColor()
        watchCCTV.text = "查看监控"
        //        allOrderButton.addTarget(self, action: #selector(self.allOrderButtonAction), forControlEvents: .TouchUpInside)
        watchCCTV.font = UIFont.systemFontOfSize(13)
        watchCCTV.textAlignment = .Center
        self.myScrollView.addSubview(watchCCTV)
        let rightGrayImageView2 = UIImageView()
        rightGrayImageView2.frame = CGRectMake(WIDTH-23*px, headerBackView.frame.height+110*px+(44-13)/2*px, 7*px, 13*px)
        rightGrayImageView2.image = UIImage(named:"wode_jiantouhuise")
        self.myScrollView.addSubview(rightGrayImageView2)
        
        let chaperonageOfHospitalButton = UIButton.init(frame: CGRectMake(0, headerBackView.frame.height+110*px, WIDTH, 44*px))
        chaperonageOfHospitalButton.backgroundColor = UIColor.clearColor()
        chaperonageOfHospitalButton.addTarget(self, action: #selector(self.chaperonageOfHospitalButtonAction), forControlEvents: .TouchUpInside)
        
        
        
        let serverOfHousekeeping = UILabel()
        serverOfHousekeeping.frame = CGRectMake(0, allOrderButton.frame.origin.y+110*px+45*px, WIDTH/2, 44*px)
        serverOfHousekeeping.backgroundColor = UIColor.whiteColor()
        serverOfHousekeeping.text = "  家政服务"
        serverOfHousekeeping.font = MainFont
        self.myScrollView.addSubview(serverOfHousekeeping)
        
        let lookOrder = UILabel()
        
        lookOrder.frame = CGRectMake(WIDTH/2, headerBackView.frame.height+110*px+45*px, WIDTH/2, 44*px)
        lookOrder.backgroundColor = UIColor.whiteColor()
        lookOrder.textColor = UIColor.grayColor()
        lookOrder.text = "查看订单"
        //        allOrderButton.addTarget(self, action: #selector(self.allOrderButtonAction), forControlEvents: .TouchUpInside)
        lookOrder.font = UIFont.systemFontOfSize(13)
        lookOrder.textAlignment = .Center
        self.myScrollView.addSubview(lookOrder)
        let rightGrayImageView3 = UIImageView()
        rightGrayImageView3.frame = CGRectMake(WIDTH-23*px, headerBackView.frame.height+110*px+(44-13)/2*px+45*px, 7*px, 13*px)
        rightGrayImageView3.image = UIImage(named:"wode_jiantouhuise")
        self.myScrollView.addSubview(rightGrayImageView3)
        
        let serverOfHousekeepingButton = UIButton.init(frame: CGRectMake(0, headerBackView.frame.height+110*px+45*px, WIDTH, 44*px))
        serverOfHousekeepingButton.backgroundColor = UIColor.clearColor()
        serverOfHousekeepingButton.addTarget(self, action: #selector(self.serverOfHousekeepingButtonAction), forControlEvents: .TouchUpInside)
        
        
        
        
        
        let toolAboutLabel = UILabel()
        toolAboutLabel.text = "   必备工具"
        toolAboutLabel.backgroundColor = LGBackColor
        toolAboutLabel.font = MainFont
        toolAboutLabel.frame = CGRectMake(0, serverOfHousekeepingButton.frame.origin.y+46*px, WIDTH, 44*px)
        self.myScrollView.addSubview(toolAboutLabel)
        
        
        toolBackView.backgroundColor = LGBackColor
        toolBackView.frame = CGRectMake(0, toolAboutLabel.frame.origin.y+toolAboutLabel.frame.height, WIDTH, CGFloat((self.toolTextArray.count-1)/3+1)*81*px)
        
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
            
            let toolButton = MainImageAndTextButton.init(frame: CGRectMake(CGFloat(index%3)*((WIDTH-2)/3+1), CGFloat(index/3)*80*px+(CGFloat(index/3+1)), (WIDTH-2)/3, 80*px), imageFrame: CGRectMake(((WIDTH-2)/3-36*px)/2, 12*px, 36*px, 33*px), textFrame: CGRectMake(0, 40*px, (WIDTH-2)/3, 40*px), imageName:imageStr , labelText:textStr )
            toolButton.downTextLable.font = MainFont
            toolButton.tag = index + 100
            toolButton.addTarget(self, action: #selector(self.toolButtonAction(_:)), forControlEvents: .TouchUpInside)
            toolButton.downTextLable.textColor = UIColor.grayColor()
            toolButton.backgroundColor = UIColor.whiteColor()
            toolBackView.addSubview(toolButton)
            
        }
        
        self.myScrollView.addSubview(toolBackView)
        
        myScrollView.contentSize = CGSizeMake(WIDTH, toolBackView.height+toolBackView.origin.y+20)
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
        
        if self.userInfor != nil{
            let vc = EditInformationViewController()
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
//            vc.hidesBottomBarWhenPushed = false
            
        }else{
            let NAV1 = UINavigationController.init(rootViewController: HPYLoginController())
            
            self.presentViewController(NAV1, animated: true) {
                
            }
        }

        

    }
    func clickedRegister(btn:UIButton){
        let registerVC = HPYRegisterController()
        registerVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(registerVC, animated: true)
    }
    func lookMyAllOrderButtonAction(){
        
    }
    func myOrderStateButtonAction(sender:UIButton){
        
    }
    func chaperonageOfHospitalButtonAction(){
        
    }
    func serverOfHousekeepingButtonAction(){
        
    }
    func setButtonAction(){
        let vc = InfoSetViewController()
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func messageButtonAction(){
        
    }
    func toolButtonAction(sender:UIButton){
        NSLOG(sender.tag)
    }
}
