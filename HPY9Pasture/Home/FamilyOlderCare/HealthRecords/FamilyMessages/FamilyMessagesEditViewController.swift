//
//  FamilyMessagesEditViewController.swift
//  HPY9Pasture
//
//  Created by purepure on 16/12/22.
//  Copyright © 2016年 xiaocool. All rights reserved.
//

import UIKit

class FamilyMessagesEditViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    let myTableView = UITableView()
    let textArray = ["序号","家属姓名","关系","性别","出生日期","民族","婚姻状况","证件类型","证件号码","所属机构","户口所在地","现住址","联系方式","备注"]
    var lastText = ["","","","","","","","","","","","","",""]
    
    let rightButton = UIButton()
    
    let dataPickerView = UIDatePicker()
    let datePickerBackView = UIView()
    var datePickerHeaderLabel = UILabel()
    var briDateString = String()//生日
    var briDateString1 = String()//时间选择器日期
    
    
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

        
        myTableView.delegate = self
        myTableView.dataSource = self
        myTableView.backgroundColor = LGBackColor
        myTableView.frame = CGRectMake(0, 0, WIDTH, HEIGHT-64)
        myTableView.separatorStyle = .None
        self.myTableView.registerNib(UINib(nibName: "RightArrowAndLabelTableViewCell",bundle: nil), forCellReuseIdentifier: "RightArrowAndLabelTableViewCell")
        
        self.rightButton.frame = CGRectMake(0, 0, 50*px, 70*px)
        self.rightButton.titleLabel?.font = MainFont
        self.rightButton.setTitle("确定", forState: .Normal)
        self.rightButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        self.rightButton.addTarget(self, action: #selector(self.rightButtonAction), forControlEvents: .TouchUpInside)
        self.rightButton.userInteractionEnabled = false
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: self.rightButton)
        self.view.addSubview(myTableView)
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
    
    
    
    //创建时间选择器
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
        
        
        self.dataPickerView.frame = CGRectMake(0, 50*px, WIDTH, 200*px)
        self.dataPickerView.datePickerMode = .Date
        self.dataPickerView.backgroundColor = UIColor.whiteColor()
        self.dataPickerView.addTarget(self, action: #selector(self.dataPickerViewAction(_:)), forControlEvents: .ValueChanged)
        //实例化一个NSDateFormatter对象
        let dateFormatter = NSDateFormatter.init()
        //设定时间格式,这里可以设置成自己需要的格式
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date1 = dateFormatter.dateFromString("1900-01-01")
        
        self.dataPickerView.maximumDate = NSDate()
        self.dataPickerView.minimumDate = date1
        
        
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
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        
        
        return 38
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        switch indexPath.row {
        case 0:
            
            let vc = PublicTextEditViewController()
            vc.title = self.textArray[indexPath.row]
            vc.leftTextLabelText = self.textArray[indexPath.row]+":"
            vc.myFunc = {(editedText) ->Void in
                self.lastText[indexPath.row] = editedText as String
                let index = NSIndexPath.init(forRow: indexPath.row, inSection: 0)
                self.myTableView.reloadRowsAtIndexPaths([index], withRowAnimation:.Automatic)
                vc.navigationController?.popViewControllerAnimated(true)
            }
            self.navigationController?.pushViewController(vc, animated: true)
            
            break
        case 1:
            let vc = PublicTextEditViewController()
            vc.title = self.textArray[indexPath.row]
            vc.leftTextLabelText = self.textArray[indexPath.row]+":"
            vc.myFunc = {(editedText) ->Void in
                self.lastText[indexPath.row] = editedText as String
                let index = NSIndexPath.init(forRow: indexPath.row, inSection: 0)
                self.myTableView.reloadRowsAtIndexPaths([index], withRowAnimation:.Automatic)
                vc.navigationController?.popViewControllerAnimated(true)
            }
            self.navigationController?.pushViewController(vc, animated: true)
            break
        case 2:
            let vc = PublicTextEditViewController()
            vc.title = self.textArray[indexPath.row]
            vc.leftTextLabelText = self.textArray[indexPath.row]+":"
            vc.myFunc = {(editedText) ->Void in
                self.lastText[indexPath.row] = editedText as String
                let index = NSIndexPath.init(forRow: indexPath.row, inSection: 0)
                self.myTableView.reloadRowsAtIndexPaths([index], withRowAnimation:.Automatic)
                vc.navigationController?.popViewControllerAnimated(true)
            }
            self.navigationController?.pushViewController(vc, animated: true)
            break
        case 3:
            let vc = PublicTableViewViewController()
            vc.myArray = ["男","女"]
            vc.title = self.textArray[indexPath.row]
            vc.myFunc = {(selectText,index) ->Void in
                self.lastText[indexPath.row] = selectText
                let index = NSIndexPath.init(forRow: indexPath.row, inSection: 0)
                self.myTableView.reloadRowsAtIndexPaths([index], withRowAnimation:.Automatic)
                vc.navigationController?.popViewControllerAnimated(true)
            }
            self.navigationController?.pushViewController(vc, animated: true)
            break
        case 4:
            self.showEffectView()
            self.CreatDataPicker()
            self.view.addSubview(self.datePickerBackView)
            UIView.animateWithDuration(0.2, animations: {
                self.datePickerBackView.frame = CGRectMake(0, HEIGHT-64-320*px, WIDTH, 320*px)
            })
            break
        case 5:
            let vc = PublicTableViewViewController()
            vc.title = "选择民族"
            let content = NSData(contentsOfURL:NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("民族——nations", ofType: "json")!) )
            var datasource = NSMutableArray()
            do{
                try datasource =  NSJSONSerialization.JSONObjectWithData(content!, options: NSJSONReadingOptions.MutableLeaves) as! NSMutableArray
            }catch{
                
            }
            
            vc.nationArray = datasource
            vc.myFunc = {(selectText,index) ->Void in
                self.lastText[indexPath.row] = selectText
                let index = NSIndexPath.init(forRow: indexPath.row, inSection: 0)
                self.myTableView.reloadRowsAtIndexPaths([index], withRowAnimation:.Automatic)
                vc.navigationController?.popViewControllerAnimated(true)
            }
            
            self.navigationController?.pushViewController(vc, animated: true)
            break
        case 6:
            let vc = PublicTableViewViewController()
            vc.myArray = ["未婚","已婚","离异"]
            vc.title = self.textArray[indexPath.row]
            vc.myFunc = {(selectText,index) ->Void in
                self.lastText[indexPath.row] = selectText
                let index = NSIndexPath.init(forRow: indexPath.row, inSection: 0)
                self.myTableView.reloadRowsAtIndexPaths([index], withRowAnimation:.Automatic)
                vc.navigationController?.popViewControllerAnimated(true)
            }
            self.navigationController?.pushViewController(vc, animated: true)
            break
        case 7:
            let vc = PublicTableViewViewController()
            vc.myArray = ["身份证","护照","其他"]
            vc.title = self.textArray[indexPath.row]
            vc.myFunc = {(selectText,index) ->Void in
                self.lastText[indexPath.row] = selectText
                let index = NSIndexPath.init(forRow: indexPath.row, inSection: 0)
                self.myTableView.reloadRowsAtIndexPaths([index], withRowAnimation:.Automatic)
                vc.navigationController?.popViewControllerAnimated(true)
            }
            self.navigationController?.pushViewController(vc, animated: true)
            break

        case 8:
            let vc = PublicTextEditViewController()
            vc.title = self.textArray[indexPath.row]
            vc.leftTextLabelText = self.textArray[indexPath.row]+":"
            vc.myFunc = {(editedText) ->Void in
                self.lastText[indexPath.row] = editedText as String
                let index = NSIndexPath.init(forRow: indexPath.row, inSection: 0)
                self.myTableView.reloadRowsAtIndexPaths([index], withRowAnimation:.Automatic)
                vc.navigationController?.popViewControllerAnimated(true)
            }
            self.navigationController?.pushViewController(vc, animated: true)
            break

        case 9:
            let vc = PublicTextEditViewController()
            vc.title = self.textArray[indexPath.row]
            vc.leftTextLabelText = self.textArray[indexPath.row]+":"
            vc.myFunc = {(editedText) ->Void in
                self.lastText[indexPath.row] = editedText as String
                let index = NSIndexPath.init(forRow: indexPath.row, inSection: 0)
                self.myTableView.reloadRowsAtIndexPaths([index], withRowAnimation:.Automatic)
                vc.navigationController?.popViewControllerAnimated(true)
            }
            self.navigationController?.pushViewController(vc, animated: true)
            break
        case 10:
            let vc = PublicTextEditViewController()
            vc.title = self.textArray[indexPath.row]
            vc.leftTextLabelText = self.textArray[indexPath.row]+":"
            vc.myFunc = {(editedText) ->Void in
                self.lastText[indexPath.row] = editedText as String
                let index = NSIndexPath.init(forRow: indexPath.row, inSection: 0)
                self.myTableView.reloadRowsAtIndexPaths([index], withRowAnimation:.Automatic)
                vc.navigationController?.popViewControllerAnimated(true)
            }
            self.navigationController?.pushViewController(vc, animated: true)
            break
        case 11:
            let vc = PublicTextEditViewController()
            vc.title = self.textArray[indexPath.row]
            vc.leftTextLabelText = self.textArray[indexPath.row]+":"
            vc.myFunc = {(editedText) ->Void in
                self.lastText[indexPath.row] = editedText as String
                let index = NSIndexPath.init(forRow: indexPath.row, inSection: 0)
                self.myTableView.reloadRowsAtIndexPaths([index], withRowAnimation:.Automatic)
                vc.navigationController?.popViewControllerAnimated(true)
            }
            self.navigationController?.pushViewController(vc, animated: true)
            break
        case 12:
            let vc = PublicTextEditViewController()
            vc.title = self.textArray[indexPath.row]
            vc.leftTextLabelText = self.textArray[indexPath.row]+":"
            vc.myFunc = {(editedText) ->Void in
                self.lastText[indexPath.row] = editedText as String
                let index = NSIndexPath.init(forRow: indexPath.row, inSection: 0)
                self.myTableView.reloadRowsAtIndexPaths([index], withRowAnimation:.Automatic)
                vc.navigationController?.popViewControllerAnimated(true)
            }
            self.navigationController?.pushViewController(vc, animated: true)
            break
        case 13:
            let vc = PublicTextEditViewController()
            vc.title = self.textArray[indexPath.row]
            vc.leftTextLabelText = self.textArray[indexPath.row]+":"
            vc.myFunc = {(editedText) ->Void in
                self.lastText[indexPath.row] = editedText as String
                let index = NSIndexPath.init(forRow: indexPath.row, inSection: 0)
                self.myTableView.reloadRowsAtIndexPaths([index], withRowAnimation:.Automatic)
                vc.navigationController?.popViewControllerAnimated(true)
            }
            self.navigationController?.pushViewController(vc, animated: true)
            break

        default:
            break
        }

    }
    
    //MARK: ------TableViewDatasource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        return self.textArray.count
        
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        
        let cell3 = tableView.dequeueReusableCellWithIdentifier("RightArrowAndLabelTableViewCell", forIndexPath: indexPath)as!RightArrowAndLabelTableViewCell
        cell3.setUIWithDic(NSDictionary())
        cell3.selectionStyle = .None
        cell3.mainLabel.text = self.textArray[indexPath.row]
        cell3.lastLabel.text = self.lastText[indexPath.row]
        cell3.lastLabel.hidden = false
        return cell3
        
        
    }
    
    //MARK:-------ACTION 
    
    func rightButtonAction(){
        
    }
    
    
    func dataPickerViewAction(sender:UIDatePicker){
        let date = sender.date
        //实例化一个NSDateFormatter对象
        let dateFormatter = NSDateFormatter.init()
        //设定时间格式,这里可以设置成自己需要的格式
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        self.briDateString1 = dateFormatter.stringFromDate(date)
        
        
    }
    
    func datePickerCancelButtonAction(){
        self.showEffectView()
    }
    
    func datePickerDetermineButtonAction(){
        
//        self.briDateString = self.briDateString1
        self.lastText[4] = self.briDateString1
        self.showEffectView()
        let index = NSIndexPath.init(forRow: 4, inSection: 0)
        self.myTableView.reloadRowsAtIndexPaths([index], withRowAnimation:.Automatic)
        
        
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
