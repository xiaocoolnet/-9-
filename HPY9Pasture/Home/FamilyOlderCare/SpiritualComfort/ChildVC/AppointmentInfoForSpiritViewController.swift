//
//  AppointmentInfoForSpiritViewController.swift
//  HPY9Pasture
//
//  Created by purepure on 17/3/3.
//  Copyright © 2017年 xiaocool. All rights reserved.
//

import UIKit

class AppointmentInfoForSpiritViewController: UIViewController,UITableViewDelegate,UITableViewDataSource ,UITextViewDelegate{
    let mytableView = UITableView()
    var headerView:SpiritualComfortChildVCTableViewCell!
    let textview = UITextView()
    let moneyLabel = UILabel()
    let textArray:Array<String> = ["手机号","性别","年龄","预约方式","预约时间"]
    var contentArray:Array<String> = ["","","","",""]
    let titleArray:Array<String> = ["预约信息","留言"]
    
    
    let dataPickerView = UIDatePicker()
    let datePickerBackView = UIView()
    var datePickerHeaderLabel = UILabel()
    var briDateString1 = String()
    
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

        //实例化一个NSDateFormatter对象
        let dateFormatter = NSDateFormatter.init()
        //设定时间格式,这里可以设置成自己需要的格式
        dateFormatter.dateFormat = "yyyy-MM-dd EEE HH:mm"
        
        self.briDateString1 = dateFormatter.stringFromDate(NSDate())
        self.view.backgroundColor = LGBackColor
        self.title = "预约信息"
        self.mytableView.frame = CGRectMake(0, 0, WIDTH, HEIGHT-64-50*px)
        self.mytableView.delegate = self
        self.mytableView.dataSource = self
        self.mytableView.backgroundColor = LGBackColor
        self.mytableView.sectionHeaderHeight = 20*px
        self.mytableView.separatorStyle = .None
       self.mytableView.registerNib(UINib(nibName: "RightArrowAndLabelTableViewCell",bundle: nil), forCellReuseIdentifier: "RightArrowAndLabelTableViewCell")
        self.view.addSubview(self.mytableView)
        
        
        self.headerView =  NSBundle.mainBundle().loadNibNamed("SpiritualComfortChildVCTableViewCell", owner: nil, options: nil).first as! SpiritualComfortChildVCTableViewCell
        self.headerView.frame = CGRectMake(0, 0, WIDTH, 85*px)

        headerView.HeaderImageView.backgroundColor = UIColor.redColor()
        headerView.name.text = "张宇"
        headerView.CreatUI(5)
        headerView.money.text = "350"+"元/小时"
        headerView.desLabel.text = "婚恋情感、亲子教育、心理障碍"
        headerView.goButton.hidden = true
        
        let backview = UIView.init(frame: self.headerView.frame)
        backview.backgroundColor = UIColor.clearColor()
        backview.addSubview(self.headerView)
        self.mytableView.tableHeaderView = backview
        
        
        let footBackView = UIView.init(frame: CGRectMake(0, 0, WIDTH, 180*px))
        footBackView.backgroundColor = LGBackColor
        self.textview.frame = CGRectMake(20*px, 0, WIDTH-40*px, 180*px)
        self.textview.layer.masksToBounds = true
        self.textview.layer.cornerRadius = 10*px
        self.textview.delegate = self
        self.textview.backgroundColor = UIColor.whiteColor()
        self.textview.textColor = MainTextBackColor
        self.textview.text = "(请留下您的要求)"
        self.textview.font = MainFont
        footBackView.addSubview(self.textview)
        self.mytableView.tableFooterView = footBackView
        
        moneyLabel.frame = CGRectMake(0, HEIGHT-64-50*px, WIDTH-100*px, 50*px)
        moneyLabel.textColor = RGBACOLOR(255, g: 172, b: 49, a: 1)
        moneyLabel.backgroundColor = UIColor.whiteColor()
        moneyLabel.font = MainFont
        moneyLabel.textAlignment = .Left
        moneyLabel.text = "  费用总计：50.00元"
        self.view.addSubview(moneyLabel)
        
        let appButton = UIButton.init(frame: CGRectMake(WIDTH-100*px, HEIGHT-64-50*px, 100*px, 50*px))
        appButton.backgroundColor = NavColor
        appButton.setTitle("立即预约", forState: .Normal)
        appButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        appButton.addTarget(self, action: #selector(self.AppButtonAction), forControlEvents: .TouchUpInside)
        appButton.titleLabel?.font = MainFont
        self.view.addSubview(appButton)

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
    
    //MARK: ------UITableViewDelegate
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        self.textview.resignFirstResponder()
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        return 44*px
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        switch indexPath.row {
        case 0:
            let vc = PublicTextEditViewController()
            vc.title = self.textArray[indexPath.row]
            vc.leftTextLabelText = self.textArray[indexPath.row]+":"
            vc.textField.keyboardType = .NumberPad
            vc.myFunc = {(editedText) ->Void in
                self.contentArray[indexPath.row] = editedText as String
                let index = NSIndexPath.init(forRow: indexPath.row, inSection: 0)
                self.mytableView.reloadRowsAtIndexPaths([index], withRowAnimation:.Automatic)
                vc.navigationController?.popViewControllerAnimated(true)
            }
            self.navigationController?.pushViewController(vc, animated: true)
            break
        case 1:
            let vc = PublicTableViewViewController()
            vc.myArray = ["男","女"]
            vc.title = self.textArray[indexPath.row]
            vc.myFunc = {(selectText,index) ->Void in
                self.contentArray[indexPath.row] = selectText as String
                let index = NSIndexPath.init(forRow: indexPath.row, inSection: 0)
                self.mytableView.reloadRowsAtIndexPaths([index], withRowAnimation:.Automatic)
                vc.navigationController?.popViewControllerAnimated(true)
            }
            self.navigationController?.pushViewController(vc, animated: true)
            break
        case 2:
            let vc = PublicTextEditViewController()
            vc.title = self.textArray[indexPath.row]
            vc.textField.keyboardType = .NumberPad
            vc.leftTextLabelText = self.textArray[indexPath.row]+":"
            vc.myFunc = {(editedText) ->Void in
                self.contentArray[indexPath.row] = editedText as String
                let index = NSIndexPath.init(forRow: indexPath.row, inSection: 0)
                self.mytableView.reloadRowsAtIndexPaths([index], withRowAnimation:.Automatic)
                vc.navigationController?.popViewControllerAnimated(true)
            }
            self.navigationController?.pushViewController(vc, animated: true)
            break
        case 3:
            let vc = PublicTableViewViewController()
            vc.myArray = ["上门服务","其他"]
            vc.title = self.textArray[indexPath.row]
            vc.myFunc = {(selectText,index) ->Void in
                self.contentArray[indexPath.row] = selectText as String
                let index = NSIndexPath.init(forRow: indexPath.row, inSection: 0)
                self.mytableView.reloadRowsAtIndexPaths([index], withRowAnimation:.Automatic)
                vc.navigationController?.popViewControllerAnimated(true)
            }
            self.navigationController?.pushViewController(vc, animated: true)
            break
        case 4:
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
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let viewBack = UIView.init(frame: CGRectMake(0, 0, WIDTH, 20*px))
        viewBack.backgroundColor = LGBackColor
        let titleLabel = UILabel.init(frame: CGRectMake(15*px, 0, WIDTH-15*px, 20*px))
        titleLabel.backgroundColor = LGBackColor
        titleLabel.font = MainFont
        titleLabel.textColor = MainTextBackColor
        titleLabel.text = self.titleArray[section]
        viewBack.addSubview(titleLabel)
        return viewBack
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if section == 0{
            return self.textArray.count
        }else{
           return 0
        }
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCellWithIdentifier("RightArrowAndLabelTableViewCell", forIndexPath: indexPath)as!RightArrowAndLabelTableViewCell
        cell.setUIWithDic(NSDictionary())
        cell.mainLabel.text = textArray[indexPath.row]
//        cell.mainLabel.font = MainFont
//        cell.lastLabel.font = UIFont.systemFontOfSize(12)
        cell.lastLabel.text = contentArray[indexPath.row]
        cell.accessoryType = .None
        cell.selectionStyle = .None
        
        return cell
    }
    
    
    //MARK: -----textViewDelegate
    
    func textViewDidBeginEditing(textView: UITextView) {
        self.mytableView.contentOffset = CGPointMake(0, 150)
        self.textview.becomeFirstResponder()
        if self.textview == textView {
            if textview.text ==  "(请留下您的要求)"{
                self.textview.text = ""
            }else{
                
            }
        }
        self.textview.textColor = UIColor.blackColor()
    }
    
    //MARK:------ACTION
    func AppButtonAction(){
        
    }
    func dataPickerViewAction(sender:UIDatePicker){
        
        
        let date = sender.date
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
        self.contentArray[4] = self.briDateString1
        self.mytableView.reloadRowsAtIndexPaths([NSIndexPath.init(forRow: 4, inSection: 0)], withRowAnimation: .Bottom)
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
