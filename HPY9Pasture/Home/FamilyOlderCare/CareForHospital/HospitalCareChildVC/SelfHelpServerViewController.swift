//
//  SelfHelpServerViewController.swift
//  HPY9Pasture
//
//  Created by purepure on 17/2/27.
//  Copyright © 2017年 xiaocool. All rights reserved.
//

import UIKit
import SwiftyJSON
typealias infoBack = (info:NSMutableDictionary)->Void

class SelfHelpServerViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextViewDelegate {
    
    var backFunc = infoBack?()
    
    var isButton = Bool()
    
    let textview = UITextView()
    let selfHelpServerTableView = UITableView()
    
    let dataPickerView = UIDatePicker()
    let datePickerBackView = UIView()
    var datePickerHeaderLabel = UILabel()
//    var weekDayLabel = UILabel()
    var briDateString1 = String()
    var moneyLabel = UILabel()
    var adressinfo:addressInfo?
    var hisAdress:BMKPoiInfo?
    
    
    
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
    
    var userinfo:Array<JSON> = []
    let textArray : Array<Array<String>> = [["被陪护人员姓名","家庭地址","电话","备用联系人电话"],["所在医院","医院地址","医院科室病房"],["2小时"],["开始时间"],[""]]
    let titleArray = ["","","陪诊时长","选择开始时间","服务说明"]
    var weekdayArray = ["星期日","星期一","星期二","星期三","星期四","星期五","星期六"]
    var rightTextArray : Array<Array<String>> = [["","","",""],["","",""],[""],[""],[""]]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //实例化一个NSDateFormatter对象
        let dateFormatter = NSDateFormatter.init()
        //设定时间格式,这里可以设置成自己需要的格式
        dateFormatter.dateFormat = "yyyy-MM-dd EEE HH:mm"
        
        self.briDateString1 = dateFormatter.stringFromDate(NSDate())
        self.rightTextArray[3][0] = self.briDateString1
        self.view.backgroundColor = LGBackColor
        
        selfHelpServerTableView.delegate = self
        selfHelpServerTableView.dataSource = self
        selfHelpServerTableView.backgroundColor = LGBackColor
        selfHelpServerTableView.frame = CGRectMake(0, 0, WIDTH, HEIGHT-64-44*px-50*px)
        selfHelpServerTableView.separatorStyle = .None
        self.selfHelpServerTableView.registerNib(UINib(nibName: "RightArrowAndLabelTableViewCell",bundle: nil), forCellReuseIdentifier: "RightArrowAndLabelTableViewCell")
        self.view.addSubview(selfHelpServerTableView)
        //服务说明
        
        if isButton{
            selfHelpServerTableView.frame = CGRectMake(0, 10*px, WIDTH, HEIGHT-74)
            let footBackView = UIView.init(frame: CGRectMake(0, 0, WIDTH, 250*px))
            footBackView.backgroundColor = LGBackColor
            self.textview.frame = CGRectMake(20*px, 0, WIDTH-40*px, 180*px)
            self.textview.layer.masksToBounds = true
            self.textview.layer.cornerRadius = 10*px
            self.textview.backgroundColor = UIColor.whiteColor()
            self.textview.textColor = MainTextBackColor
            self.textview.text = "(请填写)"
            self.textview.font = MainFont
            footBackView.addSubview(self.textview)
            
            let goButton = UIButton.init(frame: CGRectMake(40*px, 200*px, WIDTH-80*px, 35*px))
            goButton.backgroundColor = NavColor
            goButton.setTitle("确定", forState: .Normal)
            goButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
            goButton.titleLabel?.font = MainFont
            goButton.addTarget(self, action: #selector(self.goButtonAction), forControlEvents: .TouchUpInside)
            goButton.layer.masksToBounds = true
            goButton.layer.cornerRadius = 10
            footBackView.addSubview(goButton)
            self.selfHelpServerTableView.tableFooterView = footBackView

        }else{
            let footBackView = UIView.init(frame: CGRectMake(0, 0, WIDTH, 180*px))
            footBackView.backgroundColor = LGBackColor
            self.textview.frame = CGRectMake(20*px, 0, WIDTH-40*px, 180*px)
            self.textview.layer.masksToBounds = true
            self.textview.layer.cornerRadius = 10*px
            self.textview.backgroundColor = UIColor.whiteColor()
            self.textview.textColor = MainTextBackColor
            self.textview.text = "(请填写)"
            self.textview.delegate = self
            self.textview.font = MainFont
            footBackView.addSubview(self.textview)
            self.selfHelpServerTableView.tableFooterView = footBackView
            
            moneyLabel = UILabel.init(frame: CGRectMake(0, HEIGHT-114*px-53*px, WIDTH-100*px, 50*px))
            moneyLabel.textColor = RGBACOLOR(255, g: 172, b: 49, a: 1)
            moneyLabel.backgroundColor = UIColor.whiteColor()
            moneyLabel.font = MainFont
            moneyLabel.textAlignment = .Left
            moneyLabel.text = "  服务费用：50.00元/次"
            self.view.addSubview(moneyLabel)
            
            let appButton = UIButton.init(frame: CGRectMake(WIDTH-100*px, HEIGHT-114*px-53*px, 100*px, 50*px))
            appButton.backgroundColor = NavColor
            appButton.setTitle("一键预约", forState: .Normal)
            appButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
            appButton.addTarget(self, action: #selector(self.AppButtonAction), forControlEvents: .TouchUpInside)
            appButton.titleLabel?.font = MainFont
            self.view.addSubview(appButton)

        }
        
        
        
        
        
        
        


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
    
    
    //MARK:------tableView滑动
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        self.textview.resignFirstResponder()
    }
    
    
    //MARK: ------UITableViewDelegate
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        if indexPath.section == 4&&indexPath.row == 0{
            return 0
        }
        return 44*px
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        self.textview.resignFirstResponder()
        switch indexPath.section {
            
        case 0:
            switch indexPath.row {
            case 0:
                let vc = PublicTextEditViewController()
                vc.title = self.textArray[indexPath.section][indexPath.row]
                vc.leftTextLabelText = self.textArray[indexPath.section][indexPath.row]+":"
                vc.myFunc = {(editedText) ->Void in
                    self.rightTextArray[indexPath.section][indexPath.row] = editedText as String
                self.selfHelpServerTableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation:.Automatic)
                    vc.navigationController?.popViewControllerAnimated(true)
                }
                self.navigationController?.pushViewController(vc, animated: true)
                break
            case 1:
                let vc = AdressEditViewController()
                vc.isselected = true
                vc.addressBlock = {(adressinfo) -> Void in
                    self.adressinfo = adressinfo
                    self.rightTextArray[indexPath.section][indexPath.row] = adressinfo.adress
                    self.selfHelpServerTableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation:.Automatic)
                    vc.navigationController?.popViewControllerAnimated(true)
                }
                self.navigationController?.pushViewController(vc, animated: true)
                break
            case 2:
                let vc = PublicTextEditViewController()
                vc.title = self.textArray[indexPath.section][indexPath.row]
                vc.leftTextLabelText = self.textArray[indexPath.section][indexPath.row]+":"
                vc.textField.keyboardType = .NumberPad
                vc.myFunc = {(editedText) ->Void in
                    self.rightTextArray[indexPath.section][indexPath.row] = editedText as String
                self.selfHelpServerTableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation:.Automatic)
                    vc.navigationController?.popViewControllerAnimated(true)
                }
                self.navigationController?.pushViewController(vc, animated: true)
                break
            case 3:
                let vc = PublicTextEditViewController()
                vc.title = self.textArray[indexPath.section][indexPath.row]
                vc.leftTextLabelText = self.textArray[indexPath.section][indexPath.row]+":"
                vc.textField.keyboardType = .NumberPad
                vc.myFunc = {(editedText) ->Void in
                    self.rightTextArray[indexPath.section][indexPath.row] = editedText as String
                    self.selfHelpServerTableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation:.Automatic)
                    vc.navigationController?.popViewControllerAnimated(true)
                }
                self.navigationController?.pushViewController(vc, animated: true)
                break
            default:
                
                break
            }
        case 1:
            switch indexPath.row {
            case 0:
                let vc = PublicTextEditViewController()
                vc.title = self.textArray[indexPath.section][indexPath.row]
                vc.leftTextLabelText = self.textArray[indexPath.section][indexPath.row]+":"
                vc.myFunc = {(editedText) ->Void in
                    self.rightTextArray[indexPath.section][indexPath.row] = editedText as String
                    self.selfHelpServerTableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation:.Automatic)
                    vc.navigationController?.popViewControllerAnimated(true)
                }
                self.navigationController?.pushViewController(vc, animated: true)
                break
            case 1:
                let homeCareViewController = MapSelectViewController()
                homeCareViewController.mapBlock = {(mapInfo) ->Void in
                    self.hisAdress = mapInfo
                    self.rightTextArray[indexPath.section][indexPath.row] = (self.hisAdress?.address)!
                    self.selfHelpServerTableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation:.Automatic)
                    
                }
                self.navigationController?.pushViewController(homeCareViewController, animated: true)
                break
            case 2:
                
                let vc = PublicTextEditViewController()
                vc.title = self.textArray[indexPath.section][indexPath.row]
                vc.leftTextLabelText = self.textArray[indexPath.section][indexPath.row]+":"
                vc.myFunc = {(editedText) ->Void in
                    self.rightTextArray[indexPath.section][indexPath.row] = editedText as String
                    self.selfHelpServerTableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation:.Automatic)
                    vc.navigationController?.popViewControllerAnimated(true)
                }
                self.navigationController?.pushViewController(vc, animated: true)
                break
            
            default:
                
                break
            }
            
        case 2:
            break
        case 3:
            if self.datePickerBackView.superview == nil{
                self.CreatDataPicker()
            }
            self.showEffectView()
            self.view.addSubview(self.datePickerBackView)
            UIView.animateWithDuration(0.2, animations: {
                self.datePickerBackView.frame = CGRectMake(0, HEIGHT-64-320*px-40*px, WIDTH, 320*px)
            })
            break
        default:
            break
        }
    }
    //MARK: ------TableViewDatasource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return textArray[section].count
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return textArray.count
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 1{
            return 10*px
        }else if section == 0{
            return 0
        }else{
            return 20*px
        }
    }
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0||section == 1{
            let backview = UILabel.init(frame: CGRectMake(0, 0, WIDTH, 10*px))
            backview.backgroundColor = LGBackColor
            return backview
        }else{
            let backview = UILabel.init(frame: CGRectMake(0, 0, WIDTH, 20*px))
            backview.backgroundColor = LGBackColor
            backview.font = UIFont.systemFontOfSize(12)
            backview.text = titleArray[section]
            backview.textColor = MainTextBackColor
            backview.textAlignment = .Left
            return backview
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        
        let cell2 = tableView.dequeueReusableCellWithIdentifier("RightArrowAndLabelTableViewCell", forIndexPath: indexPath)as!RightArrowAndLabelTableViewCell
        cell2.setUIWithDic(NSDictionary())
        cell2.selectionStyle = .None
        cell2.accessoryType = .None
        cell2.mainLabel.text = self.textArray[indexPath.section][indexPath.row]
        cell2.lastLabel.text = self.rightTextArray[indexPath.section][indexPath.row]
        
        return cell2

        
    }
    
    
    //MARK: -----textViewDelegate
    
    func textViewDidBeginEditing(textView: UITextView) {
        self.selfHelpServerTableView.contentOffset = CGPointMake(0, 300)
        self.textview.becomeFirstResponder()
        if self.textview == textView {
            if textview.text ==  "(请填写)"{
                self.textview.text = ""
            }else{
                
            }
        }
        self.textview.textColor = UIColor.blackColor()
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
        
    }
    
    func goButtonAction(){
        self.backFunc!(info: ["name":"钱国","hos":"烟台毓璜顶医院","phone":"13254187451","otherPhone":"1548942367","hisAdress":"烟台市芝罘区青年南路468号","adress":"烟台市芝罘区青年南路468号","time":"2017.3.8 周三 10.00","longtime":"共3天"]);
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func AppButtonAction(){
        
    }
    
    func datePickerCancelButtonAction(){
        self.showEffectView()
    }
    
    func datePickerDetermineButtonAction(){
        self.showEffectView()
        self.rightTextArray[3][0] = self.briDateString1
        self.selfHelpServerTableView.reloadRowsAtIndexPaths([NSIndexPath.init(forRow: 0, inSection: 3)], withRowAnimation: .Bottom)
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
