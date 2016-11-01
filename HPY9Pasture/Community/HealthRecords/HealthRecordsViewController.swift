//
//  HealthRecordsViewController.swift
//  HPY9Pasture
//
//  Created by purepure on 16/11/1.
//  Copyright © 2016年 xiaocool. All rights reserved.
//

import UIKit

class HealthRecordsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    
    let healthTableView = UITableView()//健康档案
    let entityTableView = UITableView()//病种归类
    let healthButton = UIButton()//健康档案按钮
    let entityButton = UIButton()//病种归类按钮
    let markView = UIView()//标记滚动view
    
    
    let healthArray = ["","",""]
    let entity = ["","",""]
    
    
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = LGBackColor
        self.createUI()
        // Do any additional setup after loading the view.
    }
    
    func createUI(){
        
        healthButton.frame = CGRectMake(0, 0, WIDTH/2, 40*px)
        healthButton.setTitleColor(NavColor, forState: .Normal)
        healthButton.setTitle("健康档案", forState: .Normal)
        healthButton.titleLabel?.font = MainFont
        healthButton.backgroundColor = UIColor.whiteColor()
        healthButton.addTarget(self, action: #selector(self.healthButtonAction), forControlEvents: .TouchUpInside)
        
        entityButton.frame = CGRectMake(0, WIDTH/2, WIDTH/2, 40*px)
        entityButton.setTitleColor(LGBackColor, forState: .Normal)
        entityButton.setTitle("病种归类", forState: .Normal)
        entityButton.titleLabel?.font = MainFont
        entityButton.backgroundColor = UIColor.whiteColor()
        entityButton.addTarget(self, action: #selector(self.entityButtonAction), forControlEvents: .TouchUpInside)
        
        markView.frame = CGRectMake(0, 40*px, WIDTH/2, 5*px)
        markView.backgroundColor = LGBackColor
        
        
        healthTableView.frame = CGRectMake(0, 45*px, WIDTH, HEIGHT-(64+45)*px)
        healthTableView.backgroundColor = LGBackColor
        healthTableView.delegate = self
        healthTableView.dataSource = self
        healthTableView.separatorStyle = .None
        healthTableView.tableFooterView = UIView()
        healthTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "healthTableViewCell")
        
        entityTableView.frame = CGRectMake(WIDTH, 45*px, WIDTH, HEIGHT-(64+45)*px)
        entityTableView.backgroundColor = LGBackColor
        entityTableView.delegate = self
        entityTableView.dataSource = self
        entityTableView.separatorStyle = .None
        entityTableView.tableFooterView = UIView()
        entityTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "entityTableViewCell")
        self.view.addSubview(healthButton)
        self.view.addSubview(entityButton)
        self.view.addSubview(markView)
        self.view.addSubview(healthTableView)
        self.view.addSubview(entityTableView)
    }
    
    //MARK:  tableview
    //MARK: ------TableViewDelegate
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        return 44
        
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        
        if tableView == healthTableView {
            
        }else{
            
        }
    }
    
    
    
    //MARK: ------TableViewDatasource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if tableView == healthTableView {
            return 3
        }else{
            return 3
        }
        
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        if tableView == healthTableView {
            let cell = tableView.dequeueReusableCellWithIdentifier("healthTableViewCell", forIndexPath: indexPath)
            cell.textLabel?.font = MainFont
            cell.accessoryType = .None
            cell.selectionStyle = .None
            return cell
        }else{
            let cell = tableView.dequeueReusableCellWithIdentifier("entityTableViewCell", forIndexPath:indexPath)
            cell.textLabel?.font = MainFont
            cell.accessoryType = .None
            cell.selectionStyle = .None
            return cell
        }
        
        
    }
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if tableView == entityTableView {
            let mysectionView = UILabel()
            mysectionView.backgroundColor = LGBackColor
            mysectionView.frame = CGRectMake(0, 0, Screen_W, 30)
            mysectionView.text = "*点击"
            mysectionView.textAlignment = .Center
            mysectionView.textColor = UIColor.redColor()
            mysectionView.font = UIFont.systemFontOfSize(12)
            return mysectionView
        }else{
            return UIView()
        }
        
        
    }
    
    
    
    
    //MARK:   ButtonAction
    
    
    func healthButtonAction(){
        
    }
    func entityButtonAction(){
        
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
