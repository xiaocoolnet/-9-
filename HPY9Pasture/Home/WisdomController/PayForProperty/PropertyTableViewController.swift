//
//  PropertyTableViewController.swift
//  HPY9Pasture
//
//  Created by purepure on 17/1/3.
//  Copyright © 2017年 xiaocool. All rights reserved.
//

import UIKit
import SwiftyJSON
import MJRefresh

class PropertyTableViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    let mytableView = UITableView()
    var userid = String()
    var userinfo:Array<JSON> = []
    
    let textArray = [["青岛斯蒂芬物业公司","福海应景小区12棟506室","58.00"],["青岛斯蒂芬物业公司","福海应景小区12棟506室","58.00"]]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "物业缴费"
        
        let userLocationCenter = NSUserDefaults.standardUserDefaults()
        if userLocationCenter.objectForKey("UserInfo") != nil{
            if (userLocationCenter.objectForKey("UserInfo") as! NSDictionary)["userid"] != nil{
                userid = (userLocationCenter.objectForKey("UserInfo") as! NSDictionary)["userid"] as! String
            }else{
                
            }
        }

        self.view.backgroundColor = LGBackColor
        self.mytableView.frame = CGRectMake(0, 0, WIDTH, HEIGHT-64)
        self.mytableView.delegate = self
        self.mytableView.dataSource = self
        self.mytableView.backgroundColor = LGBackColor
        self.mytableView.separatorStyle = .None
        self.mytableView.editing = false
        self.mytableView.registerNib(UINib(nibName: "PropertyTableViewCell",bundle: nil), forCellReuseIdentifier: "PropertyTableViewCell")
        self.view.addSubview(self.mytableView)
        // Do any additional setup after loading the view.
    }
    
    
    func getData(){
        AppRequestManager.shareManager.getMyCommunityWaitForPayOrder("1", cid: "2") { (success, response) in
            if success{
                let userInfo1 = JSON(data: response as! NSData)
                self.userinfo = userInfo1["data"].array!
                self.mytableView.reloadData()
            }else{
              alert("数据加载错误！", delegate: self)
            }
        }
    }
    
    
    //MARK: ------UITableViewDelegate
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        return 60
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        
        let vc = DetailsViewController()
        self.navigationController?.pushViewController(vc, animated: true)
        
        
        
        
    }
    
    
    //MARK: ------TableViewDatasource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        return userinfo.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCellWithIdentifier("PropertyTableViewCell", forIndexPath: indexPath)as!PropertyTableViewCell
        cell.setUI()
        cell.downTextLabel.text = self.textArray[indexPath.row][1] as String
        cell.upTextLabel.text = self.textArray[indexPath.row][0] as String
        cell.rightTextLabel.text = "总欠费"+self.textArray[indexPath.row][2] as String+"元"
        cell.selectionStyle = .None
        
        return cell
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
