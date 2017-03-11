//
//  HPYLoginController.swift
//  HPY9Pasture
//
//  Created by xiaocool on 16/10/10.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import UIKit
import SVProgressHUD
import SwiftyJSON

class HPYLoginController: UIViewController {

    let userName = UITextField()
    let pwdText = UITextField()
    let fgetPwdBtn = UIButton(type: .System)
    let loginBtn = UIButton(type: .Custom)
    var userLocationCenter = NSUserDefaults.standardUserDefaults()
 

    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "登录"
        self.navigationController?.navigationBar.hidden = false
        self.createrRightNavButton()
        configureUI()
        addTargetAction()
    }
    

    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.hidden = false
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        self.navigationController?.navigationBar.hidden = false
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

    
    
    //左右侧注册按钮
    func createrRightNavButton(){
        let mapButton = UIButton()
        mapButton.frame = CGRectMake(0, 0, 40, 40)
        mapButton.setTitle("注册", forState: .Normal)
        mapButton.titleLabel?.font = MainFont
        mapButton.contentHorizontalAlignment = .Right
        mapButton.addTarget(self, action: #selector(self.goRegister), forControlEvents: .TouchUpInside)
        mapButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: mapButton)
        
        let leftButton = UIButton()
        leftButton.frame = CGRectMake(0, 0, 100, 40)
        leftButton.setTitle("暂不登录", forState: .Normal)
        leftButton.titleLabel?.font = MainFont
        leftButton.contentHorizontalAlignment = .Left
        leftButton.addTarget(self, action: #selector(self.leftButtonAction), forControlEvents: .TouchUpInside)
        leftButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: leftButton)
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
        if (self.userName.text!.isEmpty) {
            SVProgressHUD.showErrorWithStatus("请输入手机号！")
            //                self.loginBtn.backgroundColor = NavColor
            return
        }
        if (self.pwdText.text!.isEmpty) {
            SVProgressHUD.showErrorWithStatus("请输入密码！")
            //                self.loginBtn.backgroundColor = NavColor
            return
        }
        AppRequestManager.shareManager.login(userName.text!, password: pwdText.text!, registrationID: "") { (success, response) in
            if success{
                let data1 = JSON(data: response as! NSData)
                NSLOG(data1["data"].dictionary!)
                self.userLocationCenter.setBool(true, forKey: "IsLogin")
                let userInfo = NSMutableDictionary()
                if data1["data"]["name"].string != nil{
                    userInfo.setValue(data1["data"]["photo"].string, forKey: "headerPhoto")
                }
                if data1["data"]["name"].string != nil{
                    userInfo.setValue(data1["data"]["name"].string, forKey: "name")
                }
                if data1["data"]["id"].string != nil{
                    userInfo.setValue(data1["data"]["id"].string, forKey: "userid")
                }
                if data1["data"]["phone"].string != nil{
                    userInfo.setValue(data1["data"]["phone"].string, forKey: "phone")
                }
                
                userInfo.setValue(self.pwdText.text!, forKey: "password")
                self.userLocationCenter.setValue(userInfo, forKey: "UserInfo")
                NSLOG("-------------------")
                NSLOG("userinfo:")
                NSLOG(self.userLocationCenter.objectForKey("UserInfo"))
                NSLOG("-------------------")
                
                self.dismissViewControllerAnimated(true) {
                    
                }
            }else{
                Alert.shareManager.alert(response as! String, delegate: self)
                return
            }
        }
        
    }
    
    func endEditState(){
        view.endEditing(true)
    }
    
    func goRegister(){
        
        
        
        CallManager.shareManager.aplVideoWidh("xiaocool",ext: "123")
        
//        
//        let vc = HPYRegisterController()
//        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func leftButtonAction(){
        self.dismissViewControllerAnimated(true) {
            
        }
    }
    
    
}
