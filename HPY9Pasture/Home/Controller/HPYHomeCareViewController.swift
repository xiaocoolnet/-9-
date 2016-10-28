//
//  HPYHomeCareViewController.swift
//  HPY9Pasture
//
//  Created by purepure on 16/10/21.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import UIKit

class HPYHomeCareViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    
    let headerScrView = UIScrollView()
    let myTableView = UITableView()
    
    
    
    let headerTextArray:Array = ["门诊服务","巡诊服务","送药服务","养生保健"]
    let headerImageNameArray:Array = ["jujia_menzhen","jujia_xunzhen","jujia_songyao","jujia_yangshengbaojian"]
    let cellImage:Array = ["jujia_yiyuanxinxi","jujia_jijiu","jujia_jiankang","jujia_shoujibaozhi","jujia_jingdian","jujia_piaowu","jujia_jinglaodishi","jujia_dianhuachaxun","jujia_gongjiaochaxun"]
    let cellText:Array = ["医院信息","急救手册","健康百科","手机报纸","景点查询","票务服务","敬老的士","电话查询","公交查询"]
    
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "居家养老"
        self.view.backgroundColor = LGBackColor
        configureUI()
        // Do any additional setup after loading the view.
    }
    
    func configureUI(){
        headerScrView.frame = CGRectMake(0, 0, Screen_W, Screen_W/4+50)
        headerScrView.contentSize = CGSizeMake(Screen_W, Screen_W/4+50)
        headerScrView.backgroundColor = UIColor.whiteColor()
        for index in 0...headerTextArray.count-1 {
            let headerCellView = MainImageAndTextButton.init(frame: CGRectMake(CGFloat(index)*Screen_W/4, 0, Screen_W/4, Screen_W/4+30), imageFrame: CGRectMake((Screen_W/4-Screen_W*71/375)/2, 15, Screen_W*71/375, Screen_W*71/375), textFrame: CGRectMake(0, Screen_W*71/375+15, Screen_W/4, 50), imageName: self.headerImageNameArray[index], labelText: self.headerTextArray[index])
            headerCellView.downTextLable.font = UIFont.systemFontOfSize(14)
            headerCellView.tag = index
            headerCellView.addTarget(self, action: #selector(self.headerCellViewAction(_:)), forControlEvents: .TouchUpInside)
            headerScrView.addSubview(headerCellView)
        }
        
        //间隔为10
        self.myTableView.frame = CGRectMake(0, self.headerScrView.frame.height+10, Screen_W, Screen_H-self.headerScrView.frame.height-64-10)
        self.myTableView.delegate = self
        self.myTableView.dataSource = self
        self.myTableView.separatorStyle = .None
        self.myTableView.tableFooterView = UIView()
        myTableView.registerClass(ImageAndTextTableViewCell.self, forCellReuseIdentifier: "ImageAndTextTableViewCell")
        self.view.addSubview(headerScrView)
        self.view.addSubview(myTableView)
    }
    
    
    func headerCellViewAction(sender:UIButton){
        switch sender.tag {
        case 0:
            let  outpatientVC = OutpatientViewController()
            self.navigationController?.pushViewController(outpatientVC, animated: true)
            break
        case 1:
            
            break
        default:
            break
        }
      
    }
    
    
    //MARK: ------TableViewDelegate
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        
        return 44
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        
        print(indexPath)
    }
    
    
    //MARK: ------TableViewDatasource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        return self.cellText.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
         let cell = ImageAndTextTableViewCell.init()
        cell.imageView?.image = UIImage(named: self.cellImage[indexPath.row])
        cell.textLabel?.text = self.cellText[indexPath.row]
        cell.textLabel?.font = UIFont.systemFontOfSize(14)
        cell.accessoryType = .DisclosureIndicator
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
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
