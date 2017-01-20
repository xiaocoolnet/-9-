//
//  FamilyKitchenDetailsViewController.swift
//  HPY9Pasture
//
//  Created by purepure on 17/1/13.
//  Copyright © 2017年 xiaocool. All rights reserved.
//

import UIKit

class FamilyKitchenDetailsViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    var headerView = FamilyKitHeaderView()
    let schedulePhoneView = UIView()
    let kitchenTableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.hidden = true
        self.view.backgroundColor = LGBackColor
        NSLOG(80*px)
        createrHeaderUI()
        // Do any additional setup after loading the view.
    }
    func createrHeaderUI(){
        self.headerView =  NSBundle.mainBundle().loadNibNamed("FamilyKitHeaderView", owner: nil, options: nil).first as! FamilyKitHeaderView
        self.headerView.setUI()
        self.headerView.backButton.addTarget(self, action: #selector(self.backButtonAction), forControlEvents: .TouchUpInside)
        self.headerView.name.text = "王纯纯喜欢吃"
        self.headerView.money.text = "满¥"+"10"+"起送｜配送费¥"+"0"+"元"
        self.headerView.advertiseMentLabel.text = "这里没有鸡精、味精，所有食材都是正规超市所购买"
        self.headerView.frame = CGRectMake(0, -23, WIDTH, 187)
        self.view.addSubview(self.headerView)
        
        self.kitchenTableView.frame = CGRectMake(0, self.headerView.height-23, WIDTH, WIDTH-self.headerView.height-23-50*px)
        self.kitchenTableView.backgroundColor = UIColor.whiteColor()
        self.kitchenTableView.delegate = self
        self.kitchenTableView.dataSource = self
        self.kitchenTableView.separatorStyle = .None
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
        
        let phoneLabel = UILabel.init(frame: CGRectMake(phoneHeaderView.width, 0, WIDTH-phoneHeaderView.width, 50*px))
        phoneLabel.text = "18800001234"
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
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCellWithIdentifier("FoodTableViewCell", forIndexPath: indexPath)as!FoodTableViewCell
        cell.setUI()
        cell.fooddescribe.text = "测试一下的的的艰苦环境撒谎的哈哈时间和机会一定就会发黄的合法就开始大哭哈客"
        cell.foodName.text = "王纯纯好吃的"
        cell.moneyLabel.text = "¥"+"30"
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
