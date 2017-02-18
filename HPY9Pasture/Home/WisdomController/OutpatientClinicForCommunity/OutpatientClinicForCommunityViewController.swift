//
//  OutpatientClinicForCommunityViewController.swift
//  HPY9Pasture
//
//  Created by purepure on 17/2/8.
//  Copyright © 2017年 xiaocool. All rights reserved.
//

import UIKit
import SwiftyJSON
import MJRefresh

class OutpatientClinicForCommunityViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    let mainTableview = UITableView()
    var userInfo:Array<JSON> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "门诊服务"
        creatUI()
//        self.mainTableview.mj_header.beginRefreshing()
        
        

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.hidden = false
    }

    
    func creatUI(){
        mainTableview.frame = CGRectMake(0, 0, WIDTH, HEIGHT-64)
        mainTableview.delegate = self
        mainTableview.dataSource = self
        mainTableview.backgroundColor = UIColor.whiteColor()
        mainTableview.separatorStyle = .None
        self.mainTableview.registerNib(UINib(nibName: "ALLOutpatientClinicTableViewCell",bundle: nil), forCellReuseIdentifier: "ALLOutpatientClinicTableViewCell")
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
        self.getData()
    }
    
    func getData(){
        AppRequestManager.shareManager.getCommunityOutpatientListByCommunityId("1") { (success, response) in
            if success{
                let userInfo1 = JSON(data: response as! NSData)
                self.userInfo = userInfo1["data"].array!
                self.mainTableview.reloadData()
            }
        }
    }
    
    //MARK: ------UITableViewDelegate
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        
        return 145*px
        
        //        return self.textArray.count
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        let vc =  OutpatientClinicDetailsViewController()
        vc.userInfo = self.userInfo[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: ------TableViewDatasource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        return self.userInfo.count
        
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCellWithIdentifier("ALLOutpatientClinicTableViewCell", forIndexPath: indexPath)as!ALLOutpatientClinicTableViewCell
        cell.selectionStyle = .None
        cell.setUI()
        if self.userInfo[indexPath.row]["name"].string != nil
        {
          cell.name.text = self.userInfo[indexPath.row]["name"].string
        }
        if self.userInfo[indexPath.row]["leader"].string != nil
        {
            cell.personName.text = self.userInfo[indexPath.row]["leader"].string
        }
        if self.userInfo[indexPath.row]["department"].string != nil
        {
            cell.descriptionLabel.text = "特色科室：" + self.userInfo[indexPath.row]["department"].string!
        }
        if self.userInfo[indexPath.row]["address"].string != nil
        {
            cell.adress.text = "  地址："+self.userInfo[indexPath.row]["address"].string!
        }
        if self.userInfo[indexPath.row]["photo"].string != nil
        {
            cell.headerImageView.sd_setImageWithURL(NSURL.init(string: Happy_ImageUrl+self.userInfo[indexPath.row]["photo"].string!), placeholderImage: UIImage(named: ""))
        }else{
            cell.headerImageView.image = UIImage(named: "")
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
