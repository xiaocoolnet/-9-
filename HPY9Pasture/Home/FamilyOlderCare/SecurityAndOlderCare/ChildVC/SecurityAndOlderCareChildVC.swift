//
//  SecurityAndOlderCareChildVC.swift
//  HPY9Pasture
//
//  Created by purepure on 17/2/13.
//  Copyright © 2017年 xiaocool. All rights reserved.
//

import UIKit

class SecurityAndOlderCareChildVC: UIViewController,UITableViewDelegate,UITableViewDataSource {

    let SecurityAndOlderCareTableView = UITableView()
    override func viewDidLoad() {
        super.viewDidLoad()
        SecurityAndOlderCareTableView.delegate = self
        SecurityAndOlderCareTableView.dataSource = self
        SecurityAndOlderCareTableView.backgroundColor = LGBackColor
        SecurityAndOlderCareTableView.frame = CGRectMake(0, 0, WIDTH, HEIGHT-64-40*px)
        SecurityAndOlderCareTableView.separatorStyle = .None
        self.SecurityAndOlderCareTableView.registerNib(UINib(nibName: "SecurityAndOlderCareChildVCTableViewCell",bundle: nil), forCellReuseIdentifier: "SecurityAndOlderCareChildVCTableViewCell")
        self.view.addSubview(SecurityAndOlderCareTableView)

        // Do any additional setup after loading the view.
    }
    
    func getData(cid:String,type:String){
        
    }
    
    
    
    //MARK: ------UITableViewDelegate
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        return 205
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        
        
    }
    //MARK: ------TableViewDatasource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        return 2
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCellWithIdentifier("SecurityAndOlderCareChildVCTableViewCell", forIndexPath: indexPath)as!SecurityAndOlderCareChildVCTableViewCell
        cell.creatUI()
        
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
