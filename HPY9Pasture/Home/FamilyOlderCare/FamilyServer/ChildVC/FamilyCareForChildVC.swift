//
//  FamilyCareForChildVC.swift
//  HPY9Pasture
//
//  Created by purepure on 17/2/6.
//  Copyright © 2017年 xiaocool. All rights reserved.
//

import UIKit
import SwiftyJSON

class FamilyCareForChildVC: UIViewController,UITableViewDelegate,UITableViewDataSource {

    
    let familyCareTableView = UITableView()
    var userinfo:Array<JSON> = []
    override func viewDidLoad() {
        super.viewDidLoad()
        familyCareTableView.delegate = self
        familyCareTableView.dataSource = self
        familyCareTableView.backgroundColor = LGBackColor
        familyCareTableView.frame = CGRectMake(0, 10*px, WIDTH, HEIGHT-64-50*px)
        familyCareTableView.separatorStyle = .None
        self.familyCareTableView.registerNib(UINib(nibName: "FamilyCareForChildTableViewCell",bundle: nil), forCellReuseIdentifier: "FamilyCareForChildTableViewCell")
        //        familyServerTableView.sectionFooterHeight = 10*px
        self.view.addSubview(familyCareTableView)

        self.getData("")
        // Do any additional setup after loading the view.
    }
    
    func getData(beginId:String){
        AppRequestManager.shareManager.getServiceStaffsFormNearby("") { (success, response) in
            if success{
                let userinfo1 = JSON(data: response as! NSData)
                self.userinfo = userinfo1["data"].array!
                self.familyCareTableView.reloadData()
            }else{
                Alert.shareManager.alert("数据加载错误！", delegate: self)
            }
        }
    }
    
    //MARK: ------UITableViewDelegate
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        return 100*px
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        let vc = ServerInfoViewController()
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
    //MARK: ------TableViewDatasource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        return userinfo.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCellWithIdentifier("FamilyCareForChildTableViewCell", forIndexPath: indexPath)as!FamilyCareForChildTableViewCell
        if userinfo[indexPath.row]["score"].string != nil{
            let score = Int(userinfo[indexPath.row]["score"].string!)
            if score != nil{
                cell.creatUI(score!)
            }else{
                cell.creatUI(5)
            }
        }else{
            cell.creatUI(5)
        }
        
        cell.headerimageView.backgroundColor = UIColor.redColor()
        if userinfo[indexPath.row]["name"].string != nil{
            cell.name.text = userinfo[indexPath.row]["name"].string
        }
        if userinfo[indexPath.row]["servicetime"].string != nil{
            cell.serverTime.text = "服务时间：" + userinfo[indexPath.row]["servicetime"].string!
        }
        if userinfo[indexPath.row]["servicecount"].string != nil{
            cell.timesForServer.text = "已服务" + userinfo[indexPath.row]["servicecount"].string! + "次"
        }
        if userinfo[indexPath.row]["photo"].string != nil{
            cell.headerimageView.sd_setImageWithURL(NSURL.init(string: Happy_ImageUrl+userinfo[indexPath.row]["photo"].string!), placeholderImage: UIImage(named: ""))
        }
        if userinfo[indexPath.row]["dayprice"].string != nil{
            
            cell.moneyLabel.text = userinfo[indexPath.row]["dayprice"].string!+"元/天"
        }
        
        cell.appointmentButton.setTitle("立即预约", forState: .Normal)
        cell.appointmentButton.backgroundColor = NavColor
        cell.selectionStyle = .None
        cell.tag = indexPath.row
        cell.appointmentButton.addTarget(self, action: #selector(self.appointmentButtonAction(_:)), forControlEvents: .TouchUpInside)
        
        
        
        
        return cell
    }
    
    //MARK:--ACTION
    
    func appointmentButtonAction(sender:UIButton){
        let vc = AppointmentTimeViewController()
        vc.info = self.userinfo[sender.tag]
        self.navigationController?.pushViewController(vc, animated: true)
        
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
