//
//  KindVC.swift
//  HPY9Pasture
//
//  Created by purepure on 16/12/20.
//  Copyright © 2016年 xiaocool. All rights reserved.
//

import UIKit

class KindVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
     let myTableView = UITableView()
    let textArray = ["糖尿病症候群","糖尿病症候群","糖尿病症候群"]
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        myTableView.delegate = self
        myTableView.dataSource = self
        myTableView.backgroundColor = LGBackColor
        myTableView.frame = CGRectMake(0, 0, WIDTH, HEIGHT-64-43*px)
        myTableView.separatorStyle = .None
        myTableView.sectionFooterHeight = 1*px
        self.myTableView.registerNib(UINib(nibName: "KindVCTableViewCell",bundle: nil), forCellReuseIdentifier: "KindVCTableViewCell")
        self.view.addSubview(myTableView)

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
        
        return 1
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return textArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
//        let cell = KindVCTableViewCell()
        let cell = tableView.dequeueReusableCellWithIdentifier("KindVCTableViewCell", forIndexPath: indexPath)as!KindVCTableViewCell
        
        cell.mainlabel.font = UIFont.systemFontOfSize(13)
        cell.mainlabel.text = textArray[indexPath.section]
        cell.comeInButton.tag = indexPath.section
        cell.setUI()
        cell.accessoryType = .None
        cell.selectionStyle = .None
        
        return cell
    }
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footView = UIView()
        footView.backgroundColor = LGBackColor
        footView.frame = CGRectMake(0, 0, WIDTH, 1*px)
        
        return footView
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
