//
//  ChangePhoneViewController.swift
//  HPY9Pasture
//
//  Created by purepure on 17/1/13.
//  Copyright © 2017年 xiaocool. All rights reserved.
//

import UIKit
import SVProgressHUD
import SwiftyJSON

class ChangePhoneViewController: UIViewController {

    let phoneNum = UITextField()
    let codeNum = UITextField()
    let password = UITextField()
    let getCodeBtn = UIButton(type: .Custom)
    let registerBtn = UIButton(type: .Custom)
    var userLocationCenter = NSUserDefaults.standardUserDefaults()
    
    //  倒计时功能
    var processHandle:TimerHandle?
    var finishHandle:TimerHandle?
    
    //是否显示密码
    var showMM = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "修改手机号"
        time()
        configureUI()
        addTargetAction()
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        TimeManager.shareManager.taskDic["changePhone"]?.FHandle = nil
        TimeManager.shareManager.taskDic["changePhone"]?.PHandle = nil
    }
    
    
    
    
    func time(){
        
        processHandle = {[unowned self] (timeInterVal) in
            dispatch_async(dispatch_get_main_queue(), {
                self.getCodeBtn.userInteractionEnabled = false
                let btnTitle = String(timeInterVal) + "秒后重新获取"
                self.getCodeBtn.titleLabel?.font = UIFont.systemFontOfSize(12)
                //                self.getCodeBtn.setTitleColor(MainTextBackColor, forState: .Normal)
                self.getCodeBtn.backgroundColor = NavColor
                self.getCodeBtn.setTitle(btnTitle, forState: .Normal)
                
                
                
            })
        }
        
        finishHandle = {[unowned self] (timeInterVal) in
            dispatch_async(dispatch_get_main_queue(), {
                self.getCodeBtn.userInteractionEnabled = true
                self.getCodeBtn.setTitleColor(UIColor.whiteColor(), forState: .Normal)
                self.getCodeBtn.titleLabel?.font = UIFont.systemFontOfSize(12)
                self.getCodeBtn.setTitle("获取验证码", forState: .Normal)
            })
        }
        TimeManager.shareManager.taskDic["changePhone"]?.FHandle = finishHandle
        TimeManager.shareManager.taskDic["changePhone"]?.PHandle = processHandle
    }
    
    
    func addTargetAction(){
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(endEditingStatus))
        view.addGestureRecognizer(tapGesture)
        
        registerBtn.addTarget(self, action: #selector(registerAction), forControlEvents: .TouchUpInside)
        getCodeBtn.addTarget(self, action: #selector(getCodeAction), forControlEvents: .TouchUpInside)
    }
    //MARK: ======Target-Action=======
    func endEditingStatus(){
        view.endEditing(true)
    }
    func registerAction(btn:UIButton){
        if phoneNum.text!.isEmpty {
            SVProgressHUD.showErrorWithStatus("请输入手机号！")
            return
        }
        if codeNum.text!.isEmpty {
            SVProgressHUD.showErrorWithStatus("请输入验证码!")
            return
        }
        
//        if password.text!.isEmpty {
//            SVProgressHUD.showErrorWithStatus("请输入密码!")
//            return
//        }
        
//        var regex:String?
//        regex = "^[A-Za-z0-9]{6,20}$"
//        let predicate = NSPredicate.init(format: "SELF MATCHES %@",regex!)
//        let flags = predicate.evaluateWithObject(password.text! as NSString)
//        if !flags{
//            SVProgressHUD.showErrorWithStatus("请输入6-20位密码!")
//            return
//        }
         var myUserId = String()
        if userLocationCenter.objectForKey("UserInfo") != nil{
            let userInfo = userLocationCenter.objectForKey("UserInfo") as! NSDictionary
            
            if userInfo["userid"] != nil {
                myUserId = userInfo["userid"] as! String
            }
        }
        
        AppRequestManager.shareManager.UpdateUserPhone(myUserId, phone: phoneNum.text!, code: codeNum.text!) { (success, response) in
            
            dispatch_async(dispatch_get_main_queue(), {
                if !success {
                    //                    let codeJson = JSON(data: response as! NSData)
                    
                    alert("修改失败！", delegate: self)
                    
                    
                }else{
                    self.navigationController?.popViewControllerAnimated(true)
                }
            })
        }
        
        
    }
    func getCodeAction(btn:UIButton){
        //  1.判断手机号是否为空
        if phoneNum.text!.isEmpty {
            alert("请输入手机号", delegate: self)
            return
        }
        AppRequestManager.shareManager.comfirmPhoneHasRegister(phoneNum.text!, handle: {[unowned self](success, response) in
            if !success {
                //  2.1成功,验证码传到手机,执行倒计时操作
                alert("手机号未注册", delegate: self)
                return
            }else{
                //没有注册
                TimeManager.shareManager.begainTimerWithKey("register", timeInterval: 30, process: self.processHandle!, finish: self.finishHandle!)
                AppRequestManager.shareManager.sendMobileCodeWithPhoneNumber(self.phoneNum.text!, handle: {[unowned self](success, response) in
                    if !success{
                        alert("发送验证码失败", delegate: self)
                    }
                    
                    })
                
                
            }
            
            })
    }
    
    func configureUI(){
        view.backgroundColor = LGBackColor
        let phoneView = FgetItemView(field: phoneNum, itemName: "手机号", frame: CGRectMake(0, 8, Screen_W, 40))
        let codeView = FgetItemView(field: codeNum, itemName: "验证码", frame: CGRectMake(0, 48, Screen_W, 40))
//        let pwdView = FgetItemView(field: password, itemName: "密码", frame: CGRectMake(0, 88, Screen_W, 40))
//        password.rightViewMode = .Always
//        let passwordSecretBtn = UIButton.init(frame: CGRectMake(0, 0, 22*px, 10*px))
//        passwordSecretBtn.setImage(UIImage(named: "ic_biyan"), forState: .Normal)
//        password.secureTextEntry = true
//        passwordSecretBtn.addTarget(self, action: #selector(self.passwordSecretBtnAction(_:)), forControlEvents: .TouchUpInside)
//        password.rightView = passwordSecretBtn
        
        registerBtn.frame = CGRectMake(8, 250, Screen_W-16, 40)
        registerBtn.backgroundColor = NavColor
        registerBtn.setTitle("确认", forState: .Normal)
        registerBtn.titleLabel?.font = UIFont.systemFontOfSize(15)
        registerBtn.layer.cornerRadius = 4
        
        getCodeBtn.frame = CGRectMake(Screen_W - 100, 5, 90, 30)
        getCodeBtn.backgroundColor = NavColor
        getCodeBtn.setTitle("获取验证码", forState: .Normal)
        getCodeBtn.layer.cornerRadius = 10
        getCodeBtn.titleLabel?.font = UIFont.systemFontOfSize(12)
        
        phoneView.addSubview(getCodeBtn)
        
        for subView in [phoneView,codeView,registerBtn] {
            view.addSubview(subView)
        }
    }
//    //MARK:ACTION
//    func passwordSecretBtnAction(sender:UIButton){
//        if showMM == false {
//            showMM = true
//            sender.setImage(UIImage(named: "ic_zhengyan"), forState: .Normal)
//            password.secureTextEntry = false
//        }else{
//            showMM = false
//            sender.setImage(UIImage(named: "ic_biyan"), forState: .Normal)
//            password.secureTextEntry = true
//        }
//    }

}
