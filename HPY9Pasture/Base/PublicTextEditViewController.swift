//
//  PublicTextEditViewController.swift
//  HPY9Pasture
//
//  Created by purepure on 16/12/22.
//  Copyright © 2016年 xiaocool. All rights reserved.
//

import UIKit
typealias backForTexefunc = (editedText:String)->Void
class PublicTextEditViewController: UIViewController {
    
    var myFunc = backForTexefunc?()
    
    let  textField = UITextField()
    let rightButton = UIButton()
    
    var leftTextLabelText = String()
    var myTextStr = String()
    
    

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
        self.textField.placeholder = "(请填写)"
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
        

        // Do any additional setup after loading the view.
    }
    
    func rightButtonAction(){
        
        if self.myFunc != nil{
            if self.textField.text != nil {
                self.myFunc!(editedText:self.textField.text!)
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
