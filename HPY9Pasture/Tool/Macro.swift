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

let Happy_MainURL = "http://yanglao.xiaocool.net/"

let Happy_HeaderUrl = Happy_MainURL+"index.php?g=apps&m=index&a="
let Happy_ImageUrl = Happy_MainURL + "uploads/images/"

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

typealias TimerHandle = (timeInterVal:Int)->Void
//计时器类
class TimeManager{
    var taskDic = Dictionary<String,TimeTask>()
    
    //两行代码创建一个单例
    static let shareManager = TimeManager()
    private init() {
    }
    func begainTimerWithKey(key:String,timeInterval:Float,process:TimerHandle,finish:TimerHandle){
        if taskDic.count > 20 {
            print("任务太多")
            return
        }
        if timeInterval>120 {
            print("不支持120秒以上后台操作")
            return
        }
        if taskDic[key] != nil{
            print("存在这个任务")
            return
        }
        let task = TimeTask().configureWithTime(key,time:timeInterval, processHandle: process, finishHandle:finish)
        taskDic[key] = task
    }
}
class TimeTask :NSObject{
    var key:String?
    var FHandle:TimerHandle?
    var PHandle:TimerHandle?
    var leftTime:Float = 0
    var totolTime:Float = 0
    var backgroundID:UIBackgroundTaskIdentifier?
    var timer:NSTimer?
    
    func configureWithTime(myKey:String,time:Float,processHandle:TimerHandle,finishHandle:TimerHandle) -> TimeTask {
        backgroundID = UIApplication.sharedApplication().beginBackgroundTaskWithExpirationHandler(nil)
        key = myKey
        totolTime = time
        leftTime = totolTime
        FHandle = finishHandle
        PHandle = processHandle
        timer = NSTimer(timeInterval: 1.0, target: self, selector:#selector(sendHandle), userInfo: nil, repeats: true)
        
        //将timer源写入runloop中被监听，commonMode-滑动不停止
        NSRunLoop.currentRunLoop().addTimer(self.timer!, forMode: NSRunLoopCommonModes)
        return self
    }
    
    func sendHandle(){
        leftTime -= 1
        if leftTime > 0 {
            if PHandle != nil {
                PHandle!(timeInterVal:Int(leftTime))
            }
        }else{
            timer?.invalidate()
            TimeManager.shareManager.taskDic.removeValueForKey(key!)
            if FHandle != nil {
                FHandle!(timeInterVal: 0)
            }
        }
    }
}






