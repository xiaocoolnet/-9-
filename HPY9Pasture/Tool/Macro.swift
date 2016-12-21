//
//  Macro.swift
//  HPY9Pasture
//
//  Created by xiaocool on 16/10/11.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//
import UIKit

let LGBackColor = UIColor(red: 239/255.0, green: 239/255.0, blue: 239/255.0, alpha: 1)
let NavColor = UIColor(red: 81/255.0, green: 166/255.0, blue: 255/255, alpha: 1)
let MainTextBackColor = RGBACOLOR(149, g: 149, b: 149, a: 1)
let MainFont = UIFont.systemFontOfSize(13)
let Screen_H = UIScreen.mainScreen().bounds.height
let Screen_W = UIScreen.mainScreen().bounds.width
let px = Screen_W/375
//个人习惯
let HEIGHT = UIScreen.mainScreen().bounds.height
let WIDTH = UIScreen.mainScreen().bounds.width

func RGBACOLOR(r:Float,g:Float,b:Float,a:Float) -> UIColor{
    return UIColor.init(colorLiteralRed: r/255, green: g/255, blue: b/255, alpha: a)
}
//#warning 
//FIXME:测试用打印到控制台，产品发布之后注释掉，否则影响app
func NSLOG(someThing:Any){
    print(someThing)
}
//提示框

func alert(message:String,delegate:AnyObject){
    let alert = UIAlertView(title: "提示", message: message, delegate: delegate, cancelButtonTitle: "确定")
    alert.show()
}






