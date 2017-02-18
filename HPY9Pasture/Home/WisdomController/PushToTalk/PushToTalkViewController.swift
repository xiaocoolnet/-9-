//
//  PushToTalkViewController.swift
//  HPY9Pasture
//
//  Created by purepure on 16/12/19.
//  Copyright © 2016年 xiaocool. All rights reserved.
//

import UIKit
import SwiftyJSON

class PushToTalkViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UIPickerViewDelegate,UIPickerViewDataSource {
    
    let phoneTableView = UITableView()
    let imageArray = ["ic_feipinhuishou","ic_jiadianweixiu","ici_guandaoweixiu","ic_shutongxiashuidao","ic_peiyaoshi","ic_xiujiao","ic_xiuxie","ic_kaisuo","ic_modao","ic_shuaqiang"]
    let textArray = ["废品收购","家电维修","管道维修","疏通下下水道","配钥匙","修脚","修鞋","开锁服务","磨刀、剪子","刷墙"]
    
    let phonePickView = UIPickerView()
    let phonePickerViewBackView = UIView()
    var phoneString = String()
    
    var userInfor:JSON?
    var serverPhoneArrays = NSMutableArray()
    
    
    var phoneArray = NSMutableArray()
    
    
    
    
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
        self.title = "北陵社区一键通"
        
        self.serverPhoneArrays = DataBase.sharedDataBase().getAllPerson()
        
        self.phoneTableView.frame = CGRectMake(0, 0, WIDTH, HEIGHT-64)
        self.phoneTableView.delegate = self
        self.phoneTableView.dataSource = self
        self.phoneTableView.separatorStyle = .None
        self.phoneTableView.tableFooterView = UIView()
        self.phoneTableView.registerClass(ImageAndTextTableViewCell.self, forCellReuseIdentifier: "ImageAndTextTableViewCell")
        self.view.addSubview(self.phoneTableView)
        
        phonePickerViewBackView.frame = CGRectMake(0, HEIGHT, WIDTH, 280*px)
        
        let phonePickerHeaderLabel = UILabel.init(frame: CGRectMake(0, 0, WIDTH, 50*px))
        phonePickerHeaderLabel.text = "请选择电话"
        phonePickerHeaderLabel.font = UIFont.systemFontOfSize(15)
        phonePickerHeaderLabel.textAlignment = .Center
        phonePickerHeaderLabel.backgroundColor = NavColor
        phonePickerHeaderLabel.textColor = UIColor.whiteColor()
        phonePickerViewBackView.addSubview(phonePickerHeaderLabel)
        
        
        self.geData()
        
        
        
        
        self.phonePickView.frame = CGRectMake(0, 50*px, WIDTH, 140*px)
        self.phonePickView.delegate = self
        self.phonePickView.dataSource = self
        self.phonePickView
//        self.phonePickView.backgroundColor = NavColor
        
        let phonePickerCancelButton = UIButton.init(frame: CGRectMake(40*px, self.phonePickView.frame.origin.y+self.phonePickView.height+30*px, 100*px, 35*px))
        phonePickerCancelButton.backgroundColor = NavColor
        phonePickerCancelButton.setTitle("取消", forState: .Normal)
        phonePickerCancelButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        phonePickerCancelButton.addTarget(self, action: #selector(self.phonePickerCancelButtonAction), forControlEvents: .TouchUpInside)
        phonePickerCancelButton.layer.masksToBounds = true
        phonePickerCancelButton.layer.cornerRadius = 10*px
        phonePickerCancelButton.titleLabel?.font = UIFont.systemFontOfSize(14)
        
        
        let phonePickerDetermineButton = UIButton.init(frame: CGRectMake(WIDTH-140*px, self.phonePickView.frame.origin.y+self.phonePickView.height+30*px, 100*px, 35*px))
        phonePickerDetermineButton.backgroundColor = NavColor
        phonePickerDetermineButton.setTitle("立即拨打", forState: .Normal)
        phonePickerDetermineButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        phonePickerDetermineButton.addTarget(self, action: #selector(self.phonePickerDetermineButtonAction), forControlEvents: .TouchUpInside)
        phonePickerDetermineButton.layer.masksToBounds = true
        phonePickerDetermineButton.layer.cornerRadius = 10*px
        phonePickerDetermineButton.titleLabel?.font = UIFont.systemFontOfSize(14)
        
        phonePickerViewBackView.addSubview(phonePickerDetermineButton)
        
        phonePickerViewBackView.addSubview(phonePickerCancelButton)
        phonePickerViewBackView.addSubview(phonePickView)

        // Do any additional setup after loading the view.
    }
    
    
    func effectViewTouch(tap:UITapGestureRecognizer) {
        // 移除毛玻璃
        if (lasyEffectView.superview != nil) {
            lasyEffectView.removeFromSuperview()
            UIView.animateWithDuration(0.2) {
                self.phonePickerViewBackView.frame = CGRectMake(0, HEIGHT, WIDTH, 280*px)
            }
        }
    }
    func showEffectView() {
        // 点击显示毛玻璃的判断
        
        if (lasyEffectView.superview != nil) {
            lasyEffectView.removeFromSuperview()
        }else{
            self.view.addSubview(lasyEffectView)
        }
    }
    
    
    func geData(){
        AppRequestManager.shareManager.getcommunityServiceListBycommunityId("1") { (success, response) in
            if success{
                let userInfo1 = JSON(data: response as! NSData)
                
                if userInfo1["data"] != nil && userInfo1["data"].array != nil{
                    self.userInfor = userInfo1["data"]
                    NSLOG(userInfo1["data"].array?.count)
                    if userInfo1["data"].array != nil{
                        for phones in userInfo1["data"].array! {
                            let serverPhone = ServerPhone()
                            if phones["name"] != nil{
                                serverPhone.name = phones["name"].string
                            }
                            if phones["servicelist"] != nil && phones["servicelist"].array != nil{
                                let phoness = NSMutableArray()
                                for phone in phones["servicelist"].array! {
                                    if phone["phone"] != nil{
                                        phoness.addObject(phone["phone"].string!)
                                    }
                                    
                                }
                                serverPhone.phoneArray = phoness
                            }

                                DataBase.sharedDataBase().addPerson(serverPhone)

                            
                            
                            
                              //删除表
//                            DataBase.sharedDataBase().deleteTable()
                        }
                    }
                    self.serverPhoneArrays = DataBase.sharedDataBase().getAllPerson()
//                    NSLOG((self.serverPhoneArrays[0] as! ServerPhone).name!)
//                    NSLOG((self.serverPhoneArrays[0] as! ServerPhone).phoneArray!)
                }
            }else{
                alert("数据加载错误！", delegate: self)
            }
        }
    }
    
    
    //MARK: ------TableViewDelegate
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        return 44*px
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        self.showEffectView()
        NSLOG(self.serverPhoneArrays)
        for dic in self.serverPhoneArrays {
           NSLOG((dic as! ServerPhone).name)
            if (dic as! ServerPhone).name! == self.textArray[indexPath.row]{
                self.phoneArray = (dic as! ServerPhone).phoneArray!
                break
            }else{
                self.phoneArray = ["暂无纪录"];
            }
        }
//        self.phoneArray = self.serverPhoneArrays
        self.view.addSubview(self.phonePickerViewBackView)
        UIView.animateWithDuration(0.2) { 
            self.phonePickerViewBackView.frame = CGRectMake(0, HEIGHT-280*px-64, WIDTH, 280*px)
        }
        self.phonePickView.reloadAllComponents()
        
        
        
    }
    
    
    //MARK: ------TableViewDatasource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        return self.imageArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = ImageAndTextTableViewCell.init()
        cell.imageView?.image = UIImage(named: self.imageArray[indexPath.row])
        cell.textLabel?.text = self.textArray[indexPath.row]
        cell.textLabel?.font = UIFont.systemFontOfSize(13)
        cell.accessoryType = .DisclosureIndicator
        cell.selectionStyle = .None
        
        return cell
    }
    
    //MARK: -------UIPickerView DataSource
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return phoneArray.count
    }
    
    //MARK: -------UIPickerView Delegate
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.phoneArray[row] as? String
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.phoneString = self.phoneArray[row] as! String
    }
    //MARK: -------ACTION
    
    func phonePickerCancelButtonAction(){
        if (lasyEffectView.superview != nil) {
            lasyEffectView.removeFromSuperview()
            UIView.animateWithDuration(0.2) {
                self.phonePickerViewBackView.frame = CGRectMake(0, HEIGHT, WIDTH, 280*px)
            }
        }
    }
    
    func phonePickerDetermineButtonAction(){
        if UIApplication.sharedApplication().canOpenURL(NSURL.init(string: "tel:"+self.phoneString)!) {
            UIApplication.sharedApplication().openURL(NSURL.init(string: "tel:"+self.phoneString)!)
            
            if (lasyEffectView.superview != nil) {
                lasyEffectView.removeFromSuperview()
                UIView.animateWithDuration(0.2) {
                    self.phonePickerViewBackView.frame = CGRectMake(0, HEIGHT, WIDTH, 280*px)
                }
            }
        }else{
            alert("拨打出现错误，请重试", delegate: self)
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
