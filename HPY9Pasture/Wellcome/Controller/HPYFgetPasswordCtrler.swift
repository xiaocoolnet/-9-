//
//  HPYFgetPasswordCtrler.swift
//  HPY9Pasture
//
//  Created by xiaocool on 16/10/11.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import UIKit

class HPYFgetPasswordCtrler: UIViewController {
    let phoneNum = UITextField()
    let codeNum = UITextField()
    let passwordNum = UITextField()
    let confirePwdNum = UITextField()
    let getCodeBtn = UIButton(type: .Custom)
    let trueBtn = UIButton(type:.Custom)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "忘记密码"
        configureUI()
        addTargetAction()
    }
    
    func addTargetAction(){
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(endEditingState))
        view.addGestureRecognizer(tapGesture)
        
    }
    //MARK: -------target-Action----------
    func getCodeNumberAction(){
        
    }
    func comfireBtnClickedAction(){
    
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
        trueBtn.frame = CGRectMake(8, 250, Screen_W-16, 40)
        
        trueBtn.backgroundColor = NavColor
        trueBtn.setTitle("确认", forState: .Normal)
        trueBtn.titleLabel?.font = UIFont.systemFontOfSize(15)
        trueBtn.layer.cornerRadius = 4
        
        getCodeBtn.frame = CGRectMake(Screen_W - 100, 5, 90, 30)
        getCodeBtn.backgroundColor = NavColor
        getCodeBtn.setTitle("获取验证码", forState: .Normal)
        getCodeBtn.layer.cornerRadius = 10
        getCodeBtn.titleLabel?.font = UIFont.systemFontOfSize(12)
        
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
        itemField?.frame = CGRectMake(70, 10, 100, 20)
        itemField?.font = UIFont.systemFontOfSize(14)
        itemField?.placeholder = "请输入"+item.text!
        let line = UILabel(frame: CGRectMake(0,frame.height-1,frame.width,1))
        line.backgroundColor = LGBackColor
        
        addSubview(line)
        addSubview(itemField!)
        addSubview(item)
    }
}
