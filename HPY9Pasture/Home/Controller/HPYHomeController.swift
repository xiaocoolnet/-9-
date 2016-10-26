//
//  HPYHomeController.swift
//  HPY9Pasture
//
//  Created by xiaocool on 16/10/10.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import UIKit

class HPYHomeController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.greenColor()
        let label = UILabel(frame: CGRectMake(100,100,100,50))
        label.text = "首页"
        view.addSubview(label)
        configureUI()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    func configureUI(){
        
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
