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
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = LGBackColor
        
        myScrollView.frame = CGRectMake(0, 0, WIDTH, HEIGHT-46)
        myScrollView.backgroundColor = LGBackColor
        
        self.view.addSubview(myScrollView)
        
        configureUI()
        
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }

    
    func configureUI(){
        
        let headerBackView = UIView()
        headerBackView.backgroundColor = NavColor
        headerBackView.frame = CGRectMake(0, 0, WIDTH, 120*px)
        self.view.addSubview(headerBackView)
        self.myHeaderImageView = ColorfulNameLabel.init(frame: CGRectMake(15*px, 40*px, 55*px, 55*px)) 
        self.myHeaderImageView.text = "未知"
        headerBackView.addSubview(myHeaderImageView)
        
        
        
        
        let homeCareButton = UIButton.init(frame: CGRectMake(50, 200, 60, 30))
        homeCareButton.setTitle("居家养老", forState: .Normal)
        homeCareButton.addTarget(self, action: #selector(self.homeCareButtonAction), forControlEvents: .TouchUpInside)
        homeCareButton.backgroundColor = UIColor.brownColor()
        
        let logBtn = UIButton(type: .Custom)
        let registerBtn = UIButton(type: .Custom)
        logBtn.setTitle("登陆", forState: .Normal)
        registerBtn.setTitle("注册", forState: .Normal)
        logBtn.frame = CGRectMake(50, 300, 60, 30)
        registerBtn.frame = CGRectMake(180, 300, 60, 30)
        logBtn.layer.borderColor = UIColor.whiteColor().CGColor
        registerBtn.layer.borderColor = UIColor.whiteColor().CGColor
        logBtn.layer.borderWidth = 0.5
        registerBtn.layer.borderWidth = 0.5
        
        logBtn.addTarget(self, action: #selector(clickedLogBtn), forControlEvents: .TouchUpInside)
        registerBtn.addTarget(self, action: #selector(clickedRegister), forControlEvents: .TouchUpInside)
        view.addSubview(homeCareButton)
        view.addSubview(logBtn)
        view.addSubview(registerBtn)
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
}
