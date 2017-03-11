//
//  FamilyKitchenDetailsViewController.swift
//  HPY9Pasture
//
//  Created by purepure on 17/1/13.
//  Copyright © 2017年 xiaocool. All rights reserved.
//

import UIKit
import SwiftyJSON
import MJRefresh

class FamilyKitchenDetailsViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    var headerView = FamilyKitHeaderView()
    let schedulePhoneView = UIView()
    var phoneLabel = UILabel()
    let kitchenTableView = UITableView()
    var restaurantInfo:JSON?
    var userInfo:JSON?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.hidden = true
        self.view.backgroundColor = LGBackColor
        createrHeaderUI()
        
        
//        kitchenTableView.mj_header = MJRefreshNormalHeader(refreshingBlock: { () -> Void in
//            NSLOG("MJ:(下拉刷新)")
//            self.getData(beginId: "0")
//            
//            
//        })
//        kitchenTableView.mj_footer = MJRefreshBackNormalFooter(refreshingBlock: { () -> Void in
//            NSLOG("MJ:(上拉加载)")
//            self.getData(beginId: "1")
//            
//        })
//        kitchenTableView.mj_header.beginRefreshing()
        self.getData("")
        // Do any additional setup after loading the view.
    }
    
    func getData(beginID:String){
        AppRequestManager.shareManager.getFoodListByHomeId(self.restaurantInfo!["id"].string!, beginID: beginID) { (success, response) in
            if success{
                let userInfo1 = JSON(data: response as! NSData)
                self.userInfo = userInfo1["data"]
                self.kitchenTableView.reloadData()
                if self.userInfo!["name"].string != nil {
                    self.headerView.name.text = self.userInfo!["name"].string
                }
                if self.userInfo!["price"].string != nil && self.userInfo!["expressfee"].string != nil{
                    self.headerView.money.text = "满¥"+self.userInfo!["price"].string!+"起送｜配送费¥"+self.userInfo!["expressfee"].string!+"元"
                }
                if self.userInfo!["image"].string != nil {
                    self.headerView.headerImageview.sd_setImageWithURL(NSURL.init(string: Happy_ImageUrl+self.userInfo!["image"].string!), placeholderImage: UIImage(named: ""))
                }
                if self.userInfo!["noticelist"].array != nil {
                    if self.userInfo!["noticelist"].array![0]["title"].string != nil{
                        self.headerView.advertiseMentLabel.text = self.userInfo!["noticelist"].array![0]["title"].string
                    }
                    
                }
                if self.userInfo!["phone"].string != nil {
                    if self.userInfo!["phone"].string != nil{
                        self.phoneLabel.text = self.userInfo!["phone"].string
                    }
                    
                }
                
            }else{
                Alert.shareManager.alert("数据呀加载失败！", delegate: self)
            }
        }
    }
    
    func createrHeaderUI(){
        self.headerView =  NSBundle.mainBundle().loadNibNamed("FamilyKitHeaderView", owner: nil, options: nil).first as! FamilyKitHeaderView
        self.headerView.setUI()
        self.headerView.backButton.addTarget(self, action: #selector(self.backButtonAction), forControlEvents: .TouchUpInside)
        
        
        self.headerView.frame = CGRectMake(0, -23, WIDTH, 187)
        self.view.addSubview(self.headerView)
        
        self.kitchenTableView.frame = CGRectMake(0, self.headerView.height-23, WIDTH, HEIGHT-self.headerView.height-20)
        self.kitchenTableView.backgroundColor = UIColor.whiteColor()
        self.kitchenTableView.delegate = self
        self.kitchenTableView.dataSource = self
        self.kitchenTableView.separatorStyle = .None
        self.kitchenTableView.tableFooterView = UIView()
        self.kitchenTableView.registerNib(UINib(nibName: "FoodTableViewCell",bundle: nil), forCellReuseIdentifier: "FoodTableViewCell")
        
        self.view.addSubview(self.kitchenTableView)
        
        
        self.schedulePhoneView.frame = CGRectMake(0, HEIGHT-50*px, WIDTH, 50*px)
        self.schedulePhoneView.layer.masksToBounds = true
        self.schedulePhoneView.layer.borderWidth = 1
        self.schedulePhoneView.layer.borderColor = RGBACOLOR(238, g: 238, b: 238, a: 1).CGColor
        let phoneHeaderView = UILabel.init(frame: CGRectMake(0, 0, 125*px, 50*px))
        phoneHeaderView.text = "订餐热线"
        phoneHeaderView.backgroundColor = RGBACOLOR(255, g: 81, b: 85, a: 1)
        phoneHeaderView.textAlignment = .Center
        phoneHeaderView.textColor = UIColor.whiteColor()
        phoneHeaderView.font = UIFont.systemFontOfSize(15)
        phoneHeaderView.font = UIFont.boldSystemFontOfSize(15)
        
        phoneLabel = UILabel.init(frame: CGRectMake(phoneHeaderView.width, 0, WIDTH-phoneHeaderView.width, 50*px))
        
        phoneLabel.textAlignment = .Center
        phoneLabel.backgroundColor = UIColor.whiteColor()
        phoneLabel.textColor = RGBACOLOR(255, g: 81, b: 85, a: 1)
        phoneLabel.font = UIFont.systemFontOfSize(15)
        self.schedulePhoneView.addSubview(phoneHeaderView)
        self.schedulePhoneView.addSubview(phoneLabel)
        self.view.addSubview(self.schedulePhoneView)
        
    }
     //MARK: ------UITableViewDelegate
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        
        return 95*px
    }
    //MARK: ------TableViewDatasource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if self.userInfo?["foodlist"].array != nil {
            return (self.userInfo?["foodlist"].array!.count)!
        }else{
            return 0
        }
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCellWithIdentifier("FoodTableViewCell", forIndexPath: indexPath)as!FoodTableViewCell
        cell.setUI()
        if self.userInfo?["foodlist"].array != nil {
            if self.userInfo?["foodlist"].array![indexPath.row]["description"].string != nil{
                cell.fooddescribe.text = self.userInfo?["foodlist"].array![indexPath.row]["description"].string
            }
            
            if self.userInfo?["foodlist"].array![indexPath.row]["name"].string != nil{
                cell.foodName.text = self.userInfo?["foodlist"].array![indexPath.row]["name"].string
            }
            if self.userInfo?["foodlist"].array![indexPath.row]["price"].string != nil{
                cell.moneyLabel.text = "¥"+(self.userInfo?["foodlist"].array![indexPath.row]["price"].string)!
            }
            if self.userInfo?["foodlist"].array![indexPath.row]["photolist"].array != nil
            {
                if self.userInfo?["foodlist"].array![indexPath.row]["photolist"].array![0].string != nil{
                    //                NSLOG(self.userInfo?.array![indexPath.row]["photolist"].string)
                    cell.foodImage.sd_setImageWithURL(NSURL.init(string: Happy_ImageUrl+(self.userInfo?["foodlist"].array![indexPath.row]["photolist"].array![0].string)!), placeholderImage: UIImage(named: ""))
                }
            }
            
        }
        

        
        cell.selectionStyle = .None
        return cell
    }
    

    
    
    //MARK:ACTION
    func backButtonAction(){
        self.navigationController?.popViewControllerAnimated(true)
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
