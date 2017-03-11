//
//  Macro.swift
//  HPY9Pasture
//
//  Created by xiaocool on 16/10/11.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//
import UIKit
import MBProgressHUD

let LGBackColor = UIColor(red: 239/255.0, green: 239/255.0, blue: 239/255.0, alpha: 1)
let NavColor = UIColor(red: 81/255.0, green: 166/255.0, blue: 255/255, alpha: 1)
let MainTextBackColor = RGBACOLOR(149, g: 149, b: 149, a: 1)
let MainTextColor = RGBACOLOR(50, g: 50, b: 50, a: 1)
let MainFont = UIFont.systemFontOfSize(13)
let Screen_H = UIScreen.mainScreen().bounds.height
let Screen_W = UIScreen.mainScreen().bounds.width
let px = Screen_W/375
//个人习惯
let HEIGHT = UIScreen.mainScreen().bounds.height
let WIDTH = UIScreen.mainScreen().bounds.width

let USERLC = (NSUserDefaults.standardUserDefaults().objectForKey("UserInfo")) != nil ?  (NSUserDefaults.standardUserDefaults().objectForKey("UserInfo") ):nil

let Happy_MainURL = "http://yanglao.xiaocool.net/"

let Happy_HeaderUrl = Happy_MainURL+"index.php?g=apps&m=index&a="
let Happy_ImageUrl = Happy_MainURL + "uploads/images/"

func RGBACOLOR(r:Float,g:Float,b:Float,a:Float) -> UIColor{
    return UIColor.init(colorLiteralRed: r/255, green: g/255, blue: b/255, alpha: a)
}
//#warning 
//FIXME:测试用打印到控制台，产品发布之后注释掉，否则影响app
func NSLOG(someThing:Any){
//    print(someThing)
    debugPrint(someThing)
}
//提示框
class Alert{
    //两行代码创建一个单例
    static let shareManager = Alert()
    private init() {
    }
    func alert(message:String,delegate:AnyObject){
        let alert = UIAlertView(title: "提示", message: message, delegate: delegate, cancelButtonTitle: "确定")
        alert.show()
    }
    func MBAlert(message:String,view:UIView){
        let hud = MBProgressHUD.showHUDAddedTo(view, animated: true)
        hud.mode = MBProgressHUDMode.Text;
        hud.label.text = message
        hud.margin = 10.0
        hud.offset.y = HEIGHT/2-80
        hud.label.font = UIFont.systemFontOfSize(14)
        hud.hideAnimated(true, afterDelay: 1.5)
    }


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
            NSLOG("任务太多")
            return
        }
        if timeInterval>120 {
            NSLOG("不支持120秒以上后台操作")
            return
        }
        if taskDic[key] != nil{
            NSLOG("存在这个任务")
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
//计算文字高度
func calculateHeight(string:String,size:CGFloat,width:  CGFloat) -> CGFloat {
    let options : NSStringDrawingOptions = NSStringDrawingOptions.UsesLineFragmentOrigin
    //let screenBounds:CGRect = UIScreen.mainScreen().bounds
    let boundingRect = String(string).boundingRectWithSize(CGSizeMake(width, 0), options: options, attributes: [NSFontAttributeName:UIFont.systemFontOfSize(size)], context: nil)
    print(boundingRect.height)
    return boundingRect.height
}
//身份证正则表达式检测
func validateIdentityCard(card:String) -> Bool{
    let string = NSString(string: card)
    let length =  NSString(string: card).length
    if length != 15 && length != 18 {
        return false
    }
    var regex:String?
    if length == 15 {
        regex = "^[1-9]\\d{7}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])\\d{3}$"
    }else{
        regex = "^[1-9]\\d{5}[1-9]\\d{3}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])\\d{3}([0-9]|X)$"
    }
    let predicate = NSPredicate.init(format: "SELF MATCHES %@",regex!)
    
    return predicate.evaluateWithObject(string)
}
//时间格式转换
func stringToTimeStamp(stringTime:String)->String {
    
    let dfmatter = NSDateFormatter()
    dfmatter.dateFormat="yyyy年MM月dd日 HH:mm:ss"
    let date = dfmatter.dateFromString(stringTime)
    
    let dateStamp:NSTimeInterval = date!.timeIntervalSince1970
    
    return String(dateStamp)
    
}
func stringToTimeStampWithWeek(stringTime:String)->String {
    
    let dfmatter = NSDateFormatter()
    dfmatter.dateFormat="yyyy-MM-dd EEE HH:mm"
    let date = dfmatter.dateFromString(stringTime)
    
    let dateStamp:NSTimeInterval = date!.timeIntervalSince1970
    
    return String(format:"%.0f",dateStamp)
    
}

func timeStampToStringyyyyMMDD(timeStamp:String)->String {
    
    let string = NSString(string: timeStamp)
    
    let timeSta:NSTimeInterval = string.doubleValue
    let dfmatter = NSDateFormatter()
    dfmatter.dateFormat="yyyy年MM月dd日"
    
    let date = NSDate(timeIntervalSince1970: timeSta)
    
    print(dfmatter.stringFromDate(date))
    return dfmatter.stringFromDate(date)
}






