//
//  PersonalMessagesRecordsViewController.swift
//  HPY9Pasture
//
//  Created by purepure on 16/12/21.
//  Copyright © 2016年 xiaocool. All rights reserved.
//

import UIKit

class PersonalMessagesRecordsViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    let myTableView = UITableView()
    let textArray = [["照片","人员编号","姓名","性别","出生日期","联系电话"],["户口类型","住址","身份证","身份证有效期"],["民族","是否党员","婚否"],["医疗保险类型","以往病史","自动病种归类"]]
    var headerImage = UIImage() //头像
    
    var sexStr = String()//性别
    var addressStr = String()//住址
    var isPartyMember = String()//是否党员
    var isMarry = String()//婚否
    
    var dateSign = String() //时间选择器状态 ‘0’——出生日期 ‘1’——身份证有效期（早）‘2’——身份证有效期（晚）
    
    var earDate = NSDate()//表示身份证有效期（早）的日期作为身份证有效期（晚）选择时间时的最小时间
    
    
    let dataPickerView = UIDatePicker()
    let datePickerBackView = UIView()
    var datePickerHeaderLabel = UILabel()
    
    
    var IDDateString = String()//身份证有效期
    var IDDateString1 = String()//身份证有效期（早）
    var IDDateString2 = String() //身份证有效期（晚）
    
    var briDateString = String()//生日
    var briDateString1 = String()//时间选择器日期
    
    var idNumStr = String()//身份证号
    var myNationStr = String()
    
    
    
    
    
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
        self.title = "个人信息"
        dateSign = "0"
        myTableView.delegate = self
        myTableView.dataSource = self
        myTableView.backgroundColor = LGBackColor
        myTableView.frame = CGRectMake(0, 0, WIDTH, HEIGHT-64)
        myTableView.separatorStyle = .None
        myTableView.sectionFooterHeight = 10*px
        self.myTableView.registerNib(UINib(nibName: "HeaderPhotoTableViewCell",bundle: nil), forCellReuseIdentifier: "HeaderPhotoTableViewCell")
        self.myTableView.registerNib(UINib(nibName: "DoubleLabelTableViewCell",bundle: nil), forCellReuseIdentifier: "DoubleLabelTableViewCell")
        self.myTableView.registerNib(UINib(nibName: "RightArrowAndLabelTableViewCell",bundle: nil), forCellReuseIdentifier: "RightArrowAndLabelTableViewCell")
        self.view.addSubview(myTableView)
//        self.CreatDataPicker()

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
        if dateSign == "0" {
            datePickerHeaderLabel.text = "日期选择"
        }else if dateSign == "1"{
            datePickerHeaderLabel.text = "身份证有效期（早）"
        }else {
            datePickerHeaderLabel.text = "身份证有效期（晚）"
        }
        
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
        let date2 = dateFormatter.dateFromString("2200-01-01")
        if self.dateSign == "0" {
            self.dataPickerView.maximumDate = NSDate()
            self.dataPickerView.minimumDate = date1
        }else if self.dateSign == "1"{
            self.dataPickerView.maximumDate = NSDate()
            self.dataPickerView.minimumDate = date1
        }else{
            self.dataPickerView.minimumDate = earDate
            self.dataPickerView.maximumDate = date2
        }
        
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
        if self.dateSign == "1" {
            datePickerDetermineButton.setTitle("下一步", forState: .Normal)
        }else{
            datePickerDetermineButton.setTitle("确定", forState: .Normal)
        }
        
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
        
        if indexPath.section == 0 && indexPath.row == 0{
            return 51
        }else{
            return 38
        }
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        
        if indexPath.section == 0 {
            switch indexPath.row {
            case 0:
                self.uploadImage()
                break
            case 3:
                let vc = PublicTableViewViewController()
                vc.myArray = ["男","女"]
                vc.title = self.textArray[indexPath.section][indexPath.row]
                vc.myFunc = {(selectText) ->Void in
                    self.sexStr = selectText
                    self.myTableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation:.Automatic)
                }
                self.navigationController?.pushViewController(vc, animated: true)
                break
            case 4:
                self.dateSign = "0"
                self.showEffectView()
                self.CreatDataPicker()
                self.view.addSubview(self.datePickerBackView)
                UIView.animateWithDuration(0.2, animations: {
                   self.datePickerBackView.frame = CGRectMake(0, HEIGHT-64-320*px, WIDTH, 320*px)
                })
                
                
                break
            default:
                break
            }
        }else if indexPath.section == 1{
            switch indexPath.row {
            case 1:
                let vc = PublicTextEditViewController()
                vc.title = "编辑住址"
                vc.leftTextLabelText = "地址:"
                vc.myFunc = {(editedText) ->Void in
                    self.addressStr = editedText as String
                    let index = NSIndexPath.init(forRow: 1, inSection: 1)
                    self.myTableView.reloadRowsAtIndexPaths([index], withRowAnimation:.Automatic)
                }
                self.navigationController?.pushViewController(vc, animated: true)
                break
            case 2:
                let vc = PublicTextEditViewController()
                vc.title = "编辑身份证"
                vc.leftTextLabelText = "身份证:"
                vc.myFunc = {(editedText) ->Void in
                    self.idNumStr = editedText as String
                    let index = NSIndexPath.init(forRow: 2, inSection: 1)
                    self.myTableView.reloadRowsAtIndexPaths([index], withRowAnimation:.Automatic)
                }
                
                self.navigationController?.pushViewController(vc, animated: true)
                break
            case 3:
                self.dateSign = "1"
                self.showEffectView()
                self.CreatDataPicker()
                self.view.addSubview(self.datePickerBackView)
                UIView.animateWithDuration(0.2, animations: {
                    self.datePickerBackView.frame = CGRectMake(0, HEIGHT-64-320*px, WIDTH, 320*px)
                })
                
                break
            default:
                break
            }
        }else if indexPath.section == 2{
            switch indexPath.row {
            case 0:
                let vc = PublicTableViewViewController()
                vc.title = "选择民族"
                let content = NSData(contentsOfURL:NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("民族——nations", ofType: "json")!) )
                var datasource = NSMutableArray()
                do{
                    try datasource =  NSJSONSerialization.JSONObjectWithData(content!, options: NSJSONReadingOptions.MutableLeaves) as! NSMutableArray
                }catch{
                    
                }
                
                vc.nationArray = datasource
                vc.myFunc = {(selectText) ->Void in
                    self.myNationStr = selectText
                    let index = NSIndexPath.init(forRow: 0, inSection: 2)
                    self.myTableView.reloadRowsAtIndexPaths([index], withRowAnimation:.Automatic)
                }

                
                self.navigationController?.pushViewController(vc, animated: true)
                break
            case 1:
                let vc = PublicTableViewViewController()
                vc.title = "是否党员"
                vc.myArray = ["是党员","不是党员","预备党员"]
                vc.myFunc = {(selectText) ->Void in
                    self.isPartyMember = selectText
                    let index = NSIndexPath.init(forRow: 1, inSection: 2)
                    self.myTableView.reloadRowsAtIndexPaths([index], withRowAnimation:.Automatic)
                }
                self.navigationController?.pushViewController(vc, animated: true)
                break
            case 2:
                let vc = PublicTableViewViewController()
                vc.title = "婚否"
                vc.myArray = ["未婚","已婚","离异"]
                vc.myFunc = {(selectText) ->Void in
                    self.isMarry = selectText
                    let index = NSIndexPath.init(forRow: 2, inSection: 2)
                    self.myTableView.reloadRowsAtIndexPaths([index], withRowAnimation:.Automatic)
                }
                self.navigationController?.pushViewController(vc, animated: true)
                break
                
            default:
                break
            }
        }

        
    }
    
    
    //MARK: ------TableViewDatasource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        return self.textArray[section].count
        
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.textArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        
        
        
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                let cell1 = tableView.dequeueReusableCellWithIdentifier("HeaderPhotoTableViewCell", forIndexPath: indexPath)as!HeaderPhotoTableViewCell
                cell1.setUIWithDic(NSDictionary())
                cell1.headerImageView.image = self.headerImage
                cell1.selectionStyle = .None
                cell1.mainLabel.text = self.textArray[indexPath.section][indexPath.row]
                return cell1
                
            }else if indexPath.row == 1{
                let cell2 = tableView.dequeueReusableCellWithIdentifier("DoubleLabelTableViewCell", forIndexPath: indexPath)as!DoubleLabelTableViewCell
                cell2.setUIWithDic(NSDictionary())
                cell2.selectionStyle = .None
                cell2.mainLabel.text = self.textArray[indexPath.section][indexPath.row]
                return cell2
            }else if indexPath.row == 2{
                let cell2 = tableView.dequeueReusableCellWithIdentifier("DoubleLabelTableViewCell", forIndexPath: indexPath)as!DoubleLabelTableViewCell
                cell2.setUIWithDic(NSDictionary())
                cell2.selectionStyle = .None
                cell2.mainLabel.text = self.textArray[indexPath.section][indexPath.row]
                return cell2
            }else if indexPath.row == 3{
                let cell3 = tableView.dequeueReusableCellWithIdentifier("RightArrowAndLabelTableViewCell", forIndexPath: indexPath)as!RightArrowAndLabelTableViewCell
                cell3.setUIWithDic(NSDictionary())
                cell3.lastLabel.text = self.sexStr;
                cell3.selectionStyle = .None
                cell3.mainLabel.text = self.textArray[indexPath.section][indexPath.row]
                cell3.lastLabel.hidden = false
                return cell3
            }else if indexPath.row == 4{
                let cell3 = tableView.dequeueReusableCellWithIdentifier("RightArrowAndLabelTableViewCell", forIndexPath: indexPath)as!RightArrowAndLabelTableViewCell
                cell3.setUIWithDic(NSDictionary())
                cell3.selectionStyle = .None
                cell3.mainLabel.text = self.textArray[indexPath.section][indexPath.row]
                cell3.lastLabel.text = self.briDateString
                cell3.lastLabel.hidden = false
                return cell3
            }else {
                let cell2 = tableView.dequeueReusableCellWithIdentifier("DoubleLabelTableViewCell", forIndexPath: indexPath)as!DoubleLabelTableViewCell
                cell2.selectionStyle = .None
                cell2.setUIWithDic(NSDictionary())
                cell2.mainLabel.text = self.textArray[indexPath.section][indexPath.row]
                
                return cell2
            }
        }else if indexPath.section == 1{
            let cell3 = tableView.dequeueReusableCellWithIdentifier("RightArrowAndLabelTableViewCell", forIndexPath: indexPath)as!RightArrowAndLabelTableViewCell
            cell3.setUIWithDic(NSDictionary())
            cell3.selectionStyle = .None
            if indexPath.row == 2 {
                cell3.lastLabel.text = idNumStr
            }else if indexPath.row == 3{
                cell3.lastLabel.text = IDDateString
            }else if indexPath.row == 1{
                cell3.lastLabel.text = addressStr
            }
            cell3.mainLabel.text = self.textArray[indexPath.section][indexPath.row]
            cell3.lastLabel.hidden = false
            return cell3
//            switch indexPath.row {
//            case 0:
//                break
//            case 1:
//                break
//            case 2:
//                break
//            default:
//                break
//            }
        }else if indexPath.section == 2{
            let cell3 = tableView.dequeueReusableCellWithIdentifier("RightArrowAndLabelTableViewCell", forIndexPath: indexPath)as!RightArrowAndLabelTableViewCell
            cell3.setUIWithDic(NSDictionary())
            cell3.selectionStyle = .None
            cell3.mainLabel.text = self.textArray[indexPath.section][indexPath.row]
            if indexPath.row == 0 {
                cell3.lastLabel.text = self.myNationStr
            }else if indexPath.row == 1{
                cell3.lastLabel.text = isPartyMember
            }else if indexPath.row == 2{
                cell3.lastLabel.text = isMarry
            }
            cell3.lastLabel.hidden = false
            return cell3
        }else {
            let cell3 = tableView.dequeueReusableCellWithIdentifier("RightArrowAndLabelTableViewCell", forIndexPath: indexPath)as!RightArrowAndLabelTableViewCell
            cell3.setUIWithDic(NSDictionary())
            cell3.selectionStyle = .None
            cell3.mainLabel.text = self.textArray[indexPath.section][indexPath.row]
            cell3.lastLabel.hidden = true
            return cell3
            
        }
        
//        let cell = UITableViewCell()
//        cell.textLabel?.font = UIFont.systemFontOfSize(13)
//        
//        
//        cell.accessoryType = .DisclosureIndicator
//        cell.selectionStyle = .None
//        
//        return cell
    }
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footView = UIView()
        footView.backgroundColor = LGBackColor
        footView.frame = CGRectMake(0, 0, WIDTH, 10*px)
        
        return footView
    }
    //MARK:--------相册
    
    func uploadImage(){
        
        let alertController = UIAlertController.init(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        let pictureAssert = UIAlertAction.init(title: "从相册选取", style: UIAlertActionStyle.Default, handler: {
            void in
            self.LocalPhoto()
            
        })
        
        let Camera = UIAlertAction.init(title: "拍照", style: UIAlertActionStyle.Default, handler: {
            void in
            
            self.takePhoto()
            
            
        })
        let canelSelect = UIAlertAction.init(title: "取消", style: UIAlertActionStyle.Cancel, handler: nil)
        
        alertController.addAction(Camera)
        alertController.addAction(pictureAssert)
        alertController.addAction(canelSelect)
        self.presentViewController(alertController, animated: true, completion: nil)
        
        
    }
    
    func LocalPhoto(){
        let picker = UIImagePickerController()
        picker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        picker.delegate = self
        picker.allowsEditing = true
        presentViewController(picker, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func takePhoto(){
        
        let sourceType = UIImagePickerControllerSourceType.Camera
        if UIImagePickerController.isSourceTypeAvailable(sourceType) {
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.allowsEditing = true
            picker.sourceType = sourceType
            self.presentViewController(picker, animated: true, completion: nil)
        }else{
            print("无法打开相机")
        }
    }
    
    //MARK: -- UIImagePickerControllerDelegate
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        picker.dismissViewControllerAnimated(true, completion: nil)
        
        self.headerImage = (info[UIImagePickerControllerEditedImage] as! UIImage
            )
        let index = NSIndexPath.init(forRow: 0, inSection: 0)
        self.myTableView.reloadRowsAtIndexPaths([index], withRowAnimation:.Automatic)
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //MARK:-------Action
    
    func dataPickerViewAction(sender:UIDatePicker){
        let date = sender.date
        //实例化一个NSDateFormatter对象
        let dateFormatter = NSDateFormatter.init()
        //设定时间格式,这里可以设置成自己需要的格式
        dateFormatter.dateFormat = "yyyy-MM-dd"
        if self.dateSign == "0" {
            self.briDateString1 = dateFormatter.stringFromDate(date)
        }else if self.dateSign == "1"{
            self.IDDateString1 = dateFormatter.stringFromDate(date)
            earDate  = date
        }else{
            self.IDDateString2 = dateFormatter.stringFromDate(date)
        }
        
    }
    
    func datePickerCancelButtonAction(){
        self.showEffectView()
    }
    
    func datePickerDetermineButtonAction(){
        if self.dateSign == "0" {
            self.briDateString = self.briDateString1
            self.showEffectView()
            let index = NSIndexPath.init(forRow: 4, inSection: 0)
            self.myTableView.reloadRowsAtIndexPaths([index], withRowAnimation:.Automatic)
        }else if self.dateSign == "1"{
            self.dateSign = "2"
            self.showEffectView()
            self.CreatDataPicker()
             self.showEffectView()
            self.view.addSubview(self.datePickerBackView)
            UIView.animateWithDuration(0.2, animations: {
                self.datePickerBackView.frame = CGRectMake(0, HEIGHT-64-320*px, WIDTH, 320*px)
            })
            
        }else{
            self.IDDateString = self.IDDateString1 + "至" + self.IDDateString2
            self.showEffectView()
            let index = NSIndexPath.init(forRow: 3, inSection: 1)
            self.myTableView.reloadRowsAtIndexPaths([index], withRowAnimation:.Automatic)
        }
        

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
