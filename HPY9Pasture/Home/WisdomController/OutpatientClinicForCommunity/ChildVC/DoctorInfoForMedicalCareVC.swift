//
//  DoctorInfoForMedicalCareVC.swift
//  HPY9Pasture
//
//  Created by purepure on 17/2/9.
//  Copyright © 2017年 xiaocool. All rights reserved.
//

import UIKit
import SwiftyJSON

class DoctorInfoForMedicalCareVC: UIViewController,UITableViewDelegate,UITableViewDataSource {

    let mainTableview = UITableView()
    var userInfo:Array<JSON> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.creatUI()
        //        self.mainTableview.mj_header.beginRefreshing()

        // Do any additional setup after loading the view.
    }
    
    func getData(cid:String,type:String){
        AppRequestManager.shareManager.getDoctorListByOutpatientId(cid, type: type) { (success, response) in
            if success{
                let userinfo1 = JSON(data: response as! NSData)
                self.userInfo = userinfo1["data"].array!
                self.mainTableview.reloadData()
            }else{
                Alert.shareManager.alert("数据加载错误！", delegate: self)
            }
        }
    }
    
    func creatUI(){
        let lineView = UIView.init(frame: CGRectMake(0, 0, WIDTH, 1))
        lineView.backgroundColor = NavColor
        self.view.addSubview(lineView)
        mainTableview.frame = CGRectMake(0, 1, WIDTH, HEIGHT-65-40*px)
        mainTableview.delegate = self
        mainTableview.dataSource = self
        mainTableview.backgroundColor = UIColor.whiteColor()
        mainTableview.separatorStyle = .None
        self.mainTableview.registerNib(UINib(nibName: "DoctorInfoForMedicalCareVCCell",bundle: nil), forCellReuseIdentifier: "DoctorInfoForMedicalCareVCCell")
        self.view.addSubview(self.mainTableview)
        //        mainTableview.mj_header = MJRefreshNormalHeader(refreshingBlock: { () -> Void in
        //            NSLOG("MJ:(下拉刷新)")
        //            self.getData( "0")
        //
        //        })
        //        mainTableview.mj_footer = MJRefreshBackNormalFooter(refreshingBlock: { () -> Void in
        //            NSLOG("MJ:(上拉加载)")
        //            self.getData( "1")
        //
        //        })
    }
    
    //MARK: ------UITableViewDelegate
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        
        return 100*px
        
        //        return self.textArray.count
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        
    }
    
    //MARK: ------TableViewDatasource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        return self.userInfo.count
        
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCellWithIdentifier("DoctorInfoForMedicalCareVCCell", forIndexPath: indexPath)as!DoctorInfoForMedicalCareVCCell
        cell.selectionStyle = .None
        cell.setUI()
        cell.headerImageView.backgroundColor = UIColor.redColor()
        if self.userInfo[indexPath.row]["name"].string != nil{
            cell.name.text = self.userInfo[indexPath.row]["name"].string
        }
        if self.userInfo[indexPath.row]["hospital"].string != nil{
            cell.hospital.text = self.userInfo[indexPath.row]["hospital"].string
        }
        if self.userInfo[indexPath.row]["title"].string != nil{
            cell.level.text = self.userInfo[indexPath.row]["title"].string
        }
        if self.userInfo[indexPath.row]["description"].string != nil{
            cell.skilled.text = self.userInfo[indexPath.row]["description"].string
        }


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
