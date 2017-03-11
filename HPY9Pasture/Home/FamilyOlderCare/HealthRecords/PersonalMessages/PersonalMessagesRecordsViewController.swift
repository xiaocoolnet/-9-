//
//  PersonalMessagesRecordsViewController.swift
//  HPY9Pasture
//
//  Created by purepure on 16/12/21.
//  Copyright © 2016年 xiaocool. All rights reserved.
//

import UIKit
import SwiftyJSON

class PersonalMessagesRecordsViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    let myTableView = UITableView()
    let textArray = [["照片","人员编号","姓名","性别","出生日期","联系电话"],["户口类型","住址","身份证","身份证有效期"],["民族","是否党员","婚否"],["医疗保险类型","以往病史","自动病种归类","是否过敏"]]
    var headerImage = UIImage() //头像
    
    var sexStr = String()//性别
    var addressStr = String()//住址
    var isPartyMember = String()//是否党员
    var isMarry = String()//婚否
    
    var userid = String()
    
    var dateSign = String() //时间选择器状态 ‘0’——出生日期 ‘1’——身份证有效期（早）‘2’——身份证有效期（晚）
    
    var earDate = NSDate()//表示身份证有效期（早）的日期作为身份证有效期（晚）选择时间时的最小时间
    
    
    let dataPickerView = UIDatePicker()
    let datePickerBackView = UIView()
    var datePickerHeaderLabel = UILabel()
    
    
    var IDDateString = NSDate()//身份证有效期
    var IDDateString1 = String()//身份证有效期（早）
    var IDDateString2 = NSDate() //身份证有效期（晚）
    
    var briDateString = NSDate()//生日
    var briDateString1 = NSDate()//时间选择器日期
    
    var idNumStr = String()//身份证号
    var myNationStr = String()
    var userInfo:JSON?
    
    let longTimeButton = UIButton()
    
    
    
    
    
    
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
        let userLocationCenter = NSUserDefaults.standardUserDefaults()
        if userLocationCenter.objectForKey("UserInfo") != nil{
            if (userLocationCenter.objectForKey("UserInfo") as! NSDictionary)["userid"] != nil{
                userid = (userLocationCenter.objectForKey("UserInfo") as! NSDictionary)["userid"] as! String
            }else{
                
            }
        }
        
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
        
        self.getData()
        //        self.CreatDataPicker()

        // Do any additional setup after loading the view.
    }
    
    func getData(){
        var userid = String()
        let userLocationCenter = NSUserDefaults.standardUserDefaults()
        if userLocationCenter.objectForKey("UserInfo") != nil{
            if (userLocationCenter.objectForKey("UserInfo") as! NSDictionary)["userid"] != nil{
                userid = (userLocationCenter.objectForKey("UserInfo") as! NSDictionary)["userid"] as! String
            }else{
                
                return
            }
        }
        AppRequestManager.shareManager.getPersonalinformationByUserid(userid) { (success, response) in
            if success{
                let userInfo1 = JSON(data: response as! NSData)
                self.userInfo = userInfo1["data"]
                self.myTableView.reloadData()
            }else{
                Alert.shareManager.alert("数据加载错误！", delegate: self)
            }
        }
        
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
            longTimeButton.hidden = true
        }else if dateSign == "1"{
            datePickerHeaderLabel.text = "身份证有效期"
            longTimeButton.hidden = false
        }
        
        longTimeButton.frame = CGRectMake(WIDTH - 100*px, 10*px, 80*px, 30*px)
        longTimeButton.backgroundColor = UIColor.whiteColor()
        longTimeButton.setTitle("我是长期的", forState: .Normal)
        longTimeButton.titleLabel?.font = UIFont.systemFontOfSize(12)
        longTimeButton.setTitleColor(UIColor.redColor(), forState: .Normal)
        longTimeButton.layer.masksToBounds = true
        longTimeButton.layer.cornerRadius = 5
        longTimeButton.addTarget(self, action: #selector(self.longTimeButtonAction), forControlEvents: .TouchUpInside)
        
        
        
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
            self.dataPickerView.minimumDate = date1
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
        
        datePickerDetermineButton.setTitle("确定", forState: .Normal)
        
        datePickerDetermineButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        datePickerDetermineButton.addTarget(self, action: #selector(self.datePickerDetermineButtonAction), forControlEvents: .TouchUpInside)
        datePickerDetermineButton.layer.masksToBounds = true
        datePickerDetermineButton.layer.cornerRadius = 10*px
        datePickerDetermineButton.titleLabel?.font = UIFont.systemFontOfSize(14)
        
        self.datePickerBackView.addSubview(datePickerCancelButton)
        self.datePickerBackView.addSubview(datePickerDetermineButton)
        datePickerBackView.addSubview(longTimeButton)
        
        
        
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
                
                
            case 2:
                
                let vc = PublicTextEditViewController()
                vc.title = self.textArray[indexPath.section][indexPath.row]
                vc.leftTextLabelText = self.textArray[indexPath.section][indexPath.row]+":"
                if self.userInfo != nil && self.userInfo!["name"].string != nil {
                    
                    vc.myTextStr = self.userInfo!["name"].string!
                    
                }else{
                    vc.myTextStr = ""
                }
                
                vc.myFunc = {(editedText) ->Void in
                    AppRequestManager.shareManager.UpdateUserName(editedText, userid: self.userid, handle: { (success, response) in
                        if !success{
                            Alert.shareManager.alert("修改失败", delegate: self)
                        }else{
                            self.getData()
                            vc.navigationController?.popViewControllerAnimated(true)
                        }
                    })
                }
                
                self.navigationController?.pushViewController(vc, animated: true)
                break
            case 3:
                let vc = PublicTableViewViewController()
                vc.myArray = ["男","女"]
                vc.title = self.textArray[indexPath.section][indexPath.row]
                vc.myFunc = {(selectText,index) ->Void in
                    if selectText == "男" {
                        AppRequestManager.shareManager.UpdateUserSex(self.userid, sex: "1", handle: { (success, response) in
                            if !success{
                                Alert.shareManager.alert("修改失败", delegate: self)
                                
                            }else{
                                self.getData()
                                vc.navigationController?.popViewControllerAnimated(true)
                                
                            }
                        })
                    }else{
                        AppRequestManager.shareManager.UpdateUserSex(self.userid, sex: "0", handle: { (success, response) in
                            if !success{
                                Alert.shareManager.alert("修改失败", delegate: self)
                                
                            }else{
                                self.getData()
                                vc.navigationController?.popViewControllerAnimated(true)
                                
                            }
                        })
                    }

                    
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
            case 5:
                let vc = ChangePhoneViewController()
                self.navigationController?.pushViewController(vc, animated: true)
                break
            default:
                break
            }
        }else if indexPath.section == 1{
            switch indexPath.row {
            case 0:
                let vc = PublicTableViewViewController()
                vc.title = self.textArray[indexPath.section][indexPath.row]
                vc.myArray = ["农业户口","非农业户口"]
                vc.myFunc = {(selectText,index) ->Void in
                    AppRequestManager.shareManager.UpdateUserHouseholdregistration(self.userid, householdregistration: selectText as String, handle: { (success, response) in
                        if success{
                            self.getData()
                            vc.navigationController?.popViewControllerAnimated(true)
                        }else{
                            Alert.shareManager.alert("修改失败！", delegate: self)
                        }
                    })
                    
                }
                self.navigationController?.pushViewController(vc, animated: true)
                break
            case 1:
                let vc = PublicTextEditViewController()
                vc.title = "编辑住址"
                vc.leftTextLabelText = "地址:"
                vc.myFunc = {(editedText) ->Void in
                    AppRequestManager.shareManager.UpdateUserAddress(self.userid, address: editedText as String, handle: { (success, response) in
                        if success{
                            self.getData()
                            vc.navigationController?.popViewControllerAnimated(true)
                        }else{
                            Alert.shareManager.alert("修改失败！", delegate: self)
                        }
                    })
//                    let index = NSIndexPath.init(forRow: 1, inSection: 1)
                }
                self.navigationController?.pushViewController(vc, animated: true)
                break
            case 2:
                let vc = PublicTextEditViewController()
                vc.title = "编辑身份证"
                vc.leftTextLabelText = "身份证:"
                vc.myFunc = {(editedText) ->Void in
                    if !validateIdentityCard(editedText as String){
                        Alert.shareManager.alert("身份证格式不正确", delegate: self)
                        return
                    }
                    
                    AppRequestManager.shareManager.UpdateUserIDCard(self.userid, idcard: editedText as String, handle: { (success, response) in
                        if success{
                            self.getData()
                            vc.navigationController?.popViewControllerAnimated(true)
                        }else{
                            Alert.shareManager.alert("修改失败！", delegate: self)
                        }
                    })
                    
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
                vc.myFunc = {(selectText,index) ->Void in
                    AppRequestManager.shareManager.UpdateUserNation(self.userid, nation: selectText, handle: { (success, response) in
                        if success{
                            self.getData()
                            vc.navigationController?.popViewControllerAnimated(true)
                        }else{
                            Alert.shareManager.alert("修改失败！", delegate: self)
                        }
                    })
                    
                }

                
                self.navigationController?.pushViewController(vc, animated: true)
                break
            case 1:
                let vc = PublicTableViewViewController()
                vc.title = "是否党员"
                vc.myArray = ["党员","群众"]
                vc.myFunc = {(selectText,index) ->Void in
                    AppRequestManager.shareManager.UpdateUserParty(self.userid, party: selectText, handle: { (success, response) in
                        if success{
                            self.getData()
                            vc.navigationController?.popViewControllerAnimated(true)
                        }else{
                            Alert.shareManager.alert("修改失败！", delegate: self)
                        }
                        
                    })
                   
                }
                self.navigationController?.pushViewController(vc, animated: true)
                break
            case 2:
                let vc = PublicTableViewViewController()
                vc.title = "婚否"
                vc.myArray = ["未婚","已婚"]
                vc.myFunc = {(selectText,index) ->Void in
                    
                    AppRequestManager.shareManager.UpdateUserMarriageStatus(self.userid, marriage: selectText, handle: { (success, response) in
                        if success{
                            self.getData()
                            vc.navigationController?.popViewControllerAnimated(true)
                        }else{
                            Alert.shareManager.alert("修改失败！", delegate: self)
                        }
                    })
                    
                }
                self.navigationController?.pushViewController(vc, animated: true)
                break
                
            default:
                break
            }
        }else if indexPath.section == 3{
            switch indexPath.row {
            case 0:
                let vc = PublicTableViewViewController()
                vc.myArray = ["新农合医疗保险","城镇职工（含离退休人员）医疗保险","城镇居民医疗保险"]
                vc.title = self.textArray[indexPath.section][indexPath.row]
                vc.myFunc = {(selectText,index) ->Void in
                    //                    self.sexStr = selectText
                    AppRequestManager.shareManager.UpdateUserHealthInsuranceType(self.userid, type: selectText, handle: { (success, response) in
                        if success{
                            self.getData()
                            vc.navigationController?.popViewControllerAnimated(true)
                        }else{
                            Alert.shareManager.alert("修改失败！", delegate: self)
                        }
                    })
                    
                }
                self.navigationController?.pushViewController(vc, animated: true)
                break
            case 1:
                let vc = PublicTableViewViewController()
                vc.myArray = ["有","无"]
                vc.title = self.textArray[indexPath.section][indexPath.row]
                vc.myFunc = {(selectText,index) ->Void in
                    //                    self.sexStr = selectText
                    AppRequestManager.shareManager.UpdateUserMedicalhistory(self.userid, medicalhistory: selectText, handle: { (success, response) in
                        if success{
                            self.getData()
                            vc.navigationController?.popViewControllerAnimated(true)
                        }else{
                            Alert.shareManager.alert("修改失败！", delegate: self)
                        }
                    })
                    
                }
                self.navigationController?.pushViewController(vc, animated: true)
                break
            case 2:
                let vc = PublicTableViewViewController()
                vc.myArray = ["心脏病","脑血管病变","胃肠炎","流行性感冒及肺炎","支气管炎","糖尿病","肝病","结核病","感染性疾病及外伤","其他"]
                vc.title = self.textArray[indexPath.section][indexPath.row]
                vc.myFunc = {(selectText,index) ->Void in
                    //                    self.sexStr = selectText
                    AppRequestManager.shareManager.UpdateUserDiseasetype(self.userid, diseasetype: selectText, handle: { (success, response) in
                        if success{
                            self.getData()
                            vc.navigationController?.popViewControllerAnimated(true)
                        }else{
                            Alert.shareManager.alert("修改失败！", delegate: self)
                        }
                    })
                    
                }
                self.navigationController?.pushViewController(vc, animated: true)
                break
            case 3:
                let vc = PublicTableViewViewController()
                vc.myArray = ["是","否","不确定"]
                vc.title = self.textArray[indexPath.section][indexPath.row]
                vc.myFunc = {(selectText,index) ->Void in
//                    self.sexStr = selectText
                    AppRequestManager.shareManager.UpdateUserIrritability(self.userid, irritability: selectText, handle: { (success, response) in
                        if success{
                            self.getData()
                            vc.navigationController?.popViewControllerAnimated(true)
                        }else{
                            Alert.shareManager.alert("修改失败！", delegate: self)
                        }
                    })
                    
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
                if self.userInfo != nil{
                    if self.userInfo!["photo"].string != nil{
                        cell1.headerImageView.sd_setImageWithURL(NSURL.init(string: Happy_ImageUrl+self.userInfo!["photo"].string!), placeholderImage: UIImage(named: "wode_beijing"))
                    }else{
                        cell1.headerImageView.image = UIImage(named: "wode_beijing")
                    }
                }
                
                
                cell1.selectionStyle = .None
                cell1.mainLabel.text = self.textArray[indexPath.section][indexPath.row]
                return cell1
                
            }else if indexPath.row == 1{
                let cell2 = tableView.dequeueReusableCellWithIdentifier("DoubleLabelTableViewCell", forIndexPath: indexPath)as!DoubleLabelTableViewCell
                cell2.setUIWithDic(NSDictionary())
                cell2.selectionStyle = .None
                if self.userInfo != nil{
                    if self.userInfo!["peoplenumber"].string != nil{
                        cell2.lastLabel.text = self.userInfo!["peoplenumber"].string
                    }
                }
                cell2.mainLabel.text = self.textArray[indexPath.section][indexPath.row]
                
                
                return cell2
            }else if indexPath.row == 2{
                let cell2 = tableView.dequeueReusableCellWithIdentifier("RightArrowAndLabelTableViewCell", forIndexPath: indexPath)as!RightArrowAndLabelTableViewCell
                cell2.setUIWithDic(NSDictionary())
                cell2.selectionStyle = .None
                cell2.mainLabel.text = self.textArray[indexPath.section][indexPath.row]
                cell2.lastLabel.hidden = false
                if self.userInfo != nil{
                    if self.userInfo!["name"].string != nil{
                        cell2.lastLabel.text = self.userInfo!["name"].string
                    }
                }
                
                return cell2
            }else if indexPath.row == 3{
                let cell3 = tableView.dequeueReusableCellWithIdentifier("RightArrowAndLabelTableViewCell", forIndexPath: indexPath)as!RightArrowAndLabelTableViewCell
                cell3.setUIWithDic(NSDictionary())
                if self.userInfo != nil{
                    if self.userInfo!["sex"].string != nil{
                        if self.userInfo!["sex"].string == "1"{
                            cell3.lastLabel.text = "男"
                        }else{
                            cell3.lastLabel.text = "女"
                        }
                        
                    }
                }
                
                cell3.selectionStyle = .None
                cell3.mainLabel.text = self.textArray[indexPath.section][indexPath.row]
                cell3.lastLabel.hidden = false
                return cell3
            }else if indexPath.row == 4{
                let cell3 = tableView.dequeueReusableCellWithIdentifier("RightArrowAndLabelTableViewCell", forIndexPath: indexPath)as!RightArrowAndLabelTableViewCell
                cell3.setUIWithDic(NSDictionary())
                cell3.selectionStyle = .None
                cell3.mainLabel.text = self.textArray[indexPath.section][indexPath.row]
                
                if self.userInfo != nil{
                    if self.userInfo!["birthday"].string != nil{
                        cell3.lastLabel.text = timeStampToStringyyyyMMDD(self.userInfo!["birthday"].string!)
                        
                    }
                }
                
                cell3.lastLabel.hidden = false
                return cell3
            }else {
                let cell2 = tableView.dequeueReusableCellWithIdentifier("RightArrowAndLabelTableViewCell", forIndexPath: indexPath)as!RightArrowAndLabelTableViewCell
                cell2.selectionStyle = .None
                cell2.setUIWithDic(NSDictionary())
                cell2.mainLabel.text = self.textArray[indexPath.section][indexPath.row]
                
                if self.userInfo != nil{
                    if self.userInfo!["phone"].string != nil{
                        cell2.lastLabel.text = self.userInfo!["phone"].string!
                        
                    }
                }
                
                return cell2
            }
        }else if indexPath.section == 1{
            let cell3 = tableView.dequeueReusableCellWithIdentifier("RightArrowAndLabelTableViewCell", forIndexPath: indexPath)as!RightArrowAndLabelTableViewCell
            cell3.setUIWithDic(NSDictionary())
            cell3.selectionStyle = .None
            if self.userInfo != nil{
                if indexPath.row == 2 {
                    if self.userInfo!["idcard"].string != nil{
                        cell3.lastLabel.text = self.userInfo!["idcard"].string!
                        
                    }
                }else if indexPath.row == 3{
                    if self.userInfo!["idcardexpirydate"].string != nil{
                        cell3.lastLabel.text = self.userInfo!["idcardexpirydate"].string!
                        
                    }
                }else if indexPath.row == 1{
                    if self.userInfo!["address"].string != nil{
                        cell3.lastLabel.text = self.userInfo!["address"].string!
                        
                    }
                }else if indexPath.row == 0{
                    if self.userInfo!["householdregistration"].string != nil{
                        cell3.lastLabel.text = self.userInfo!["householdregistration"].string!
                        
                    }

                }
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
            if self.userInfo != nil{
                if indexPath.row == 0 {
                    if self.userInfo!["nation"].string != nil{
                        cell3.lastLabel.text = self.userInfo!["nation"].string!
                        
                    }
                    
                }else if indexPath.row == 1{
                    if self.userInfo!["party"].string != nil{
//                        if self.userInfo!["ispartynumber"].string == "0"{
                            cell3.lastLabel.text = self.userInfo!["party"].string
//                        }else if self.userInfo!["ispartynumber"].string == "1"{
//                            cell3.lastLabel.text = "是"
//                        }else {
//                            cell3.lastLabel.text = "预备党员"
//                        }
                        
                    }
                }else if indexPath.row == 2{
                    if self.userInfo!["ismarriage"].string != nil{
//                        if self.userInfo!["ismarriage"].string == "0"{
                            cell3.lastLabel.text = self.userInfo!["ismarriage"].string
//                        }else if self.userInfo!["ismarriage"].string == "1"{
//                            cell3.lastLabel.text = "已婚"
//                        }else {
//                            cell3.lastLabel.text = "离异"
//                        }
                        
                    }
                }
            }
            
            cell3.lastLabel.hidden = false
            return cell3
        }else {
            let cell3 = tableView.dequeueReusableCellWithIdentifier("RightArrowAndLabelTableViewCell", forIndexPath: indexPath)as!RightArrowAndLabelTableViewCell
            cell3.setUIWithDic(NSDictionary())
            cell3.selectionStyle = .None
            cell3.mainLabel.text = self.textArray[indexPath.section][indexPath.row]
            cell3.lastLabel.hidden = false
            if self.userInfo != nil{
                switch indexPath.row {
                case 0:
                    if self.userInfo!["healthinsurancetype"].string != nil{
                        cell3.lastLabel.text = self.userInfo!["healthinsurancetype"].string
                    }
                    
                    break
                case 1:
                    if self.userInfo!["medicalhistory"].string != nil{
                        cell3.lastLabel.text = self.userInfo!["medicalhistory"].string
                    }
                    
                    break
                case 2:
                    if self.userInfo!["diseasetype"].string != nil{
                        cell3.lastLabel.text = self.userInfo!["diseasetype"].string
                    }
                    
                    break
                case 3:
                    if self.userInfo!["irritability"].string != nil{
                        cell3.lastLabel.text = self.userInfo!["irritability"].string
                    }
                    
                    break
                default:
                    break
                }
            }
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
            NSLOG("无法打开相机")
        }
    }
    
    //MARK: -- UIImagePickerControllerDelegate
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        picker.dismissViewControllerAnimated(true, completion: nil)
        
        self.headerImage = (info[UIImagePickerControllerEditedImage] as! UIImage
            )
        
        
        let data = UIImageJPEGRepresentation(self.headerImage, 0.1)!
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyyMMddHHmmssSSS"
        let dateStr1 = dateFormatter.stringFromDate(NSDate())
        let imageName = "myHeaderImage" + dateStr1 + String(arc4random() % 10000) + userid
        ConnectModel.uploadWithImageName(imageName, imageData: data, URL: Happy_HeaderUrl+"uploadimg") { (data) in
            let json = JSON(data: data)
            if (json["status"].string) != nil&&(json["status"].string) == "success" {
                if json["data"].string != nil{
                    AppRequestManager.shareManager.UpdateUserAvatar(json["data"].string!, userid: self.userid, handle: { (success, response) in
                        if !success{
                            Alert.shareManager.alert("修改失败！", delegate: self)
                        }else{
                            self.getData()
                            
                        }
                    })
                }
                
            }
        }
        
        
       
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
            self.briDateString1 = date
        }else if self.dateSign == "1"{
            self.IDDateString1 =  dateFormatter.stringFromDate(date)
            earDate  = date
        }
    }
    
    func datePickerCancelButtonAction(){
        self.showEffectView()
    }
    
    func datePickerDetermineButtonAction(){
        if self.dateSign == "0" {
//            self.briDateString = self.briDateString1
            self.showEffectView()
            let date = String(self.briDateString1.timeIntervalSince1970)
            
            AppRequestManager.shareManager.UpdateUserBirthday(self.userid, birthday: date) { (success, response) in
                if success {
                    self.getData()
                }else{
                    Alert.shareManager.alert("修改失败", delegate: self)
                }
            }
            
            
        }else if self.dateSign == "1"{
            self.showEffectView()
            
            
            AppRequestManager.shareManager.UpdateUserIDCardExpiry(self.userid, birthday: self.IDDateString1) { (success, response) in
                if success {
                    self.getData()
                }else{
                    Alert.shareManager.alert("修改失败", delegate: self)
                }
            }
            
        }

    }
    
    func longTimeButtonAction(){
        self.showEffectView()
        AppRequestManager.shareManager.UpdateUserIDCardExpiry(self.userid, birthday: "长期") { (success, response) in
            if success {
                self.getData()
            }else{
                Alert.shareManager.alert("修改失败", delegate: self)
            }
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
