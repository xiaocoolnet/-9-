//
//  HPYLoginController.swift
//  HPY9Pasture
//
//  Created by xiaocool on 16/10/10.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import UIKit

class HPYLoginController: UIViewController {

    let userName = UITextField()
    let pwdText = UITextField()
    let fgetPwdBtn = UIButton(type: .System)
    let loginBtn = UIButton(type: .Custom)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "登录"
        self.createrRightNavButton()
        configureUI()
        addTargetAction()
    }
    
    
    //右侧注册按钮
    func createrRightNavButton(){
        let mapButton = UIButton()
        mapButton.frame = CGRectMake(0, 0, 40, 40)
        mapButton.setTitle("注册", forState: .Normal)
        mapButton.titleLabel?.font = MainFont
        mapButton.titleLabel?.textAlignment = .Right
        mapButton.addTarget(self, action: #selector(self.goRegister), forControlEvents: .TouchUpInside)
        mapButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: mapButton)
    }
    
    func addTargetAction(){
        fgetPwdBtn.addTarget(self, action: #selector(clickedForgetPwdBtn), forControlEvents: .TouchUpInside)
        loginBtn.addTarget(self, action: #selector(clickedLoginBtn), forControlEvents: .TouchUpInside)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(endEditState))
        view.userInteractionEnabled = true
        view.addGestureRecognizer(tapGesture)
    }
    
    //MARK:----------Target-Action-------
    func clickedForgetPwdBtn(btn:UIButton){
        navigationController?.pushViewController(HPYFgetPasswordCtrler(), animated: true)
    }
    func clickedLoginBtn(btn:UIButton){
        self.dismissViewControllerAnimated(true) { 
            
        }
    }
    
    func endEditState(){
        view.endEditing(true)
    }
    
    func goRegister(){
        let vc = HPYRegisterController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func configureUI(){
        view.backgroundColor = LGBackColor
        userName.frame = CGRectMake(8,15,Screen_W-16,20)
        userName.placeholder = "用户名／手机号"
        userName.font = UIFont.systemFontOfSize(14)
        pwdText.frame = CGRectMake(8,65,Screen_W-16,20)
        pwdText.placeholder = "密码"
        pwdText.secureTextEntry = true
        pwdText.font = UIFont.systemFontOfSize(14)
        let lineView = UIView(frame: CGRectMake(0,50,Screen_W,1))
        lineView.backgroundColor = LGBackColor
        
        let inputBack = UIView(frame: CGRectMake(0,10,Screen_W,100))
        inputBack.backgroundColor = UIColor.whiteColor()
        
        fgetPwdBtn.frame = CGRectMake(Screen_W/2-50, 150, 100, 30)
        fgetPwdBtn.setTitle("忘记密码", forState: .Normal)
        
        inputBack.addSubview(userName)
        inputBack.addSubview(pwdText)
        inputBack.addSubview(lineView)
        
        loginBtn.frame = CGRectMake(8, 250, Screen_W-16, 40)
        loginBtn.backgroundColor = NavColor
        loginBtn.titleLabel?.font = UIFont.systemFontOfSize(15)
        loginBtn.layer.cornerRadius = 4
        loginBtn.setTitle("登录", forState: .Normal)
        
        
        view.addSubview(inputBack)
        view.addSubview(fgetPwdBtn)
        view.addSubview(loginBtn)
    }

}
