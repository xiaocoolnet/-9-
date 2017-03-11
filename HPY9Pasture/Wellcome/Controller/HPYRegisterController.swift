//
//  HPYRegisterController.swift
//  HPY9Pasture
//
//  Created by xiaocool on 16/10/11.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import UIKit
import SVProgressHUD
import SwiftyJSON

class HPYRegisterController: UIViewController {
    let phoneNum = UITextField()
    let codeNum = UITextField()
    let password = UITextField()
    let getCodeBtn = UIButton(type: .Custom)
    let registerBtn = UIButton(type: .Custom)
    
    //  倒计时功能
    var processHandle:TimerHandle?
    var finishHandle:TimerHandle?
    
    //是否显示密码
    var showMM = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "注册"
        time()
        configureUI()
        addTargetAction()
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        TimeManager.shareManager.taskDic["register"]?.FHandle = nil
        TimeManager.shareManager.taskDic["register"]?.PHandle = nil
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
        TimeManager.shareManager.taskDic["register"]?.FHandle = finishHandle
        TimeManager.shareManager.taskDic["register"]?.PHandle = processHandle
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
        
        if password.text!.isEmpty {
            SVProgressHUD.showErrorWithStatus("请输入密码!")
            return
        }
        
        var regex:String?
        regex = "^[A-Za-z0-9]{6,20}$"
        let predicate = NSPredicate.init(format: "SELF MATCHES %@",regex!)
        let flags = predicate.evaluateWithObject(password.text! as NSString)
        if !flags{
            SVProgressHUD.showErrorWithStatus("请输入6-20位密码!")
            return
        }
        AppRequestManager.shareManager.register(phoneNum.text!, password: password.text!, code: codeNum.text!, token: "") { (success, response) in
            dispatch_async(dispatch_get_main_queue(), {
                if success {
//                    let codeJson = JSON(data: response as! NSData)
                    
                    Alert.shareManager.alert("注册成功！", delegate: self)
                    self.navigationController?.popViewControllerAnimated(true)
                    
                }else{
                    
                    Alert.shareManager.alert(response as! String, delegate: self)
                    
                    
                }
            })
        }
        
        
    }
    func getCodeAction(btn:UIButton){
        //  1.判断手机号是否为空
        if phoneNum.text!.isEmpty {
            Alert.shareManager.alert("请输入手机号", delegate: self)
            return
        }
        AppRequestManager.shareManager.comfirmPhoneHasRegister(phoneNum.text!, handle: {[unowned self](success, response) in
            if success {
                //  2.1成功,验证码传到手机,执行倒计时操作
                Alert.shareManager.alert("手机已注册", delegate: self)
                return
            }else{
                //没有注册
                TimeManager.shareManager.begainTimerWithKey("register", timeInterval: 30, process: self.processHandle!, finish: self.finishHandle!)
                AppRequestManager.shareManager.sendMobileCodeWithPhoneNumber(self.phoneNum.text!, handle: {[unowned self](success, response) in
                    if !success{
                        Alert.shareManager.alert("发送验证码失败", delegate: self)
                    }
                    
                    })
                
                
            }
        
    })
    }
    
    func configureUI(){
        view.backgroundColor = LGBackColor
        let phoneView = FgetItemView(field: phoneNum, itemName: "手机号", frame: CGRectMake(0, 8, Screen_W, 40))
        let codeView = FgetItemView(field: codeNum, itemName: "验证码", frame: CGRectMake(0, 48, Screen_W, 40))
        let pwdView = FgetItemView(field: password, itemName: "密码", frame: CGRectMake(0, 88, Screen_W, 40))
        password.rightViewMode = .Always
        let passwordSecretBtn = UIButton.init(frame: CGRectMake(0, 0, 22*px, 10*px))
        passwordSecretBtn.setImage(UIImage(named: "ic_biyan"), forState: .Normal)
        password.secureTextEntry = true
        passwordSecretBtn.addTarget(self, action: #selector(self.passwordSecretBtnAction(_:)), forControlEvents: .TouchUpInside)
        password.rightView = passwordSecretBtn
        
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
        
        for subView in [phoneView,codeView,pwdView,registerBtn] {
            view.addSubview(subView)
        }
    }
    //MARK:ACTION
    func passwordSecretBtnAction(sender:UIButton){
        if showMM == false {
            showMM = true
            sender.setImage(UIImage(named: "ic_zhengyan"), forState: .Normal)
            password.secureTextEntry = false
        }else{
            showMM = false
            sender.setImage(UIImage(named: "ic_biyan"), forState: .Normal)
            password.secureTextEntry = true
        }
    }
    
}
