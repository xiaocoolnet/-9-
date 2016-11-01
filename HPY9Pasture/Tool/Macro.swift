//
//  Macro.swift
//  HPY9Pasture
//
//  Created by xiaocool on 16/10/11.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//
import UIKit

let LGBackColor = UIColor(red: 239/255.0, green: 239/255.0, blue: 239/255.0, alpha: 1)
let NavColor = UIColor(red: 80/255.0, green: 150/255.0, blue: 240/255, alpha: 1)
let MainFont = UIFont.systemFontOfSize(15)
let Screen_H = UIScreen.mainScreen().bounds.height
let Screen_W = UIScreen.mainScreen().bounds.width
let px = Screen_W/375
//个人习惯
let HEIGHT = UIScreen.mainScreen().bounds.height
let WIDTH = UIScreen.mainScreen().bounds.width

func RGBACOLOR(r:Float,g:Float,b:Float,a:Float) -> UIColor{
    return UIColor.init(colorLiteralRed: r/255, green: g/255, blue: b/255, alpha: a)
}
func NSLOG(someThing:NSObject){
    print(someThing)
}

