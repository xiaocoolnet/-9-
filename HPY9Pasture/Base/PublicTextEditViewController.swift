//
//  PublicTextEditViewController.swift
//  HPY9Pasture
//
//  Created by purepure on 16/12/22.
//  Copyright © 2016年 xiaocool. All rights reserved.
//

import UIKit
typealias backForTexefunc = (editedText:String)->Void
class PublicTextEditViewController: UIViewController,UITextViewDelegate {
    
    var myFunc = backForTexefunc?()
    
    let  textField = UITextField()
    let textview = UITextView()
    
    let rightButton = UIButton()
    
    var leftTextLabelText = String()
    var myTextStr = String()
    
    var isLongText = Bool()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = LGBackColor
        self.textField.frame = CGRectMake(0, 0, WIDTH, 44*px)
        let leftTextLabel = UILabel.init(frame: CGRectMake(0, 0, WIDTH/3, 50*px))
        leftTextLabel.font = MainFont
        leftTextLabel.text = self.leftTextLabelText
        self.textField.leftViewMode = .Always
        self.textField.leftView = leftTextLabel
        self.textField.textAlignment = .Right
        self.textField.font = MainFont
        if myTextStr != "" {
            self.textField.text = self.myTextStr
        }else{
            self.textField.placeholder = "(请填写)"
        }
        
        self.textField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), forControlEvents: .EditingChanged)
        self.textField.clearButtonMode = .Always
        self.textField.backgroundColor = UIColor.whiteColor()
        self.textField.contentVerticalAlignment = .Center
        
        self.view.addSubview(self.textField)
        
        self.rightButton.frame = CGRectMake(0, 0, 50*px, 70*px)
        self.rightButton.titleLabel?.font = MainFont
        self.rightButton.setTitle("保存", forState: .Normal)
        self.rightButton.setTitleColor(UIColor.lightGrayColor(), forState: .Normal)
        self.rightButton.addTarget(self, action: #selector(self.rightButtonAction), forControlEvents: .TouchUpInside)
        self.rightButton.userInteractionEnabled = false
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: self.rightButton)
        
        self.textview.frame = CGRectMake(20*px, 20*px, WIDTH-40*px, 180*px)
        self.textview.layer.masksToBounds = true
        self.textview.layer.cornerRadius = 10*px
        self.textview.backgroundColor = UIColor.whiteColor()
        
        if self.myTextStr != "" {
            self.textview.textColor = UIColor.blackColor()
            self.textview.text = myTextStr
        }else{
            self.textview.textColor = MainTextBackColor
            self.textview.text = "(请填写)"
        }
        
        self.textview.font = MainFont
        self.textview.delegate = self
        self.view.addSubview(self.textview)
        
        if self.isLongText {
            self.textField.hidden = true
            self.textview.hidden = false
        }else{
            self.textField.hidden = false
            self.textview.hidden = true
        }
        

        // Do any additional setup after loading the view.
    }
    
    //MARK: -----textViewDelegate
    
    func textViewDidBeginEditing(textView: UITextView) {
        if textView.text == self.myTextStr {
            self.rightButton.setTitleColor(UIColor.lightGrayColor(), forState: .Normal)
            self.rightButton.userInteractionEnabled = false
        }else{
            self.rightButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
            self.rightButton.userInteractionEnabled = true
        }
        if self.textview == textView {
            if textview.text ==  "(请填写)"{
                self.textview.text = ""
            }else{
                
            }
        }
        self.textview.textColor = UIColor.blackColor()
    }
    
    func rightButtonAction(){
        
        
        if self.myFunc != nil{
            if isLongText {
                if self.textview.text != nil || self.textview.text != "(请填写)" {
                    self.myFunc!(editedText:self.textview.text!)
                }else{
                   self.myFunc!(editedText:"")
                }
            }else{
                if self.textField.text != nil {
                    self.myFunc!(editedText:self.textField.text!)
                }
            }
            
            
        }
        self.navigationController?.popViewControllerAnimated(true)
    }
    func textFieldDidChange(sender:UITextField){
        if sender.text == self.myTextStr {
            self.rightButton.setTitleColor(UIColor.lightGrayColor(), forState: .Normal)
            self.rightButton.userInteractionEnabled = false
        }else{
            self.rightButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
            self.rightButton.userInteractionEnabled = true
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
