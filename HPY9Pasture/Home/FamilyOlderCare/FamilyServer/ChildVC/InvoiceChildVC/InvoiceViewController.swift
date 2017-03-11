//
//  InvoiceViewController.swift
//  HPY9Pasture
//
//  Created by purepure on 17/2/14.
//  Copyright © 2017年 xiaocool. All rights reserved.
//

import UIKit
import SwiftyJSON

class InvoiceViewController: UIViewController,UITableViewDelegate,UITableViewDataSource ,UIScrollViewDelegate,UIPickerViewDelegate,UIPickerViewDataSource,UITextViewDelegate{
    
    var type = String()
    
    var money = Float()
    
    var servertimes = 2
    
    var projecttype = String()
    
    var serverList:Array<JSON> = []
    
    var timeStr = String()
    
    var timeArray:Array<String> = []

    let InvoiceTableView = UITableView()
    var myTextView = PlaceholderTextView()
    var headerTextArray = NSMutableArray()
    var cellTextArray:Array<Array<String>> = [[""]]
    var VCArray = NSMutableArray()
    let dataPickerView = UIDatePicker()
    let datePickerBackView = UIView()
    var datePickerHeaderLabel = UILabel()
    var timeHoursWorkStr = "2小时"
    
    let timePickerView = UIPickerView()
    let timePickerBackView = UIView()
    let timeHoursTextArray = ["08","09","10","11","12","13","14","15","16","17","18"]
    var halfHoursTextArray = ["00","30"]
    
    var weekdayArray = ["星期日","星期一","星期二","星期三","星期四","星期五","星期六"]
    var newTimeHoursTextArray :Array<String> = []
    
    var timeforWork = NSMutableDictionary()
    
    var timeHoursStr = String()
    var halfHoursStr = String()
    var isToDay = false//是否是当天时间
    let tatolMoenylabel = UILabel()
    
    var briDateString1 = NSString()//时间选择器日期
    
    var weekDayLabel = UILabel()
    
    var userLocationCenter = NSUserDefaults.standardUserDefaults()
    
    var openDatePickerViewCount = Int()//时间选择单元格标签
    let countLabel = UILabel()//数量Label
    var counts = 1//数量
    var price = Float()
    var adressinfo:addressInfo?
    
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
        timeforWork = ["2小时":2,"2.5小时":2.5,"3小时":3,"3.5小时":3.5,"4小时":4,"4.5小时":4.5,"5小时":5,"5.5小时":5.5,"6小时":6]
        timeHoursStr = "08"
        halfHoursStr = "00"
        self.projecttype = ""
        //添加默认开始时间
        let dateFormatter = NSDateFormatter.init()
        dateFormatter.dateFormat = "yyyy-MM-dd EEE"
        let newdateStr = dateFormatter.stringFromDate(NSDate())
        self.briDateString1 = dateFormatter.stringFromDate(NSDate())
        if self.briDateString1 == newdateStr{
            self.isToDay = true
            self.newTimeHoursTextArray.removeAll()
            let dateFormatter = NSDateFormatter.init()
            dateFormatter.dateFormat = "HH"
            let newdateStr1 = dateFormatter.stringFromDate(NSDate())
            let newdateHours = Int(newdateStr1)
            for hours in self.timeHoursTextArray{
                let newdateHour2 = Int(hours)
                if newdateHour2>newdateHours{
                    self.newTimeHoursTextArray =  self.newTimeHoursTextArray+[String(newdateHour2!)]
                }
            }
            
            
            if self.newTimeHoursTextArray.count > 0 {
                timeHoursStr = self.newTimeHoursTextArray[0]
                timeStr = (self.briDateString1 as String) +  "  " + self.timeHoursStr+":"+self.halfHoursStr
            }
            if newdateHours>18{
                self.briDateString1 = dateFormatter.stringFromDate(self.DateSection(1))
                timeHoursStr = "08"
                timeStr =  (self.briDateString1 as String) +  "  " + self.timeHoursStr+":"+self.halfHoursStr
            }
            
        }
        NSLOG(cellTextArray)
        NSLOG(timeStr)
        
        
        cellTextArray[cellTextArray.count-2] = [timeStr]
        InvoiceTableView.delegate = self
        InvoiceTableView.dataSource = self
        InvoiceTableView.backgroundColor = LGBackColor
        InvoiceTableView.frame = CGRectMake(0, 0, WIDTH, HEIGHT-64-40*px)
        InvoiceTableView.separatorStyle = .None
//        self.InvoiceTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
        
        
        InvoiceTableView.sectionHeaderHeight = 30*px
        self.view.addSubview(InvoiceTableView)
        
        self.tatolMoenylabel.textColor = RGBACOLOR(255, g: 172, b: 49, a: 1)
        self.tatolMoenylabel.font = MainFont
        self.tatolMoenylabel.frame = CGRectMake(0, HEIGHT-64-40*px, WIDTH-100*px, 40*px)
        
        
        self.tatolMoenylabel.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(self.tatolMoenylabel)
        
        let goButton = UIButton.init(frame: CGRectMake(WIDTH-100*px, HEIGHT-64-40*px, 100*px, 40*px))
        goButton.backgroundColor = RGBACOLOR(81, g: 166, b: 255, a: 1)
        goButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        goButton.setTitle("立即预约", forState: .Normal)
        goButton.addTarget(self, action: #selector(self.goButtonAction), forControlEvents: .TouchUpInside)
        goButton.titleLabel?.font = MainFont
        self.view.addSubview(goButton)
        
        
        let type1 = Int(self.type)
        
        if type1 != nil{
            self.getDate(String(type1!+1))
        }
        
        
        // Do any additional setup after loading the view.
    }
    
    func getDate(type:String){
        
        AppRequestManager.shareManager.getPriceByServiceType(type) { (success, response) in
            if success{
                let priceJson = JSON(data: response as! NSData)
                if priceJson["data"]["price"].string != nil{
                    if NSInteger(priceJson["data"]["price"].string!) != nil{
                        self.price = Float(priceJson["data"]["price"].string!)!
                        self.changeMoneyLabel()
                        self.InvoiceTableView.reloadData()
                    }
                    
                }
            }else{
                Alert.shareManager.alert("网络请求失败！", delegate: self)
            }
        }
    }
    
    func  makeAnAppointment(){
        
        if  USERLC != nil && USERLC!["userid"] != nil {
            if self.adressinfo == nil{
                Alert.shareManager.alert("请选择地址", delegate: self)
                return
            }
        }
        let goType = String(Int(self.type)!)
        var number = String()
        var servicetime = String()
        var beginArray : Array<String> = []
        var textStr = String()
        if self.type == "0"{
            beginArray.appendContentsOf(self.cellTextArray[2])
            servicetime = String(self.timeforWork.objectForKey(self.cellTextArray[1][0]) as! NSInteger)
        }else if self.type == "1"{
            beginArray.appendContentsOf(self.cellTextArray[4])
            servicetime = String(self.timeforWork.objectForKey(self.cellTextArray[1][0]) as! NSInteger)
            number = self.cellTextArray[3][0]
        }else if self.type == "2"||self.type == "3"||self.type == "4"{
            beginArray.appendContentsOf(self.cellTextArray[3])
            servicetime = self.cellTextArray[2][0]
        }else if self.type == "5" || self.type == "6"||self.type == "8"{
            beginArray.appendContentsOf(self.cellTextArray[2])
            
        }else if self.type == "7"{
            beginArray.appendContentsOf(self.cellTextArray[2])
            number = String(self.counts)
        }
        
        if beginArray.count != 1{
            beginArray.removeLast()
        }
        if self.myTextView.text != nil && self.myTextView.text != "" && self.myTextView.text != "请输入您的要求，客服会及时安排。"{
            textStr = self.myTextView.text
        }
       
        AppRequestManager.shareManager.AddServiceOrder(USERLC!["userid"] as! String, type: goType, servicetime: servicetime, money: String(self.money), begintime: beginArray, address: (self.adressinfo?.adress)!, longitude: (self.adressinfo?.longitude)!, latitude: (self.adressinfo?.latitude)!, remark:textStr , projectid: self.projecttype, number: number, price: String(self.price)) { (success, response) in
            if success{
                NSLOG("go pay")
            }else{
                NSLOG("error")
                NSLOG(response)
            }
        }
        
    }
    
    
    
    func changeMoneyLabel(){
        
        if self.type == "0"||self.type == "5"{
            self.tatolMoenylabel.text = "    费用总计：" + String(format: "%.2f",self.price*Float(self.servertimes))+"元"
            self.money = self.price
        }else if self.type == "1"{
            self.tatolMoenylabel.text = "    费用总计：" + String(format: "%.2f",(self.timeforWork.objectForKey(self.cellTextArray[1][0]) as! Float)*self.price*Float(self.cellTextArray[3][0])!)+"元"
            self.money = (self.timeforWork.objectForKey(self.cellTextArray[1][0]) as! Float)*self.price*Float(self.cellTextArray[3][0])!
        }else if self.type == "2"||self.type == "3"||self.type == "4"{
            self.tatolMoenylabel.text = "    费用总计：" + String(format: "%.2f",(Float(self.cellTextArray[2][0]))!*self.price)+"元"
            self.money = (Float(self.cellTextArray[2][0]))!*self.price
        }else if self.type == "6"||self.type == "7"||self.type == "8"{
            self.tatolMoenylabel.text = "    费用总计：" + String(format: "%.2f",(self.price))+"元"
            self.money = self.price
        }
    }
    
    
    func effectViewTouch(tap:UITapGestureRecognizer) {
        // 移除毛玻璃
        if (lasyEffectView.superview != nil) {
            lasyEffectView.removeFromSuperview()
            self.datePickerBackView.removeFromSuperview()
            self.timePickerBackView.removeFromSuperview()
            for view in self.datePickerBackView.subviews {
                view.removeFromSuperview()
            }
            for view in self.timePickerBackView.subviews {
                view.removeFromSuperview()
            }
            
        }
    }
    func showEffectView() {
        // 点击显示毛玻璃的判断
        
        if (lasyEffectView.superview != nil) {
            lasyEffectView.removeFromSuperview()
            self.datePickerBackView.removeFromSuperview()
            self.timePickerBackView.removeFromSuperview()
            for view in self.datePickerBackView.subviews {
                view.removeFromSuperview()
            }
            for view in self.timePickerBackView.subviews {
                view.removeFromSuperview()
            }
        }else{
            self.view.addSubview(lasyEffectView)
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
        
        self.weekDayLabel.frame = CGRectMake(0, 0, 100, 50*px)
        weekDayLabel.font = UIFont.systemFontOfSize(15)
        weekDayLabel.textAlignment = .Center
        weekDayLabel.backgroundColor = NavColor
        weekDayLabel.textColor = UIColor.whiteColor()
        self.datePickerBackView.addSubview(weekDayLabel)
        
        self.dataPickerView.frame = CGRectMake(0, 50*px, WIDTH, 200*px)
        self.dataPickerView.datePickerMode = .Date
        self.dataPickerView.backgroundColor = UIColor.whiteColor()
        self.dataPickerView.addTarget(self, action: #selector(self.dataPickerViewAction(_:)), forControlEvents: .ValueChanged)

        
        if newTimeHoursTextArray.count>0{
            self.dataPickerView.minimumDate = NSDate()
            weekDayLabel.text = self.weekdayArray[self.dateWeek(NSDate())]
        }else{
            self.dataPickerView.minimumDate = self.DateSection(1)
            weekDayLabel.text = self.weekdayArray[self.dateWeek(self.DateSection(1))]
            newTimeHoursTextArray = timeHoursTextArray
        }
        
        self.dataPickerView.maximumDate = self.DateSection(14)
        
        
        
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
        
        datePickerDetermineButton.setTitle("下一步", forState: .Normal)
        
        datePickerDetermineButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        datePickerDetermineButton.addTarget(self, action: #selector(self.datePickerDetermineButtonAction), forControlEvents: .TouchUpInside)
        datePickerDetermineButton.layer.masksToBounds = true
        datePickerDetermineButton.layer.cornerRadius = 10*px
        datePickerDetermineButton.titleLabel?.font = UIFont.systemFontOfSize(14)
        
        self.datePickerBackView.addSubview(datePickerCancelButton)
        self.datePickerBackView.addSubview(datePickerDetermineButton)
        
        
        
        
    }
    //创建时间选择器
    func CreatTimePicker(){
        
        self.timePickerBackView.frame = CGRectMake(0, HEIGHT, WIDTH, 320*px)
        self.timePickerBackView.backgroundColor = UIColor.whiteColor()
        let timePickerHeaderLabel = UILabel.init(frame: CGRectMake(0, 0, WIDTH, 50*px))
        timePickerHeaderLabel.text = "日期选择"
        
        let dateFormatter = NSDateFormatter.init()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let newdateStr = dateFormatter.stringFromDate(NSDate())
//        self.briDateString1 = dateFormatter.stringFromDate(NSDate())
        if self.briDateString1 == newdateStr{
            self.isToDay = true
            self.newTimeHoursTextArray.removeAll()
            let dateFormatter = NSDateFormatter.init()
            dateFormatter.dateFormat = "HH"
            let newdateStr1 = dateFormatter.stringFromDate(NSDate())
            let newdateHours = Int(newdateStr1)
            for hours in self.timeHoursTextArray{
                let newdateHour2 = Int(hours)
                if newdateHour2>newdateHours{
                    self.newTimeHoursTextArray =  self.newTimeHoursTextArray+[String(newdateHour2!)]
                    
                }
            }
            timeHoursStr = self.newTimeHoursTextArray[0]
        }else{
            self.isToDay = false
            timeHoursStr = "08"
            
//            self.timePickerView.reloadAllComponents()
        }
        
        
        timePickerHeaderLabel.font = UIFont.systemFontOfSize(15)
        timePickerHeaderLabel.textAlignment = .Center
        timePickerHeaderLabel.backgroundColor = NavColor
        timePickerHeaderLabel.textColor = UIColor.whiteColor()
        timePickerBackView.addSubview(timePickerHeaderLabel)
        
        
        self.timePickerView.frame = CGRectMake(0, 50*px, WIDTH, 200*px)
        self.timePickerView.delegate = self
        self.timePickerView.dataSource = self
        self.timePickerView.backgroundColor = UIColor.whiteColor()
        
        
        self.dataPickerView.locale = NSLocale.init(localeIdentifier: "zh_CN")
        self.timePickerBackView.addSubview(self.timePickerView)
        
        let timePickerCancelButton = UIButton.init(frame: CGRectMake(40*px, self.timePickerView.frame.origin.y+self.timePickerView.height+15*px, 100*px, 35*px))
        timePickerCancelButton.backgroundColor = NavColor
        timePickerCancelButton.setTitle("取消", forState: .Normal)
        timePickerCancelButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        timePickerCancelButton.addTarget(self, action: #selector(self.timePickerCancelButtonAction), forControlEvents: .TouchUpInside)
        timePickerCancelButton.layer.masksToBounds = true
        timePickerCancelButton.layer.cornerRadius = 10*px
        timePickerCancelButton.titleLabel?.font = UIFont.systemFontOfSize(14)
        
        
        let timePickerDetermineButton = UIButton.init(frame: CGRectMake(WIDTH-140*px, self.timePickerView.frame.origin.y+self.timePickerView.height+15*px, 100*px, 35*px))
        timePickerDetermineButton.backgroundColor = NavColor
        
        timePickerDetermineButton.setTitle("确定", forState: .Normal)
        
        timePickerDetermineButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        timePickerDetermineButton.addTarget(self, action: #selector(self.timePickerDetermineButtonAction), forControlEvents: .TouchUpInside)
        timePickerDetermineButton.layer.masksToBounds = true
        timePickerDetermineButton.layer.cornerRadius = 10*px
        timePickerDetermineButton.titleLabel?.font = UIFont.systemFontOfSize(14)
        
        self.timePickerBackView.addSubview(timePickerCancelButton)
        self.timePickerBackView.addSubview(timePickerDetermineButton)
        self.timePickerView.selectRow(0, inComponent: 0, animated: false)
        
        
        
    }

    
    
    
    //MARK: ------UITableViewDelegate
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        
        
        if indexPath.section == 0{
            return 65*px
        }else if indexPath.section == self.headerTextArray.count-1{
            return 150*px
        }else{
            return 44*px
        }
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        self.myTextView.resignFirstResponder()
        switch indexPath.section {
            
        case 0:
            let vc = AdressEditViewController()
            vc.isselected = true
            vc.addressBlock = {(adressinfo) -> Void in
                self.adressinfo = adressinfo
                self.InvoiceTableView.reloadSections(NSIndexSet.init(index: 0), withRowAnimation: .Automatic)
                vc.navigationController?.popViewControllerAnimated(true)
            }
            self.navigationController?.pushViewController(vc, animated: true)
            
            
        case self.cellTextArray.count-2:
            
            self.openDatePickerViewCount = indexPath.row
            
            self.showEffectView()
            self.CreatDataPicker()
            let dateFormatter = NSDateFormatter.init()
            dateFormatter.dateFormat = "HH"
            let newdateStr = dateFormatter.stringFromDate(NSDate())
            let newdateHours = Int(newdateStr)
            if newdateHours > 17 {
                let calendar = NSCalendar.init(calendarIdentifier:NSCalendarIdentifierGregorian)
                let adcomps = NSDateComponents.init()
                adcomps.setValue(1, forComponent: .Day)
                let newdate = calendar?.dateByAddingComponents(adcomps, toDate: NSDate(), options: .WrapComponents)
                self.dataPickerView.minimumDate = newdate
            }
            
            
            
            self.view.addSubview(self.datePickerBackView)
            UIView.animateWithDuration(0.2, animations: {
                self.datePickerBackView.frame = CGRectMake(0, HEIGHT-64-320*px, WIDTH, 320*px)
            })
            
            break


        case 1:
            
             if self.type == "0"||self.type == "1"{
                let vc = PublicTableViewViewController()
                vc.title = "打扫时长"
                vc.myArray = ["2小时","2.5小时","3小时","3.5小时","4小时","4.5小时","5小时","5.5小时","6小时"]
                vc.myFunc = {(selectText,index) ->Void in
                    self.cellTextArray[indexPath.section][indexPath.row]  = selectText
                    self.InvoiceTableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Bottom)
                    if self.type == "1"{
                        
                        let indexs = Float(self.cellTextArray[3][0])
                        if indexs != nil{
                            self.tatolMoenylabel.text = "    费用总计：" + String(format: "%.2f",indexs!*self.price*(self.timeforWork.objectForKey(selectText) as! Float))+"元"
                            self.money = indexs!*self.price*(self.timeforWork.objectForKey(selectText) as! Float)
                        }else{
                            Alert.shareManager.alert("请输入正确的数字", delegate: vc)
                            return
                        }
                        
                    }else{
                        self.tatolMoenylabel.text = "    费用总计：" + String(format: "%.2f",(self.timeforWork.objectForKey(selectText) as! Float)*self.price)+"元"
                        self.servertimes = self.timeforWork.objectForKey(selectText) as! Int
                        self.money = (self.timeforWork.objectForKey(selectText) as! Float)*self.price
                    }
                    
                    vc.navigationController?.popViewControllerAnimated(true)
                }
                self.navigationController?.pushViewController(vc, animated: true)

             }
             else if self.type == "2"||self.type == "3"||self.type == "4"{
                let vc = PublicTableViewViewController()
                vc.title = "工作性质"
                vc.myFunc = {[unowned self](selectText,index) ->Void in
                    self.cellTextArray[indexPath.section][indexPath.row]  = selectText
                    self.InvoiceTableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Bottom)
                    if self.serverList[index]["price"].string != nil{
                        self.price = Float(self.serverList[index]["price"].string!)!
                    }
                    if self.serverList[index]["id"].string != nil{
                        self.projecttype = self.serverList[index]["id"].string!
                    }
                    
                    self.tatolMoenylabel.text = "    费用总计：" + String(format: "%.2f",(Float(self.cellTextArray[2][0]))!*self.price)+"元"
                    self.money = (Float(self.cellTextArray[2][0]))!*self.price
                    vc.navigationController?.popViewControllerAnimated(true)
                    
                }
                 self.navigationController?.pushViewController(vc, animated: true)
                vc.dataBlock = {[unowned self]() -> Void in
                    if self.type == "2"{
                        AppRequestManager.shareManager.GetMoonWomanProjectList({ (success, response) in
                            if success{
                               let userinfo = response as! NSData
                                self.serverList = JSON(data: userinfo)["data"].array!
                                for data  in self.serverList{
                                    if data["name"].string != nil&&data["price"].string != nil{
                                        vc.myArray.append(data["name"].string!+"("+data["price"].string!+"元/天)")
                                    }
                                    
                                }
                                vc.myTableView.reloadData()
                            }
                        })
                    }else if self.type == "3"{
                        AppRequestManager.shareManager.GetParentingProjectList({ (success, response) in
                            if success{
                                let userinfo = response as! NSData
                                self.serverList = JSON(data: userinfo)["data"].array!
                                for data  in self.serverList{
                                    if data["name"].string != nil&&data["price"].string != nil{
                                        vc.myArray.append(data["name"].string!+"("+data["price"].string!+"元/天)")
                                    }
                                    
                                }
                                vc.myTableView.reloadData()
                            }
                        })
                    }else if self.type == "4"{
                        
                    }
                    
                }
             }
             else if self.type == "6"{
                let vc = PublicTableViewViewController()
                vc.title = self.headerTextArray[indexPath.section] as? String
                vc.myFunc = {(selectText,index) ->Void in
                    self.cellTextArray[indexPath.section][indexPath.row]  = selectText
                    self.InvoiceTableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Bottom)
                    if self.serverList[index]["price"].string != nil{
                        self.price = Float(self.serverList[index]["price"].string!)!
                    }
                    if self.serverList[index]["id"].string != nil{
                        self.projecttype = self.serverList[index]["id"].string!
                    }
                    
                    self.tatolMoenylabel.text = "    费用总计：" + String(format: "%.2f",self.price) + "元"
                    self.money = self.price
                    
                vc.navigationController?.popViewControllerAnimated(true)
             }
             self.navigationController?.pushViewController(vc, animated: true)
                
                vc.dataBlock = {[unowned self]() -> Void in
                    
                    AppRequestManager.shareManager.GetMaintenanceProjectList({ (success, response) in
                        if success{
                            let userinfo = response as! NSData
                            self.serverList = JSON(data: userinfo)["data"].array!
                            for data  in self.serverList{
                                if data["name"].string != nil&&data["price"].string != nil{
                                    vc.myArray.append(data["name"].string!+"("+data["price"].string!+"元)")
                                }
                                
                            }
                            vc.myTableView.reloadData()
                        }
                    })
                }
            
             }else if self.type == "7"{
                if indexPath.row == 0{
                    let vc = PublicTableViewViewController()
                    vc.title = self.headerTextArray[indexPath.section] as? String
                    vc.myFunc = {(selectText,index) ->Void in
                        self.cellTextArray[indexPath.section][indexPath.row]  = selectText
                        if self.serverList[index]["price"].string != nil{
                            self.price = Float(self.serverList[index]["price"].string!)!
                        }
                        
                        if self.serverList[index]["id"].string != nil{
                            self.projecttype = self.serverList[index]["id"].string!
                        }
                        self.tatolMoenylabel.text = "    费用总计：" + String(format: "%.2f",self.price * Float(self.counts)) + "元"
                        self.money = self.price * Float(self.counts)
                        if self.cellTextArray[1].count == 1{
                             self.cellTextArray[1].insert("清洗数量", atIndex: 1)
                        }
                       
                        self.InvoiceTableView.reloadData()
                        
                        vc.navigationController?.popViewControllerAnimated(true)
                    }
                    self.navigationController?.pushViewController(vc, animated: true)
                    
                    vc.dataBlock = {[unowned self]() -> Void in
                        
                        AppRequestManager.shareManager.GetAppliancesProjectList({ (success, response) in
                            if success{
                                let userinfo = response as! NSData
                                self.serverList = JSON(data: userinfo)["data"].array!
                                for data  in self.serverList{
                                    if data["name"].string != nil&&data["price"].string != nil{
                                        vc.myArray.append(data["name"].string!+"("+data["price"].string!+"元/件)")
                                    }
                                    
                                }
                                vc.myTableView.reloadData()
                            }
                        })
                    }
                }
                
             }else if self.type == "8"{
                let vc = PublicTableViewViewController()
                vc.title = self.headerTextArray[indexPath.section] as? String
        
                vc.myFunc = {(selectText,index) ->Void in
                    self.cellTextArray[indexPath.section][indexPath.row]  = selectText
                    self.InvoiceTableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Bottom)
                    if self.serverList[index]["price"].string != nil{
                        self.price = Float(self.serverList[index]["price"].string!)!
                    }
                    if self.serverList[index]["id"].string != nil{
                        self.projecttype = self.serverList[index]["id"].string!
                    }
                    self.tatolMoenylabel.text = "    费用总计：" + String(format: "%.2f",self.price) + "元"
                    self.money = self.price
                    
                    vc.navigationController?.popViewControllerAnimated(true)
                }
                self.navigationController?.pushViewController(vc, animated: true)
                
                vc.dataBlock = {[unowned self]() -> Void in
                    
                    AppRequestManager.shareManager.GetFirstidkitProjectList({ (success, response) in
                        if success{
                            let userinfo = response as! NSData
                            self.serverList = JSON(data: userinfo)["data"].array!
                            for data  in self.serverList{
                                if data["name"].string != nil&&data["price"].string != nil{
                                    vc.myArray.append(data["name"].string!+"("+data["price"].string!+"元)")
                                }
                                
                            }
                            vc.myTableView.reloadData()
                        }
                    })
                }
             }else if self.type == "5"{
                let vc = PublicTableViewViewController()
                vc.title = self.headerTextArray[indexPath.section] as? String
                vc.myFunc = {(selectText,index) ->Void in
                    self.cellTextArray[indexPath.section][indexPath.row]  = selectText
                    self.InvoiceTableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Bottom)
                    if self.serverList[index]["price"].string != nil{
                        self.price = Float(self.serverList[index]["price"].string!)!
                    }
                    if self.serverList[index]["id"].string != nil{
                        self.projecttype = self.serverList[index]["id"].string!
                    }
                    self.tatolMoenylabel.text = "    费用总计：" + String(format: "%.2f",self.price) + "元"
                    self.money = self.price
                    vc.navigationController?.popViewControllerAnimated(true)
                }
                self.navigationController?.pushViewController(vc, animated: true)
                
                vc.dataBlock = {[unowned self]() -> Void in
                    
                    AppRequestManager.shareManager.GetCleaningProjectList({ (success, response) in
                        if success{
                            let userinfo = response as! NSData
                            self.serverList = JSON(data: userinfo)["data"].array!
                            for data  in self.serverList{
                                if data["name"].string != nil&&data["price"].string != nil{
                                    vc.myArray.append(data["name"].string!+"("+data["price"].string!+"元)")
                                }
                                
                            }
                            vc.myTableView.reloadData()
                        }
                    })
                }
             }
             break
            
            
        case 2:
            if self.type == "1"{
                let vc = PublicTableViewViewController()
                 vc.title = self.headerTextArray[indexPath.section] as? String
                vc.myArray = ["一周一次","一周多次","两周一次"]
                vc.myFunc = {(selectText,index) ->Void in
                    self.cellTextArray[indexPath.section][indexPath.row]  = selectText
                    self.InvoiceTableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Bottom)
                    for _ in self.cellTextArray[4] {
                        if self.cellTextArray[4].count != 1{
                            self.cellTextArray[4].removeLast()
                        }
                    }
                    if selectText == "一周多次"{
                        self.cellTextArray[4].insert("请选择下次服务时间", atIndex: 1)
                        self.InvoiceTableView.reloadData()
                    }else{
                        
//                        self.cellTextArray[4].insert("请选择下次服务时间", atIndex: 1)
                        self.InvoiceTableView.reloadData()
                    }
                    if selectText == "两周一次"{
                        self.dataPickerView.maximumDate = self.DateSection(14)
                    }else {
                        self.dataPickerView.maximumDate = self.DateSection(7)
                    }
//                    NSLOG(self.cellTextArray[4])
//                    self.tatolMoenylabel.text = "    费用总计：" + String(format: "%.2f",(self.timeforWork.objectForKey(selectText) as! Float)*30)+"元"
                    vc.navigationController?.popViewControllerAnimated(true)
                }
                self.navigationController?.pushViewController(vc, animated: true)
                
            }else if self.type == "2"||self.type == "3"||self.type == "4"{
                let vc = PublicTextEditViewController()
                vc.title = self.headerTextArray[indexPath.section] as? String
                vc.leftTextLabelText = self.headerTextArray[indexPath.section] as! String
                vc.textField.keyboardType = .NumberPad
                vc.myFunc = {(selectText) ->Void in
                    self.cellTextArray[indexPath.section][indexPath.row]  = selectText
                    self.InvoiceTableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Bottom)
                    
                    let indexs = Float(selectText)
                    
                    if indexs != nil{
                        self.tatolMoenylabel.text = "    费用总计：" + String(format: "%.2f",(Float(self.cellTextArray[indexPath.section][indexPath.row]))!*self.price)+"元"
                        self.money = (Float(self.cellTextArray[indexPath.section][indexPath.row]))!*self.price
                    }else{
                        Alert.shareManager.alert("请输入正确的数字", delegate: vc)
                        return
                    }
                     vc.navigationController?.popViewControllerAnimated(true)
                    
                }
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
            break
            
        case 3:
            if self.type == "1"{
                let vc = PublicTextEditViewController()
                vc.title = self.headerTextArray[indexPath.section] as? String
                vc.leftTextLabelText = self.headerTextArray[indexPath.section] as! String
                vc.textField.keyboardType = .NumberPad
                vc.myFunc = {(selectText) ->Void in
                    self.cellTextArray[indexPath.section][indexPath.row]  = selectText
                    self.InvoiceTableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Bottom)
                    
                    let indexs = Float(selectText)
                    if indexs<2{
                        Alert.shareManager.alert("请至少输入2次", delegate: vc)
                        return
                    }
                    if indexs != nil{
                        self.tatolMoenylabel.text = "    费用总计：" + String(format: "%.2f",indexs!*self.price*(self.timeforWork.objectForKey(self.cellTextArray[1][0]) as! Float))+"元"
                        self.money = indexs!*self.price*(self.timeforWork.objectForKey(self.cellTextArray[1][0]) as! Float)
                    }else{
                        Alert.shareManager.alert("请输入正确的数字", delegate: vc)
                        return
                    }
                    
                    vc.navigationController?.popViewControllerAnimated(true)
                }
                self.navigationController?.pushViewController(vc, animated: true)
                
            }
            break
            
        default:
            break
        }
        
    }
    
    
    //MARK: ------TableViewDatasource
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.cellTextArray.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        return cellTextArray[section].count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        
        
        let cell = UITableViewCell.init(style: .Value1, reuseIdentifier: "UITableViewCell")
        
        cell.accessoryType = .DisclosureIndicator
        cell.selectionStyle = .None
        
        let headerImage = UIImageView.init(frame: CGRectMake(10*px, (65*px-16)/2, 13, 16))
        let nameLabe = UILabel.init(frame: CGRectMake(40*px, 10*px, WIDTH/2-60*px, 30*px))
        let phoneLabel = UILabel.init(frame: CGRectMake(WIDTH/2-10*px, 10*px, WIDTH/2-50*px, 30*px))
        let adressLabel = UILabel.init(frame: CGRectMake(40*px, 35*px, WIDTH-90*px, 30*px))
        if indexPath.section == self.headerTextArray.count-1{
            myTextView.frame =  CGRectMake(10, 0, WIDTH-20, 140*px)
            myTextView.delegate = self
            myTextView.font = MainFont
            myTextView.editable = true
            myTextView.placeholder = "请输入您的要求，客服会及时安排。"
            cell.addSubview(myTextView)
        }
        if indexPath.section == 0 && self.adressinfo != nil{
            headerImage.image = UIImage(named: "ic_dingwei")
            cell.addSubview(headerImage)
            nameLabe.textColor = MainTextColor
            nameLabe.text = self.adressinfo?.name
            nameLabe.font = MainFont
            cell.addSubview(nameLabe)
            phoneLabel.textColor = MainTextColor
            phoneLabel.text = self.adressinfo?.phone
            phoneLabel.font = MainFont
            cell.addSubview(phoneLabel)
            adressLabel.textColor = MainTextColor
            adressLabel.text = self.adressinfo?.adress
            adressLabel.font = MainFont
            cell.addSubview(adressLabel)
            return cell
        }else if indexPath.section == 0 && self.adressinfo == nil{
            cell.textLabel?.text = "请选择地址"
            cell.textLabel?.textColor = MainTextBackColor
            cell.textLabel?.font = MainFont
            return cell
        }
        
        
        if indexPath.section == cellTextArray.count-2{
            
            if indexPath.row == 0{
                cell.textLabel?.text = ""
                cell.textLabel?.font = MainFont
                cell.detailTextLabel?.font = MainFont
                cell.detailTextLabel?.textColor = MainTextBackColor
                cell.detailTextLabel?.text = cellTextArray[indexPath.section][indexPath.row]
                NSLOG(cellTextArray)
                return cell
            }else{
                
        
                cell.detailTextLabel?.font = MainFont
                cell.detailTextLabel?.textColor = MainTextBackColor
                cell.detailTextLabel?.text = cellTextArray[indexPath.section][indexPath.row]
                
                if cellTextArray[indexPath.section][indexPath.row] == "请选择下次服务时间"{
                    return cell
                }else{
                    let delButton = UIButton.init(frame: CGRectMake(10, 5, 50, 20))
                    delButton.backgroundColor = UIColor.redColor()
                    delButton.setTitle("删除", forState: .Normal)
                    delButton.titleLabel?.font = MainFont
                    delButton.layer.masksToBounds = true
                    delButton.layer.cornerRadius = 5
                    delButton.tag = indexPath.row
                    delButton.addTarget(self, action: #selector(self.delButtonAction(_:)), forControlEvents: .TouchUpInside)
                    
                    cell.addSubview(delButton)
                    
                    return cell

                }
                
            }
            
            
        }
        
        
        cell.textLabel?.text = (self.cellTextArray[indexPath.section] )[indexPath.row] as String
            
//            self.cellTextArray[indexPath.section][indexPath.row] as! String
        cell.textLabel?.font = MainFont
        if self.type == "2"||self.type == "3"||self.type == "4"{
            if indexPath.section == 1{
                if cell.textLabel?.text == "请选择工作性质"{
                    cell.textLabel?.textColor = MainTextBackColor
                }
            }
        }
        
        if indexPath.section == 1 && self.type == "5"{
            if cell.textLabel?.text == "请选择清洁范围"{
                cell.textLabel?.textColor = MainTextBackColor
            }
        }
        
        if indexPath.section == 1 && self.type == "6"{
            if cell.textLabel?.text == "请选择维修物品"{
                cell.textLabel?.textColor = MainTextBackColor
            }
        }
        
        if indexPath.section == 1 && self.type == "7"&&indexPath.row == 0{
            if cell.textLabel?.text == "请选择清洗物品"{
                cell.textLabel?.textColor = MainTextBackColor
            }
        }
        if indexPath.section == 1 && self.type == "8"{
            if cell.textLabel?.text == "请选择服务类型"{
                cell.textLabel?.textColor = MainTextBackColor
            }
        }
        
        
        
        if self.type == "7"&&indexPath.section == 1&&indexPath.row == 1{
            cell.accessoryType = .None
            let reduceButton = UIButton.init(frame: CGRectMake(WIDTH-90*px,(44*px-13)/2, 25, 13))
            let addButton = UIButton.init(frame: CGRectMake(WIDTH-30*px, (44*px-13)/2, 25, 13))
            reduceButton.setImage(UIImage(named: "ic_jian"), forState: .Normal)
            addButton.setImage(UIImage(named: "ic_jia"), forState: .Normal)
            reduceButton.imageView?.contentMode = .Right
            addButton.imageView?.contentMode = .Left
            reduceButton.addTarget(self, action: #selector(self.reduceButtonAction), forControlEvents: .TouchUpInside)
            addButton.addTarget(self, action: #selector(self.addButtonAction), forControlEvents: .TouchUpInside)
            self.countLabel.frame = CGRectMake(WIDTH-60*px, 0, 30*px, 44*px)
            self.countLabel.font = MainFont
            self.countLabel.textAlignment = .Center
            if String(self.counts) != nil{
                self.countLabel.text = String(self.counts)
            }else{
                self.countLabel.text = "1"
            }
            
//            self.countLabel.backgroundColor = UIColor.redColor()
            cell.addSubview(addButton)
            cell.addSubview(reduceButton)
            cell.addSubview(self.countLabel)
        }

        cell.detailTextLabel?.font = MainFont
        cell.detailTextLabel?.textColor = MainTextBackColor
        if (self.type == "0"||self.type == "1")&&indexPath.section == 1&&indexPath.row == 0{
            cell.detailTextLabel?.text = "钟点工"+String(self.price)+"元／小时"
        }
        

        return cell
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let backHeaderView = UIView.init(frame: CGRectMake(0, 0, WIDTH, 30*px))
        backHeaderView.backgroundColor = LGBackColor
        let titleLabel = UILabel.init(frame: CGRectMake(10, 0, WIDTH-10, 30*px))
        titleLabel.backgroundColor = LGBackColor
        titleLabel.textColor = MainTextBackColor
        titleLabel.font = UIFont.systemFontOfSize(12)
        titleLabel.text = self.headerTextArray[section] as? String
        backHeaderView.addSubview(titleLabel)
        return backHeaderView
        
    }
    
    
    //MARK:--UIPickerViewDatasource
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 4
    }
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        switch component {
        case 0:
            if self.isToDay{
                return newTimeHoursTextArray.count
            }else{
                return timeHoursTextArray.count
            }
            
            
        case 1:
            return 1
            
        case 2:
            return self.halfHoursTextArray.count
            
        default:
            return 1
            
        }
        
    }
    
    //MARK:--UIPickerViewDelegate
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        switch component {
        case 0:
            if self.isToDay{
                return self.newTimeHoursTextArray[row]
            }else{
                return self.timeHoursTextArray[row]
            }
            
            
        case 1:
            return "时"
            
        case 2:
            return self.halfHoursTextArray[row]
            
        default:
            return "分"
            
        }
        
    }
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0{
            if self.isToDay{
                timeHoursStr = self.newTimeHoursTextArray[row]
            }else{
                timeHoursStr = self.timeHoursTextArray[row]
            }
            if timeHoursStr == "18"{
                self.halfHoursTextArray = ["00"]
            }else{
                self.halfHoursTextArray = ["00","30"]
            }
            self.timePickerView.reloadComponent(2)
            
            NSLOG(self.timeHoursTextArray[row])
        }else{
            halfHoursStr = self.halfHoursTextArray[row]
            NSLOG(self.halfHoursTextArray[row])
        }
        
    }
    
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
//        print(self.myTextView.isFirstResponder())
        self.myTextView.resignFirstResponder()
        
    }
    
    
    
    //MARK:ACTION
    //MARK:-------Action
    
    func dataPickerViewAction(sender:UIDatePicker){
        
        
        let date = sender.date
        weekDayLabel.text = self.weekdayArray[self.dateWeek(sender.date)]
        //实例化一个NSDateFormatter对象
        let dateFormatter = NSDateFormatter.init()
        //设定时间格式,这里可以设置成自己需要的格式
        dateFormatter.dateFormat = "yyyy-MM-dd EEE"
        
        self.briDateString1 = dateFormatter.stringFromDate(date)
        NSLOG(self.briDateString1)
        
    }
    
    func datePickerCancelButtonAction(){
        self.showEffectView()
    }
    
    func datePickerDetermineButtonAction(){
        
//        self.showEffectView()
        self.CreatTimePicker()
        self.view.addSubview(self.timePickerBackView)
        UIView.animateWithDuration(0.2, animations: {
            self.timePickerBackView.frame = CGRectMake(0, HEIGHT-64-320*px, WIDTH, 320*px)
        })
    }
    
    
    func timePickerCancelButtonAction(){
        self.showEffectView()
    }
    
    func timePickerDetermineButtonAction(){
        self.showEffectView()
        
        
        
        self.timeStr = (self.briDateString1 as String) +  "  " + self.timeHoursStr + ":" + self.halfHoursStr
        
            if cellTextArray[cellTextArray.count-2].last == "请选择下次服务时间"&&cellTextArray[cellTextArray.count-2].count == openDatePickerViewCount+1{
                if cellTextArray[cellTextArray.count-2].contains(self.timeStr){
                    Alert.shareManager.alert("请不要重复添加相同时间！", delegate: self)
                    return
                }
                cellTextArray[cellTextArray.count-2][cellTextArray[cellTextArray.count-2].count-1] =  self.timeStr
                cellTextArray[cellTextArray.count-2].append("请选择下次服务时间")
            }else{
                cellTextArray[cellTextArray.count-2][openDatePickerViewCount] =  self.timeStr
            }
        self.InvoiceTableView.reloadData()
        
        NSLOG(self.cellTextArray)
        
    }
    
    func goButtonAction(){
        self.makeAnAppointment()
    }
    
    func delButtonAction(sender:UIButton){
        self.cellTextArray[cellTextArray.count-2].removeAtIndex(sender.tag)
        self.InvoiceTableView.deleteRowsAtIndexPaths([NSIndexPath.init(forRow: sender.tag, inSection: cellTextArray.count-2)], withRowAnimation: .Right)
    }
    
    func addButtonAction(){
        if String(self.counts) != nil{
            self.countLabel.text = String(self.counts+1)
            self.counts = self.counts + 1
        }else{
            self.countLabel.text = "1"
            self.counts = 1
        }
        self.tatolMoenylabel.text = "    费用总计：" + String(format: "%.2f",self.price * Float(self.counts)) + "元"
        self.money = self.price * Float(self.counts)
    }
    func reduceButtonAction(){
        if String(self.counts) != nil&&self.counts>1{
            self.countLabel.text = String(self.counts-1)
            self.counts = self.counts - 1
        }else{
            self.countLabel.text = "1"
            self.counts = 1
            
        }
        self.tatolMoenylabel.text = "    费用总计：" + String(format: "%.2f",self.price * Float(self.counts)) + "元"
        self.money = self.price * Float(self.counts)
    }
    
    
//    func textViewShouldBeginEditing(textView: UITextView) -> Bool {
//        
//        if !textView.isFirstResponder(){
//            textView.becomeFirstResponder()
//        }
//        
//        
//        return true
//    }
    func textViewDidBeginEditing(textView: UITextView) {
        self.InvoiceTableView.contentOffset = CGPointMake(0,100)
//        self.InvoiceTableView.contentOffset = CGPointMake(<#T##x: CGFloat##CGFloat#>, <#T##y: CGFloat##CGFloat#>)
        
                if !self.myTextView.isFirstResponder(){
                    self.myTextView.becomeFirstResponder()
                }
    }
    //MARK:---TimeMAXMIN
    func DateSection(selectDays:Int)->NSDate{
        
        let dateFormatter = NSDateFormatter.init()
        //设定时间格式,这里可以设置成自己需要的格式
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let calendar = NSCalendar.init(calendarIdentifier:NSCalendarIdentifierGregorian)
        let adcomps = NSDateComponents.init()
        adcomps.setValue(selectDays, forComponent: .Day)
        let newdate = calendar?.dateByAddingComponents(adcomps, toDate: NSDate(), options: .WrapComponents)
        return newdate!
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
