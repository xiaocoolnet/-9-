//
//  HPYRegisterController.swift
//  HPY9Pasture
//
//  Created by xiaocool on 16/10/11.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import UIKit

class HPYRegisterController: UIViewController {
    let phoneNum = UITextField()
    let codeNum = UITextField()
    let password = UITextField()
    let getCodeBtn = UIButton(type: .Custom)
    let registerBtn = UIButton(type: .Custom)
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "注册"
        configureUI()
        addTargetAction()
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
    
    }
    func getCodeAction(btn:UIButton){
    
    }
    
    func configureUI(){
        view.backgroundColor = LGBackColor
        let phoneView = FgetItemView(field: phoneNum, itemName: "手机号", frame: CGRectMake(0, 8, Screen_W, 40))
        let codeView = FgetItemView(field: codeNum, itemName: "验证码", frame: CGRectMake(0, 48, Screen_W, 40))
        let pwdView = FgetItemView(field: password, itemName: "密码", frame: CGRectMake(0, 88, Screen_W, 40))
        
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
}
