//
//  AppointmentTimeViewController.swift
//  HPY9Pasture
//
//  Created by purepure on 17/2/17.
//  Copyright © 2017年 xiaocool. All rights reserved.
//

import UIKit
import SwiftyJSON

class AppointmentTimeViewController: UIViewController {
    
    let countLabel = UILabel()
    let totalLabel = UILabel()
    let timeLabel = UILabel()
    var info:JSON?
    let textArray = ["  护理模式：","  单次护理价格:","  选择开始时间:","  护理数量："]
    var counts = 1
    var money = String()
    var price = String()
    
    let dataPickerView = UIDatePicker()
    let datePickerBackView = UIView()
    var datePickerHeaderLabel = UILabel()
    
    let halfDayButton = UIButton()
    let DayButton = UIButton()
    let moneyLabel = UILabel()
    let totalMoneyLabel = UILabel()
    
    let headerImage = UIImageView()
    let nameLabe = UILabel()
    let phoneLabel = AutoScrollLabel()
    let adressLabel = UILabel()
    let proTextLabel = UILabel()
    
    var adressinfo:addressInfo?
    
//    var weekDayLabel = UILabel()
    var briDateString1 = String()
    var timeInterval = NSTimeInterval()
    
    // 懒加载(毛玻璃效果)
    lazy var lasyEffectView:UIVisualEffectView = {
        // iOS8 系统才有
        let tempEffectView = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.ExtraLight))
        tempEffectView.frame = self.view.bounds;
        tempEffectView.alpha = 0.8
        // 添加手势
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.effectViewTouch(_:)))
        tempEffectView.addGestureRecognizer(tap)
        return tempEffectView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = LGBackColor
        self.title = "选择服务时间"
        self.creatUI()

        // Do any additional setup after loading the view.
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
            UIView.animateWithDuration(0.2) {
                self.datePickerBackView.frame = CGRectMake(0, HEIGHT, WIDTH, 320*px)
            }
           
        }else{
            self.view.addSubview(lasyEffectView)
        }
    }
    
    func changeMoeny(){
        self.money = String(format: "%.2f",Float(self.counts*Int(self.price)!))
        totalMoneyLabel.text = "  费用总计："+self.money+"元"
        
    }

    
    func creatUI(){
        
        let backView = UIView.init(frame: CGRectMake(0, 56*px, WIDTH, HEIGHT-50*px-64-56*px))
        backView.backgroundColor = LGBackColor
        
        for index in 0...textArray.count-1 {
            let leftLabel = UILabel.init(frame: CGRectMake(0, CGFloat(index)*51*px+10*px, WIDTH, 50*px))
            leftLabel.text = self.textArray[index]
            leftLabel.textAlignment = .Left
            leftLabel.font = MainFont
            leftLabel.textColor = MainTextColor
            leftLabel.backgroundColor = UIColor.whiteColor()
            backView.addSubview(leftLabel)
        }
        
        self.halfDayButton.frame = CGRectMake(WIDTH-135*px, 25*px, 60*px, 25*px)
        self.halfDayButton.backgroundColor = NavColor
        self.halfDayButton.setTitle("12小时", forState: .Normal)
        self.halfDayButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        self.halfDayButton.titleLabel?.font = UIFont.systemFontOfSize(12)
        self.halfDayButton.addTarget(self, action: #selector(self.halfDayButtonAction), forControlEvents: .TouchUpInside)
        self.halfDayButton.layer.masksToBounds = true
        self.halfDayButton.layer.cornerRadius = 5*px
        self.halfDayButton.selected = true
        backView.addSubview(halfDayButton)
        
        self.DayButton.frame = CGRectMake(WIDTH-65*px, 25*px, 60*px, 25*px)
        self.DayButton.backgroundColor = RGBACOLOR(181, g: 181, b: 181, a: 1)
        self.DayButton.setTitle("24小时", forState: .Normal)
        self.DayButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        self.DayButton.titleLabel?.font = UIFont.systemFontOfSize(12)
        self.DayButton.addTarget(self, action: #selector(self.DayButtonAction), forControlEvents: .TouchUpInside)
        self.DayButton.layer.masksToBounds = true
        self.DayButton.layer.cornerRadius = 5*px
        self.DayButton.selected = false
        backView.addSubview(DayButton)
        
        moneyLabel.frame = CGRectMake(WIDTH-100*px, 61*px, 90*px, 50*px)
        self.price = self.info!["dayprice"].string != nil ? self.info!["dayprice"].string!:"0"
        self.changeMoeny()
        moneyLabel.text = self.price+"元/次"
        
        moneyLabel.font = MainFont
        moneyLabel.textColor = MainTextBackColor
        backView.addSubview(moneyLabel)
        
        let rightImageView = UIImageView.init(frame: CGRectMake(WIDTH-25*px, 112*px+(50*px-13)/2, 7, 13))
        rightImageView.image = UIImage(named: "ic_youjiantou")
        backView.addSubview(rightImageView)
        self.timeLabel.frame = CGRectMake(WIDTH/2-70*px, 112*px, WIDTH/2+30*px, 50*px)
        self.timeLabel.font = UIFont.systemFontOfSize(12)
        self.timeLabel.textColor = MainTextBackColor
        self.timeLabel.textAlignment = .Right
        backView.addSubview(timeLabel)
        //实例化一个NSDateFormatter对象
        let dateFormatter = NSDateFormatter.init()
        //设定时间格式,这里可以设置成自己需要的格式
        dateFormatter.dateFormat = "yyyy-MM-dd EEE HH:mm"
        
        self.briDateString1 = dateFormatter.stringFromDate(NSDate())
        self.timeLabel.text = self.briDateString1
        
        let timeSelectClearButton = UIButton.init(frame: CGRectMake(0, 112*px, WIDTH, 50*px))
        timeSelectClearButton.backgroundColor = UIColor.clearColor()
        timeSelectClearButton.addTarget(self, action: #selector(self.timeSelectClearButtonAction), forControlEvents: .TouchUpInside)
        backView.addSubview(timeSelectClearButton)
        
        let reduceButton = UIButton.init(frame: CGRectMake(WIDTH-120*px,(50*px-13)/2+163*px, 25, 13))
        let addButton = UIButton.init(frame: CGRectMake(WIDTH-35*px, (50*px-13)/2+163*px, 25, 13))
        reduceButton.setImage(UIImage(named: "ic_jian"), forState: .Normal)
        addButton.setImage(UIImage(named: "ic_jia"), forState: .Normal)
        reduceButton.imageView?.contentMode = .Right
        addButton.imageView?.contentMode = .Left
        reduceButton.addTarget(self, action: #selector(self.reduceButtonAction), forControlEvents: .TouchUpInside)
        addButton.addTarget(self, action: #selector(self.addButtonAction), forControlEvents: .TouchUpInside)
        self.countLabel.frame = CGRectMake(WIDTH-95*px, 163*px, 60*px, 50*px)
        self.countLabel.font = MainFont
        self.countLabel.textAlignment = .Center
        if String(self.counts) != nil{
            self.countLabel.text = String(self.counts)
        }else{
            self.countLabel.text = "1"
        }
        
       
        
//        self.countLabel.backgroundColor = UIColor.redColor()
        backView.addSubview(addButton)
        backView.addSubview(reduceButton)
        backView.addSubview(self.countLabel)
        
        totalMoneyLabel.frame =  CGRectMake(0, HEIGHT-124*px, WIDTH-100*px, 50*px)
        totalMoneyLabel.textColor = RGBACOLOR(255, g: 172, b: 49, a: 1)
        totalMoneyLabel.backgroundColor = UIColor.whiteColor()
        totalMoneyLabel.font = MainFont
        totalMoneyLabel.textAlignment = .Left
        totalMoneyLabel.text = "  费用总计："+self.money+"元"
        self.view.addSubview(totalMoneyLabel)
        
        let appButton = UIButton.init(frame: CGRectMake(WIDTH-100*px, HEIGHT-124*px, 100*px, 50*px))
        appButton.backgroundColor = NavColor
        appButton.setTitle("立即预约", forState: .Normal)
        appButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        appButton.addTarget(self, action: #selector(self.AppButtonAction), forControlEvents: .TouchUpInside)
        appButton.titleLabel?.font = MainFont
        self.view.addSubview(appButton)
        self.view.addSubview(backView)
        let adressView = UIView.init(frame: CGRectMake(0, 0, WIDTH, 65*px))
        adressView.backgroundColor = UIColor.whiteColor()
        let rightImageView2 = UIImageView.init(frame: CGRectMake(WIDTH-25*px, (65*px-13)/2, 7, 13))
        rightImageView2.image = UIImage(named: "ic_youjiantou")
        let linebackView = UIView.init(frame: CGRectMake(0, 64*px, WIDTH, 1*px))
        linebackView.backgroundColor = LGBackColor
        adressView.addSubview(linebackView)
        adressView.addSubview(rightImageView2)
        headerImage.frame = CGRectMake(10*px, (65*px-16)/2, 13, 16)
        headerImage.image = UIImage(named: "ic_dingwei")
        nameLabe.frame = CGRectMake(40*px, 10*px, WIDTH/2-60*px, 30*px)
        nameLabe.textColor = MainTextColor
//
        nameLabe.font = MainFont
        phoneLabel.frame = CGRectMake(WIDTH/2-10*px, 10*px, WIDTH/2-50*px, 30*px)
        phoneLabel.textColor = MainTextColor
//
        phoneLabel.font = MainFont
        adressLabel.frame = CGRectMake(40*px, 35*px, WIDTH-90*px, 30*px)
        adressLabel.textColor = MainTextColor
//
        adressLabel.font = MainFont
        
        proTextLabel.frame = CGRectMake(40*px, 25*px/2, WIDTH-90*px, 40*px)
        proTextLabel.textColor = MainTextColor
        proTextLabel.font = MainFont
        
        let addressclearButton = UIButton.init(frame: adressView.frame)
        addressclearButton.backgroundColor = UIColor.clearColor()
        addressclearButton.addTarget(self, action: #selector(self.addressclearButtonAction), forControlEvents: .TouchUpInside)
        
        
        adressView.addSubview(headerImage)
        adressView.addSubview(nameLabe)
        adressView.addSubview(phoneLabel)
        adressView.addSubview(adressLabel)
        adressView.addSubview(proTextLabel)
        self.view.addSubview(adressView)
        self.view.addSubview(addressclearButton)
        
        self.changeAdress(nil)

    }
    
    func changeAdress(adress:addressInfo?){
        if adress != nil{
            self.proTextLabel.removeFromSuperview()
            adressLabel.text = self.adressinfo?.adress
            phoneLabel.text = self.adressinfo?.phone
            nameLabe.text = self.adressinfo?.name
        }else{
            self.proTextLabel.text = "请选择地址"
        }
        
    }
    
    
    //创建日期选择器
    func CreatDataPicker(){
        
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
        
        
        
        
    }

    
    
    //MARK:-----ACTION
    
    func addButtonAction(){
        
        if String(self.counts) != nil{
            self.counts = self.counts + 1
            self.countLabel.text = String(self.counts)
            self.changeMoeny()
        }

    }
    func reduceButtonAction(){
        
        if String(self.counts) != nil&&self.counts>1{
            self.counts = self.counts - 1
            self.countLabel.text = String(self.counts)
            self.changeMoeny()
        }
    }
    
    func halfDayButtonAction(){
        if !halfDayButton.selected {
            halfDayButton.selected = true
            DayButton.selected = false
            DayButton.backgroundColor = RGBACOLOR(181, g: 181, b: 181, a: 1)
            halfDayButton.backgroundColor = NavColor
            self.price = self.info!["dayprice"].string != nil ? self.info!["dayprice"].string!:"0"
            moneyLabel.text = self.price+"元/次"
            self.changeMoeny()
            
        }
        
    }
    
    func DayButtonAction(){
        if !DayButton.selected{
            DayButton.selected = true
            halfDayButton.selected = false
            halfDayButton.backgroundColor = RGBACOLOR(181, g: 181, b: 181, a: 1)
            DayButton.backgroundColor = NavColor
            self.price = self.info!["allprice"].string != nil ? self.info!["allprice"].string!:"0"
            NSLOG(self.price)
            moneyLabel.text = self.price+"元/次"
            self.changeMoeny()
        }
       
    }
    
    func timeSelectClearButtonAction(){
        if self.datePickerBackView.superview == nil{
            self.CreatDataPicker()
        }
        self.showEffectView()
        self.view.addSubview(self.datePickerBackView)
        UIView.animateWithDuration(0.2, animations: {
            self.datePickerBackView.frame = CGRectMake(0, HEIGHT-64-320*px, WIDTH, 320*px)
        })

    }
    
    
    //MARK:-------Action
    
    func dataPickerViewAction(sender:UIDatePicker){
        
        
        let date = sender.date
//        weekDayLabel.text = self.weekdayArray[self.dateWeek(sender.date)]
        //实例化一个NSDateFormatter对象
        let dateFormatter = NSDateFormatter.init()
        //设定时间格式,这里可以设置成自己需要的格式
        dateFormatter.dateFormat = "yyyy-MM-dd EEE HH:mm"
        
        self.briDateString1 = dateFormatter.stringFromDate(date)
        NSLOG(self.briDateString1)
        
    }
    
    func datePickerCancelButtonAction(){
        self.showEffectView()
    }
    
    func datePickerDetermineButtonAction(){
        self.showEffectView()
        self.timeLabel.text = self.briDateString1
    }
    
    func AppButtonAction(){
        
        
        if  USERLC != nil && USERLC!["userid"] != nil {
            if self.adressinfo == nil{
                Alert.shareManager.alert("请选择地址", delegate: self)
                return
            }
        }
        var carersid = String()
        var servicetime = "12小时"
        if self.info!["id"].string != nil{
            carersid = self.info!["id"].string!
        }else{
            Alert.shareManager.alert("预约失败", delegate: self)
            return
        }
        
        if !DayButton.selected{
            servicetime = "24小时"
        }
        
        AppRequestManager.shareManager.AddCarersOrder(USERLC!["userid"] as! String, carersid: carersid, servicetime: servicetime, money: self.money, begintime: stringToTimeStampWithWeek(self.briDateString1), address: (self.adressinfo?.adress)!, longitude: (self.adressinfo?.longitude)!, latitude: (self.adressinfo?.latitude)!, phone: (self.adressinfo?.phone)!, linkman: "", price: self.price, number: String(self.counts),remark: "") { (success, response) in
            if success{
                NSLOG("go pay")
            }else{
                NSLOG(response)
            }
        }
    }
    
    func addressclearButtonAction(){
        let vc = AdressEditViewController()
        vc.isselected = true
        vc.addressBlock = {(adressinfo) -> Void in
            self.adressinfo = adressinfo
            self.changeAdress(adressinfo)
            vc.navigationController?.popViewControllerAnimated(true)
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func dateWeek(date:NSDate)->Int{
        let calendar = NSCalendar.currentCalendar()
        var comps: NSDateComponents = NSDateComponents()
        comps = calendar.components(.Weekday, fromDate: date)
        return comps.weekday-1
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
