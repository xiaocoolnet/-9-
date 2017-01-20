//
//  HPYFgetPasswordCtrler.swift
//  HPY9Pasture
//
//  Created by xiaocool on 16/10/11.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import UIKit
import SVProgressHUD
import MBProgressHUD

class HPYFgetPasswordCtrler: UIViewController {
    let phoneNum = UITextField()
    let codeNum = UITextField()
    let passwordNum = UITextField()
    let confirePwdNum = UITextField()
    let getCodeBtn = UIButton(type: .Custom)
    let trueBtn = UIButton(type:.Custom)
    
    //  倒计时功能
    var processHandle:TimerHandle?
    var finishHandle:TimerHandle?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "忘记密码"
        time()
        configureUI()
        addTargetAction()
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        TimeManager.shareManager.taskDic["forget"]?.FHandle = nil
        TimeManager.shareManager.taskDic["forget"]?.PHandle = nil
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
        TimeManager.shareManager.taskDic["forget"]?.FHandle = finishHandle
        TimeManager.shareManager.taskDic["forget"]?.PHandle = processHandle
    }
    
    func addTargetAction(){
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(endEditingState))
        view.addGestureRecognizer(tapGesture)
        
    }
    //MARK: -------target-Action----------
    func getCodeBtnAction(sender:UIButton){
        if phoneNum.text!.isEmpty {
            SVProgressHUD.showErrorWithStatus("请输入手机号！")
            return
        }
        AppRequestManager.shareManager.comfirmPhoneHasRegister(phoneNum.text!, handle: {[unowned self](success, response) in
            if !success {
                //  2.1成功,验证码传到手机,执行倒计时操作
                alert("手机未注册！", delegate: self)
                return
            }else{
                //没有注册
                TimeManager.shareManager.begainTimerWithKey("forget", timeInterval: 30, process: self.processHandle!, finish: self.finishHandle!)
                AppRequestManager.shareManager.sendMobileCodeWithPhoneNumber(self.phoneNum.text!, handle: {[unowned self](success, response) in
                    if !success{
                        alert("发送验证码失败", delegate: self)
                    }
                    
                    })
                
                
            }
            
            })
    }
    func comfireBtnClickedAction(){
        
        if phoneNum.text!.isEmpty {
            SVProgressHUD.showErrorWithStatus("请输入手机号！")
            return
        }
        if codeNum.text!.isEmpty {
            SVProgressHUD.showErrorWithStatus("请输入验证码!")
            return
        }
        
        if passwordNum.text!.isEmpty {
            SVProgressHUD.showErrorWithStatus("请输入密码!")
            return
        }
        if passwordNum.text != confirePwdNum.text {
            SVProgressHUD.showErrorWithStatus("两次密码输入不一致!")
            return
        }
        
        var regex:String?
        regex = "^[A-Za-z0-9]{6,20}$"
        let predicate = NSPredicate.init(format: "SELF MATCHES %@",regex!)
        let flags = predicate.evaluateWithObject(passwordNum.text! as NSString)
        if !flags{
            SVProgressHUD.showErrorWithStatus("请输入6-20位密码!")
            return
        }
        AppRequestManager.shareManager.forgetPassword(phoneNum.text!, code: codeNum.text!, password: passwordNum.text!) { (success, response) in
            if success{
                alert("修改成功", delegate: self)
                self.navigationController?.popViewControllerAnimated(true)
                
            }else{
                alert(response as! String, delegate: self)
            }
        }
    }
    func endEditingState(){
        view.endEditing(true)
    }
    
    func configureUI(){
        view.backgroundColor = LGBackColor
        let phoneView = FgetItemView(field: phoneNum, itemName: "手机号", frame: CGRectMake(0, 8, Screen_W, 40))
        let codeView = FgetItemView(field: codeNum, itemName: "验证码", frame: CGRectMake(0, 48, Screen_W, 40))
        let pwdView = FgetItemView(field: passwordNum, itemName: "密码", frame: CGRectMake(0, 88, Screen_W, 40))
        let cPwdView = FgetItemView(field: confirePwdNum, itemName: "确认密码", frame: CGRectMake(0, 128, Screen_W, 40))
        passwordNum.secureTextEntry = true
        confirePwdNum.secureTextEntry = true
        trueBtn.frame = CGRectMake(8, 250, Screen_W-16, 40)
        
        trueBtn.backgroundColor = NavColor
        trueBtn.setTitle("确认", forState: .Normal)
        trueBtn.titleLabel?.font = UIFont.systemFontOfSize(15)
        trueBtn.layer.cornerRadius = 4
        trueBtn.addTarget(self, action: #selector(self.comfireBtnClickedAction), forControlEvents: .TouchUpInside)
        
        getCodeBtn.frame = CGRectMake(Screen_W - 100, 5, 90, 30)
        getCodeBtn.backgroundColor = NavColor
        getCodeBtn.setTitle("获取验证码", forState: .Normal)
        getCodeBtn.layer.cornerRadius = 10
        getCodeBtn.titleLabel?.font = UIFont.systemFontOfSize(12)
        getCodeBtn.addTarget(self, action: #selector(self.getCodeBtnAction(_:)), forControlEvents: .TouchUpInside)
        phoneView.addSubview(getCodeBtn)
        
        for subView in [phoneView,codeView,pwdView,cPwdView,trueBtn] {
            view.addSubview(subView)
        }
    }

}

class FgetItemView: UIView {
    let item = UILabel()
    var itemField:UITextField?
    
    convenience init(field:UITextField,itemName:String,frame:CGRect) {
        self.init(frame: frame)
        item.text = itemName
        itemField = field
        configureUI()
    }
    
    func configureUI(){
        backgroundColor = UIColor.whiteColor()
        item.frame = CGRectMake(8, 10, 60, 20)
        item.font = UIFont.systemFontOfSize(14)
        itemField?.frame = CGRectMake(70, 10, width-90, 20)
        itemField?.font = UIFont.systemFontOfSize(14)
        itemField?.placeholder = "请输入"+item.text!
        let line = UILabel(frame: CGRectMake(0,frame.height-1,frame.width,1))
        line.backgroundColor = LGBackColor
        
        addSubview(line)
        addSubview(itemField!)
        addSubview(item)
    }
}
