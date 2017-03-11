//
//  EvaluateListForServerViewController.swift
//  HPY9Pasture
//
//  Created by purepure on 17/2/21.
//  Copyright © 2017年 xiaocool. All rights reserved.
//

import UIKit
import SwiftyJSON

class EvaluateListForServerViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    let evaluateTableView = UITableView()
    let evaluateList : Array<JSON> = []
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = LGBackColor
        self.creatUI()
        // Do any additional setup after loading the view.
    }
    
    func creatUI(){
        self.evaluateTableView.frame = CGRectMake(0, 0, WIDTH, HEIGHT-110-40*px)
        self.evaluateTableView.sectionHeaderHeight = 20
        self.evaluateTableView.delegate = self
        self.evaluateTableView.dataSource = self
        self.evaluateTableView.backgroundColor = LGBackColor
        self.evaluateTableView.separatorStyle = .None
        self.evaluateTableView.registerNib(UINib(nibName: "EvaluateListTableViewCell",bundle: nil), forCellReuseIdentifier: "EvaluateListTableViewCell")
        self.view.addSubview(self.evaluateTableView)
    }
    
    //MARK: ------UITableViewDelegate
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        return 80*px
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        
        
        
        
    }
    
    //MARK: ------TableViewDatasource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        return 2
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCellWithIdentifier("EvaluateListTableViewCell", forIndexPath: indexPath)as!EvaluateListTableViewCell
        cell.creatUI()
        cell.headerImageView.backgroundColor = UIColor.redColor()
        cell.nameLabel.text = "王阿姨"
        cell.timeLabel.text = "一天前"
        cell.descriptionLabel.text = "丁虎功认真，仔细，有耐心。丁虎功认真，仔细，有耐心。丁虎功认真，仔细，有耐心。"
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
