//
//  ToolboxViewController.swift
//  HPY9Pasture
//
//  Created by purepure on 17/3/10.
//  Copyright © 2017年 xiaocool. All rights reserved.
//

import UIKit

class ToolboxViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    let mytableView = UITableView()
    let textArray:Array<String> = ["医院信息","急救手册","健康百科","手机报纸","景点查询","票务服务","敬老的士","电话查询","公交查询","养生保健"]
    let imageArray:Array<String> = ["jujia_yiyuanxinxi","jujia_jijiu","jujia_jiankang","jujia_shoujibaozhi","jujia_jingdian","jujia_piaowu","jujia_jinglaodishi","jujia_dianhuachaxun","ic_gongjiaochaxue","ic_yangshengbaojian"]

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "工具箱"
        self.view.backgroundColor = LGBackColor
        self.mytableView.frame = CGRectMake(0, 0, WIDTH, HEIGHT-64)
        self.mytableView.delegate = self
        self.mytableView.dataSource = self
        self.mytableView.backgroundColor = UIColor.whiteColor()
        self.mytableView.separatorStyle = .None
        self.mytableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "PublicTableViewCell")
        self.view.addSubview(self.mytableView)
        // Do any additional setup after loading the view.
    }
    //MARK: ------UITableViewDelegate
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        return 44*px
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        
    }
    //MARK: ------TableViewDatasource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return self.textArray.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = PublicTableViewCell.init(style: .Default)
        cell.imageView?.image = UIImage(named: self.imageArray[indexPath.row])
        cell.textLabel?.text = self.textArray[indexPath.row]
        cell.textLabel?.font = MainFont
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
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
