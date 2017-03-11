//
//  AssignSeverForHosViewController.swift
//  HPY9Pasture
//
//  Created by purepure on 17/2/27.
//  Copyright © 2017年 xiaocool. All rights reserved.
//

import UIKit
import SwiftyJSON
class AssignSeverForHosViewController: UIViewController ,UITableViewDelegate,UITableViewDataSource{

    let assignSeverTableView = UITableView()
    var userinfo:Array<JSON> = []
    let infoTableHeaderView = UIView()
    var infoHeaderView = InfoHeaderViewTableViewCell()

    override func viewDidLoad() {
        super.viewDidLoad()

        assignSeverTableView.delegate = self
        assignSeverTableView.dataSource = self
        assignSeverTableView.backgroundColor = LGBackColor
        assignSeverTableView.frame = CGRectMake(0, 0*px, WIDTH, HEIGHT-64-50*px)
        assignSeverTableView.separatorStyle = .None
        self.assignSeverTableView.registerNib(UINib(nibName: "FamilyCareForChildTableViewCell",bundle: nil), forCellReuseIdentifier: "FamilyCareForChildTableViewCell")
        //        familyServerTableView.sectionFooterHeight = 10*px
        self.view.addSubview(assignSeverTableView)
        
        let headerBackView = UIView.init(frame: CGRectMake(0, 0, WIDTH, 85*px))
        headerBackView.backgroundColor = RGBACOLOR(255, g: 172, b: 49, a: 1)
        
        let addButton = UIButton.init(frame: CGRectMake(WIDTH/2-20, 8*px, 40, 40))
        addButton.setImage(UIImage(named: "ic_tianjia"), forState: .Normal)
        addButton.addTarget(self, action: #selector(self.addButtonAction), forControlEvents: .TouchUpInside)
        headerBackView.addSubview(addButton)
        
        let addLabel = UILabel.init(frame: CGRectMake(0, addButton.height+10*px, WIDTH, 20*px))
        addLabel.text = "添加人员信息"
        addLabel.textColor = UIColor.whiteColor()
        addLabel.textAlignment = .Center
        addLabel.font = UIFont.systemFontOfSize(13)
        headerBackView.addSubview(addLabel)
        assignSeverTableView.tableHeaderView = headerBackView
        
        
        
        self.getData("")
        // Do any additional setup after loading the view.
    }
    
    
    func getData(beginId:String){
        AppRequestManager.shareManager.getServiceStaffsFormNearby("") { (success, response) in
            if success{
                let userinfo1 = JSON(data: response as! NSData)
                self.userinfo = userinfo1["data"].array!
                self.assignSeverTableView.reloadData()
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
        cell.moneyLabel.text = "180"+"元/天"
        cell.appointmentButton.setTitle("立即预约", forState: .Normal)
        cell.appointmentButton.backgroundColor = NavColor
        cell.selectionStyle = .None
        cell.appointmentButton.addTarget(self, action: #selector(self.appointmentButtonAction(_:)), forControlEvents: .TouchUpInside)
        
        
        
        
        return cell
    }
    
    func creatHeaderInfoView(){
        self.infoHeaderView =  NSBundle.mainBundle().loadNibNamed("InfoHeaderViewTableViewCell", owner: nil, options: nil).first as! InfoHeaderViewTableViewCell
        self.infoHeaderView.headerImageView.backgroundColor = UIColor.redColor()
        self.infoHeaderView.name.text = "钱国"
        self.infoHeaderView.hospital.text = "1212121222"
        self.infoHeaderView.roomName.text = "45454545"
        self.infoHeaderView.phone.text = "45454785241"+"备用联系人"+"1215452125454"
        self.infoHeaderView.addressForHos.text = "烟台市芝罘区青年南路监控阿兰大赛就"
        self.infoHeaderView.adress.text = "烟台市芝罘区青年南路监控阿兰大赛就"
        self.infoHeaderView.time.text = "2016.12.23 9:00开始"+"共"+"6"+"小时"
        self.assignSeverTableView.tableHeaderView = self.infoHeaderView
        self.infoHeaderView.changeButton.addTarget(self, action: #selector(self.changeButtonAction), forControlEvents: .TouchUpInside)
    }
    
    //MARK:--ACTION
    
    func appointmentButtonAction(sender:UIButton){
        let vc = AppointmentTimeViewController()
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    func addButtonAction(){
        let vc = SelfHelpServerViewController()
        vc.backFunc =  {(arrays)->Void in
            self.creatHeaderInfoView()
        }
        vc.isButton = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func changeButtonAction(){
        let vc = SelfHelpServerViewController()
        vc.backFunc =  {(arrays)->Void in
            self.creatHeaderInfoView()
        }
        vc.isButton = true
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
