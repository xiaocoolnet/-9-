//
//  EditInformationViewController.swift
//  HPY9Pasture
//
//  Created by purepure on 17/1/12.
//  Copyright © 2017年 xiaocool. All rights reserved.
//

import UIKit
import SwiftyJSON

class EditInformationViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    let informationTableView = UITableView()
    let textArray = ["头像","姓名","性别","电话号码","出生年月","身份证号"]
    
    var userLocationCenter = NSUserDefaults.standardUserDefaults()
    var userInfor:JSON?
    
    let dataPickerView = UIDatePicker()
    let datePickerBackView = UIView()
    var datePickerHeaderLabel = UILabel()
    var briDateStr = String()//时间选择器时间
    
    var headerImage = UIImage() //头像
    var userid = String()
    var briDate = NSDate()
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
        self.title = "个人资料"
        self.configureUI()

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.hidden = false
        self.tabBarController?.tabBar.hidden = true
        self.getUserInfo()
        }
    
    func getUserInfo(){
        if userLocationCenter.objectForKey("UserInfo") != nil{
            let userInfo = userLocationCenter.objectForKey("UserInfo") as! NSDictionary
            
            if userInfo["userid"] != nil {
                self.userid = userInfo["userid"] as! String
                AppRequestManager.shareManager.getUserinfoWithUserId(userInfo["userid"] as! String, handle: { (success, response) in
                    if success{
                        let userInfo1 = JSON(data: response as! NSData)
                        
                        if userInfo1["data"] != nil{
                            self.userInfor = userInfo1["data"]
                        }
                        self.informationTableView.reloadData()
                        
                    }else{
                        
                    }
                })
            }
            
        }else{
            self.userid = ""
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
    
    func configureUI(){
        
        informationTableView.delegate = self
        informationTableView.dataSource = self
        informationTableView.backgroundColor = LGBackColor
        informationTableView.frame = CGRectMake(0, 5, WIDTH, HEIGHT-64-5)
        informationTableView.separatorStyle = .None
        self.informationTableView.registerNib(UINib(nibName: "HeaderPhotoTableViewCell",bundle: nil), forCellReuseIdentifier: "HeaderPhotoTableViewCell")
        self.informationTableView.registerNib(UINib(nibName: "RightArrowAndLabelTableViewCell",bundle: nil), forCellReuseIdentifier: "RightArrowAndLabelTableViewCell")
        self.view.addSubview(informationTableView)
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
//        let date2 = dateFormatter.dateFromString("2200-01-01")
        
       
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
        if indexPath.section == 0 && indexPath.row == 0{
            return 51
        }else{
            return 38
        }
//        return self.textArray.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        switch indexPath.row {
            
        case 0:
            self.uploadImage()
            break
        case 2:
            let vc = PublicTableViewViewController()
            vc.myArray = ["男","女"]
            vc.title = self.textArray[indexPath.row]
            vc.myFunc = {(selectText) ->Void in
                if selectText == "男" {
                    AppRequestManager.shareManager.UpdateUserSex(self.userid, sex: "1", handle: { (success, response) in
                        if !success{
                            alert("修改失败", delegate: self)
                        }else{
                            vc.navigationController?.popViewControllerAnimated(true)
                        }
                    })
                }else{
                    AppRequestManager.shareManager.UpdateUserSex(self.userid, sex: "0", handle: { (success, response) in
                        if !success{
                            alert("修改失败", delegate: self)
                        }else{
                            vc.navigationController?.popViewControllerAnimated(true)
                        }
                    })
                }
            }
            self.navigationController?.pushViewController(vc, animated: true)
            break
          case 1:
            
            let vc = PublicTextEditViewController()
            vc.title = self.textArray[indexPath.row]
            vc.leftTextLabelText = self.textArray[indexPath.row]+":"
            if self.userInfor != nil && self.userInfor!["name"].string != nil {
                
                vc.myTextStr = self.userInfor!["name"].string!
                
            }else{
                vc.myTextStr = ""
            }
            
            vc.myFunc = {(editedText) ->Void in
                AppRequestManager.shareManager.UpdateUserName(editedText, userid: self.userid, handle: { (success, response) in
                    if !success{
                        alert("修改失败", delegate: self)
                    }else{
                        vc.navigationController?.popViewControllerAnimated(true)
                    }
                })
            }
            
            self.navigationController?.pushViewController(vc, animated: true)
            break
        case 3:
            
            let vc = ChangePhoneViewController()
            self.navigationController?.pushViewController(vc, animated: true)
            break
        case 5:
            
            let vc = PublicTextEditViewController()
            vc.title = self.textArray[indexPath.row]
            vc.leftTextLabelText = self.textArray[indexPath.row]+":"
            vc.myFunc = {(editedText) ->Void in
                
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
        default:
            break
        }
    }
    //MARK: ------TableViewDatasource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        return self.textArray.count
        
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        if indexPath.row == 0 {
            let cell1 = tableView.dequeueReusableCellWithIdentifier("HeaderPhotoTableViewCell", forIndexPath: indexPath)as!HeaderPhotoTableViewCell
            cell1.setUIWithDic(NSDictionary())
            if self.userInfor != nil && self.userInfor!["photo"].string != nil {
                cell1.headerImageView.sd_setImageWithURL(NSURL(string:Happy_ImageUrl+self.userInfor!["photo"].string!), placeholderImage: UIImage(named: "ic_touxi"))
            }else if self.userInfor != nil && self.userInfor!["sex"].string != nil{
                if self.userInfor!["sex"].string == "1"{
                    cell1.headerImageView.image = UIImage(named:"ic_touxi" )
                }else{
                    cell1.headerImageView.image = UIImage(named:"ic_toux" )
                }
                
            }
            
            cell1.selectionStyle = .None
            cell1.mainLabel.text = self.textArray[indexPath.row]
            return cell1
            
        }else if indexPath.row == 2{
            let cell3 = tableView.dequeueReusableCellWithIdentifier("RightArrowAndLabelTableViewCell", forIndexPath: indexPath)as!RightArrowAndLabelTableViewCell
            cell3.setUIWithDic(NSDictionary())
            if self.userInfor != nil && self.userInfor!["sex"].string != nil {
                if self.userInfor!["sex"].string == "1"{
                    cell3.lastLabel.text = "男"
                }else{
                    cell3.lastLabel.text = "女"
                }
            }else{
                cell3.lastLabel.text = "未知"
            }
            
            cell3.selectionStyle = .None
            cell3.mainLabel.text = self.textArray[indexPath.row]
            cell3.lastLabel.hidden = false
            return cell3
        }else if indexPath.row == 1{
            let cell3 = tableView.dequeueReusableCellWithIdentifier("RightArrowAndLabelTableViewCell", forIndexPath: indexPath)as!RightArrowAndLabelTableViewCell
            cell3.setUIWithDic(NSDictionary())
            if self.userInfor != nil && self.userInfor!["name"].string != nil {
               
                    cell3.lastLabel.text = self.userInfor!["name"].string
                
            }else{
                cell3.lastLabel.text = ""
            }
            
            cell3.selectionStyle = .None
            cell3.mainLabel.text = self.textArray[indexPath.row]
            cell3.lastLabel.hidden = false
            return cell3
        }else if indexPath.row == 3{
            let cell3 = tableView.dequeueReusableCellWithIdentifier("RightArrowAndLabelTableViewCell", forIndexPath: indexPath)as!RightArrowAndLabelTableViewCell
            cell3.setUIWithDic(NSDictionary())
            if self.userInfor != nil && self.userInfor!["phone"].string != nil {
                
                cell3.lastLabel.text = self.userInfor!["phone"].string
                
            }else{
                cell3.lastLabel.text = ""
            }
            
            cell3.selectionStyle = .None
            cell3.mainLabel.text = self.textArray[indexPath.row]
            cell3.lastLabel.hidden = false
            return cell3
        }else if indexPath.row == 4{
            let cell3 = tableView.dequeueReusableCellWithIdentifier("RightArrowAndLabelTableViewCell", forIndexPath: indexPath)as!RightArrowAndLabelTableViewCell
            cell3.setUIWithDic(NSDictionary())
            if self.userInfor != nil && self.userInfor!["birthday"].string != nil {
//                let date = NSDate()
                let dateFormatter = NSDateFormatter.init()
                dateFormatter.dateFormat = "yyyy年MM月dd日"
                let confromTimesp = NSDate.init(timeIntervalSince1970: NSTimeInterval(self.userInfor!["birthday"].string!)!)
                cell3.lastLabel.text = dateFormatter.stringFromDate(confromTimesp)
                
            }else{
                cell3.lastLabel.text = ""
            }
            
            cell3.selectionStyle = .None
            cell3.mainLabel.text = self.textArray[indexPath.row]
            cell3.lastLabel.hidden = false
            return cell3
        }else {
            let cell3 = tableView.dequeueReusableCellWithIdentifier("RightArrowAndLabelTableViewCell", forIndexPath: indexPath)as!RightArrowAndLabelTableViewCell
            cell3.setUIWithDic(NSDictionary())
            if self.userInfor != nil && self.userInfor!["idcard"].string != nil {
                //                let date = NSDate()
                if (self.userInfor!["idcard"].string)?.characters.count > 15 {
                    let str = self.userInfor!["idcard"].string! as NSString
                    cell3.lastLabel.text = str.substringToIndex(4)+"*********"+str.substringFromIndex(str.length-4)
                }
                
            }else{
                cell3.lastLabel.text = ""
            }
            
            cell3.selectionStyle = .None
            cell3.mainLabel.text = self.textArray[indexPath.row]
            cell3.lastLabel.hidden = false
            return cell3
        }
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
                            alert("修改失败！", delegate: self)
                        }else{
                            self.getUserInfo()
                        }
                    })
                }
                
            }
        }
//        let index = NSIndexPath.init(forRow: 0, inSection: 0)
//        self.myTableView.reloadRowsAtIndexPaths([index], withRowAnimation:.Automatic)
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    
    
    //MARK:Action
    func dataPickerViewAction(sender:UIDatePicker){
        self.briDate = sender.date
        //实例化一个NSDateFormatter对象
        let dateFormatter = NSDateFormatter.init()
        //设定时间格式,这里可以设置成自己需要的格式
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        self.briDateStr = dateFormatter.stringFromDate(briDate)
    
    }
    
    func datePickerCancelButtonAction(){
        self.showEffectView()
    }
    
    func datePickerDetermineButtonAction(){
        
//            var briDateString = self.briDateStr
            self.showEffectView()
        let date = String(self.briDate.timeIntervalSince1970)
       
        AppRequestManager.shareManager.UpdateUserBirthday(self.userid, birthday: date) { (success, response) in
            if success {
                self.getUserInfo()
            }else{
                alert("修改失败", delegate: self)
            }
        }
        
        
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
