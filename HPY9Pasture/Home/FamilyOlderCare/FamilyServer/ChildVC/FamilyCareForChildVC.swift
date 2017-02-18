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
        familyCareTableView.frame = CGRectMake(0, 0, WIDTH, HEIGHT-64-40*px)
        familyCareTableView.separatorStyle = .None
        self.familyCareTableView.registerNib(UINib(nibName: "FamilyCareForChildTableViewCell",bundle: nil), forCellReuseIdentifier: "FamilyCareForChildTableViewCell")
        //        familyServerTableView.sectionFooterHeight = 10*px
        self.view.addSubview(familyCareTableView)

        // Do any additional setup after loading the view.
    }
    
    func getData(beginId:String){
        AppRequestManager.shareManager.getServiceStaffsFormNearby("") { (success, response) in
            if success{
                let userinfo1 = JSON(data: response as! NSData)
                self.userinfo = userinfo1["data"].array!
            }else{
                alert("数据加载错误！", delegate: self)
            }
        }
    }
    
    //MARK: ------UITableViewDelegate
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        return 150*px
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        
        
    }
    
    
    //MARK: ------TableViewDatasource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        return 2
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCellWithIdentifier("FamilyCareForChildTableViewCell", forIndexPath: indexPath)as!FamilyCareForChildTableViewCell
        cell.creatUI(5)
        cell.headerimageView.backgroundColor = UIColor.redColor()
        cell.name.text = "何护工"
        cell.serverTime.text = "服务时间："+"14:00-16:00"
        cell.timesForServer.text = "已服务"+"56"+"次"
        cell.zanLabel.text = "点赞"+"3"
        cell.commentLabel.text = "评论"+"25"
        if indexPath.row == 0{
            cell.appointmentButton.setTitle("耐心等待", forState: .Normal)
            cell.appointmentButton.backgroundColor = RGBACOLOR(201, g: 201, b: 201, a: 1)
            cell.appointmentButton.userInteractionEnabled = false
            cell.stateImage.image = UIImage(named: "ic_fuwuzhong")
        }else{
            cell.appointmentButton.setTitle("立即预约", forState: .Normal)
            cell.appointmentButton.backgroundColor = NavColor
            cell.appointmentButton.userInteractionEnabled = true
            cell.stateImage.image = UIImage(named: "ic_woyoukong")
        }
        cell.selectionStyle = .None
        cell.appointmentButton.addTarget(self, action: #selector(self.appointmentButtonAction(_:)), forControlEvents: .TouchUpInside)
        
        
        
        
        return cell
    }
    
    //MARK:--ACTION
    
    func appointmentButtonAction(sender:UIButton){
        let vc = AppointmentTimeViewController()
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
