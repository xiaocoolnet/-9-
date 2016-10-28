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
    //MARK: ------SET
    func createTableView(){
        videoTableView.frame = self.view.frame
        videoTableView.backgroundColor = UIColor.whiteColor()
        videoTableView.delegate = self
        videoTableView.dataSource = self
        videoTableView.tableFooterView = UIView()//去掉多于的分割线
        self.view.addSubview(videoTableView)
        
    }
    
    //MARK: ------TableViewDelegate
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        
        return cellHeight!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        
        print(indexPath)
    }
    
    
    //MARK: ------TableViewDatasource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        return 2
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        
        let cell = UITableViewCell()
        cell.textLabel?.font = MainFont
        cell.textLabel?.text = listArray[indexPath.row]
        cell.accessoryType = .DisclosureIndicator
        cell.selectionStyle = .None
        return cell
    }
    
    
    
    
    
    
    
    
    
    
}
