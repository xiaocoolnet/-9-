//
//  OutpatientViewController.swift
//  HPY9Pasture
//
//  Created by purepure on 16/10/27.
//  Copyright © 2016年 xiaocool. All rights reserved.
//

import UIKit

class OutpatientViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    

    let outpatienTableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "门诊服务"
        self.view.backgroundColor = LGBackColor
        createTableView()
    }

    func createTableView(){
        outpatienTableView.frame = CGRectMake(0, 0, Screen_W, Screen_H-64)
        outpatienTableView.backgroundColor = UIColor.whiteColor()
        outpatienTableView.delegate = self
        outpatienTableView.dataSource = self
        outpatienTableView.separatorStyle = .None
        outpatienTableView.tableFooterView = UIView()
        outpatienTableView.sectionFooterHeight = 10
        outpatienTableView.registerNib(UINib(nibName: "OutpatientTableViewCell",bundle: nil), forCellReuseIdentifier: "OutpatientTableViewCell")
        self.view.addSubview(outpatienTableView)
        
    }
    
    
    //MARK: ------TableViewDelegate
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        
        return 140
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        
        NSLOG(indexPath)
    }
    
    
    //MARK: ------TableViewDatasource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let dic = NSDictionary()
        let cell = tableView.dequeueReusableCellWithIdentifier("OutpatientTableViewCell", forIndexPath: indexPath)as!OutpatientTableViewCell
        cell.setValueWithInfo(dic)
        cell.accessoryType = .None
        cell.selectionStyle = .None
        
        return cell
    }
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let mysectionView = UIView()
        mysectionView.backgroundColor = LGBackColor
        mysectionView.frame = CGRectMake(0, 0, Screen_W, 20)
        return mysectionView
        
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
