//
//  HPYVideoController.swift
//  HPY9Pasture
//
//  Created by xiaocool on 16/10/10.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import UIKit



class HPYVideoController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    let videoTableView = UITableView()
    let cellHeight : CGFloat? = 50
    let listArray = ["远程认证","远程监控"]
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.whiteColor()
        let label = UILabel(frame: CGRectMake(100,100,100,50))
        label.text = "视频大厅"
//        view.addSubview(label)
        createTableView()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.hidden = false
    }
    
    //MARK: ------SET
    func createTableView(){
        videoTableView.frame = self.view.frame
        videoTableView.backgroundColor = UIColor.whiteColor()
        videoTableView.delegate = self
        videoTableView.dataSource = self
        videoTableView.separatorStyle = .None
        videoTableView.tableFooterView = UIView()//去掉多于的分割线
        videoTableView.registerClass(PublicTableViewCell.self, forCellReuseIdentifier: "PublicTableViewCell")
        self.view.addSubview(videoTableView)
        
    }
    
    //MARK: ------TableViewDelegate
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        
        return cellHeight!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        
        switch indexPath.row {
        case 1:
            let watchMovieVC = DeviceViewController()
            let openApi = OpenApiService()
            
            let ServerInfo = "openapi.lechange.cn:443"
            let m_strAppId = "lc80db01e1cb4142dd"//appid
            let m_strAppSecret = "643ec05b22714e9080e1cd5a5dba36"//AppSecret
            let m_strSrv = parseServerIp(ServerInfo)
            let m_iPort = parseServerPort(ServerInfo)
            let phone = "18678959897"
            var accessTok:NSString?
            var errCode : NSString?
            var errMsg : NSString?
            
            
            let ret = openApi.getAccessToken(m_strSrv, port: m_iPort, appId: m_strAppId, appSecret: m_strAppSecret, phone: phone, token: &accessTok, errcode: &errCode, errmsg: &errMsg)
            if ret < 0 {
                if errCode == "TK1006" {
                    alert("该号码不是开发者账号的手机号码，开发者创建应用后，可在开放平台网站>开发中心>应用详情页中找到管理员账号。", delegate: self)
                }else if errMsg != nil{
                    alert(errMsg as! String, delegate: self)
                }else{
                    alert("网络超时，请重试", delegate: self)
                }
            }
            let m_strAccessTok = accessTok as!String
            NSLOG(m_strAccessTok)
            watchMovieVC.setAdminInfo(m_strAccessTok, address: m_strSrv, port: m_iPort, appId: m_strAppId, appSecret: m_strAppSecret)
            watchMovieVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(watchMovieVC, animated: true)
            break
        default:
            break
        }
        
        NSLOG(indexPath)
    }
    
    
    //MARK: ------TableViewDatasource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        return 2
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        
        let cell = PublicTableViewCell.init(style: .Default)
        cell.textLabel?.font = MainFont
        cell.textLabel?.textAlignment = .Left
        cell.textLabel?.text = listArray[indexPath.row]
        cell.accessoryType = .DisclosureIndicator
        cell.selectionStyle = .None
        return cell
    }
    
    
    
    func parseServerPort(svrInfo:String)->NSInteger{
        var arr = NSArray()
        arr = svrInfo.componentsSeparatedByString(":")
        if arr.count <= 1 {
            if ((arr.objectAtIndex(0)).rangeOfString("https")).location != NSNotFound {
                return 443
            }else{
                return 80
            }
        }else{
            return (arr.objectAtIndex(1)).integerValue
        }
    }
    
    func parseServerIp(svrInfo:String)->String{
        var arr = NSArray()
        arr = svrInfo.componentsSeparatedByString(":")
        return arr.objectAtIndex(0) as! String
    }

    
    
    
    
    
    
}
