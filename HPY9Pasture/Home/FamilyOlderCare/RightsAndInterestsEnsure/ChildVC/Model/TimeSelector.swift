//
//  TimeSelector.swift
//  HPY9Pasture
//
//  Created by purepure on 17/3/9.
//  Copyright © 2017年 xiaocool. All rights reserved.
//

import UIKit

typealias timeSelectBlock = (timestr:String,date:NSDate)->Void

class TimeSelector: NSObject {
    
    var timeBlock = timeSelectBlock?()
    
    var heights = CGFloat()
    var mainVC = UIViewController()
    let dataPickerView = UIDatePicker()
    let datePickerBackView = UIView()
    var datePickerHeaderLabel = UILabel()
    var briDateString1 = String()
    
    var date = NSDate()
    
    // 懒加载(毛玻璃效果)
    lazy var lasyEffectView:UIVisualEffectView = {
        // iOS8 系统才有
        let tempEffectView = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.ExtraLight))
        tempEffectView.frame = (UIApplication.sharedApplication().keyWindow?.rootViewController?.view.frame)!
        tempEffectView.alpha = 0.8
        // 添加手势
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.effectViewTouch(_:)))
        tempEffectView.addGestureRecognizer(tap)
        return tempEffectView
    }()
    
    //单例
    static let shareManager = TimeSelector()
    private override init() {
        super.init()
        self.initManager()
    }
    func  initManager() {
        
        //实例化一个NSDateFormatter对象
        let dateFormatter = NSDateFormatter.init()
        //设定时间格式,这里可以设置成自己需要的格式
        dateFormatter.dateFormat = "yyyy-MM-dd EEE HH:mm"
        
        self.briDateString1 = dateFormatter.stringFromDate(NSDate())
        
        self.date = NSDate()
        
    }
    
    //创建日期选择器
    func CreatDataPicker(vc:UIViewController,height:CGFloat,timesblock:timeSelectBlock){
        
        self.mainVC = vc
        
        self.timeBlock = timesblock
        self.heights = height
        
        self.datePickerBackView.frame = CGRectMake(0, HEIGHT, WIDTH, 320*px)
        self.datePickerBackView.backgroundColor = UIColor.whiteColor()
        
        datePickerHeaderLabel = UILabel.init(frame: CGRectMake(0, 0, WIDTH, 50*px))
        datePickerHeaderLabel.text = "日期选择"
        
        
        
        datePickerHeaderLabel.font = UIFont.systemFontOfSize(15)
        datePickerHeaderLabel.textAlignment = .Center
        datePickerHeaderLabel.backgroundColor = NavColor
        datePickerHeaderLabel.textColor = UIColor.whiteColor()
        datePickerBackView.addSubview(datePickerHeaderLabel)
        
        //        self.weekDayLabel.frame = CGRectMake(0, 0, 100, 50*px)
        //        weekDayLabel.font = UIFont.systemFontOfSize(15)
        //        weekDayLabel.textAlignment = .Center
        //        weekDayLabel.backgroundColor = NavColor
        //        weekDayLabel.textColor = UIColor.whiteColor()
        //        self.datePickerBackView.addSubview(weekDayLabel)
        
        self.dataPickerView.frame = CGRectMake(0, 50*px, WIDTH, 200*px)
        self.dataPickerView.datePickerMode = .DateAndTime
        self.dataPickerView.backgroundColor = UIColor.whiteColor()
        self.dataPickerView.addTarget(self, action: #selector(self.dataPickerViewAction(_:)), forControlEvents: .ValueChanged)
        self.dataPickerView.minimumDate = NSDate()
        self.dataPickerView.locale = NSLocale.init(localeIdentifier: "zh_CN")
        self.datePickerBackView.addSubview(self.dataPickerView)
        
        let datePickerCancelButton = UIButton.init(frame: CGRectMake(40*px, self.dataPickerView.frame.origin.y+self.dataPickerView.height+15*px, 100*px, 35*px))
        datePickerCancelButton.backgroundColor = NavColor
        datePickerCancelButton.setTitle("取消", forState: .Normal)
        datePickerCancelButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        datePickerCancelButton.addTarget(self, action: #selector(self.datePickerCancelButtonAction), forControlEvents: .TouchUpInside)
        datePickerCancelButton.layer.masksToBounds = true
        datePickerCancelButton.layer.cornerRadius = 10*px
        datePickerCancelButton.titleLabel?.font = UIFont.systemFontOfSize(14)
        
        
        let datePickerDetermineButton = UIButton.init(frame: CGRectMake(WIDTH-140*px, self.dataPickerView.frame.origin.y+self.dataPickerView.height+15*px, 100*px, 35*px))
        datePickerDetermineButton.backgroundColor = NavColor
        
        datePickerDetermineButton.setTitle("确定", forState: .Normal)
        
        datePickerDetermineButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        datePickerDetermineButton.addTarget(self, action: #selector(self.datePickerDetermineButtonAction), forControlEvents: .TouchUpInside)
        datePickerDetermineButton.layer.masksToBounds = true
        datePickerDetermineButton.layer.cornerRadius = 10*px
        datePickerDetermineButton.titleLabel?.font = UIFont.systemFontOfSize(14)
        
        self.datePickerBackView.addSubview(datePickerCancelButton)
        self.datePickerBackView.addSubview(datePickerDetermineButton)
        
        self.showEffectView()
        self.mainVC.view.addSubview(self.datePickerBackView)
        
        UIView.animateWithDuration(0.2, animations: {
            self.datePickerBackView.frame = CGRectMake(0, self.heights-320*px, WIDTH, 320*px)
        })
        
    }
    
    
    func effectViewTouch(tap:UITapGestureRecognizer) {
        // 移除毛玻璃
        if (lasyEffectView.superview != nil) {
            lasyEffectView.removeFromSuperview()
            UIView.animateWithDuration(0.2) {
                self.datePickerBackView.frame = CGRectMake(0, HEIGHT, WIDTH, 320*px)
            }
        }
    }
    func showEffectView() {
        // 点击显示毛玻璃的判断
        
        if (lasyEffectView.superview != nil) {
            lasyEffectView.removeFromSuperview()
            
            self.datePickerBackView.removeFromSuperview()
            for view in self.datePickerBackView.subviews {
                view.removeFromSuperview()
            }
            
            
        }else{
            self.mainVC.view.addSubview(lasyEffectView)
        }
    }
    
    
    func dataPickerViewAction(sender:UIDatePicker){
        
        
        date = sender.date
        //        weekDayLabel.text = self.weekdayArray[self.dateWeek(sender.date)]
        //实例化一个NSDateFormatter对象
        let dateFormatter = NSDateFormatter.init()
        //设定时间格式,这里可以设置成自己需要的格式
        dateFormatter.dateFormat = "yyyy-MM-dd EEE HH:mm"
        
        self.briDateString1 = dateFormatter.stringFromDate(date)
        
    }
    func datePickerCancelButtonAction(){
        self.showEffectView()
    }
    
    func datePickerDetermineButtonAction(){
        self.showEffectView()
        self.timeBlock!(timestr: self.briDateString1,date: date)
    }
}
